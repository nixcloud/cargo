pub mod nix_build_runner;
use crate::core::compiler::unit_graph::UnitGraph;
use crate::core::compiler::Unit;
use crate::core::compiler::{BuildContext, BuildRunner, CompileMode};
use crate::core::TargetKind;
use crate::util::context::GlobalContext;
use crate::util::{CargoResult, NixBuild};
use cargo_util::ProcessBuilder;
use handlebars::Handlebars;
use std::path::Path;

use indoc::indoc;
use std::collections::BTreeSet;
use std::fs::{create_dir_all, File};
use std::io::Write;
use std::path::PathBuf;

#[derive(Debug)]
struct DefaultNixEntry {
    name: String,
    filename: String,
}

// used to create the nix attribute 'name' from cargo's crate_name and crate_version
// proc-macro2-1.0.94.nix
// proc-macro2-1.0.94-script-build.nix
// proc-macro2-1.0.94-script-run.nix
#[derive(Debug, Eq, PartialEq)]
pub enum NixNameMode {
    AttributeName,
    FileName,
}

fn kind_string(tk: &TargetKind) -> String {
    match tk {
        TargetKind::Lib(_) => {
            "".to_string() // default, so we leave it empty
        }
        TargetKind::ExampleLib(_) => "-example_lib".to_string(),
        TargetKind::Bin => "-bin".to_string(),
        TargetKind::CustomBuild => "-custom_build".to_string(),
        TargetKind::Test => "-test".to_string(),
        TargetKind::Bench => "-bench".to_string(),
        TargetKind::ExampleBin => "-example_bin".to_string(),
    }
}

fn mode_string(mode: &CompileMode) -> &str {
    match mode {
        CompileMode::Test => "-test",
        CompileMode::Build => "", // default, so we leave it empty
        CompileMode::Check { test: _ } => "-check",
        CompileMode::Bench => "-bench",
        CompileMode::Doc { deps: _, json: _ } => "-doc",
        CompileMode::Doctest => "-doc_test",
        CompileMode::Docscrape => "-doc_scrape",
        CompileMode::RunCustomBuild => "-run_custom_build",
    }
}

pub fn create_nix_name(unit: &Unit, nix_name_mode: NixNameMode) -> String {
    let pkg = unit.pkg.package_id();
    let crate_name = pkg.name().to_string();
    let crate_version = pkg.version().to_string();
    let kind: String = kind_string(unit.target.kind());
    let mode: &str = mode_string(&unit.mode);
    let nix_name: String = format!("{}-{}{}{}", crate_name, crate_version, kind, mode,);
    match nix_name_mode {
        NixNameMode::AttributeName => nix_name.replace(".", "_"),
        NixNameMode::FileName => nix_name + ".nix",
    }
}

pub struct NixBuildRunner {}

impl<'a, 'gctx> NixBuildRunner {
    pub fn new(build_runner: &BuildRunner<'a, 'gctx>) -> CargoResult<()> {
        let bcx: &BuildContext<'a, 'gctx> = &build_runner.bcx;
        let gctx: &'gctx GlobalContext = bcx.gctx;

        match gctx.nix()? {
            None => {
                println!("NixBuild not active");
            }
            Some(NixBuild::Fast) => {
                println!("NixBuild is set to Fast");
            }
            Some(NixBuild::Sandbox) => {
                println!("NixBuild is set to Sandbox");
            }
        };

        let workspace = build_runner.bcx.ws;
        let unit_graph: &UnitGraph = &bcx.unit_graph;
        let mut visited = BTreeSet::new();
        let mut all_nodes: Vec<DefaultNixEntry> = Vec::new();

        let dir = PathBuf::from("/tmp/nix");
        create_dir_all(&dir)?;

        let r: Vec<(ProcessBuilder, Unit)> =
            build_runner.raw_process_builder.lock().unwrap().clone();
        let l = r.len();
        println!("Need to generate: {l} units.");

        for (process_builder, unit) in r {
            if visited.contains(&unit) {
                continue;
            }
            visited.insert(unit.clone());

            let pkg = unit.pkg.package_id();
            let is_root: bool = workspace.members().any(|member| member.package_id() == pkg);
            let is_run_custom_build: bool = unit.mode == CompileMode::RunCustomBuild;
            let crate_name: String = pkg.name().to_string();
            let crate_version: String = pkg.version().to_string();
            let fullname: String = create_nix_name(&unit, NixNameMode::AttributeName);
            if is_run_custom_build {
                Self::process_build_runner(
                    &unit,
                    crate_name,
                    crate_version,
                    fullname,
                    &process_builder,
                    unit_graph,
                    is_root,
                    &mut all_nodes,
                )?
            } else {
                Self::process_unit(
                    &unit,
                    crate_name,
                    crate_version,
                    fullname,
                    &process_builder,
                    unit_graph,
                    is_root,
                    &mut all_nodes,
                )?
            }
        }

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/default.nix.handlebars");
        handlebars.register_template_string("default", template_str)?;

        // Render default_nix_packages as `name = callPackage' ./relative_path {};`
        let default_nix_packages = all_nodes
            .iter()
            .map(|entry| {
                let path = PathBuf::from(&entry.filename);
                let rel_path = path.strip_prefix("/tmp/nix").unwrap_or(&path);
                format!(
                    "    {} = callPackage' ./{} {{}};",
                    entry.name,
                    rel_path.display()
                )
            })
            .collect::<Vec<_>>()
            .join("\n");

        let rendered = handlebars.render(
            "default",
            &serde_json::json!({
                "default_nix_packages": default_nix_packages
            }),
        )?;

        // Write to /tmp/nix/default.nix
        let default_nix_path = PathBuf::from("/tmp/nix/default.nix");
        let mut file = File::create(default_nix_path)?;
        write!(file, "{}", rendered)?;
        Ok(())
    }

    /// custom-build-run_custom-build
    fn process_build_runner(
        unit: &Unit,
        crate_name: String,
        crate_version: String,
        fullname: String,
        process_builder: &ProcessBuilder,
        unit_graph: &UnitGraph,
        is_root: bool,
        all_nodes: &mut Vec<DefaultNixEntry>,
    ) -> CargoResult<()> {
        println!("Generating {}", fullname);

        let mut build_inputs: Vec<String> = vec![];
        if let Some(deps) = unit_graph.get(unit) {
            for dep in deps {
                build_inputs.push(create_nix_name(&dep.unit, NixNameMode::AttributeName));
            }
        }

        let src: String = if is_root {
            let mut handlebars = Handlebars::new();
            let template_str = indoc! {
            r#"
                src = builtins.filterSource
                    (path: type:
                    let base = baseNameOf path;
                    in !(base == "target" || base == "result" || builtins.match "result-*" base != null))
                    {{{src}}};
            "#};
            handlebars.register_template_string("fetch", template_str)?;
            let rendered: String = handlebars.render(
                "fetch",
                &serde_json::json!({
                    "src": std::env::current_dir().unwrap_or(PathBuf::from("./..")),
                }),
            )?;
            rendered
        } else {
            let mut handlebars = Handlebars::new();
            let template_str = indoc! {
            r#"
              src = pkgs.fetchurl {
                url = "https://crates.io/api/v1/crates/{{{crate_name}}}/{{{crate_version}}}/download";
                sha256 = "{{{hash}}}";
              };
            "#};
            handlebars.register_template_string("fetch", template_str)?;
            let rendered: String = handlebars.render(
                "fetch",
                &serde_json::json!({
                    "crate_name": crate_name,
                    "crate_version": crate_version,
                    "hash": unit.pkg.manifest().summary().checksum().unwrap_or(""),
                }),
            )?;
            rendered
        };
        let unpack_phase: String = if is_root {
            indoc! {
            r#"
                    unpackPhase = "";
                "#}
            .to_string()
        } else {
            let mut handlebars = Handlebars::new();
            let template_str = indoc! {
            r#"
                unpackPhase = ''
                    tar xf $src
                    cd {{{crate_name}}}-{{{crate_version}}}
                '';
            "#};

            handlebars.register_template_string("unpack_phase", template_str)?;
            let rendered: String = handlebars.render(
                "unpack_phase",
                &serde_json::json!({
                    "crate_name": crate_name,
                    "crate_version": crate_version,
                }),
            )?;
            rendered
        };

        let install_phase: String = indoc! {
        r#"
            mkdir -p $out
            cp -R $OUT_DIR/* $out
        "#}
        .to_string();

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/rustc-call.nix.handlebars");
        handlebars.register_template_string("rustc-call", template_str)?;

        let environment_variables: String = process_builder
            .get_envs()
            .iter()
            .filter(|(key, _)| {
                *key != "CARGO"
                    && *key != "RUSTC"
                    && *key != "LD_LIBRARY_PATH"
                    && *key != "OUT_DIR"
                    && *key != "CARGO_RUSTC_CURRENT_DIR"
            })
            .map(|(key, value)| match value {
                Some(os_str) => {
                    let s: String = os_str.to_string_lossy().to_string();
                    let res: String = match key.as_str() {
                        // we make these into relative paths, as in the builder there is no fs access to ~/ anyways
                        "CARGO_MANIFEST_DIR" | "CARGO_MANIFEST_PATH" => {
                            // something like: /home/nixos/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f
                            let cwd: &Path = process_builder.get_cwd().unwrap();
                            let path = PathBuf::from(s);
                            let rel_path = path.strip_prefix(cwd).unwrap();
                            format!("./{}", rel_path.display())
                        }
                        _ => s,
                    };
                    format!("    {} = \"{}\";", key, res)
                }
                None => format!("    {} = \"\";", key),
            })
            .collect::<Vec<String>>()
            .join("\n");

        let command_line: String = {
            assert!(build_inputs.len() == 1);
            //format!("${{{}}}/build_script_build-* > $OUT_DIR/build_script_build.out", build_inputs[0]).to_string()

            format!(
                r#"
                ${{{}}}/build_script_build-* > $OUT_DIR/build_script_build.out
                ${{pkgs.parse-build}}/bin/cargo-build_script_build-parser $OUT_DIR/build_script_build.out environment-variables > $OUT_DIR/build_script_build.out.environment-variables
                ${{pkgs.parse-build}}/bin/cargo-build_script_build-parser $OUT_DIR/build_script_build.out rustc-arguments > $OUT_DIR/build_script_build.out.rustc-arguments
            "#,
                build_inputs[0]
            )
        };

        let additional_build_phase_arguments: String = "".to_string();

        let default_function_arguments: Vec<String> = vec!["pkgs", "stdenv", "rustc", "cargo"]
            .iter()
            .map(|m| m.to_string())
            .collect();
        let function_arguments: Vec<String> =
            [default_function_arguments, build_inputs.clone()].concat();

        let rendered = handlebars.render(
            "rustc-call",
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "fullname": create_nix_name(unit, NixNameMode::AttributeName),
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "build_inputs": build_inputs.join(" "),
                "required_inputs": build_inputs.join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": additional_build_phase_arguments,
                "command_line": command_line,
                "install_phase": install_phase,
            }),
        )?;

        let dir = if is_root {
            PathBuf::from("/tmp/nix")
        } else {
            PathBuf::from("/tmp/nix/deps")
        };
        create_dir_all(&dir)?;
        let file_path = dir.join(create_nix_name(unit, NixNameMode::FileName));
        let mut file = File::create(&file_path)?;
        writeln!(file, "{}", rendered)?;

        all_nodes.push(DefaultNixEntry {
            name: create_nix_name(unit, NixNameMode::AttributeName),
            filename: file_path.to_string_lossy().to_string(),
        });

        Ok(())
    }

    fn process_unit(
        unit: &Unit,
        crate_name: String,
        crate_version: String,
        fullname: String,
        process_builder: &ProcessBuilder,
        unit_graph: &UnitGraph,
        is_root: bool,
        all_nodes: &mut Vec<DefaultNixEntry>,
    ) -> CargoResult<()> {
        println!("Generating {}", fullname);

        // println!("unit.target: {:?}", unit.target);
        // println!(
        //     "<<<<<<<<<<<<<<<<<<<<<< rustc {fullname} <<<<<<<<<<<<<<<<<<<<<<",
        // );
        // //println!("{:#?}", process_builder);
        // println!("{:#?}", unit);
        // println!(">>>>>>>>>>>>>>>>>>>>>> /rustc >>>>>>>>>>>>>>>>>>>>>>\n");

        let mut build_inputs: Vec<String> = vec![];
        if let Some(deps) = unit_graph.get(unit) {
            for dep in deps {
                build_inputs.push(create_nix_name(&dep.unit, NixNameMode::AttributeName));
            }
        }

        let src: String = if is_root {
            let mut handlebars = Handlebars::new();
            let template_str = r#"
    src = builtins.filterSource
    (path: type:
      let base = baseNameOf path;
      in !(base == "target" || base == "result" || builtins.match "result-*" base != null))
      {{{src}}};
            "#;
            handlebars.register_template_string("fetch", template_str)?;
            let rendered: String = handlebars.render(
                "fetch",
                &serde_json::json!({
                    "src": std::env::current_dir().unwrap_or(PathBuf::from("./..")),
                }),
            )?;
            rendered
        } else {
            let mut handlebars = Handlebars::new();
            let template_str = indoc! {
            r#"
              src = pkgs.fetchurl {
                url = "https://crates.io/api/v1/crates/{{{crate_name}}}/{{{crate_version}}}/download";
                sha256 = "{{{hash}}}";
              };
            "#};
            handlebars.register_template_string("fetch", template_str)?;
            let rendered: String = handlebars.render(
                "fetch",
                &serde_json::json!({
                    "crate_name": crate_name,
                    "crate_version": crate_version,
                    "hash": unit.pkg.manifest().summary().checksum().unwrap_or(""),
                }),
            )?;
            rendered
        };
        let unpack_phase: String = if is_root {
            r#"
    unpackPhase = "";
"#
            .to_string()
        } else {
            let mut handlebars = Handlebars::new();
            let template_str = r#"
    unpackPhase = ''
      tar xf $src
      cd {{{crate_name}}}-{{{crate_version}}}
    '';
"#;

            handlebars.register_template_string("unpack_phase", template_str)?;
            let rendered: String = handlebars.render(
                "unpack_phase",
                &serde_json::json!({
                    "crate_name": crate_name,
                    "crate_version": crate_version,
                }),
            )?;
            rendered
        };

        let install_phase: String = r#"
              mkdir -p $out
              cp -R $OUT_DIR/* $out
        "#
        .to_string();

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/rustc-call.nix.handlebars");
        handlebars.register_template_string("rustc-call", template_str)?;

        let environment_variables: String = process_builder
            .get_envs()
            .iter()
            .filter(|(key, _)| {
                *key != "CARGO"
                    && *key != "RUSTC"
                    && *key != "LD_LIBRARY_PATH"
                    && *key != "OUT_DIR"
                    && *key != "CARGO_RUSTC_CURRENT_DIR"
            })
            .map(|(key, value)| match value {
                Some(os_str) => {
                    // FIXME if a crates has the Cargo.toml outside the package root this will fail
                    let s: String = os_str.to_string_lossy().to_string();
                    let res: String = match key.as_str() {
                        // we make these into relative paths, as in the builder there is no fs access to ~/ anyways
                        "CARGO_MANIFEST_DIR" | "CARGO_MANIFEST_PATH" => {
                            println!("{}: {:?}", key.as_str(), value);
                            if is_root {
                                s
                            } else {
                                // something like: /home/nixos/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f
                                let cwd: &Path = process_builder.get_cwd().unwrap();
                                let path = PathBuf::from(s);
                                let rel_path = path.strip_prefix(cwd).unwrap();
                                format!("./{}", rel_path.display())
                            }
                        }
                        _ => s,
                    };
                    // };
                    format!("    {} = \"{}\";", key, res)
                }
                None => format!("    {} = \"\";", key),
            })
            .collect::<Vec<String>>()
            .join("\n");

        let command_line: String = format!(
            "      ${{rustc}}/bin/rustc{}",
            process_builder
                .get_args()
                .map(|arg| {
                    let arg_str = arg.to_string_lossy();
                    if arg_str.starts_with('-') {
                        format!(" \\\n        {}", arg_str)
                    } else {
                        format!(" {}", arg_str)
                    }
                })
                .collect::<String>()
        );
        // RUSTC_ADDITIONAL_ARGUMENTS=$(cat ${libc-0_2_170-custom_build-run_custom_build}/build_script_build.out.rustc-arguments)
        let additional_build_phase_arguments: String = "".to_string();

        let default_function_arguments: Vec<String> = vec!["pkgs", "stdenv", "rustc", "cargo"]
            .iter()
            .map(|m| m.to_string())
            .collect();
        let function_arguments: Vec<String> =
            [default_function_arguments, build_inputs.clone()].concat();

        let rendered = handlebars.render(
            "rustc-call",
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "fullname": create_nix_name(unit, NixNameMode::AttributeName),
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "build_inputs": build_inputs.join(" "),
                "required_inputs": build_inputs.join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": additional_build_phase_arguments,
                "command_line": command_line,
                "install_phase": install_phase,
            }),
        )?;

        let dir = if is_root {
            PathBuf::from("/tmp/nix")
        } else {
            PathBuf::from("/tmp/nix/deps")
        };
        create_dir_all(&dir)?;
        let file_path = dir.join(create_nix_name(unit, NixNameMode::FileName));
        let mut file = File::create(&file_path)?;
        writeln!(file, "{}", rendered)?;

        all_nodes.push(DefaultNixEntry {
            name: create_nix_name(unit, NixNameMode::AttributeName),
            filename: file_path.to_string_lossy().to_string(),
        });

        Ok(())
    }
}
