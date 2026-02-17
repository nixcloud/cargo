use std::fs;
use std::path::Path;
use regex::Regex;
use colored::*;
use anyhow::{Context, Result};

mod tests;

#[derive(Debug)]
pub struct TheResult {
    pub rustc_arguments: Vec<String>,
    pub rustc_propagated_arguments: Vec<String>,
    pub environment_variables: Vec<String>,
    pub metadata: Vec<String>,
    pub rustc_flags: Vec<String>,
    pub rustc_link_arg_cdylib: Vec<String>,
    pub rustc_link_arg_bin: Vec<String>,
    pub rustc_link_arg_bins: Vec<String>,
    pub rustc_link_arg_tests: Vec<String>,
    pub rustc_link_arg_examples: Vec<String>,
    pub rustc_link_arg_benches: Vec<String>,
}

pub trait EnvifyExt: ToString {
    fn envify(&self) -> String;
}

impl EnvifyExt for String {
    // function copied from cargo /home/nixos/cargo/src/cargo/core/compiler/mod.rs
    fn envify(&self) -> String {
        self.chars()
            .flat_map(|c| c.to_uppercase())
            .map(|c| if c == '-' { '_' } else { c })
            .collect()
    }
}

pub fn process_buildrs_output(in_path: &Path, out_dir: &Path) -> Result<()> {
    let input = fs::read_to_string(in_path).expect("Could not read file");
    match handle_content(input) {
        Ok(out) => {
            let rustc_arguments_path = Path::new(&out_dir).join("rustc-arguments");
            std::fs::write(rustc_arguments_path, out.rustc_arguments.join(" "))
                .expect("Unable to write data to file");

            let rustc_propagated_arguments_path =
                Path::new(&out_dir).join("rustc-propagated-arguments");
            std::fs::write(
                rustc_propagated_arguments_path,
                out.rustc_propagated_arguments.join(" "),
            )
            .expect("Unable to write data to file");

            let environment_variables_path =
                Path::new(&out_dir).join("environment-variables");
            std::fs::write(
                environment_variables_path,
                out.environment_variables.join("\n"),
            )
            .expect("Unable to write data to file");

            let rustc_link_arg_benches_path =
                Path::new(&out_dir).join("rustc-link-arg-benches");
            std::fs::write(
                rustc_link_arg_benches_path,
                out.rustc_link_arg_benches.join(" "),
            )
            .expect("Unable to write data to file");

            println!(
                "build.rs related nix files written to '{}'",
                out_dir.display()
            );
            Ok(())
        }
        Err(e) => anyhow::bail!(e)
    }
}

fn eprintln_document_with_error(input: String, error_line: usize) {
    for (line_number, line) in input.lines().enumerate() {
        let formatted_line_number = format!("{:3}   ", line_number);
        if line_number == error_line {
            eprintln!("> {} {}", formatted_line_number, line.red());
        } else {
            eprintln!("  {} {}", formatted_line_number, line);
        }
    }
}

fn eprintln_document_with_warning(input: String, error_line: usize) {
    eprintln!(
        "{}",
        "The following build.rs 'cargo:' directive will be ignored:".yellow()
    );
    for (line_number, line) in input.lines().enumerate() {
        let formatted_line_number = format!("{:3}   ", line_number);
        if line_number == error_line {
            eprintln!("> {} {}", formatted_line_number, line.yellow());
        } else {
            eprintln!("  {} {}", formatted_line_number, line);
        }
    }
}

pub fn handle_content(input: String) -> Result<TheResult> {
    let mut rustc_arguments: Vec<String> = vec![];
    let mut rustc_propagated_arguments: Vec<String> = vec![];
    let mut environment_variables: Vec<String> = vec![];
    let metadata: Vec<String> = vec![];
    let rustc_flags: Vec<String> = vec![];
    let rustc_link_arg_cdylib: Vec<String> = vec![];
    let rustc_link_arg_bin: Vec<String> = vec![];
    let rustc_link_arg_bins: Vec<String> = vec![];
    let rustc_link_arg_tests: Vec<String> = vec![];
    let rustc_link_arg_examples: Vec<String> = vec![];
    let mut rustc_link_arg_benches: Vec<String> = vec![];

    for (line_number, line) in input.lines().enumerate() {
        let trimmed_line = line.trim();
        if !trimmed_line.starts_with("cargo:") {
            continue;
        }

        let line = line.trim(); // Remove any trailing newline or whitespace
        let re =
            Regex::new(r"^cargo:([^=]+)\s*=\s*(.+)$").context("Regex error constructing cargo metadata regex")?;

        if let Some(caps) = re.captures(line) {
            let command = &caps[1];
            let arg = &caps[2];

            match command {
                // rustc
                "rustc-cfg" => rustc_arguments.push(format!("--cfg '{}'", arg)),
                "rustc-check-cfg" => rustc_arguments.push(format!("--check-cfg '{}'", arg)),

                // env - cargo:rustc-env=VAR=VALUE 
                "rustc-env" => {
                    let re = Regex::new(r"^(.+)\s*=\s*(.*)$")
                        .context("Regex error constructing cargo metadata regex")?;
                    if let Some(caps) = re.captures(&arg) {
                        let key = &caps[1];
                        let val = &caps[2];
                        environment_variables.push(format!("{}='{}'", key, val))
                    } else {
                        eprintln_document_with_error(input.clone(), line_number);
                        anyhow::bail!("Unable to parse rustc-env argument at {line_number}: '{line}'")
                    }
                },

                "warning" => {
                    eprintln!("\x1b[1;33mwarning\x1b[0m: {arg}");
                },
                "error" => {
                    eprintln!("\x1b[1;31error\x1b[0m: {arg}");
                },

                // cargo:rustc-link-lib=static=sqlite3
                "rustc-link-lib" => rustc_arguments.push(format!("-l '{}'", arg)),
                // cargo:rustc-link-search=native=/build/tmp.X3Lovygu3U
                // libsqlite3-sys> cargo:rustc-link-search=native=/nix/store/yfjzkkkyxcalyj7l1n4d4y6s81i65hmy-sqlite-3.48.0/lib
                "rustc-link-search" => {
                    rustc_propagated_arguments.push(format!("-L '{}'", arg));
                    let re = Regex::new(r"^(.+)\s*=\s*(.+)$")
                        .context("Regex error constructing cargo metadata regex")?;
                    if let Some(caps) = re.captures(&arg) {
                        let mode = &caps[1];
                        let _directory = &caps[2];
                        // if directory.starts_with("/nix/store") {
                            // rustc_arguments.push(format!("-L \"{}={}\"", mode, directory));
                        // } else {
                            rustc_arguments.push(format!("-L \"{}=$out\"", mode));
                        // }
                    } else {
                        eprintln_document_with_error(input.clone(), line_number);
                        anyhow::bail!("Unable to parse rustc-link-search argument at {line_number}: '{line}'")
                    }
                },
                // https://rurust.github.io/cargo-docs-ru/build-script.html#the-links-manifest-key
                // cargo:include=/build/libsqlite3-sys-0.31.0/sqlite3
                // DEP_{}_INCLUDE='value'
                "include" => {
                    let links = std::env::var("CARGO_MANIFEST_LINKS").unwrap().envify();
                    let key = format!("DEP_{}_INCLUDE", links);
                    environment_variables.push(format!("{}='{}'", key, arg))
                },
                // https://rurust.github.io/cargo-docs-ru/build-script.html#the-links-manifest-key
                // cargo:root=/nix/store/jndiwzj2zslh1hm7gadhj1rngv7dpgsp-libz-sys-1_1_21-script_build_run-61b385027f328c5a
                // DEP_{}_ROOT='value'
                "root" => {
                    let links = std::env::var("CARGO_MANIFEST_LINKS").unwrap().envify();
                    let key = format!("DEP_{}_ROOT", links);
                    environment_variables.push(format!("{}='{}'", key, arg))
                },
                // https://rurust.github.io/cargo-docs-ru/build-script.html#the-links-manifest-key
                // cargo:conf=OPENSSL_NO_SSL3_METHOD
                // DEP_{}_CONF='value'
                "conf" => {
                    let links = std::env::var("CARGO_MANIFEST_LINKS").unwrap().envify();
                    let key = format!("DEP_{}_CONF", links);
                    environment_variables.push(format!("{}='{}'", key, arg))
                },

                // https://rurust.github.io/cargo-docs-ru/build-script.html#the-links-manifest-key
                // cargo:version_number=30400010
                // DEP_{}_VERSION_NUMBER='value'
                "version_number" => {
                    let links = std::env::var("CARGO_MANIFEST_LINKS").unwrap().envify();
                    let key = format!("DEP_{}_VERSION_NUMBER", links);
                    environment_variables.push(format!("{}='{}'", key, arg))   
                },
                // https://rurust.github.io/cargo-docs-ru/build-script.html#the-links-manifest-key
                // cargo:static=1
                // DEP_{}_STATIC='1'
                "static" => {
                    let links = std::env::var("CARGO_MANIFEST_LINKS").unwrap().envify();
                    let key = format!("DEP_{}_STATIC", links);
                    environment_variables.push(format!("{}='{}'", key, arg))
                },
                // https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-link-arg-benches
                // cargo::rustc-link-arg-benches=FLAG
                // cargo:rustc-link-arg-benches=-rdynamic 
                "rustc-link-arg-benches" => {
                    rustc_link_arg_benches.push(format!("-C link-arg='{}'", arg));
                },

                // https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-cdylib-link-arg
                // cargo::rustc-link-arg-cdylib=FLAG
                "rustc-cdylib-link-arg" |
                "rustc-link-arg-cdylib" => {
                    eprintln_document_with_error(input.clone(), line_number);
                    anyhow::bail!("Command: '{command}' on line: '{line_number}' not implemented yet!")
                },

                // intentionally ignored 
                "lib_dir" => {}, // cargo:lib_dir=/build/tmp.X3Lovygu3U
                "rerun-if-changed" => {},
                "rerun-if-env-changed" => {}, 
                "rerun-if-changed-bin" => {},
                "rerun-if-changed-glob" => {},
                "rerun-if-changed-dir" => {},
                "rerun-if-changed-recursive" => {},
                "rerun-if-changed-env" => {},

                // failing, to be implemented (without usecase/example yet)
                "metadata" |                   // https://doc.rust-lang.org/cargo/reference/build-scripts.html#the-links-manifest-key
                "rustc-flags" |                // https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-flags
                "rustc-link-arg" |             // https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-link-arg
                "rustc-link-arg-bin" |         // https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-link-arg-bin
                "rustc-link-arg-bins" |        // https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-link-arg-bins
                "rustc-link-arg-tests" |       // https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-link-arg-tests
                "rustc-link-arg-examples"      // https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-link-arg-examples
                => {
                    eprintln_document_with_error(input.clone(), line_number);
                    let version = format!("{} version {}", env!("CARGO_PKG_NAME"), env!("CARGO_PKG_VERSION"));
                    anyhow::bail!("Command: '{command}' on line: '{line_number}' not implemented yet! {version}")
                }
                _ => {
                    eprintln_document_with_warning(input.clone(), line_number);
                    continue
                },
            }
        } else {
            eprintln_document_with_error(input.clone(), line_number);
            anyhow::bail!("Unknown command to parse on line {line_number}: '{line}'")
        };
    }

    let the_result = TheResult {
        rustc_arguments,
        rustc_propagated_arguments,
        environment_variables,
        metadata,
        rustc_flags,
        rustc_link_arg_cdylib,
        rustc_link_arg_bin,
        rustc_link_arg_bins,
        rustc_link_arg_tests,
        rustc_link_arg_examples,
        rustc_link_arg_benches,
    };

    Ok(the_result)
}
