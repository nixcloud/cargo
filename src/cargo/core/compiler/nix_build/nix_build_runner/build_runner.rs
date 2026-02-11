use super::build_result_parser::parse_stdout_lines;
use crate::util::Filesystem;
use crate::util::{CargoResult, GlobalContext};

use logone::{LogLevel, LogOne};

pub struct NixBuild {}

impl NixBuild {
    pub fn build<'gctx>(
        nix_base_dir: Filesystem,
        gctx: &'gctx GlobalContext,
        keep_going: bool,
    ) -> CargoResult<()> {
        use std::io::{BufRead, BufReader, Write};
        use std::process::{Command, Stdio};
        let keep_going: &str = match keep_going {
            true => "--keep-going",
            false => "",
        };

        std::io::stdout()
            .flush()
            .map_err(|e| anyhow::format_err!("Failed to flush stdout: {}", e))?;

        let mut binding = Command::new("nix");
                binding
            .arg("build")
            .arg("target")
            .arg("--file")
            .arg(format!(
                "{}/cargo_build_caller.nix",
                nix_base_dir.display().to_string()
            ))
            .arg("--out-link")
            .arg(format!(
                "{}/gc/result",
                nix_base_dir.display().to_string()
            ))
            .arg("--json")
            .arg("--log-format")
            .arg("internal-json")
            //.arg("--option extra-sandbox-paths")
            //.arg("'/incremental-target=/cargo-incremental-target'")
            .stdout(Stdio::piped())
            .stderr(Stdio::piped());

        if !keep_going.is_empty() {
            binding.arg(keep_going);
        }

        gctx.shell()
            .status(
                    "nix build call",
                    format!(
                        "{} {}",
                        binding.get_program().to_string_lossy(),
                        binding
                            .get_args()
                            .map(|arg| arg.to_string_lossy().into_owned())
                            .collect::<Vec<_>>()
                            .join(" ")
                    ).trim(),
                )
            .unwrap();

        let mut command = binding
            .env_clear()
            .spawn()
            .map_err(|e| anyhow::format_err!("Failed to execute nix-build: {}", e))?;

        std::io::stdout()
            .flush()
            .map_err(|e| anyhow::format_err!("Failed to flush stdout: {}", e))?;

        // Handle stdout in a separate thread → JSON capture only
        let stdout = command
            .stdout
            .take()
            .ok_or_else(|| anyhow::format_err!("Failed to capture stdout"))?;
        let stdout_reader = BufReader::new(stdout);
        let stdout_handle = std::thread::spawn(move || {
            let mut json_string: Vec<String> = vec![];

            for line in stdout_reader.lines() {
                match line {
                    Ok(line) => {
                        json_string.push(line);
                        let _ = std::io::stdout().flush();
                    }
                    Err(e) => eprintln!("Error reading stdout: {}", e),
                }
            }
            json_string
        });

        // Handle stderr in a separate thread → use logone
        let stderr = command
            .stderr
            .take()
            .ok_or_else(|| anyhow::format_err!("Failed to capture stderr"))?;
        let stderr_reader = BufReader::new(stderr);
        let stderr_handle = std::thread::spawn(move || {
            let mut logone = LogOne::new(true, LogLevel::Cargo);

            for line in stderr_reader.lines() {
                match line {
                    Ok(line) => {
                        let _ = logone::parser::parse_nix_line(&line, &mut logone);
                    }
                    Err(e) => {
                        eprintln!("Error reading stderr: {}", e);
                        return;
                    }
                }
            }
        });

        // Wait for the command to complete
        let status = command
            .wait()
            .map_err(|e| anyhow::format_err!("Failed to wait for process: {}", e));

        std::io::stdout()
            .flush()
            .map_err(|e| anyhow::format_err!("Failed to flush stdout: {}", e))?;

        // Ensure threads complete
        let stdout_lines: Vec<String> = stdout_handle
            .join()
            .map_err(|e| anyhow::format_err!("Failed to join stdout thread: {:?}", e))?;
        stderr_handle
            .join()
            .map_err(|e| anyhow::format_err!("Failed to join stderr thread: {:?}", e))?;

        if status?.success() {
            let build_records = parse_stdout_lines(stdout_lines);

            if build_records.len() != 1 {
                anyhow::bail!("Can't create result symlink because too many results were created".to_string())
            }

            for record in build_records {
                if let Some(out) = record.outputs.get("out") {
                    let activation_script = format!("{}/bin/create-symlinks", out);
                    let _ = Command::new(&activation_script).output().expect(
                        format!(
                            "failed to execute create-symlinks for: {}",
                            &activation_script
                        )
                        .as_str(),
                    );
                    gctx.shell()
                        .verbose(|s| {
                            s.status(
                                "Symlink",
                                format!(
                                    "Symlinking results using '{}'",
                                    activation_script
                                ),
                            )
                        })
                        .unwrap();
                }
            }
            Ok(())
        } else {
            anyhow::bail!("could not compile target".to_string())
        }
    }
}
