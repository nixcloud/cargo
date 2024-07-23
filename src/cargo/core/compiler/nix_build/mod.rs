mod asserts;
mod download;
mod deps;
mod tests;
pub mod nix_files;
pub mod nix_code;
pub mod nix_build_runner;

use cargo_util::ProcessBuilder;
use handlebars::Handlebars;
use indoc::indoc;
use std::collections::BTreeSet;
use std::fs::File;
use std::io::Write;
use std::path::PathBuf;
use std::fs;

use asserts::assert_escapes;
use deps::{Dependencies, handle_dynamic_crate_aspects};
use nix_files::{create_nix_filepath, write_nix_file};
use nix_code::{IndentationExt, cargo_crate_info, create_nix_name, generate_environment_variables, generate_unpack_phase, generate_src};
use crate::core::compiler::nix_build::nix_build_runner::NixBuild;
use crate::core::compiler::nix_build::nix_files::ensure_garbage_collected_directory;
use crate::core::compiler::unit_graph::UnitGraph;
use crate::core::compiler::Unit;
use crate::core::compiler::{BuildContext, BuildRunner, CompileMode};
use crate::core::workspace::Workspace;
use crate::core::TargetKind;
use crate::util::{CargoResult, Filesystem, GlobalContext};

#[derive(Clone, Debug)]
pub struct NixBuildOptions {
    pub out_dir: PathBuf,
    pub url: String,
    pub hash: String,
}

#[derive(Debug)]
struct DefaultNixEntry {
    name: String,
    rel_file_path: PathBuf,
    is_root: bool,
}

#[derive(Debug, Eq, PartialEq)]
pub enum NixNameMode {
    AttributeName,
    FileName,
}

pub fn kind_string(tk: &TargetKind) -> String {
    match tk {
        TargetKind::Lib(_) => {
            "".to_string() // default, so we leave it empty
        }
        TargetKind::ExampleLib(_) => "-example_lib".to_string(),
        TargetKind::Bin => "-bin".to_string(),
        TargetKind::CustomBuild => "-script_build".to_string(),
        TargetKind::Test => "-test".to_string(),
        TargetKind::Bench => "-bench".to_string(),
        TargetKind::ExampleBin => "-example_bin".to_string(),
    }
}

pub fn mode_string(mode: &CompileMode) -> &str {
    match mode {
        CompileMode::Test => "-test",
        CompileMode::Build => "", // default, so we leave it empty
        CompileMode::Check { test: _ } => "-check",
        CompileMode::Bench => "-bench",
        CompileMode::Doc { deps: _, json: _ } => "-doc",
        CompileMode::Doctest => "-doc_test",
        CompileMode::Docscrape => "-doc_scrape",
        CompileMode::RunCustomBuild => "_run",
    }
}


// FIXME refactor this, we probably can use CompileMode::Build instead now
#[derive(Debug, Clone, Hash, PartialEq, Eq, PartialOrd, Ord)]
enum CrateBuildType {
    LibBuild,
    ScriptBuild,
    ScriptBuildRun,
    BinBuild,
    Other,
}

fn crate_build_type(unit: &Unit) -> CrateBuildType {
    let target_kind: &TargetKind = unit.target.kind();
    let compile_mode: CompileMode = unit.mode;

    if compile_mode == CompileMode::Build && matches!(*target_kind, TargetKind::Lib(_)) {
        CrateBuildType::LibBuild
    } else if compile_mode == CompileMode::Build && *target_kind == TargetKind::CustomBuild {
        CrateBuildType::ScriptBuild
    } else if compile_mode == CompileMode::RunCustomBuild && *target_kind == TargetKind::CustomBuild
    {
        CrateBuildType::ScriptBuildRun
    } else if compile_mode == CompileMode::Build && *target_kind == TargetKind::Bin {
        CrateBuildType::BinBuild
    } else {
        CrateBuildType::Other
    }
}

struct SymlinkedTargets {
    attribute_name: String,
    script: String,
}

pub struct NixBuildRunner {}

impl<'a, 'gctx> NixBuildRunner {
    pub fn build(build_runner: &BuildRunner<'a, 'gctx>) -> CargoResult<()> {
        let bcx: &BuildContext<'a, 'gctx> = &build_runner.bcx;
        let keep_going: bool = bcx.build_config.keep_going;
        let workspace: &Workspace<'gctx> = build_runner.bcx.ws;
        let gctx: &'gctx GlobalContext = bcx.gctx;

        let unit_graph: &UnitGraph = &bcx.unit_graph;
        
        // FIXME is this limitation required? can't we just support all profiles?
        let requested_profile = if build_runner.bcx.build_config.requested_profile == "release" {
            "release"
        } else {
            "debug"
        };

        let mut visited_units = BTreeSet::new();
        let mut all_nodes: Vec<DefaultNixEntry> = Vec::new();
        let all_units_with_process_builder: Vec<(ProcessBuilder, Unit)> =
            build_runner.raw_process_builder.lock().unwrap().clone();

        let mut symlinked_targets: Vec<SymlinkedTargets> = vec![];

        let write_nix_buildsystem_options: Option<NixBuildOptions> = gctx.write_nix_buildsystem_options.borrow().unwrap_or(&None).clone();
        let nix_base_dir: Filesystem = match write_nix_buildsystem_options {
            Some(ref write_nix_buildsystem_options) => {
                if requested_profile != "release" {
                    gctx.shell()
                        .status(
                            "write-nix-buildsystem",
                            format!("\x1b[33mWarning\x1b[0m: requested_profile is '{}', not 'release'.", requested_profile).trim(),
                        )
                        .unwrap();
                }
                crate::util::Filesystem::new(write_nix_buildsystem_options.out_dir.clone())
            },
            None => {
                // files in target/nix should created if new, update if existent and deleted if not used anymore
                let target_dir: Filesystem = workspace.target_dir();
                target_dir.join(requested_profile).join("nix")
            }
        };

        let nix_base_dir_path = nix_base_dir.clone().into_path_unlocked();
        ensure_garbage_collected_directory(&nix_base_dir_path)?;

        let nix_derivations_dir = nix_base_dir.join("derivations");
        nix_derivations_dir.create_dir()?;

        gctx.shell()
            .status(
                "Nix",
                format!(
                    "Creating nix build system for {} cargo units.",
                    all_units_with_process_builder.len()
                ),
            )
        .unwrap();

        for (process_builder, unit) in all_units_with_process_builder.clone() {
            if visited_units.contains(&unit) {
                continue;
            }
            visited_units.insert(unit.clone());
            let pkg = unit.pkg.package_id();
            let is_root: bool = workspace.members().any(|member| member.package_id() == pkg);
            let is_run_custom_build: bool = unit.mode == CompileMode::RunCustomBuild;
            let crate_name: String = pkg.name().to_string();
            let crate_version: String = pkg.version().to_string();
            let nix_attribute_name: String =
                create_nix_name(&unit, build_runner, NixNameMode::AttributeName, false);
            gctx.shell()
                .verbose(|s| s.status("Generating", &nix_attribute_name))?;

            // let s = format!("unit.profile.incremental: {} {:?}", &nix_attribute_name, unit.profile.incremental);
            // println!("{s}");

            let src: String = generate_src(&workspace, &unit, &crate_name, &crate_version, &gctx, &write_nix_buildsystem_options)?;

            let deps: Dependencies = deps::create_unit_dependencies(
                &unit,
                &crate_name,
                &crate_version,
                unit_graph,
                build_runner,
                &all_units_with_process_builder,
                &workspace,
            );

            if is_run_custom_build {
                Self::process_script_build_run(
                    &workspace,
                    &unit,
                    crate_name,
                    crate_version,
                    nix_attribute_name,
                    &process_builder,
                    is_root,
                    &mut all_nodes,
                    build_runner,
                    &deps,
                    &nix_derivations_dir,
                    &src,
                )?
            } else {
                Self::process_unit(
                    &workspace,
                    &unit,
                    crate_name,
                    crate_version,
                    nix_attribute_name,
                    &process_builder,
                    is_root,
                    &mut all_nodes,
                    build_runner,
                    &deps,
                    &nix_derivations_dir,
                    &mut symlinked_targets,
                    &requested_profile,
                    &src
                )?
            }
        }

        // cargo_build_caller.nix //////////////////////////////////////////////////////////////////////////////////
        gctx.shell()
            .verbose(|s| s.status("Generating", "cargo_build_caller.nix"))?;
        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/cargo_build_caller.nix.handlebars");
        handlebars.register_template_string("caller", template_str)?;
        let project_root = match write_nix_buildsystem_options {
            Some(_) => { "." },      // exported build system via write-nix-buildsystem
            None => { "../../.." },  // build system used in normal 'CARGO_BACKEND=nix cargo build'
        };

        let rendered = handlebars.render(
            "caller",
            &serde_json::json!({
                "project_root": project_root,
            }),
        )?;

        let cargo_build_caller_path = nix_base_dir
            .clone()
            .join("cargo_build_caller.nix")
            .into_path_unlocked();
        let mut file = File::create(&cargo_build_caller_path)?;
        write!(file, "{}", rendered)?;

        // build_rs_libnix.nix //////////////////////////////////////////////////////////////////////////////////
           
        gctx.shell().verbose(|s| s.status("Generating", "build_rs_libnix.nix"))?;
        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/build_rs_libnix.nix.handlebars");
        handlebars.register_template_string("build_rs_libnix", template_str)?;

        let rendered = handlebars.render(
            "build_rs_libnix",
            &serde_json::json!({}),
        )?;

        let build_rs_libnix_path = nix_derivations_dir
            .clone()
            .join("build_rs_libnix.nix")
            .into_path_unlocked();
        let mut file = File::create(&build_rs_libnix_path)?;
        write!(file, "{}", rendered)?;

        // default.nix //////////////////////////////////////////////////////////////////////////////////
        gctx.shell()
            .verbose(|s| s.status("Generating", "default.nix"))?;
        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/default.nix.handlebars");
        handlebars.register_template_string("default", template_str)?;

        all_nodes.sort_by(|a, b| a.name.cmp(&b.name));
        let nix_packages_deps = all_nodes
            .iter()
            .filter(|entry| !entry.is_root)
            .map(|entry| {
                format!(
                    "      {} = callPackage' ./{} {{ }};",
                    entry.name,
                    &entry.rel_file_path.display()
                )
            })
            .collect::<Vec<_>>()
            .join("\n");
        // Render default_nix_packages as `name = callPackage' ./relative_path {};`
        let nix_packages_root = all_nodes
            .iter()
            .filter(|entry| entry.is_root)
            .map(|entry| {
                format!(
                    "    {} = callPackage' ./{} {{ }};",
                    entry.name,
                    &entry.rel_file_path.display()
                )
            })
            .collect::<Vec<_>>()
            .join("\n");

        let rendered = handlebars.render(
            "default",
            &serde_json::json!({
                "nix_packages_root": nix_packages_root,
                "nix_packages_deps": nix_packages_deps,
            }),
        )?;

        // nix/default.nix //////////////////////////////////////////////////////////////////////////////////
        gctx.shell()
            .verbose(|s| s.status("Generating", "nix/default.nix"))?;
        let default_nix_path = nix_derivations_dir
            .clone()
            .join("default.nix")
            .into_path_unlocked();
        let mut file = File::create(default_nix_path)?;
        write!(file, "{}", rendered)?;

        // target.nix //////////////////////////////////////////////////////////////////////////////////
        gctx.shell()
            .verbose(|s| s.status("Generating", "nix/target.nix"))?;
        let mut function_arguments_ = symlinked_targets
            .iter()
            .map(|t| t.attribute_name.clone())
            .collect::<Vec<String>>();
        let mut function_arguments: Vec<String> = vec!["pkgs".to_string()];
        function_arguments.append(&mut function_arguments_);

        let targets = symlinked_targets
            .iter()
            .map(|t| {
                t.script
                .indentation(2)
            })
            .collect::<Vec<String>>()
            .join("\n");

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/target.nix.handlebars");
        handlebars.register_template_string("target", template_str)?;
        let rendered = handlebars.render(
            "target",
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "targets": targets,
            }),
        )?;
        let target_path = nix_derivations_dir
            .clone()
            .join("target.nix")
            .into_path_unlocked();
        let mut file = File::create(target_path)?;
        write!(file, "{}", rendered)?;

        if write_nix_buildsystem_options.is_none() {
            NixBuild::build(nix_base_dir, &gctx, keep_going)?;
        } else {
            let target_path: PathBuf = nix_base_dir
                .clone()
                .join("Cargo.dependencies.nix")
                .into_path_unlocked();
            match fs::copy("Cargo.dependencies.nix", target_path) {
                Ok(_) => {
                    let _ = gctx.shell().status("write-nix-buildsystem","Copied Cargo.dependencies.nix to out_dir");
                },
                Err(e) => {
                    gctx.shell().status(
                        "write-nix-buildsystem",
                        format!(
                            "Failed to copy Cargo.dependencies.nix to out_dir: {}",
                            e
                        ),
                    ).ok();
                }
            };
            gctx.shell()
            .status(
                    "write-nix-buildsystem",
                    format!(
                        "Successfully exported build system to '{}'.",
                        nix_base_dir.display()
                    ).trim(),
                )
            .unwrap();
        }
        Ok(())
    }

    fn process_script_build_run(
        workspace: &Workspace<'gctx>,
        unit: &Unit,
        crate_name: String,
        crate_version: String,
        nix_attribute_name: String,
        process_builder: &ProcessBuilder,
        is_root: bool,
        all_nodes: &mut Vec<DefaultNixEntry>,
        build_runner: &BuildRunner<'a, 'gctx>,
        deps: &Dependencies,
        nix_derivations_dir: &Filesystem,
        src: &String,
    ) -> CargoResult<()> {
        let parent_full_name = match &deps.rust_crate_parent {
            Some(val) => val.nix_attribute_name.clone(),
            None => {
                println!("deps.rust_crate_parent must not be empty as we are in process_script_build_run!");
                std::process::abort(); // FIXME rewrite with proper error
            }
        };

        let unpack_phase: String = generate_unpack_phase(&unit, &crate_name, &crate_version)?;

        let file_name: String = create_nix_name(unit, build_runner, NixNameMode::FileName, false);
        let (rel_file_path, file_path) =
            create_nix_filepath(&nix_derivations_dir, &file_name, is_root)?;

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/rustc-call.nix.handlebars");
        handlebars.register_template_string("rustc-call", template_str)?;

        let environment_variables: String =
            generate_environment_variables(workspace, unit, process_builder)?;

        let phases: Vec<&str> = vec!["unpackPhase", "buildPhase"];

        let mut rustc_arguments: Vec<String> = vec![];
        rustc_arguments.push(
            format!(indoc! {
            r#"
                rustc_arguments="";
            "#})
            .to_string()
            .indentation(2),
        );

        let filename_notice_build_script_build = format!(
            "There was an error executing build_script_build in file: '{}':",
            file_path.display()
        );
        let filename_notice_build_parser = format!(
            "There was an error executing build_parser in file: '{}':",
            file_path.display()
        );

        let template_str: String = 
                indoc! {
                r#"
                build_script_build_output_lines=$(${pkgs.mktemp}/bin/mktemp)
                set -x +e
                ${ {{parent_full_name}} }/build_script_build > $OUT_DIR/nix/build_script_build.out 2> $build_script_build_output_lines
                build_script_build_exit_value=$?
                set +x -e

                if [ "$build_script_build_exit_value" -ne 0 ]; then
                    print_cargo_message_type_3 "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" "{{{filename_notice_build_script_build}}}" $build_script_build_exit_value $build_script_build_output_lines
                    cat "$build_script_build_output_lines"
                    exit $build_script_build_exit_value
                fi
                
                build_parser_output_lines=$(${pkgs.mktemp}/bin/mktemp)
                set -x +e
                ${fn.build_rs_libnix} --script-output $OUT_DIR/nix/build_script_build.out --out-dir $out/nix 2> $build_parser_output_lines
                build_parser_exit_value=$?
                set +x -e

                if [ "$build_parser_exit_value" -ne 0 ]; then
                    print_cargo_message_type_3 "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" "{{{filename_notice_build_parser}}}" $build_script_build_exit_value $build_script_build_output_lines
                    cat $build_parser_output_lines
                    exit $build_parser_exit_value
                fi
                echo "@cargo {\"type\": 3, \"crate_name\": \"${meta.cargo_crate_info.name}\", \"crate_type\": \"${meta.cargo_crate_info.type}\", \"exit_code\": 0, \"messages\": []}"
            "#}
            .to_string().indentation(6);

        handlebars.register_template_string("command_line", template_str)?;
        let command_line: String = handlebars.render(
            "command_line",
            &serde_json::json!({
                "parent_full_name": parent_full_name,
                "nix_attribute_name": nix_attribute_name,
                "filename_notice_build_script_build": filename_notice_build_script_build,
                "filename_notice_build_parser": filename_notice_build_parser,
            }),
        )?;

        let default_function_arguments: Vec<String> =
            vec!["pkgs", "fn", "cargo", "rustc", "deps", "project_root"]
                .iter()
                .map(|m| m.to_string())
                .collect();
        let root_deps: Vec<String> = deps
            .all_deps
            .iter()
            .filter(|dep| dep.is_root)
            .map(|m| m.nix_attribute_name.clone())
            .collect();
        let function_arguments: Vec<String> = [default_function_arguments, root_deps].concat();

        let additional_build_phase_arguments = handle_dynamic_crate_aspects(unit, &deps);

        let rendered = handlebars.render(
            "rustc-call",
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "nix_attribute_name": nix_attribute_name,
                "cargo_crate_info": cargo_crate_info(unit, build_runner)?,
                "nix_phases": phases.join(" "),
                "change_directory": "cd $CARGO_MANIFEST_DIR",
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "rust_crate_libraries": deps.rust_crate_libraries.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_crate_parent": deps.rust_crate_parent.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_script_build_run": deps.rust_script_build_run.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": additional_build_phase_arguments.join("\n"),
                "command_line": command_line,
            }),
        )?;

        write_nix_file(file_path, &rendered)?;

        all_nodes.push(DefaultNixEntry {
            name: create_nix_name(unit, build_runner, NixNameMode::AttributeName, false), // refactor into nix_attribute_name?
            rel_file_path,
            is_root,
        });

        Ok(())
    }

    fn process_unit(
        workspace: &Workspace<'gctx>,
        unit: &Unit,
        crate_name: String,
        crate_version: String,
        nix_attribute_name: String,
        process_builder: &ProcessBuilder,
        is_root: bool,
        all_nodes: &mut Vec<DefaultNixEntry>,
        build_runner: &BuildRunner<'a, 'gctx>,
        deps: &Dependencies,
        nix_derivations_dir: &Filesystem,
        symlinked_targets: &mut Vec<SymlinkedTargets>,
        requested_profile: &str,
        src: &String,
    ) -> CargoResult<()> {
        // println!("unit.target: {:?}", unit.target);
        // println!(
        //     "<<<<<<<<<<<<<<<<<<<<<< rustc {nix_attribute_name} <<<<<<<<<<<<<<<<<<<<<<",
        // );
        // //println!("{:#?}", process_builder);
        // println!("{:#?}", unit);
        // println!(">>>>>>>>>>>>>>>>>>>>>> /rustc >>>>>>>>>>>>>>>>>>>>>>\n");

        // let mut rust_crate_libraries: Vec<String> = vec![];

        let unpack_phase: String = generate_unpack_phase(&unit, &crate_name, &crate_version)?;

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/rustc-call.nix.handlebars");
        handlebars.register_template_string("rustc-call", template_str)?;

        let environment_variables: String =
            generate_environment_variables(workspace, unit, process_builder)?;

        let template_str = indoc! {
        r#"
        rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
        set -x +e
        ${RUSTC}{{{process_builder}}} 2> $rustc_json_output_lines
        rustc_exit_value=$?
        set +x -e
             
        print_rustc_rendered_messages $rustc_json_output_lines
        {{{create_symlink}}}
        print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines

        if [ "$rustc_exit_value" -ne 0 ]; then
            exit $rustc_exit_value
        fi
        "#}
        .to_string();

        let process_builder = process_builder
            .get_args()
            .map(|arg| {
                let arg_str = arg.to_string_lossy();
                if arg_str.starts_with('-') {
                    format!(" \\\n        {}", arg_str)
                } else {
                    format!(" {}", arg_str)
                }
            })
            .collect::<String>();

        let create_symlink = if crate_build_type(&unit) == CrateBuildType::ScriptBuild {
            let meta = build_runner.files().metadata(&unit);
            let hash: String = meta.unit_id().to_string();

            format!(
                indoc! {r#"
                    ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-{} $OUT_DIR/build_script_build
                "#},
                hash
            )
            .to_string()
            .indentation(3)
        } else {
            "".to_string()
        };

        handlebars.register_template_string("command_line", template_str)?;
        let command_line: String = handlebars.render(
            "command_line",
            &serde_json::json!({
                "process_builder": assert_escapes(&process_builder),
                "nix_attribute_name": nix_attribute_name,
                "create_symlink": create_symlink,
                "crate_name": crate_name,
            }),
        )?;

        let default_function_arguments: Vec<String> = vec!["fn", "pkgs", "rustc", "cargo", "deps", "project_root"]
            .iter()
            .map(|m| m.to_string())
            .collect();
        let root_deps: Vec<String> = deps
            .all_deps
            .iter()
            .filter(|dep| dep.is_root)
            .map(|m| m.nix_attribute_name.clone())
            .collect();
        let function_arguments: Vec<String> = [default_function_arguments, root_deps].concat();

        let additional_build_phase_arguments = handle_dynamic_crate_aspects(unit, &deps);

        let mut phases: Vec<&str> = vec!["unpackPhase", "buildPhase"];
        let mut append: Vec<String> = vec![];

        if is_root && crate_build_type(&unit) == CrateBuildType::BinBuild {
            // instead of using fn link_targets() or fn link_or_copy() we built the names on the fly
            let meta = build_runner.files().metadata(&unit);
            let hash: String = meta.unit_id().to_string();
            let crate_name: String = unit.target.crate_name().to_string();
            let binary_name: String = unit.target.name().to_string(); // could also be binary_filename(), see manifest.rs
            let crate_name_with_hash = format!("{}-{}", crate_name, hash);
            phases.push("installPhase");
            append.push(
                format!(
                    indoc! {r#"
                      installPhase = ''
                        mkdir $out/bin
                        ln -s $out/{} $out/bin/{}
                      '';
                "#},
                    crate_name_with_hash, binary_name
                )
                .to_string()
                .indentation(4),
            );
            let attribute_name = create_nix_name(
                unit,
                build_runner,
                NixNameMode::AttributeName,
                false,
            );
            symlinked_targets.push(SymlinkedTargets {
                attribute_name: attribute_name.clone(),
                script: format!(
                    indoc! {
                    r#"
                      rm -f target/{}/{}
                      ln -s ${{{}}}/bin/{} target/{}/
                    "#},
                    requested_profile,
                    binary_name,
                    attribute_name,
                    binary_name,
                    requested_profile,
                )
                .to_string()
            });
        } else if is_root && crate_build_type(&unit) == CrateBuildType::LibBuild {
            // Support for [lib] only crates
            let meta = build_runner.files().metadata(&unit);
            let hash: String = meta.unit_id().to_string();
            let name: String = unit.target.name().to_string();

            let attribute_name = create_nix_name(
                unit,
                build_runner,
                NixNameMode::AttributeName,
                false,
            );

            // List the extensions and their prefixes. Adjust "lib" if needed.
            let exts = [("rlib", "lib"), ("so", "lib"), ("a", "lib"), ("rmeta", "lib"), ("d", "lib")];

            // Build the body of the script.
            let mut script_body = String::new();
            for (ext, prefix) in exts.iter() {
                let src_name = format!("{prefix}{name}-{hash}.{ext}");
                let dst_name = format!("{prefix}{name}.{ext}");
                script_body.push_str(&format!(
                    indoc! {
                    r#"
                        if [[ -f "${{{}}}/{}" ]]; then
                          ln -fs ${{{}}}/{} target/{}/{}
                        fi
                    "#},
                    attribute_name, src_name, attribute_name, src_name, requested_profile, dst_name
                ));
            }

            symlinked_targets.push(SymlinkedTargets {
                attribute_name: attribute_name.clone(),
                script: script_body,
            });
        }

        let rendered = handlebars.render(
            "rustc-call",
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "nix_attribute_name": create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
                "cargo_crate_info": cargo_crate_info(unit, build_runner)?,
                "nix_phases": phases.join(" "),
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "change_directory": "",
                "rust_crate_libraries": deps.rust_crate_libraries.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_crate_parent": deps.rust_crate_parent.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_script_build_run": deps.rust_script_build_run.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": additional_build_phase_arguments.join("\n"),
                "command_line": command_line.indentation(6),
                "append": append.join("\n"),
            }),
        )?;
        let file_name: String = create_nix_name(unit, build_runner, NixNameMode::FileName, false);
        let (rel_file_path, file_path) =
            create_nix_filepath(&nix_derivations_dir, &file_name, is_root)?;
        write_nix_file(file_path, &rendered)?;

        all_nodes.push(DefaultNixEntry {
            name: create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
            rel_file_path,
            is_root,
        });
        Ok(())
    }
}
