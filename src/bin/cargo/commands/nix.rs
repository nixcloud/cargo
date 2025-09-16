use crate::command_prelude::*;
use std::path::PathBuf;

pub fn cli() -> Command {
    subcommand("nix")
        .about("Use 'nix build' with the nix job scheduler to build crates inside a sandbox")
        .arg_new_opts()
        .arg_registry("Registry to use")
        .arg_silent_suggestion()
        .after_help(color_print::cstr!(
            "Run `<cyan,bold>cargo help nix</>` for more detailed information.\n"
        ))
        .subcommand(
            Command::new("generate")
                .about("Generate default.nix files to build the project")
                .arg(
                    opt("generate-path", "Output path were to write the documents")
                        .value_name("PATH"),
                ),
        )
        .subcommand(
            Command::new("parse-build-script-build")
                .about("Parse the output of a build.rs script run to inject it into the nix-build run, see https://doc.rust-lang.org/cargo/reference/build-scripts.html")
                .arg(
                    opt("path", "An absolute path to the /nix/store/...-build-script-build.out file to parse")
                        .value_name("PATH"),
                )
                .subcommand(
                    Command::new("rustc_arguments")
                        .about("Collects cargo::rustc-cfg=, cargo::rustc-check-cfg=CHECK_CFG and similar and formats it to be added to the rustc call"),
                )
                .subcommand(
                    Command::new("environment_variables")
                        .about("Collects: cargo::rustc-env=VAR=VALUE and sets it during the rustc call"),
                )
        )
}

pub fn exec(gctx: &mut GlobalContext, args: &ArgMatches) -> CliResult {
    match args.subcommand() {
        Some(("generate", sub_args)) => {
            let path = sub_args.value_of_path("generate-path", gctx);
            println!("Generating `default.nix` at: {:?}", path);
            Ok(())
        }
        Some(("parse-build-script-build", sub_args)) => {
            let file_path: Option<PathBuf> = sub_args.value_of_path("path", gctx);
            if sub_args.subcommand_matches("rustc_arguments").is_some() {
                eprintln!("rustc_arguments for path: {:?}", file_path.clone());
                // match build_rs_parser(BuildRsParserCommand::RustcArguments, file_path.clone()) {
                //     Ok(res) => println!("{}", res),
                //     Err(e) => return Err(CliError::new(anyhow::format_err!("{e}"), 101)),
                // }
                return Ok(());
            }
            if sub_args
                .subcommand_matches("environment_variables")
                .is_some()
            {
                eprintln!("environment_variables for path: {:?}", file_path.clone());
                // match build_rs_parser(
                //     BuildRsParserCommand::EnvironmentVariables,
                //     file_path.clone(),
                // ) {
                //     Ok(res) => println!("{}", res),
                //     Err(e) => return Err(CliError::new(anyhow::format_err!("{e}"), 101)),
                // }
                return Ok(());
            } else {
                // Handle other cases or default behavior
                eprintln!(
                    "Parse the output of a build.rs script run to inject it into the nix-build run"
                );
            }
            Ok(())
        }
        _ => {
            // No subcommand or an unknown subcommand was used
            let _ = cli().print_help();
            println!();
            Ok(())
        }
    }
}
