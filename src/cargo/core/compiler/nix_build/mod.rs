mod download;
pub mod nix_build_runner;
pub mod build_rs_parser;
use download::download_git_for_metadata;
mod asserts;
use asserts::{assert_valid_nix_attr_name, assert_valid_nix_file_name, assert_escapes};

use crate::core::compiler::unit_graph::UnitGraph;
use crate::core::compiler::Unit;
use crate::core::compiler::{BuildContext, BuildRunner, CompileMode};
use crate::core::workspace::Workspace;
use crate::core::SourceKind;
use crate::core::TargetKind;
use crate::util::CargoResult;
use anyhow::anyhow;
use cargo_util::ProcessBuilder;
use handlebars::Handlebars;
use regex::Regex;

use indoc::indoc;
use std::collections::BTreeSet;
use std::fs::{create_dir_all, File};
use std::io::Write;
use std::path::{Path, PathBuf, Component};


#[derive(Debug)]
struct DefaultNixEntry {
    name: String,
    filename: String,
}

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
        TargetKind::CustomBuild => "-script_build".to_string(),
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
        CompileMode::RunCustomBuild => "_run",
    }
}

pub trait AttrReplaceExt: ToString {
    fn nix_attr_replace(&self) -> String;
}

impl AttrReplaceExt for String {
    fn nix_attr_replace(&self) -> String {
        self.replace(".", "_").nix_file_replace()
    }
}

pub trait FileReplaceExt: ToString {
    fn nix_file_replace(&self) -> String;
}

impl FileReplaceExt for String {
    fn nix_file_replace(&self) -> String {
        self.replace("+", "_plus_")
    }
}

pub trait IndentationExt: ToString {
    fn indentation(&self, spaces: usize) -> String;
}

impl IndentationExt for String {
    fn indentation(&self, spaces: usize) -> String {
        let space_str = " ".repeat(spaces);
        self.lines()
            .map(|line| space_str.clone() + line)
            .collect::<Vec<_>>()
            .join("\n")
    }
}

pub fn strip_path_after_checkouts(path: &Path) -> Option<PathBuf> {
    let components: Vec<_> = path.components().collect();

    // Search from the end toward the beginning for `.cargo`
    for (i, comp) in components.iter().enumerate().rev() {
        if let Component::Normal(os_str) = comp {
            if *os_str == ".cargo" {
                // Check the next components: git, checkouts, X, Y
                if i + 4 < components.len() {
                    let git = &components[i + 1];
                    let checkouts = &components[i + 2];

                    if git.as_os_str() == "git" && checkouts.as_os_str() == "checkouts" {
                        // Ensure next two are arbitrary (X and Y), then take everything after that
                        let remaining = &components[i + 5..];
                        let mut result = PathBuf::new();
                        for comp in remaining {
                            result.push(comp.as_os_str());
                        }
                        return Some(result);
                    }
                }
            }
        }
    }

    None
}

fn escape_environment_variable(input: String) -> String {
    let mut result = String::with_capacity(input.len());
    let mut chars = input.chars().peekable();

    while let Some(c) = chars.next() {
        if c == '"' {
            // Check if the previous char was NOT a backslash
            if !result.ends_with('\\') {
                result.push('\\');
            }
            result.push('"');
        } else {
            result.push(c);
        }
    }
    result
}

pub fn cargo_crate_info<'a, 'gctx>(
    unit: &Unit,
    build_runner: &BuildRunner<'a, 'gctx>,
) -> CargoResult<String> {
    let pkg = unit.pkg.package_id();
    let crate_name = pkg.name().to_string();
    let crate_version = pkg.version().to_string();

    let meta = build_runner.files().metadata(&unit);
    let crate_hash: String = meta.c_extra_filename().unwrap().to_string();

    let cargo_crate_info: String = format!(indoc!{r#"
    meta.cargo_crate_info = {{
      name = "{}";
      version = "{}";
      crate_hash = "{}";
    }};"#}, crate_name, crate_version, crate_hash).to_string().indentation(4);
      Ok(cargo_crate_info)
}

pub fn create_nix_name<'a, 'gctx>(
    unit: &Unit,
    build_runner: &BuildRunner<'a, 'gctx>,
    nix_name_mode: NixNameMode,
    only_name_and_version: bool,
) -> String {
    let pkg = unit.pkg.package_id();
    let crate_name = pkg.name().to_string();
    let crate_version = pkg.version().to_string();
    let kind: String = kind_string(unit.target.kind());
    let mode: &str = mode_string(&unit.mode);

    let meta = build_runner.files().metadata(&unit);
    let cargo_hash: String = meta.c_extra_filename().unwrap().to_string();

    let nix_name: String = 
    match only_name_and_version {
        false => format!("{}-{}{}{}-{}", crate_name, crate_version, kind, mode, cargo_hash),
        true => format!("{}-{}", crate_name, crate_version)
    };
    match nix_name_mode {
        NixNameMode::AttributeName => {
            return assert_valid_nix_attr_name(nix_name.nix_attr_replace())
        }
        NixNameMode::FileName => {
            let file_name = nix_name + ".nix";
            return assert_valid_nix_file_name(file_name.nix_file_replace())
        }
    };
}

#[derive(Debug, Clone, Hash, PartialEq, Eq, PartialOrd, Ord)]
enum CrateBuildType {
    LibBuild,
    ScriptBuild,
    ScriptBuildRun,
    Other
}

fn crate_build_type(
    unit: &Unit,
) -> CrateBuildType {
    let target_kind: &TargetKind = unit.target.kind();
    let compile_mode: CompileMode = unit.mode;

    if compile_mode == CompileMode::Build && matches!(*target_kind, TargetKind::Lib(_)) {
        CrateBuildType::LibBuild
    } else if compile_mode == CompileMode::Build && *target_kind == TargetKind::CustomBuild {
        CrateBuildType::ScriptBuild
    } else if compile_mode == CompileMode::RunCustomBuild && *target_kind == TargetKind::CustomBuild {
        CrateBuildType::ScriptBuildRun
    } else {
        CrateBuildType::Other
    }
}

struct Dependencies {
    /// all inputs, not sorted, not filtered
    all_deps: Vec<String>,
    /// contains only libraries used for -L
    rust_crate_libraries: Vec<String>,
    /// should contain at max one parent: CrateBuildType hierarchy basically
    rust_crate_parent: Vec<String>,
    /// contains all script_build_run inputs to this unit
    rust_script_build_run: Vec<String>,
}

fn generate_environment_variables<'gctx>(
    workspace: &Workspace<'gctx>,
    unit: &Unit,
    process_builder: &ProcessBuilder,
) -> CargoResult<String> {
    let ret = process_builder
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
            let env_value: String = os_str.to_string_lossy().to_string();
            let res: String = match key.as_str() {
                // we make these into relative paths, as in the builder there is no fs access to ~/ anyways
                "CARGO_MANIFEST_DIR" | "CARGO_MANIFEST_PATH" => {
                    generate_manifest_environment_variables(key.clone(), env_value, unit, process_builder, workspace).unwrap()
                }
                _ => escape_environment_variable(env_value),
            };
            format!("    {} = \"{}\";", key, res)
        }
        None => format!("    {} = \"\";", key),
    })
    .collect::<Vec<String>>()
    .join("\n");
    Ok(ret)
}

/// environment-variables / environment-propagated-variables / rustc-arguments / rustc-propagated-arguments
/// require special care between different crate build steps: ScriptBuild / ScriptBuildRun / LibBuild
fn handle_dynamic_crate_aspects (
    unit: &Unit,
    deps: &Dependencies,
) -> (Vec<String>, Vec<String>) {
    let mut additional_build_phase_arguments: Vec<String> = vec![];
    let mut rustc_arguments: Vec<String> = vec![];

    match crate_build_type(unit) {
        CrateBuildType::LibBuild |
        CrateBuildType::ScriptBuild |
        CrateBuildType::ScriptBuildRun => {
            match deps.rust_crate_parent.len() {
                0 => {
                    rustc_arguments.push(
                        format!(
                            indoc! {r#"
                            rustc_arguments="";
                        "#}).to_string().indentation(2));
                },
                1 => {
                    let parent_full_name: String = deps.rust_crate_parent[0].clone();
                    if crate_build_type(unit) == CrateBuildType::LibBuild {
                        additional_build_phase_arguments
                            .push(format!("cp -r ${{{}}}/* $OUT_DIR", parent_full_name).to_string().indentation(6));
                        additional_build_phase_arguments
                            .push(format!(indoc! {r#"
                            for file in $out/environment-variables $out/environment-propagated-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
                                if [ -f "$file" ]; then
                                    sed -i "s|${{{}}}|$out|g" "$file"
                                fi
                            done
                        "#}, parent_full_name).to_string().indentation(6));
                    }
                    additional_build_phase_arguments.push(
                        format!(
                            indoc! {r#"
                        if [ -f ${{{}}}/environment-variables ]; then
                            set -a
                            source ${{{}}}/environment-variables; 
                            set +a
                        fi
                        for file in ${{fn.environment_propagated_variables passthru.rust_script_build_run}} ${{{}}}/environment-propagated-variables; do
                            if [ -f $file ]; then
                                set -a
                                while read -r line; do
                                    echo -e "\033[38;5;208m$line\033[0m"
                                done < "$file"
                                source $file
                                set +a
                            fi  
                        done
                        "#}, parent_full_name, parent_full_name, parent_full_name
                        )
                        .to_string().indentation(6),
                    );
                    rustc_arguments.push(
                        format!(
                            indoc! {r#"
                            rustc_arguments = fn.rustc_arguments {};
                        "#},
                        parent_full_name).to_string().indentation(2));
                },
                _ => {
                    println!("For buildInputs found these matches: {}", deps.rust_crate_parent.len());
                    println!("  buildInputs: {:?}", deps.rust_crate_parent);
                    std::process::abort(); // FIXME rewrite with proper error
                }
            };
        },
        _ => {}
    }
    (additional_build_phase_arguments, rustc_arguments)
}

fn write_nix_file(
    file_name: &String,
    content: &String,
    is_root: bool,
) -> CargoResult<PathBuf> {
    let dir = if is_root {
        PathBuf::from("/tmp/nix")
    } else {
        PathBuf::from("/tmp/nix/deps")
    };
    create_dir_all(&dir)?;
    let file_path = dir.join(file_name);

    let mut file = File::create(&file_path)?;
    writeln!(file, "{}", content)?;
    Ok(file_path)
}


fn crate_name_and_version(
    unit: &Unit,
) -> (String, String) {
    let pkg = unit.pkg.package_id();
    let crate_name = pkg.name().to_string();
    let crate_version = pkg.version().to_string();
    (crate_name, crate_version)
}

/// in the terminology of CrateBuildType we need to find LibBuild and we come from ScriptBuildRun
/// in other words: find the unit which makes use of this build.rs execution
/// why? in vanilla cargo all 3 share the same directory and in the nix build system they don't
/// 
/// Generating curl-sys-0_4_80_plus_curl-8_12_1-script_build_run-2bd25bf7f874b161
// base unit: curl-sys-0_4_80_plus_curl-8_12_1-script_build_run-2bd25bf7f874b161
//
// input: libnghttp2-sys-0_1_11_plus_1_64_0-script_build_run-a7a473a2bc3c4265
// input: libz-sys-1_1_21-script_build_run-9964415cd6446950
// input: openssl-sys-0_9_106-script_build_run-bf6c2c38618f44c9

// Generating curl-0_4_47-script_build_run-7162e6f0e51e3a28
// base unit: curl-0_4_47-script_build_run-7162e6f0e51e3a28
//
// input: curl-sys-0_4_80_plus_curl-8_12_1-script_build_run-2bd25bf7f874b161
// input: openssl-sys-0_9_106-script_build_run-bf6c2c38618f44c9

fn find_lib_build_target<'a, 'gctx>(
    unit: &Unit,
    passthru_rust_script_build_run: &Unit,
    unit_graph: &UnitGraph,
    build_runner: &BuildRunner<'a, 'gctx>,
    all_units_with_process_builder: &Vec<(ProcessBuilder, Unit)>
) -> CargoResult<Unit> {

    let (unit_name, _) = crate_name_and_version(unit);
    let (passthru_rust_script_build_run_name, _) = crate_name_and_version(passthru_rust_script_build_run);

    if unit_name == passthru_rust_script_build_run_name {
        return Ok(passthru_rust_script_build_run.clone())
    } else {
        for (_, loop_unit) in all_units_with_process_builder.clone() {
            if let Some(deps) = unit_graph.get(&loop_unit) {
                for dep in deps {
                    if dep.unit == *passthru_rust_script_build_run {
                        if matches!(loop_unit.target.kind(), TargetKind::Lib(_)) || matches!(loop_unit.target.kind(), TargetKind::ExampleLib(_)) {
                            if matches!(&loop_unit.mode, CompileMode::Build) {
                                return Ok(loop_unit.clone())
                            }
                        }
                    }
                }
            }
        }
    }

    println!("-----------------------------");
    println!("base unit: {}",
        create_nix_name(
            &unit,
            &build_runner,
            NixNameMode::AttributeName,
            false,
        ));
    println!("input: {}",
    create_nix_name(
        &passthru_rust_script_build_run,
        &build_runner,
        NixNameMode::AttributeName,
        false,
    ));        
    println!("-----------------------------");
    return Err(anyhow!("find_lib_build_target could not find the parent of the unit"))
}

fn process_deps<'a, 'gctx>(
    unit: &Unit,
    crate_name: &String,
    crate_version: &String,
    unit_graph: &UnitGraph,
    build_runner: &BuildRunner<'a, 'gctx>,
    all_units_with_process_builder: &Vec<(ProcessBuilder, Unit)>
) -> Dependencies {
    let mut all_deps = vec![];
    let mut rust_crate_libraries = vec![];
    let mut rust_crate_parent = vec![];
    let mut rust_script_build_run = vec![];

    if let Some(deps) = unit_graph.get(unit) {
        for dep in deps {
            all_deps.push(create_nix_name(
                &dep.unit,
                &build_runner,
                NixNameMode::AttributeName,
                false,
            ));
            // all except -custom-build and -custom-build_run dependencies
            match dep.unit.target.kind() {
                TargetKind::Lib(_)
                | TargetKind::ExampleLib(_)
                | TargetKind::Bin
                | TargetKind::ExampleBin => {
                    if dep.unit.mode != CompileMode::Build {
                        continue;
                    }
                    rust_crate_libraries.push(create_nix_name(
                        &dep.unit,
                        &build_runner,
                        NixNameMode::AttributeName,
                        false,
                    ));
                }
                _ => {}
            }
            // script_build_run
            match dep.unit.target.kind() {
                TargetKind::CustomBuild => {
                    if dep.unit.mode == CompileMode::RunCustomBuild {
                        let c = &find_lib_build_target(
                            &unit,
                            &dep.unit,
                            &unit_graph,
                            &build_runner,
                            &all_units_with_process_builder,
                        ).unwrap();
                        let c_name = create_nix_name(
                            c,
                            &build_runner,
                            NixNameMode::AttributeName,
                            false,
                        );
                        if !all_deps.contains(&c_name) {
                            all_deps.push(c_name.clone());
                        }
                        rust_script_build_run.push(c_name);
                    }
                },
                _ => {}
            }
            
        }
        //println!("{}: {:#?}", build_inputs.len(), build_inputs);

        // when building cargo 'rustls-0_23_23-script_build_run' actually has two inputs
        // Generating rustls-0_23_23-script_build_run
        // 2: [
        //     "ring-0_17_11-script_build_run",
        //     "rustls-0_23_23-script_build",
        // ]
        let search: String =
        match crate_build_type(unit) {
          CrateBuildType::LibBuild => {
            format!("{}-{}-script_build_run", crate_name, crate_version).nix_attr_replace()
          },
          CrateBuildType::ScriptBuildRun => {
            format!("{}-{}-script_build", crate_name, crate_version).nix_attr_replace()
          },
          _ => "".to_string() // FIXME
        };
        let mut matches: Vec<(usize, &String)> = Vec::new();
        for (index, input) in all_deps.iter().enumerate() {
            //println!("input: {:?}", input);
            //println!("search: {:?}", search);
            let pattern = format!(r"^{}-[a-zA-Z0-9]+$", search);
            let re = Regex::new(&pattern).unwrap();
            if re.is_match(input) {
                matches.push((index, input));
            }
        }
        //println!("matches.len() {:?}", matches.len());
        for (_, name) in matches {
            rust_crate_parent.push(name.clone());
        }
    }
    Dependencies { all_deps, rust_crate_libraries, rust_crate_parent, rust_script_build_run }
}

fn generate_unpack_phase<'gctx>(
    unit: &Unit,
    crate_name: &String,
    crate_version: &String,
) -> CargoResult<String> {
    let source_id = unit.pkg.package_id().source_id();
    let ret: String = match source_id.kind() {
        SourceKind::Path => {
            indoc! {r#"
              unpackPhase = "";
            "#}
            .to_string()
        },
        SourceKind::Git(_git_ref) => {
            indoc! {r#"
            unpackPhase = ''
              cd $src/$CARGO_MANIFEST_DIR
            '';
          "#}
          .to_string()
        },
        SourceKind::Registry => {
            if source_id.is_crates_io() {
                let mut handlebars = Handlebars::new();
                let template_str = indoc! {
                r#"
                    unpackPhase = ''
                      tar xf $src
                      cd {{{crate_name}}}-{{{crate_version}}}
                    '';
                "#}.to_string();

                handlebars.register_template_string("unpack_phase", template_str)?;
                let rendered: String = handlebars.render(
                    "unpack_phase",
                    &serde_json::json!({
                        "crate_name": crate_name,
                        "crate_version": crate_version,
                    }),
                )?;
                rendered
            } else {
                println!("Unsupported: Source is another registry: {}", source_id.url());
                return Err(anyhow!("Unsupported: Source is another registry: {}", source_id.url()).into());
            }
        }
        _ => {
            println!("Unknown source: {}", source_id.url());
            return Err(anyhow!("Unknown source: {}", source_id.url()).into());
        },
    };
    Ok(ret.indentation(4))
}

fn generate_manifest_environment_variables<'gctx>(
    env_key: String,
    env_value: String,
    unit: &Unit,
    process_builder: &ProcessBuilder,
    workspace: &Workspace<'gctx>,
) -> CargoResult<String> {
    let source_id = unit.pkg.package_id().source_id();
    let ret: String = match source_id.kind() {
        SourceKind::Path => {
            let ws_root: &Path = workspace.root();
            let path: PathBuf = PathBuf::from(env_value);
            let rel_path: &Path = path.strip_prefix(ws_root).unwrap();
            let l = format!("./{}", rel_path.display());
            l
        },
        SourceKind::Git(_git_ref) => {
            // something like: /home/nixos/.cargo/git/checkouts/utbw-9a768fae0576fac1/06ba56a/crates/value-spec
            //let cwd: &Path = process_builder.get_cwd().unwrap();
            //println!("SourceKind::Git: cwd: {}", cwd.display());
            //let path: PathBuf = PathBuf::from(env_value);
            // println!("  path: {:?}", path);
            // println!("  pkg.root(): {:?}", unit.pkg.root()); // "/home/nixos/.cargo/git/checkouts/utbw-9a768fae0576fac1/06ba56a/crates/units"
            // FIXME this is an ugly hack but after hours of not understanding where this string is assembled and if the parts are
            // still accessible at this stage i ended up with this temporary hack
            let strip = strip_path_after_checkouts(unit.pkg.root()).unwrap();
            //println!("  strip: {:?}", strip);
            // println!("  pkg.manifest_path(): {:?}", unit.pkg.manifest_path());
            // println!("------------- unit ---------------");
            // println!("{:#?}", unit);
            // println!("------------- manifest ---------------");
            // println!("{:#?}", unit.pkg.manifest());
            // println!("------------- summary ---------------");
            // println!("{:#?}", unit.pkg.manifest().summary());
            // "/home/nixos/.cargo/git/checkouts/utbw-9a768fae0576fac1/06ba56a/crates/presenter/src/lib.rs"
            //println!("  unit.target.src_path(): {:#?}", unit.target.src_path());
            //println!("  source_id(): {:#?}", source_id);

            // FIXME want: crates/value-spec or crates/presenter (from the two examples above)
            match env_key.as_str() {
                "CARGO_MANIFEST_DIR" => format!("./{}", strip.display().to_string()),
                "CARGO_MANIFEST_PATH" => format!("./{}", strip.join("Cargo.toml").display().to_string()),
                _ => return Err(anyhow!("Unsupported key").into()),
            }
        },
        SourceKind::Registry => {
            if source_id.is_crates_io() {
                // something like: /home/nixos/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f
                let cwd: &Path = process_builder.get_cwd().unwrap();
                //println!("cwd: {:?}", cwd);
                let path: PathBuf = PathBuf::from(env_value);
                //println!("path: {:?}", path);
                let rel_path: &Path = path.strip_prefix(cwd).unwrap();
                let l = format!("./{}", rel_path.display());
                l
            } else {
                println!("Unsupported: Source is another registry: {}", source_id.url());
                return Err(anyhow!("Unsupported: Source is another registry: {}", source_id.url()).into());
            }
        }
        _ => {
            println!("Unknown source: {}", source_id.url());
            return Err(anyhow!("Unknown source: {}", source_id.url()).into());
        },
    };
    Ok(ret)
}

fn generate_src<'gctx>(
    workspace: &Workspace<'gctx>,
    unit: &Unit,
    crate_name: &String,
    crate_version: &String,
) -> CargoResult<String> {
    let source_id = unit.pkg.package_id().source_id();
    match source_id.kind() {
        SourceKind::Path => {
            let src = workspace.root().display().to_string();
            let mut handlebars = Handlebars::new();
            let template_str = indoc! {
            r#"
                src = builtins.filterSource
                  (path: type:
                    let base = baseNameOf path;
                    in !(base == "target" || base == "result" || builtins.match "result-*" base != null)
                  ) {{{src}}};
            "#};
            handlebars.register_template_string("fetch", template_str)?;
            let rendered: String = handlebars.render(
                "fetch",
                &serde_json::json!({
                    "src": src,
                }),
            )?;
            return Ok(rendered.indentation(4));
        }
        SourceKind::Git(_git_ref) => {
            if let Some(precise_rev) = source_id.precise_git_fragment() {
                let url: String = source_id.url().to_string();
                let meta_data =
                    download_git_for_metadata(&url, &precise_rev.to_string(), &"".to_string())?;

                let mut handlebars = Handlebars::new();
                let template_str = indoc! {
                r#"
                  src = pkgs.fetchgit {
                    url = "{{{url}}}";
                    rev = "{{{rev}}}";
                    sha256 = "{{{sha256}}}";
                  };
                "#};
                handlebars.register_template_string("fetch", template_str)?;
                let rendered: String = handlebars.render(
                    "fetch",
                    &serde_json::json!({
                        "url": url,
                        "rev": precise_rev,
                        "sha256": meta_data.sha256,
                    }),
                )?;
                return Ok(rendered.indentation(4));
            } else {
                println!("Source GIT but commit hash not given!");
            }
        }
        SourceKind::Registry => {
            if source_id.is_crates_io() {
                let mut handlebars = Handlebars::new();
                let template_str = indoc! {
                r#"
                  src = pkgs.fetchurl {
                    url = "https://crates.io/api/v1/crates/{{{crate_name}}}/{{{crate_version}}}/download";
                    sha256 = "{{{hash}}}";
                  };
                "#};
                handlebars.register_template_string("fetch", template_str)?;

                let hash: &str = match unit.pkg.manifest().summary().checksum() {
                    Some(h) => h,
                    None => {
                        return Err(anyhow!(
                            "hash for pkgs.fetchurl is missing for {crate_name}-{crate_version}"
                        )
                        .into());
                    }
                };
                let rendered: String = handlebars.render(
                    "fetch",
                    &serde_json::json!({
                        "crate_name": crate_name,
                        "crate_version": crate_version,
                        "hash": hash
                    }),
                )?;
                return Ok(rendered.indentation(4));
            } else {
                println!("Source is another registry: {}", source_id.url());
            }
        }
        _ => println!("Unknown source: {}", source_id.url()),
    }
    return Err(anyhow!("no match, no match!").into());
}

pub struct NixBuildRunner {}

impl<'a, 'gctx> NixBuildRunner {
    pub fn new(build_runner: &BuildRunner<'a, 'gctx>) -> CargoResult<()> {
        let bcx: &BuildContext<'a, 'gctx> = &build_runner.bcx;

        let workspace: &Workspace<'gctx> = build_runner.bcx.ws;
        let unit_graph: &UnitGraph = &bcx.unit_graph;
        let mut visited = BTreeSet::new();
        let mut all_nodes: Vec<DefaultNixEntry> = Vec::new();

        let all_units_with_process_builder: Vec<(ProcessBuilder, Unit)> =
            build_runner.raw_process_builder.lock().unwrap().clone();

        println!("Need to generate: {} units.", all_units_with_process_builder.len());

        for (process_builder, unit) in all_units_with_process_builder.clone() {
            if visited.contains(&unit) {
                continue;
            }
            visited.insert(unit.clone());
            let pkg = unit.pkg.package_id();
            let is_root: bool = workspace.members().any(|member| member.package_id() == pkg);
            let is_run_custom_build: bool = unit.mode == CompileMode::RunCustomBuild;
            let crate_name: String = pkg.name().to_string();
            let crate_version: String = pkg.version().to_string();
            let fullname: String = create_nix_name(&unit, build_runner, NixNameMode::AttributeName, false);

            println!("Generating {}", fullname);
            let deps: Dependencies = process_deps(&unit, &crate_name, &crate_version, unit_graph, build_runner, &all_units_with_process_builder);

            if is_run_custom_build {
                Self::process_script_build_run(
                    &workspace,
                    &unit,
                    crate_name,
                    crate_version,
                    &process_builder,
                    is_root,
                    &mut all_nodes,
                    build_runner,
                    &deps,
                )?
            } else {
                Self::process_unit(
                    &workspace,
                    &unit,
                    crate_name,
                    crate_version,
                    &process_builder,
                    is_root,
                    &mut all_nodes,
                    build_runner,
                    &deps,
                )?
            }
        }

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/default.nix.handlebars");
        handlebars.register_template_string("default", template_str)?;

        all_nodes.sort_by(|a, b| a.name.cmp(&b.name));
        // Render default_nix_packages as `name = callPackage' ./relative_path {};`
        let default_nix_packages = all_nodes
            .iter()
            .map(|entry| {
                let path = PathBuf::from(&entry.filename);
                let rel_path = path.strip_prefix("/tmp/nix").unwrap_or(&path);
                format!(
                    "    {} = callPackage' ./{} {{ inherit fn; }};",
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

    fn process_script_build_run(
        workspace: &Workspace<'gctx>,
        unit: &Unit,
        crate_name: String,
        crate_version: String,
        process_builder: &ProcessBuilder,
        is_root: bool,
        all_nodes: &mut Vec<DefaultNixEntry>,
        build_runner: &BuildRunner<'a, 'gctx>,
        deps: &Dependencies,
    ) -> CargoResult<()> {

        let src: String = generate_src(&workspace, &unit, &crate_name, &crate_version)?;
        let unpack_phase: String = generate_unpack_phase(&unit, &crate_name, &crate_version)?;
        let build_inputs: Vec<String> = vec![];

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/rustc-call.nix.handlebars");
        handlebars.register_template_string("rustc-call", template_str)?;

        let environment_variables: String = generate_environment_variables(workspace, unit, process_builder)?;

        let mut rustc_arguments: Vec<String> = vec![];
        rustc_arguments.push(
            format!(
                indoc! {
            r#"
                rustc_arguments="";
            "#}).to_string().indentation(2));

        let command_line: String = {
            if deps.rust_crate_parent.len() != 1 {
                println!("For buildInputs found these matches: {}", deps.rust_crate_parent.len());
                println!("  buildInputs: {:?}", deps.rust_crate_parent);
                std::process::abort(); // FIXME rewrite with proper error
            } else {
                let program_script_build = deps.rust_crate_parent[0].clone();
                //${{{}}}/build_script_build > $OUT_DIR/build_script_build.out
                //${{cargo}}/bin/cargo nix parse-build-script-build --path $OUT_DIR/build_script_build.out rustc_arguments > $OUT_DIR/rustc-arguments
                //${{cargo}}/bin/cargo nix parse-build-script-build --path $OUT_DIR/build_script_build.out environment-variables > $OUT_DIR/environment-variables
                //${{cargo}}/bin/cargo nix parse-build-script-build --path $OUT_DIR/build_script_build.out environment-propagated-variables > $OUT_DIR/environment-propagated-variables
                //${{cargo}}/bin/cargo nix parse-build-script-build --path $OUT_DIR/build_script_build.out_filtered rustc-propagated-arguments > $OUT_DIR/rustc-propagated-arguments

                format!(
                    indoc! {
                    r#"
                    ${{{}}}/build_script_build > $OUT_DIR/build_script_build.out
                    # the .out file could be empty
                    cat $OUT_DIR/build_script_build.out | sort | uniq | grep -e '^cargo:' > $OUT_DIR/build_script_build.out_filtered || true
                    ${{pkgs.parse-build}}/bin/cargo-build_script_build-parser $OUT_DIR/build_script_build.out_filtered environment-variables > $OUT_DIR/environment-variables
                    ${{pkgs.parse-build}}/bin/cargo-build_script_build-parser $OUT_DIR/build_script_build.out_filtered environment-propagated-variables > $OUT_DIR/environment-propagated-variables
                    ${{pkgs.parse-build}}/bin/cargo-build_script_build-parser $OUT_DIR/build_script_build.out_filtered rustc-arguments > $OUT_DIR/rustc-arguments
                    ${{pkgs.parse-build}}/bin/cargo-build_script_build-parser $OUT_DIR/build_script_build.out_filtered rustc-propagated-arguments > $OUT_DIR/rustc-propagated-arguments
                "#},
                program_script_build
                ).to_string().indentation(6)
            }
        };

        let default_function_arguments: Vec<String> =
            vec!["fn", "pkgs", "rustc", "cargo"]
                .iter()
                .map(|m| m.to_string())
                .collect();
        let function_arguments: Vec<String> =
            [default_function_arguments, deps.all_deps.clone()].concat();

        let (additional_build_phase_arguments, rustc_arguments) = handle_dynamic_crate_aspects(
            unit, 
            &deps,
        );

        let rendered = handlebars.render(
            "rustc-call",
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "rustc_arguments": rustc_arguments.join("\n"),
                "fullname": create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
                "cargo_crate_info": cargo_crate_info(unit, build_runner)?,
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "build_inputs": build_inputs.join(" "),
                "rust_crate_libraries": deps.rust_crate_libraries.join(" "),
                "rust_script_build_run": deps.rust_script_build_run.join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": additional_build_phase_arguments.join("\n"),
                "command_line": assert_escapes(&command_line),
            }),
        )?;

        let file_name: String = create_nix_name(unit, build_runner, NixNameMode::FileName, false);
        let file_path = write_nix_file(&file_name, &rendered, is_root)?;
        all_nodes.push(DefaultNixEntry {
            name: create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
            filename: file_path.to_string_lossy().to_string(),
        });

        Ok(())
    }

    fn process_unit(
        workspace: &Workspace<'gctx>,
        unit: &Unit,
        crate_name: String,
        crate_version: String,
        process_builder: &ProcessBuilder,
        is_root: bool,
        all_nodes: &mut Vec<DefaultNixEntry>,
        build_runner: &BuildRunner<'a, 'gctx>,
        deps: &Dependencies,
        ) -> CargoResult<()> {
        // println!("unit.target: {:?}", unit.target);
        // println!(
        //     "<<<<<<<<<<<<<<<<<<<<<< rustc {fullname} <<<<<<<<<<<<<<<<<<<<<<",
        // );
        // //println!("{:#?}", process_builder);
        // println!("{:#?}", unit);
        // println!(">>>>>>>>>>>>>>>>>>>>>> /rustc >>>>>>>>>>>>>>>>>>>>>>\n");

        // let mut build_inputs: Vec<String> = vec![];
        // let mut rust_crate_libraries: Vec<String> = vec![];

        let src: String = generate_src(&workspace, &unit, &crate_name, &crate_version)?;
        let unpack_phase: String = generate_unpack_phase(&unit, &crate_name, &crate_version)?;

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/rustc-call.nix.handlebars");
        handlebars.register_template_string("rustc-call", template_str)?;

        let environment_variables: String = generate_environment_variables(workspace, unit, process_builder)?;

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

        let default_function_arguments: Vec<String> =
            vec!["fn", "pkgs", "rustc", "cargo"]
                .iter()
                .map(|m| m.to_string())
                .collect();
        let function_arguments: Vec<String> =
            [default_function_arguments, deps.all_deps.clone()].concat();

        let build_inputs: Vec<String> = vec![];

        let (additional_build_phase_arguments, rustc_arguments) = handle_dynamic_crate_aspects(
            unit, 
            &deps,
        );

        let mut additional_command_lines: Vec<String> = vec![];
        if crate_build_type(&unit) == CrateBuildType::ScriptBuild {
            let meta = build_runner.files().metadata(&unit);
            let hash: String = meta.c_extra_filename().unwrap().to_string();
            additional_command_lines.push(
                format!(
                    indoc! {r#"
                    ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-{} $OUT_DIR/build_script_build
                "#},
                hash).to_string().indentation(6));
        };

        let rendered = handlebars.render(
            "rustc-call",
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "rustc_arguments": rustc_arguments.join("\n"),
                "fullname": create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
                "cargo_crate_info": cargo_crate_info(unit, build_runner)?,
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "build_inputs": build_inputs.join(" "),
                "rust_crate_libraries": deps.rust_crate_libraries.join(" "),
                "rust_script_build_run": deps.rust_script_build_run.join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": additional_build_phase_arguments.join("\n"),
                "command_line": assert_escapes(&command_line),
                "additional_command_lines": assert_escapes(&additional_command_lines.join("\n")),
            }),
        )?;
        let file_name: String = create_nix_name(unit, build_runner, NixNameMode::FileName, false);
        let file_path = write_nix_file(&file_name, &rendered, is_root)?;
        all_nodes.push(DefaultNixEntry {
            name: create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
            filename: file_path.to_string_lossy().to_string(),
        });
        Ok(())
    }
}
