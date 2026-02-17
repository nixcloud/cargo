use clap::Parser;
use std::fs;
use std::path::{Path, PathBuf};
use build_rs_libnix::handle_content;
use anyhow::Result;

#[derive(clap::Parser, Debug)]
#[clap(
    name = "build-rs-libnix",
    about = "Parse the output of a build.rs script for 'nix build'",
)]

pub struct BuildRsNixArgs {
    /// Absolute path to the /nix/store/...-build-script-build.out file to parse
    #[clap(long = "script-output", value_name = "PATH")]
    pub script_output: PathBuf,

    /// A directory where the nix/* files are generated to
    #[clap(long = "out-dir", value_name = "PATH")]
    pub out_dir: PathBuf,
}

fn main() -> Result<()> {

    let args = BuildRsNixArgs::parse();
    let input = fs::read_to_string(Path::new(&args.script_output)).expect("Could not read file");
    match handle_content(input) {
        Ok(out) => {
            let out_dir = args.out_dir;

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
        }
        Err(e) => return Err(e),
    }
    Ok(())
}
