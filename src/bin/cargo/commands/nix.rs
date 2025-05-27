use crate::command_prelude::*;

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
            Command::new("build-graph")
                .about("Parse Cargo.lock and download all required crates into the nix store"),
        )
}

pub fn exec(gctx: &mut GlobalContext, args: &ArgMatches) -> CliResult {
    match args.subcommand() {
        Some(("generate", sub_args)) => {
            let path = sub_args.value_of_path("generate-path", gctx);
            println!("Generating `default.nix` at: {:?}", path);
            Ok(())
        }
        Some(("build-graph", _sub_args)) => {
            println!("Building crate dependency graph...");
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
