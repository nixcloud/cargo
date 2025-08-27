pub struct NixBuild {}

impl NixBuild {
    pub fn build(build_type: &str) -> Result<(), String> {
        use std::io::{BufRead, BufReader, Write};
        use std::process::{Command, Stdio};

        println!("Starting nix '{}' build ...", build_type);
        std::io::stdout()
            .flush()
            .map_err(|e| format!("Failed to flush stdout: {}", e))?;

        let mut command = Command::new("nix")
            .arg("build")
            .arg("--file")
            .arg(format!("target/{}/nix/cargo_build_caller.nix", build_type))
            .arg("--no-link")
            .arg("-L")
            .arg("--print-out-paths")
            .arg("target")
            .arg("--json")
            .stdout(Stdio::piped())
            .stderr(Stdio::piped())
            .spawn()
            .map_err(|e| format!("Failed to execute nix-build: {}", e))?;

        println!("Command spawned successfully"); // Debug: Confirm spawn
        std::io::stdout()
            .flush()
            .map_err(|e| format!("Failed to flush stdout: {}", e))?;

        // Handle stdout in a separate thread to prevent blocking
        let stdout = command.stdout.take().ok_or("Failed to capture stdout")?;
        let stdout_reader = BufReader::new(stdout);
        let stdout_handle = std::thread::spawn(move || {
            for line in stdout_reader.lines() {
                match line {
                    Ok(line) => {
                        println!("stdout: {}", line);
                        let _ = std::io::stdout().flush(); // Ensure immediate output
                    }
                    Err(e) => println!("Error reading stdout: {}", e),
                }
            }
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
        println!("Command finished with status: {}", status); // Debug: Confirm completion
        std::io::stdout()
            .flush()
            .map_err(|e| format!("Failed to flush stdout: {}", e))?;

        // Ensure threads complete
        stdout_handle
            .join()
            .map_err(|e| format!("Failed to join stdout thread: {:?}", e))?;
        stderr_handle
            .join()
            .map_err(|e| format!("Failed to join stderr thread: {:?}", e))?;

        if status.success() {
            Ok(())
        } else {
            Err("nix-build command failed".to_string())
        }
    }
}
