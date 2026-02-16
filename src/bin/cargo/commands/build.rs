use crate::command_prelude::*;
use cargo::ops;
use build_rs_libnix::process_buildrs_output;

pub fn cli() -> Command {
    subcommand("build")
        // subcommand aliases are handled in aliased_command()
        // .alias("b")
        .about("Compile a local package and all of its dependencies")
        .arg_future_incompat_report()
        .arg_message_format()
        .arg_silent_suggestion()
        .arg_package_spec(
            "Package to build (see `cargo help pkgid`)",
            "Build all packages in the workspace",
            "Exclude packages from the build",
        )
        .arg_targets_all(
            "Build only this package's library",
            "Build only the specified binary",
            "Build all binaries",
            "Build only the specified example",
            "Build all examples",
            "Build only the specified test target",
            "Build all targets that have `test = true` set",
            "Build only the specified bench target",
            "Build all targets that have `bench = true` set",
            "Build all targets",
        )
        .arg_features()
        .arg_release("Build artifacts in release mode, with optimizations")
        .arg_redundant_default_mode("debug", "build", "release")
        .arg_profile("Build artifacts with the specified profile")
        .arg_parallel()
        .arg_target_triple("Build for the target triple")
        .arg_target_dir()
        .arg_artifact_dir()
        .arg_build_plan()
        .arg_unit_graph()
        .arg_timings()
        .arg_manifest_path()
        .arg_lockfile_path()
        .arg_ignore_rust_version()

        // refactor: move to command_prelude.rs, use gctx and only display if cargo backend is "nix"
        //           this might require to move the gctx.backend() out of gctx because that is only constructed
        //           after the command line parameters have been created
        .subcommand(
            Command::new("write-nix-buildsystem")
                .about("Export the nix buildsystem to be called from nixpkgs or flakes, won't trigger a compile")
                .arg(
                    opt("out-dir", "The directory the build system is exported to (must be new or at least empty)")
                        .value_name("PATH"),
                )
                .arg(
                    opt("url", "Use remote URL for source code download")
                        .value_name("URI"),
                )
                .arg(
                    opt("hash", "The hash (sha256), created with nix-prefetch-url")
                )
        )
        .subcommand(
            Command::new("build-rs-nix")
                .about("Parse the output of a build.rs script for 'nix build'")
                .arg(
                    opt("script-output", "Absolute path to the /nix/store/...-build-script-build.out file to parse")
                        .value_name("PATH"),
                )
                .arg(
                    opt("out-dir", "A directory where the nix/* files are generated to")
                        .value_name("PATH"),
                )
        )
        .after_help(color_print::cstr!(
            "Run `<cyan,bold>cargo help build</>` for more detailed information.\n"
        ))
}

pub fn exec(gctx: &mut GlobalContext, args: &ArgMatches) -> CliResult {
    let ws = args.workspace(gctx)?;
    let write_nix_buildsystem_options: Option<NixBuildOptions> = match args.subcommand() {
        Some(("write-nix-buildsystem", sub_args)) => {
            let out_dir = sub_args.value_of_path("out-dir", gctx).ok_or_else(|| {
                CliError::new(
                    anyhow::format_err!(
                        "`cargo build write-nix-buildsystem` requires --out-dir\n\
                        Please specify the --out-dir option."
                    ),
                    101,
                )
            })?.clone();

            let url = sub_args.get_one::<String>("url").ok_or_else(|| {
                CliError::new(
                    anyhow::format_err!(
                        "`cargo build write-nix-buildsystem` requires --url\n\
                        Please specify the --url option."
                    ),
                    101,
                )
            })?.clone();

            let hash = sub_args.get_one::<String>("hash").ok_or_else(|| {
                CliError::new(
                    anyhow::format_err!(
                        "`cargo build write-nix-buildsystem` requires --hash\n\
                        Please specify the --hash option."
                    ),
                    101,
                )
            })?.clone();
            Some(NixBuildOptions { out_dir, url, hash })
        },
        Some(("build-rs-nix", sub_args)) => {
            let script_output = sub_args.value_of_path("script-output", gctx).ok_or_else(|| {
                CliError::new(
                    anyhow::format_err!(
                        "`cargo build build-rs-nix` requires --script-output\n\
                        Please specify the --script-output option."
                    ),
                    101,
                )
            })?.clone();
            let out_dir = sub_args.value_of_path("out-dir", gctx).ok_or_else(|| {
                CliError::new(
                    anyhow::format_err!(
                        "`cargo build out-dir` requires --out-dir\n\
                        Please specify the --out-dir option."
                    ),
                    101,
                )
            })?.clone();
            let _ = process_buildrs_output(&script_output, &out_dir);
            return Ok(());
        },
        Some((&_, _)) => {None},
        None => {None}
    };
    gctx.write_nix_buildsystem_options.fill(write_nix_buildsystem_options).expect("fill should only be called once");
    let mut compile_opts =
        args.compile_options(gctx, CompileMode::Build, Some(&ws), ProfileChecking::Custom)?;
    if let Some(artifact_dir) = args.value_of_path("artifact-dir", gctx) {
        // If the user specifies `--artifact-dir`, use that
        compile_opts.build_config.export_dir = Some(artifact_dir);
    } else if let Some(artifact_dir) = args.value_of_path("out-dir", gctx) {
        // `--out-dir` is deprecated, but still supported for now
        gctx.shell()
            .warn("the --out-dir flag has been changed to --artifact-dir")?;
        compile_opts.build_config.export_dir = Some(artifact_dir);
    } else if let Some(artifact_dir) = gctx.build_config()?.artifact_dir.as_ref() {
        // If a CLI option is not specified for choosing the artifact dir, use the `artifact-dir` from the build config, if
        // present
        let artifact_dir = artifact_dir.resolve_path(gctx);
        compile_opts.build_config.export_dir = Some(artifact_dir);
    } else if let Some(artifact_dir) = gctx.build_config()?.out_dir.as_ref() {
        // As a last priority, check `out-dir` in the build config
        gctx.shell()
            .warn("the out-dir config option has been changed to artifact-dir")?;
        let artifact_dir = artifact_dir.resolve_path(gctx);
        compile_opts.build_config.export_dir = Some(artifact_dir);
    }

    if compile_opts.build_config.export_dir.is_some() {
        gctx.cli_unstable()
            .fail_if_stable_opt("--artifact-dir", 6790)?;
    }

    ops::compile(&ws, &compile_opts)?;
    Ok(())
}
