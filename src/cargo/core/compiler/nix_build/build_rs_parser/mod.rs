use std::fs;
use std::path::PathBuf;
use regex::Regex;

mod tests;

pub enum BuildRsParserCommand {
    RustcArguments,
    EnvironmentVariables,
}

pub fn build_rs_parser(c: BuildRsParserCommand, file_path: Option<PathBuf>) -> Result<String, Box<dyn std::error::Error>> {
    let content = fs::read_to_string(file_path.unwrap()).expect("Could not read file");
    let mut rustc_arguments: Vec<String> = vec![];
    let mut environment_variables: Vec<String> = vec![];
    for (line_number, line) in content.lines().enumerate() {
        if !line.starts_with("cargo:") {
            continue
        }
        let (command, arg) = parse(line_number, line)?;
        match command.as_str() {
            // rustc
            "rustc-cfg" => rustc_arguments.push(format!("--cfg={}", arg)),
            "rustc-check-cfg" => rustc_arguments.push(format!("--check-cfg={}", arg)),

            // env
            "rustc-env" => environment_variables.push(format!("{}", arg)),

            // warning
            "warning" => {
                eprintln!("WARNING: {arg}");
            },

            // ignored
            "rerun-if-changed" => {},
            "rerun-if-env-changed" => {}, 
            "rerun-if-changed-bin" => {},
            "rerun-if-changed-glob" => {},
            "rerun-if-changed-dir" => {},
            "rerun-if-changed-recursive" => {},
            "rerun-if-changed-env" => {},

            // fail
            "rustc-link-lib" |
            "rustc-link-search" |
            "rustc-flags" |
            "rustc-cdylib-link-arg" |
            "rustc-bin-link-arg" |
            "rustc-link-arg-bin" => {
                return Err(format!("Command: '{command}' on line: '{line_number}' not implemented yet!").into())
            },

            _ => {
                return Err(format!("Unexpected command: '{command}' on line: '{line_number}'").into())
            },
        }
    }

    match c {
        BuildRsParserCommand::RustcArguments => Ok(format!("{}", rustc_arguments.join(" "))),
        BuildRsParserCommand::EnvironmentVariables => Ok(format!("{}", environment_variables.join("\n"))),
    }
}

fn parse(line_number: usize, line: &str) -> Result<(String,String), String> {
    let line = line.trim(); // Remove any trailing newline or whitespace
    let re = Regex::new(r"^cargo:([^=]+)\s*=\s*(.+)$")
        .map_err(|e| format!("Regex error: {}", e))?;

    if let Some(caps) = re.captures(line) {
        let command = &caps[1];
        let arg = &caps[2];
        Ok((command.to_string(), arg.to_string()))
    } else {
        Err(format!("Unable to parse the line {line_number}: '{line}'").to_string())
    }
}
