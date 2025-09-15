use super::build_result_parser::parse_stdout_lines;
use crate::util::Filesystem;

pub struct NixBuild {}

impl NixBuild {
    pub fn build(nix_base_dir: Filesystem) -> Result<(), String> {
        use std::io::{BufRead, BufReader, Write};
        use std::process::{Command, Stdio};

        println!("Starting nix '{}' build ...", nix_base_dir.display().to_string());
        std::io::stdout()
            .flush()
            .map_err(|e| format!("Failed to flush stdout: {}", e))?;

        let mut binding = Command::new("nix");
        binding
            .arg("build")
            .arg("--file")
            .arg(format!("{}/cargo_build_caller.nix", nix_base_dir.display().to_string()))
            .arg("--out-link")
            .arg(format!("{}/result_cargo_build", nix_base_dir.display().to_string()))
            .arg("-L")
            .arg("target")
            .arg("--json")
            .stdout(Stdio::piped())
            .stderr(Stdio::piped());

        println!(
            "Command: {} {}",
            binding.get_program().to_string_lossy(),
            binding
                .get_args()
                .map(|arg| arg.to_string_lossy().into_owned())
                .collect::<Vec<_>>()
                .join(" ")
        );

        let mut command = binding
            .spawn()
            .map_err(|e| format!("Failed to execute nix-build: {}", e))?;

        std::io::stdout()
            .flush()
            .map_err(|e| format!("Failed to flush stdout: {}", e))?;

        // Handle stdout in a separate thread to prevent blocking
        let stdout = command.stdout.take().ok_or("Failed to capture stdout")?;
        let stdout_reader = BufReader::new(stdout);
        let stdout_handle = std::thread::spawn(move || {
            let mut json_string: Vec<String> = vec![];

            for line in stdout_reader.lines() {
                match line {
                    Ok(line) => {
                        println!("stdout: {}", line);
                        json_string.push(line);
                        let _ = std::io::stdout().flush(); // Ensure immediate output
                    }
                    Err(e) => println!("Error reading stdout: {}", e),
                }
            }
            json_string
        });

        // Handle stderr in a separate thread to prevent blocking
        let stderr = command.stderr.take().ok_or("Failed to capture stderr")?;
        let stderr_reader = BufReader::new(stderr);
        let stderr_handle = std::thread::spawn(move || {
            for line in stderr_reader.lines() {
                match line {
                    Ok(line) => {
                        println!("stderr: {}", line);
                        let _ = std::io::stdout().flush(); // Ensure immediate output
                    }
                    Err(e) => println!("Error reading stderr: {}", e),
                }
            }
        });

        // Wait for the command to complete
        let status = command
            .wait()
            .map_err(|e| format!("Failed to wait for process: {}", e))?;
        //println!("Command finished with status: {}", status); // Debug: Confirm completion
        std::io::stdout()
            .flush()
            .map_err(|e| format!("Failed to flush stdout: {}", e))?;

        // Ensure threads complete
        let stdout_lines: Vec<String> = stdout_handle
            .join()
            .map_err(|e| format!("Failed to join stdout thread: {:?}", e))?;
        stderr_handle
            .join()
            .map_err(|e| format!("Failed to join stderr thread: {:?}", e))?;

        if status.success() {
            let build_records = parse_stdout_lines(stdout_lines);
            for record in build_records {
                match record.outputs.get("out") {
                    Some(out) => {
                        let activation_script = format!("{}/bin/create-symlinks", out);
                        let _ = Command::new(&activation_script).output().expect(
                            format!(
                                "failed to execute create-symlinks for: {}",
                                &activation_script
                            )
                            .as_str(),
                        );
                        println!("Created symlink for programs using '{}'", activation_script);
                    }
                    None => {}
                }
            }
            Ok(())
        } else {
            Err("nix-build command failed".to_string())
        }
    }
}
