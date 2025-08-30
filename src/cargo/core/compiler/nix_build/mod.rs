pub mod build_rs_parser;
mod download;
pub mod nix_build_runner;
use download::download_git_for_metadata;
mod asserts;
use crate::core::compiler::nix_build::nix_build_runner::NixBuild;
use asserts::{assert_escapes, assert_valid_nix_attr_name, assert_valid_nix_file_name};

use crate::core::compiler::unit_graph::UnitGraph;
use crate::core::compiler::Unit;
use crate::core::compiler::{BuildContext, BuildRunner, CompileMode};
use crate::core::workspace::Workspace;
use crate::core::SourceKind;
use crate::core::TargetKind;
use crate::util::{CargoResult, Filesystem};
use anyhow::anyhow;
use cargo_util::ProcessBuilder;
use handlebars::Handlebars;
use regex::Regex;

use indoc::indoc;
use std::collections::BTreeSet;
use std::fs::File;
use std::io::Write;
use std::path::{Component, Path, PathBuf};

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

    let cargo_crate_info: String = format!(
        indoc! {r#"
    meta.cargo_crate_info = {{
      name = "{}";
      version = "{}";
      crate_hash = "{}";
    }};"#},
        crate_name, crate_version, crate_hash
    )
    .to_string()
    .indentation(4);
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

    let nix_name: String = match only_name_and_version {
        false => format!(
            "{}-{}{}{}-{}",
            crate_name, crate_version, kind, mode, cargo_hash
        ),
        true => format!("{}-{}", crate_name, crate_version),
    };
    match nix_name_mode {
        NixNameMode::AttributeName => {
            return assert_valid_nix_attr_name(nix_name.nix_attr_replace())
        }
        NixNameMode::FileName => {
            let file_name = nix_name + ".nix";
            return assert_valid_nix_file_name(file_name.nix_file_replace());
        }
    };
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

#[derive(Debug, Clone)]
struct Dependency {
    nix_attribute_name: String,
    is_root: bool,
    unit: Unit,
}

#[derive(Debug)]
struct Dependencies {
    /// all units, not sorted, not filtered
    all_deps: Vec<Dependency>,
    /// contains only libraries used for -L
    rust_crate_libraries: Vec<Dependency>,
    /// should contain at max one parent: CrateBuildType hierarchy basically
    rust_crate_parent: Option<Dependency>,
    /// contains all script_build_run inputs to this unit
    rust_script_build_run: Vec<Dependency>,
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
                        generate_manifest_environment_variables(
                            key.clone(),
                            env_value,
                            unit,
                            process_builder,
                            workspace,
                        )
                        .unwrap()
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

/// environment-variables / rustc-arguments / rustc-propagated-arguments
/// require special care between different crate build steps: ScriptBuild / ScriptBuildRun / LibBuild
fn handle_dynamic_crate_aspects(unit: &Unit, deps: &Dependencies) -> Vec<String> {
    let mut additional_build_phase_arguments: Vec<String> = vec![];
    let source_environment_variables: String = indoc! {r#"
    for file in ${fn.environment_variables passthru.rust_script_build_run}; do
      if [ -f $file ]; then
        set -a
          while read -r line; do
            echo -e "\033[38;5;208m$line\033[0m"
          done < "$file"
          source $file
          set +a
      fi
    done
    "#}
    .to_string();

    match crate_build_type(unit) {
        CrateBuildType::BinBuild => {
            additional_build_phase_arguments.push(source_environment_variables.indentation(6));
        }
        CrateBuildType::LibBuild | CrateBuildType::ScriptBuild | CrateBuildType::ScriptBuildRun => {
            match &deps.rust_crate_parent {
                Some(_) => {
                    if crate_build_type(unit) == CrateBuildType::LibBuild {
                        additional_build_phase_arguments
                            .push(format!("cp -r ${{fn.get_rust_crate_parent passthru.rust_crate_parent}}/* $OUT_DIR").to_string().indentation(6));
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

fn write_nix_file(
    out_directory: &Filesystem,
    file_name: &String,
    content: &String,
    is_root: bool,
) -> CargoResult<PathBuf> {
    let rel_dir: PathBuf = if is_root {
        PathBuf::new()
    } else {
        PathBuf::from("deps")
    };
    let base_dir = out_directory.clone().join(rel_dir.clone());
    base_dir.create_dir()?;
    let file_path = base_dir.join(file_name).into_path_unlocked();
    let mut file = File::create(&file_path)?;
    writeln!(file, "{}", content)?;
    Ok(rel_dir.join(file_name))
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

/// a unit in cargo has several dependencies like build.rs but also crates used for linking (rlib)
/// this function splits these dependencies into said groups so that the nix scripts have an
/// easy time working with the filtered subsets
fn create_unit_dependencies<'a, 'gctx>(
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
                unit: dep.unit.clone(),
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
                        unit: dep.unit.clone(),
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
                            unit: c.clone(),
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
        CrateBuildType::LibBuild => {
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

fn generate_unpack_phase<'gctx>(
    unit: &Unit,
    crate_name: &String,
    crate_version: &String,
) -> CargoResult<String> {
    let source_id = unit.pkg.package_id().source_id();
    let ret: String = match source_id.kind() {
        SourceKind::Path => indoc! {r#"
              unpackPhase = "";
            "#}
        .to_string(),
        SourceKind::Git(_git_ref) => indoc! {r#"
            unpackPhase = ''
              cd $src/$CARGO_MANIFEST_DIR
            '';
          "#}
        .to_string(),
        SourceKind::Registry => {
            if source_id.is_crates_io() {
                let mut handlebars = Handlebars::new();
                let template_str = indoc! {
                r#"
                    unpackPhase = ''
                      tar xf $src
                      cd {{{crate_name}}}-{{{crate_version}}}
                    '';
                "#}
                .to_string();

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
                println!(
                    "Unsupported: Source is another registry: {}",
                    source_id.url()
                );
                return Err(anyhow!(
                    "Unsupported: Source is another registry: {}",
                    source_id.url()
                )
                .into());
            }
        }
        _ => {
            println!("Unknown source: {}", source_id.url());
            return Err(anyhow!("Unknown source: {}", source_id.url()).into());
        }
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
        }
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
                "CARGO_MANIFEST_PATH" => {
                    format!("./{}", strip.join("Cargo.toml").display().to_string())
                }
                _ => return Err(anyhow!("Unsupported key").into()),
            }
        }
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
                println!(
                    "Unsupported: Source is another registry: {}",
                    source_id.url()
                );
                return Err(anyhow!(
                    "Unsupported: Source is another registry: {}",
                    source_id.url()
                )
                .into());
            }
        }
        _ => {
            println!("Unknown source: {}", source_id.url());
            return Err(anyhow!("Unknown source: {}", source_id.url()).into());
        }
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

struct SymlinkedTargets {
    attribute_name: String,
    binary_name: String,
}

pub struct NixBuildRunner {}

impl<'a, 'gctx> NixBuildRunner {
    pub fn build(build_runner: &BuildRunner<'a, 'gctx>) -> CargoResult<()> {
        let bcx: &BuildContext<'a, 'gctx> = &build_runner.bcx;
        let workspace: &Workspace<'gctx> = build_runner.bcx.ws;
        let unit_graph: &UnitGraph = &bcx.unit_graph;
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
        // files in target/nix should created if new, update if existent and deleted if not used anymore
        let target_dir: Filesystem = workspace.target_dir();
        let nix_base_dir = target_dir.join(requested_profile).join("nix");
        assert_ne!("~".to_string(), nix_base_dir.display().to_string());
        assert_ne!(".".to_string(), nix_base_dir.display().to_string());
        assert_ne!("/".to_string(), nix_base_dir.display().to_string());
        nix_base_dir.create_dir()?;
        // println!("target_dir: {}", nix_base_dir.display());
        let nix_derivations_dir = nix_base_dir.join("derivations");
        // paths::remove_dir_all(&nix_derivations_dir)?;
        nix_derivations_dir.create_dir()?;
        // println!("nix_derivations_dir: {}", nix_derivations_dir.display());

        println!(
            "Need to generate: {} units.",
            all_units_with_process_builder.len()
        );

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
            let fullname: String =
                create_nix_name(&unit, build_runner, NixNameMode::AttributeName, false);

            println!("Generating {}", fullname);
            let deps: Dependencies = create_unit_dependencies(
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
                    &process_builder,
                    is_root,
                    &mut all_nodes,
                    build_runner,
                    &deps,
                    &nix_derivations_dir,
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
                    &nix_derivations_dir,
                    &mut symlinked_targets,
                )?
            }
        }

        // cargo_build_caller.nix //////////////////////////////////////////////////////////////////////////////////
        println!("Creating cargo_build_caller.nix");
        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/cargo_build_caller.nix.handlebars");
        handlebars.register_template_string("caller", template_str)?;
        let rendered = handlebars.render("caller", &serde_json::json!({}))?;

        let cargo_build_caller_path = nix_base_dir
            .clone()
            .join("cargo_build_caller.nix")
            .into_path_unlocked();
        let mut file = File::create(cargo_build_caller_path)?;
        write!(file, "{}", rendered)?;

        // default.nix //////////////////////////////////////////////////////////////////////////////////
        println!("Creating default.nix");
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
        println!("Creating nix/default.nix");
        let default_nix_path = nix_derivations_dir
            .clone()
            .join("default.nix")
            .into_path_unlocked();
        let mut file = File::create(default_nix_path)?;
        write!(file, "{}", rendered)?;

        // target.nix //////////////////////////////////////////////////////////////////////////////////
        println!("Creating target.nix");
        let mut function_arguments_ = symlinked_targets
            .iter()
            .map(|t| t.attribute_name.clone())
            .collect::<Vec<String>>();
        let mut function_arguments: Vec<String> = vec!["pkgs".to_string()];
        function_arguments.append(&mut function_arguments_);

        let targets = symlinked_targets
            .iter()
            .map(|t| {
                format!(
                    indoc! {
                    r#"
                      rm -f target/{}/{}
                      ln -s ${{{}}}/bin/{} target/{}/
                    "#},
                    requested_profile,
                    t.binary_name,
                    t.attribute_name,
                    t.binary_name,
                    requested_profile,
                )
                .to_string()
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

        NixBuild::build(requested_profile).unwrap();

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
        nix_derivations_dir: &Filesystem,
    ) -> CargoResult<()> {
        let parent_full_name = match &deps.rust_crate_parent {
            Some(val) => val.nix_attribute_name.clone(),
            None => {
                println!("deps.rust_crate_parent must not be empty as we are in process_script_build_run!");
                std::process::abort(); // FIXME rewrite with proper error
            }
        };

        let src: String = generate_src(&workspace, &unit, &crate_name, &crate_version)?;
        let unpack_phase: String = generate_unpack_phase(&unit, &crate_name, &crate_version)?;

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/rustc-call.nix.handlebars");
        handlebars.register_template_string("rustc-call", template_str)?;

        let environment_variables: String =
            generate_environment_variables(workspace, unit, process_builder)?;

        let mut rustc_arguments: Vec<String> = vec![];
        rustc_arguments.push(
            format!(indoc! {
            r#"
                rustc_arguments="";
            "#})
            .to_string()
            .indentation(2),
        );

        let mut command_line: Vec<String> = vec![];
        command_line.push(
            format!(
                indoc! {
                r#"
                ${{{}}}/build_script_build > $OUT_DIR/nix/build_script_build.out
                ${{build_parser}}/bin/cargo-build_script_build-parser $OUT_DIR/nix/build_script_build.out --out-path $out/nix write-results
            "#},
            parent_full_name
            ).to_string().indentation(6)
            );

        let default_function_arguments: Vec<String> =
            vec!["pkgs", "fn", "cargo", "rustc", "deps", "build_parser"]
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
                "fullname": create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
                "cargo_crate_info": cargo_crate_info(unit, build_runner)?,
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "rust_crate_libraries": deps.rust_crate_libraries.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_crate_parent": deps.rust_crate_parent.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_script_build_run": deps.rust_script_build_run.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": additional_build_phase_arguments.join("\n"),
                "command_line": assert_escapes(&command_line.join("\n")),
            }),
        )?;

        let file_name: String = create_nix_name(unit, build_runner, NixNameMode::FileName, false);
        let rel_file_path = write_nix_file(&nix_derivations_dir, &file_name, &rendered, is_root)?;
        all_nodes.push(DefaultNixEntry {
            name: create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
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
        process_builder: &ProcessBuilder,
        is_root: bool,
        all_nodes: &mut Vec<DefaultNixEntry>,
        build_runner: &BuildRunner<'a, 'gctx>,
        deps: &Dependencies,
        nix_derivations_dir: &Filesystem,
        symlinked_targets: &mut Vec<SymlinkedTargets>,
    ) -> CargoResult<()> {
        // println!("unit.target: {:?}", unit.target);
        // println!(
        //     "<<<<<<<<<<<<<<<<<<<<<< rustc {fullname} <<<<<<<<<<<<<<<<<<<<<<",
        // );
        // //println!("{:#?}", process_builder);
        // println!("{:#?}", unit);
        // println!(">>>>>>>>>>>>>>>>>>>>>> /rustc >>>>>>>>>>>>>>>>>>>>>>\n");

        // let mut rust_crate_libraries: Vec<String> = vec![];

        let src: String = generate_src(&workspace, &unit, &crate_name, &crate_version)?;
        let unpack_phase: String = generate_unpack_phase(&unit, &crate_name, &crate_version)?;

        let mut handlebars = Handlebars::new();
        let template_str = include_str!("templates/rustc-call.nix.handlebars");
        handlebars.register_template_string("rustc-call", template_str)?;

        let environment_variables: String =
            generate_environment_variables(workspace, unit, process_builder)?;

        let mut command_line: Vec<String> = vec![];
        command_line.push(format!(
            "      ${{RUSTC}}{}",
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
        ));

        let default_function_arguments: Vec<String> = vec!["fn", "pkgs", "rustc", "cargo", "deps"]
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

        if crate_build_type(&unit) == CrateBuildType::ScriptBuild {
            let meta = build_runner.files().metadata(&unit);
            let hash: String = meta.c_extra_filename().unwrap().to_string();
            command_line.push(
                format!(
                    indoc! {r#"
                    ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-{} $OUT_DIR/build_script_build
                "#},
                    hash
                )
                .to_string()
                .indentation(6),
            );
        };

        let mut phases: Vec<&str> = vec!["unpackPhase", "buildPhase"];
        let mut append: Vec<String> = vec![];
        if crate_build_type(&unit) == CrateBuildType::BinBuild {
            // instead of using fn link_targets() or fn link_or_copy() we built the names on the fly
            let meta = build_runner.files().metadata(&unit);
            let hash: String = meta.c_extra_filename().unwrap().to_string();
            let binary_name = unit.target.name();
            let binary_name_with_hash = format!("{}-{}", binary_name, hash);
            phases.push("installPhase");
            append.push(
                format!(
                    indoc! {r#"
                      installPhase = ''
                        mkdir $out/bin
                        ln -s $out/{} $out/bin/{}
                      '';
                "#},
                    binary_name_with_hash, binary_name
                )
                .to_string()
                .indentation(4),
            );
            symlinked_targets.push(SymlinkedTargets {
                attribute_name: create_nix_name(
                    unit,
                    build_runner,
                    NixNameMode::AttributeName,
                    false,
                ),
                binary_name: binary_name.to_string(),
            });
        }

        let rendered = handlebars.render(
            "rustc-call",
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "fullname": create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
                "cargo_crate_info": cargo_crate_info(unit, build_runner)?,
                "nix_phases": phases.join(" "),
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "rust_crate_libraries": deps.rust_crate_libraries.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_crate_parent": deps.rust_crate_parent.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_script_build_run": deps.rust_script_build_run.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": additional_build_phase_arguments.join("\n"),
                "command_line": assert_escapes(&command_line.join("\n")),
                "append": append.join("\n"),
            }),
        )?;
        let file_name: String = create_nix_name(unit, build_runner, NixNameMode::FileName, false);
        let rel_file_path = write_nix_file(&nix_derivations_dir, &file_name, &rendered, is_root)?;
        all_nodes.push(DefaultNixEntry {
            name: create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
            rel_file_path,
            is_root,
        });
        Ok(())
    }
}
