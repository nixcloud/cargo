pub mod nix_build_runner;

use crate::core::compiler::unit_graph::UnitGraph;
use crate::core::compiler::Unit;
use crate::core::compiler::{BuildContext, BuildRunner};
use crate::util::CargoResult;
use cargo_util::ProcessBuilder;
use handlebars::Handlebars;
use std::path::Path;

use std::collections::BTreeSet;
use std::fs::{create_dir_all, File};
use std::io::Write;
use std::path::PathBuf;

#[derive(Debug)]
struct DefaultNixEntry {
    name: String,
    filename: String,
}

pub struct NixBuildRunner {}

impl<'a, 'gctx> NixBuildRunner {
    pub fn new(build_runner: &BuildRunner<'a, 'gctx>) -> CargoResult<()> {
        let bcx: &BuildContext<'a, 'gctx> = &build_runner.bcx;
        let workspace = build_runner.bcx.ws;
        let unit_graph: &UnitGraph = &bcx.unit_graph;
        let mut visited = BTreeSet::new();
        let mut all_nodes: Vec<DefaultNixEntry> = Vec::new();

        let dir = PathBuf::from("/tmp/nix");
        create_dir_all(&dir)?;

        for (process_builder, unit) in &build_runner.raw_process_builder {
            let pkg = unit.pkg.package_id();
            let crate_name = pkg.name().to_string();
            let is_root = workspace.members().any(|member| member.package_id() == pkg);
            println!(
                "<<<<<<<<<<<<<<<<<<<<<< rustc {}<<<<<<<<<<<<<<<<<<<<<<",
                crate_name
            );
            println!("{:#?}", process_builder);
            println!("{:#?}", unit);
            println!(">>>>>>>>>>>>>>>>>>>>>> /rustc >>>>>>>>>>>>>>>>>>>>>>\n");
            Self::process_unit(
                unit,
                process_builder,
                unit_graph,
                is_root,
                &mut visited,
                &mut all_nodes,
            )?;
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

    fn process_unit(
        unit: &Unit,
        process_builder: &ProcessBuilder,
        unit_graph: &UnitGraph,
        is_root: bool,
        visited: &mut BTreeSet<Unit>,
        all_nodes: &mut Vec<DefaultNixEntry>,
    ) -> CargoResult<()> {
        if visited.contains(unit) {
            return Ok(());
        }
        visited.insert(unit.clone());

        let mut build_inputs: Vec<String> = vec![];

        // // Recursively process dependencies first
        if let Some(deps) = unit_graph.get(unit) {
            for dep in deps {
                let pkg = dep.unit.pkg.package_id();
                let crate_name = pkg.name().to_string();
                let crate_version = pkg.version().to_string();
                build_inputs.push(format!(
                    "{}-{}",
                    crate_name,
                    crate_version.replace(".", "_")
                ));
            }
        }

        let pkg = unit.pkg.package_id();
        println!("unit.target: {:?}", unit.target);

        let crate_name = pkg.name().to_string();
        let crate_version = pkg.version().to_string();

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
            let template_str = r#"
    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/{{{crate_name}}}/{{{crate_version}}}/download";
      sha256 = "{{{hash}}}";
    };
            "#;
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

        let dir = if is_root {
            PathBuf::from("/tmp/nix")
        } else {
            PathBuf::from("/tmp/nix/deps")
        };
        create_dir_all(&dir)?;

        let file_path = dir.join(format!("{}-{}.nix", crate_name, crate_version));
        let mut file = File::create(&file_path)?;

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/rustc-call.nix.handlebars");
        handlebars.register_template_string("rustc-call", template_str)?;

        let environment_variables: String = process_builder
            .get_envs()
            .iter()
            .filter(|(key, _)| *key != "CARGO" && *key != "LD_LIBRARY_PATH" && *key != "OUT_DIR" && *key != "CARGO_RUSTC_CURRENT_DIR")
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
                        },
                        _ => s
                    };
                    format!("    {} = \"{}\";", key, res)
                },
                None => format!("    {} = \"\";", key),
            })
            .collect::<Vec<String>>()
            .join("\n");

        let rustc_command_line: String = format!(
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
                "crate_name": crate_name,
                "src": src,
                "unpack_phase": unpack_phase,
                "crate_version": crate_version,
                "build_inputs": build_inputs.join(" "),
                "environment_variables": environment_variables,
                "rustc_command_line": rustc_command_line,
            }),
        )?;

        writeln!(file, "{}", rendered)?;

        all_nodes.push(DefaultNixEntry {
            name: format!("{}-{}", crate_name, crate_version.replace(".", "_")),
            filename: file_path.to_string_lossy().to_string(),
        });

        Ok(())
    }
}
