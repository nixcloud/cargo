mod download;
pub mod nix_build_runner;
pub mod build_rs_parser;
use download::download_git_for_metadata;
mod asserts;
use asserts::{assert_valid_nix_attr_name, assert_valid_nix_file_name, assert_escapes};
use crate::sources::source::SourceMap;
// use crate::sources::{GitSource, PathSource, RegistrySource};

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
    let hash: String = meta.c_extra_filename().unwrap().to_string();

    let nix_name: String = 
    match only_name_and_version {
        false => format!("{}-{}{}{}-{}", crate_name, crate_version, kind, mode, hash),
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

struct Dependencies {
    build_inputs: Vec<String>,
    required_inputs: Vec<String>, // FIXME refactor this into crate_inputs (also in the nix-abstraction with passthru)
}

fn process_deps<'a, 'gctx>(
    unit: &Unit,
    unit_graph: &UnitGraph,
    build_runner: &BuildRunner<'a, 'gctx>,
) -> Dependencies {
    let mut build_inputs = vec![];
    let mut required_inputs = vec![];
    if let Some(deps) = unit_graph.get(unit) {
        for dep in deps {
            build_inputs.push(create_nix_name(
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
                    required_inputs.push(create_nix_name(
                        &dep.unit,
                        &build_runner,
                        NixNameMode::AttributeName,
                        false,
                    ));
                }
                _ => {}
            }
        }
    }
    Dependencies{ build_inputs, required_inputs }
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
    _source_map: &SourceMap<'gctx>,
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

            //source_map.load()

            // if let Some(source) = source_map.get(source_id) {
                //println!("{:#?}", source.);
                // let s = source
                //     .as_any_mut()
                //     .downcast_mut::<GitSource>();
                //let s: Source = source.into();
                // match s.downcast_ref::<GitSource>() {
                //     Some(git_source) => println!("{:?}", git_source),
                //     None => eprintln!("Failed to downcast to GitSource"),
                // }
            // };
            
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

        let source_map: &SourceMap<'gctx> = &bcx.packages.sources();

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
            let fullname: String = create_nix_name(&unit, build_runner, NixNameMode::AttributeName, false);

            println!("Generating {}", fullname);

            if is_run_custom_build {
                Self::process_build_runner(
                    &workspace,
                    &unit,
                    crate_name,
                    crate_version,
                    &process_builder,
                    unit_graph,
                    is_root,
                    &mut all_nodes,
                    build_runner,
                    source_map,
                )?
            } else {
                Self::process_unit(
                    &workspace,
                    &unit,
                    crate_name,
                    crate_version,
                    &process_builder,
                    unit_graph,
                    is_root,
                    &mut all_nodes,
                    build_runner,
                    source_map,
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

    /// custom-build-run_custom-build
    fn process_build_runner(
        workspace: &Workspace<'gctx>,
        unit: &Unit,
        crate_name: String,
        crate_version: String,
        process_builder: &ProcessBuilder,
        unit_graph: &UnitGraph,
        is_root: bool,
        all_nodes: &mut Vec<DefaultNixEntry>,
        build_runner: &BuildRunner<'a, 'gctx>,
        source_map: &SourceMap<'gctx>,
    ) -> CargoResult<()> {
        let deps: Dependencies = process_deps(&unit, unit_graph, build_runner);

        let src: String = generate_src(&workspace, &unit, &crate_name, &crate_version)?;
        let unpack_phase: String = generate_unpack_phase(&unit, &crate_name, &crate_version)?;

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
                    let env_value: String = os_str.to_string_lossy().to_string();
                    let res: String = match key.as_str() {
                        // we make these into relative paths, as in the builder there is no fs access to ~/ anyways
                        "CARGO_MANIFEST_DIR" | "CARGO_MANIFEST_PATH" => {
                            generate_manifest_environment_variables(key.clone(), env_value, unit, process_builder, workspace, source_map).unwrap()
                        }
                        _ => env_value,
                    };
                    format!("    {} = \"{}\";", key, res)
                }
                None => format!("    {} = \"\";", key),
            })
            .collect::<Vec<String>>()
            .join("\n");

            let mut rustc_inherited_arguments: Vec<String> = vec![];
            rustc_inherited_arguments.push(
                format!(
                    indoc! {
                r#"
                    rustc_inherited_arguments="";
                "#}).to_string().indentation(2));

        let command_line: String = {
            //println!("{}: {:#?}", build_inputs.len(), build_inputs);
            assert!(deps.build_inputs.len() >= 1); // FIXME rewrite with proper error

            // when building cargo 'rustls-0_23_23-script_build_run' actually has two inputs
            // Generating rustls-0_23_23-script_build_run
            // 2: [
            //     "ring-0_17_11-script_build_run",
            //     "rustls-0_23_23-script_build",
            // ]

            let search: String =
                format!("{}-{}-script_build", crate_name, crate_version).nix_attr_replace();

            let mut matches: Vec<(usize, &String)> = Vec::new();
            for (index, input) in deps.build_inputs.iter().enumerate() {
                //println!("input: {:?}", input);
                //println!("search: {:?}", search);
                let pattern = format!(r"^{}-[a-zA-Z0-9]+$", search); // FIXME generalize this for the regexp
                let re = Regex::new(&pattern).unwrap();
                if re.is_match(input) {
                    matches.push((index, input));
                }
            }
            //println!("matches.len() {:?}", matches.len());

            if matches.len() < 1 {
                println!("For buildInputs found these matches: {}", matches.len());
                std::process::abort(); // FIXME rewrite with proper error
            } else {
                let program_script_build = matches[0].1;
                //${{{}}}/build_script_build-* > $OUT_DIR/build_script_build.out
                //${{cargo}}/bin/cargo nix parse-build-script-build --path $OUT_DIR/build_script_build.out rustc_arguments > $OUT_DIR/rustc-arguments
                //${{cargo}}/bin/cargo nix parse-build-script-build --path $OUT_DIR/build_script_build.out environment-variables > $OUT_DIR/environment-variables
                format!(
                    indoc! {
                    r#"
                    ${{{}}}/build_script_build-* > $OUT_DIR/build_script_build.out
                    # the .out file could be empty
                    cat $OUT_DIR/build_script_build.out | grep -e '^cargo:' > $OUT_DIR/build_script_build.out_filtered || true
                    ${{pkgs.parse-build}}/bin/cargo-build_script_build-parser $OUT_DIR/build_script_build.out_filtered environment-variables > $OUT_DIR/environment-variables
                    ${{pkgs.parse-build}}/bin/cargo-build_script_build-parser $OUT_DIR/build_script_build.out_filtered rustc-arguments > $OUT_DIR/rustc-arguments  
                "#},
                program_script_build
                ).to_string().indentation(6)
            }
        };

        let default_function_arguments: Vec<String> =
            vec!["fn", "pkgs", "stdenv", "rustc", "cargo"]
                .iter()
                .map(|m| m.to_string())
                .collect();
        let function_arguments: Vec<String> =
            [default_function_arguments, deps.build_inputs.clone()].concat();

        let rendered = handlebars.render(
            "rustc-call",
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "fullname": create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "build_inputs": deps.build_inputs.join(" "),
                "required_inputs": deps.required_inputs.join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": "",
                "command_line": assert_escapes(&command_line),
                "rustc_inherited_arguments": rustc_inherited_arguments.join("\n"),
            }),
        )?;

        // FIXME generalize this code below since it is also used by process_unit

        let dir = if is_root {
            PathBuf::from("/tmp/nix")
        } else {
            PathBuf::from("/tmp/nix/deps")
        };
        create_dir_all(&dir)?;
        let file_path = dir.join(create_nix_name(unit, build_runner, NixNameMode::FileName, false));
        let mut file = File::create(&file_path)?;
        writeln!(file, "{}", rendered)?;

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
        unit_graph: &UnitGraph,
        is_root: bool,
        all_nodes: &mut Vec<DefaultNixEntry>,
        build_runner: &BuildRunner<'a, 'gctx>,
        source_map: &SourceMap<'gctx>,
    ) -> CargoResult<()> {
        // println!("unit.target: {:?}", unit.target);
        // println!(
        //     "<<<<<<<<<<<<<<<<<<<<<< rustc {fullname} <<<<<<<<<<<<<<<<<<<<<<",
        // );
        // //println!("{:#?}", process_builder);
        // println!("{:#?}", unit);
        // println!(">>>>>>>>>>>>>>>>>>>>>> /rustc >>>>>>>>>>>>>>>>>>>>>>\n");

        // let mut build_inputs: Vec<String> = vec![];
        // let mut required_inputs: Vec<String> = vec![];

        let deps: Dependencies = process_deps(&unit, unit_graph, build_runner);

        let src: String = generate_src(&workspace, &unit, &crate_name, &crate_version)?;
        let unpack_phase: String = generate_unpack_phase(&unit, &crate_name, &crate_version)?;

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
                    let env_value: String = os_str.to_string_lossy().to_string();
                    let res: String = match key.as_str() {
                        // we make these into relative paths, as in the builder there is no fs access to ~/ anyways
                        "CARGO_MANIFEST_DIR" | "CARGO_MANIFEST_PATH" => {
                            generate_manifest_environment_variables(key.clone(), env_value, unit, process_builder, workspace, source_map).unwrap()
                        }
                        _ => env_value,
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

        let default_function_arguments: Vec<String> =
            vec!["fn", "pkgs", "stdenv", "rustc", "cargo"]
                .iter()
                .map(|m| m.to_string())
                .collect();
        let function_arguments: Vec<String> =
            [default_function_arguments, deps.build_inputs.clone()].concat();


        let mut additional_build_phase_arguments: Vec<String> = vec![];
        let mut rustc_inherited_arguments: Vec<String> = vec![];

        let name_and_version: String = create_nix_name(unit, build_runner, NixNameMode::AttributeName, true);
        // we search for something like 'rustversion-1_0_19-script_build-4138656a97af0b01'
        fn find_unique_match(input: Vec<String>, pattern: String) -> Option<String> {
            let re = Regex::new(pattern.as_str()).ok()?;
        
            let mut matches = input.into_iter().filter(|s| re.is_match(s));
        
            let first = matches.next()?;
            if matches.next().is_none() {
                Some(first)
            } else {
                None
            }
        }
        let parent_output: Option<String> = find_unique_match(deps.build_inputs.clone(), format!("{}-script_build_run-[a-z0-9]+", name_and_version));

        if let Some(parent_full_name) = parent_output {
            additional_build_phase_arguments.push(
                format!(
                    indoc! {r#"
                  if [ -f ${{{}}}/environment-variables ]; then 
                    source ${{{}}}/environment-variables; 
                  fi
                "#},
                parent_full_name, parent_full_name
                )
                .to_string().indentation(6),
            );
            additional_build_phase_arguments
                .push(format!("cp ${{{}}}/* $OUT_DIR", parent_full_name).to_string().indentation(6));
            rustc_inherited_arguments.push(
                format!(
                    indoc! {r#"
                    rustc_inherited_arguments = fn.rustc_inherited_arguments {};
                "#},
                parent_full_name).to_string().indentation(2));
        } else {
            rustc_inherited_arguments.push(
                format!(
                    indoc! {r#"
                    rustc_inherited_arguments="";
                "#}).to_string().indentation(2));
        };

        let rendered = handlebars.render(
            "rustc-call",
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "fullname": create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "build_inputs": deps.build_inputs.join(" "),
                "required_inputs": deps.required_inputs.join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": additional_build_phase_arguments.join("\n"),
                "command_line": assert_escapes(&command_line),
                "rustc_inherited_arguments": rustc_inherited_arguments.join("\n"),
            }),
        )?;

        let dir = if is_root {
            PathBuf::from("/tmp/nix")
        } else {
            PathBuf::from("/tmp/nix/deps")
        };
        create_dir_all(&dir)?;
        let file_path = dir.join(create_nix_name(unit, build_runner, NixNameMode::FileName, false));
        let mut file = File::create(&file_path)?;
        writeln!(file, "{}", rendered)?;

        all_nodes.push(DefaultNixEntry {
            name: create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
            filename: file_path.to_string_lossy().to_string(),
        });

        Ok(())
    }
}
