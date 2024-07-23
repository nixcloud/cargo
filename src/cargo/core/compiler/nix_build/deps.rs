use regex::Regex;
use indoc::indoc;

use crate::core::TargetKind;
use crate::util::command_prelude::CompileMode;
use crate::core::compiler::Unit;
use crate::core::compiler::BuildRunner;
use crate::core::compiler::unit_graph::UnitGraph;
use crate::core::compiler::nix_build::{CrateBuildType, NixNameMode, crate_build_type, create_nix_name};
use crate::core::compiler::nix_build::nix_code::{AttrReplaceExt, IndentationExt};
use crate::core::Workspace;
use cargo_util::ProcessBuilder;

#[derive(Debug, Clone)]
pub struct Dependency {
    pub nix_attribute_name: String,
    pub is_root: bool,
}

#[derive(Debug)]
pub struct Dependencies {
    /// all units, not sorted, not filtered
    pub all_deps: Vec<Dependency>,
    /// contains only libraries used for -L
    pub rust_crate_libraries: Vec<Dependency>,
    /// should contain at max one parent: CrateBuildType hierarchy basically
    pub rust_crate_parent: Option<Dependency>,
    /// contains all script_build_run inputs to this unit
    pub rust_script_build_run: Vec<Dependency>,
}

/// environment-variables / rustc-arguments / rustc-propagated-arguments
/// require special care between different crate build steps: ScriptBuild / ScriptBuildRun / LibBuild
pub fn handle_dynamic_crate_aspects(unit: &Unit, deps: &Dependencies) -> Vec<String> {
    let mut additional_build_phase_arguments: Vec<String> = vec![];
    let source_environment_variables: String = indoc! {r#"
      load_environment_variables_from_files "${fn.environment_variables passthru.rust_script_build_run}"
    "#}
    .to_string();

    match crate_build_type(unit) {
        CrateBuildType::BinBuild => {
            additional_build_phase_arguments.push(source_environment_variables.indentation(6));
            match &deps.rust_crate_parent {
                Some(_) => {
                    additional_build_phase_arguments
                        .push(format!(indoc! {r#"
                        copy_build_script_run_results_over_without_nix "${{fn.get_rust_crate_parent passthru.rust_crate_parent}}"
                    "#}).to_string().indentation(6));
                }
                None => {}
            };
        }
        CrateBuildType::LibBuild | CrateBuildType::ScriptBuild | CrateBuildType::ScriptBuildRun => {
            match &deps.rust_crate_parent {
                Some(_) => {
                    if crate_build_type(unit) == CrateBuildType::LibBuild {
                        additional_build_phase_arguments
                            .push(format!(indoc! {r#"
                            copy_build_script_run_results_over_with_nix "${{fn.get_rust_crate_parent passthru.rust_crate_parent}}"
                        "#}).to_string().indentation(6));
                        additional_build_phase_arguments
                            .push(format!(indoc! {r#"
                            for file in $out/environment-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
                                if [ -f "$file" ]; then
                                sed -i "s|${{fn.get_rust_crate_parent passthru.rust_crate_parent}}|$out|g" "$file"
                                fi
                            done
                        "#}).to_string().indentation(6));
                    }
                    additional_build_phase_arguments
                        .push(source_environment_variables.indentation(6));
                }
                None => {}
            };
        }
        _ => {}
    }
    additional_build_phase_arguments
}

/// a unit in cargo has several dependencies like build.rs but also crates used for linking (rlib)
/// this function splits these dependencies into said groups so that the nix scripts have an
/// easy time working with the filtered subsets
pub fn create_unit_dependencies<'a, 'gctx>(
    unit: &Unit,
    crate_name: &String,
    crate_version: &String,
    unit_graph: &UnitGraph,
    build_runner: &BuildRunner<'a, 'gctx>,
    all_units_with_process_builder: &Vec<(ProcessBuilder, Unit)>,
    workspace: &Workspace<'gctx>,
) -> Dependencies {
    fn is_root<'a, 'gctx>(unit: &Unit, workspace: &Workspace<'gctx>) -> bool {
        let pkg = unit.pkg.package_id();
        workspace.members().any(|member| member.package_id() == pkg)
    }

    let mut all_deps: Vec<Dependency> = vec![];
    let mut rust_crate_libraries: Vec<Dependency> = vec![];
    let mut rust_script_build_run: Vec<Dependency> = vec![];

    if let Some(deps) = unit_graph.get(unit) {
        for dep in deps {
            all_deps.push(Dependency {
                nix_attribute_name: create_nix_name(
                    &dep.unit,
                    &build_runner,
                    NixNameMode::AttributeName,
                    false,
                ),
                is_root: is_root(&dep.unit, workspace),
            });
            // all except -custom-build and -custom-build_run dependencies
            match dep.unit.target.kind() {
                TargetKind::Lib(_)
                | TargetKind::ExampleLib(_)
                | TargetKind::Bin
                | TargetKind::ExampleBin => {
                    if dep.unit.mode != CompileMode::Build {
                        continue;
                    }
                    rust_crate_libraries.push(Dependency {
                        nix_attribute_name: create_nix_name(
                            &dep.unit,
                            &build_runner,
                            NixNameMode::AttributeName,
                            false,
                        ),
                        is_root: is_root(&dep.unit, workspace),
                    });
                }
                _ => {}
            }
            // script_build_run
            match dep.unit.target.kind() {
                TargetKind::CustomBuild => {
                    if dep.unit.mode == CompileMode::RunCustomBuild {
                        let c: &Unit = &find_lib_build_target(
                            &unit,
                            &dep.unit,
                            &unit_graph,
                            &all_units_with_process_builder,
                        );
                        let c_name =
                            create_nix_name(c, &build_runner, NixNameMode::AttributeName, false);
                        let d = Dependency {
                            nix_attribute_name: c_name.clone(),
                            is_root: is_root(c, workspace),
                        };
                        if !all_deps.iter().any(|dep| dep.nix_attribute_name == c_name) {
                            all_deps.push(d.clone());
                        }
                        rust_script_build_run.push(d);
                    }
                }
                _ => {}
            }
        }
    }
    // when building cargo the 'rustls-0_23_23-script_build_run' has two inputs
    // Generating rustls-0_23_23-script_build_run
    // 2: [
    //     "ring-0_17_11-script_build_run",
    //     "rustls-0_23_23-script_build",
    // ]
    let search: String = match crate_build_type(unit) {
        CrateBuildType::BinBuild | CrateBuildType::LibBuild => {
            format!("{}-{}-script_build_run", crate_name, crate_version).nix_attr_replace()
        }
        CrateBuildType::ScriptBuildRun => {
            format!("{}-{}-script_build", crate_name, crate_version).nix_attr_replace()
        }
        _ => "".to_string(), // FIXME
    };

    let pattern = format!(r"^{}-[a-zA-Z0-9]+$", search);
    let re = Regex::new(&pattern).unwrap();
    let found_elements: Vec<Dependency> = all_deps
        .clone()
        .into_iter()
        .filter(|f| re.is_match(f.nix_attribute_name.as_str()))
        .collect();
    let rust_crate_parent: Option<Dependency> = match found_elements.len() {
        0 => None,
        1 => Some(found_elements[0].clone()),
        _ => {
            println!("unit: '{}' claims to have more than one parent", search);
            std::process::abort(); // FIXME rewrite with proper error
        }
    };

    Dependencies {
        all_deps,
        rust_crate_libraries,
        rust_crate_parent,
        rust_script_build_run,
    }
}

/// in the terminology of CrateBuildType we need to find LibBuild and we come from ScriptBuildRun
/// in other words: find the unit which makes use of this build.rs execution
/// why? in vanilla cargo all 3 share the same directory and in the nix build system they don't

// base: curl-sys-0_4_80_plus_curl-8_12_1-script_build_run-2bd25bf7f874b161
//   rust_script_build_run: libnghttp2-sys-0_1_11_plus_1_64_0-script_build_run-a7a473a2bc3c4265
//   rust_script_build_run: libz-sys-1_1_21-script_build_run-9964415cd6446950
//   rust_script_build_run: openssl-sys-0_9_106-script_build_run-bf6c2c38618f44c9
// -> rewrite each

// base: curl-0_4_47-script_build_run-7162e6f0e51e3a28
//   rust_script_build_run: curl-sys-0_4_80_plus_curl-8_12_1-script_build_run-2bd25bf7f874b161
//   rust_script_build_run: openssl-sys-0_9_106-script_build_run-bf6c2c38618f44c9
// -> rewrite each

// base: cargo-0_88_0-bin-fafc14832178210d
//   rust_script_build_run: cargo-0_88_0-script_build_run-dc81d07243ae70b8
// -> rewrite each

// base: cargo-0_88_0-d76731b471aa2da9
//   rust_script_build_run: cargo-0_88_0-script_build_run-dc81d07243ae70b8
// -> no rewrite
fn find_lib_build_target<'a, 'gctx>(
    unit: &Unit,
    passthru_rust_script_build_run: &Unit,
    unit_graph: &UnitGraph,
    all_units_with_process_builder: &Vec<(ProcessBuilder, Unit)>,
) -> Unit {
    for (_, loop_unit) in all_units_with_process_builder.clone() {
        if let Some(deps) = unit_graph.get(&loop_unit) {
            for dep in deps {
                if dep.unit == *passthru_rust_script_build_run {
                    if matches!(loop_unit.target.kind(), TargetKind::Lib(_))
                        || matches!(loop_unit.target.kind(), TargetKind::ExampleLib(_))
                    {
                        if matches!(&loop_unit.mode, CompileMode::Build) {
                            let u = loop_unit.clone();
                            if u == *unit {
                                return passthru_rust_script_build_run.clone();
                            } else {
                                return u.clone();
                            }
                        }
                    }
                }
            }
        }
    }
    return passthru_rust_script_build_run.clone();
}