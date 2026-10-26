use std::path::{Component, Path, PathBuf};
use anyhow::anyhow;
use indoc::indoc;
use cargo_util::ProcessBuilder;
use crate::compiler::nix_build::templates;

use crate::compiler::nix_build::crate_build_type;
use crate::compiler::nix_build::asserts::{assert_valid_nix_file_name, assert_valid_nix_attr_name};
use crate::compiler::nix_build::download::download_git_for_metadata;
use crate::compiler::nix_build::git_store::{checkout_root, git_source_in_store};
use crate::compiler::nix_build::{NixNameMode, CrateBuildType, mode_string, kind_string};
use crate::util::command_prelude::NixBuildOptions;
use crate::compiler::BuildRunner;
use crate::compiler::Unit;
use crate::compiler::CompileMode;
use crate::workspace::TargetKind;
use crate::workspace::Workspace;
use crate::workspace::SourceKind;
use crate::util::{CargoResult, GlobalContext};

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

/// The directory of a git dependency's package in its repository (`crates/x`, empty at the root). Cargo checks
/// the repository out to `~/.cargo/git/checkouts/<repo>/<rev>/`; a vendored git source (source replacement,
/// `cargo vendor`) has the package only, so it is looked up in the checkout nix-prefetch-git made.
fn git_package_subpath(unit: &Unit, gctx: &GlobalContext) -> CargoResult<PathBuf> {
    if let Some(subpath) = strip_path_after_checkouts(unit.pkg.root()) {
        return Ok(subpath);
    }
    let source_id = unit.pkg.package_id().source_id();
    let name = unit.pkg.name();
    let rev = source_id
        .precise_git_fragment()
        .ok_or_else(|| anyhow!("git dependency `{name}` has no commit"))?;
    let meta = download_git_for_metadata(&source_id.url().to_string(), &rev.to_string(), &String::new(), gctx)?;
    find_package_dir(Path::new(&meta.path), name.as_str()).ok_or_else(|| {
        anyhow!("git dependency `{name}`: no Cargo.toml of package `{name}` in {} ({})", source_id.url(), meta.path)
            .into()
    })
}

/// The directory below `root` of the Cargo.toml of package `name`; the least deep one if there are several.
fn find_package_dir(root: &Path, name: &str) -> Option<PathBuf> {
    walkdir::WalkDir::new(root)
        .sort_by_file_name()
        .into_iter()
        .filter_entry(|e| e.depth() == 0 || !matches!(e.file_name().to_str(), Some(".git" | "target")))
        .filter_map(Result::ok)
        .filter(|e| e.file_name() == "Cargo.toml" && e.file_type().is_file())
        .filter(|e| {
            let Ok(text) = std::fs::read_to_string(e.path()) else { return false };
            let Ok(manifest) = text.parse::<toml::Table>() else { return false };
            manifest.get("package").and_then(|p| p.get("name")).and_then(|n| n.as_str()) == Some(name)
        })
        .min_by_key(|e| e.depth())
        .and_then(|e| e.path().parent()?.strip_prefix(root).ok().map(Path::to_path_buf))
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
    let crate_hash: String = meta.unit_id().to_string();

    let target_name = unit.target.name();
    let crate_type: String = match crate_build_type(&unit) {
        CrateBuildType::LibBuild => "".to_string(),
        CrateBuildType::ScriptBuild => "(build.rs build)".to_string(),
        CrateBuildType::ScriptBuildRun => "(build.rs run)".to_string(),
        CrateBuildType::BinBuild => "(bin)".to_string(),
        // a package has several test harnesses, the target tells them apart
        CrateBuildType::TestBuild => match unit.target.kind() {
            TargetKind::Lib(_) => "(lib test)".to_string(),
            TargetKind::Bin => format!("(bin {target_name} test)"),
            TargetKind::Test => format!("(test {target_name})"),
            TargetKind::Bench => format!("(bench {target_name} test)"),
            TargetKind::ExampleBin | TargetKind::ExampleLib(_) => format!("(example {target_name} test)"),
            TargetKind::CustomBuild => "(build.rs test)".to_string(),
        },
        CrateBuildType::ExampleBuild => format!("(example {target_name})"),
        CrateBuildType::Other => "(?)".to_string(),
    };

    let cargo_crate_info: String = format!(
        indoc! {r#"
    meta.cargo_crate_info = {{
      name = "{}";
      version = "{}";
      crate_hash = "{}";
      type = "{}";
    }};"#},
        crate_name, crate_version, crate_hash, crate_type,
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
    let cargo_hash: String = meta.unit_id().to_string();

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

/// The binaries an integration test or bench depends on (those of its package): their names and their files in
/// the store, as nix expressions.
pub fn bins_in_store(unit: &Unit, build_runner: &BuildRunner<'_, '_>) -> Vec<(String, String)> {
    let Some(deps) = build_runner.bcx.unit_graph.get(unit) else { return Vec::new() };
    deps.iter()
        .map(|dep| &dep.unit)
        .filter(|bin| bin.target.is_bin() && bin.mode == CompileMode::Build)
        .map(|bin| {
            let name = bin.target.binary_filename().unwrap_or(bin.target.name().to_string());
            let attr = create_nix_name(bin, build_runner, NixNameMode::AttributeName, false);
            let hash = build_runner.files().metadata(bin).unit_id().to_string();
            (name, format!("${{{attr}}}/{}-{hash}", bin.target.crate_name()))
        })
        .collect()
}

/// `CARGO_BIN_EXE_<name>` of an integration test or bench: the binary in the store, not in target/<profile>.
fn bin_exe_in_store(unit: &Unit, build_runner: &BuildRunner<'_, '_>, name: &str) -> Option<String> {
    bins_in_store(unit, build_runner).into_iter().find(|(n, _)| n == name).map(|(_, file)| file)
}

pub fn generate_environment_variables<'gctx>(
    workspace: &Workspace<'gctx>,
    unit: &Unit,
    process_builder: &ProcessBuilder,
    build_runner: &BuildRunner<'_, 'gctx>,
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
                    k if k.starts_with("CARGO_BIN_EXE_") => {
                        bin_exe_in_store(unit, build_runner, &k["CARGO_BIN_EXE_".len()..])
                            .unwrap_or_else(|| escape_environment_variable(env_value))
                    }
                    _ => escape_environment_variable(env_value),
                };
                format!("    {} = \"{}\";", key, res.trim())
            }
            None => format!("    {} = \"\";", key),
        })
        .collect::<Vec<String>>()
        .join("\n");
    Ok(ret)
}



pub fn generate_unpack_phase<'gctx>(
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
        // a writable copy of the repository, like an unpacked crate: the build writes its argument files (`*.rsp`)
        // to the crate directory. CARGO_MANIFEST_DIR is the crate's path in the repository, relative to the crate
        // from there on
        SourceKind::Git(_git_ref) => indoc! {r#"
            unpackPhase = ''
              cp -r $src source && chmod -R u+w source && cd source/$CARGO_MANIFEST_DIR
              export CARGO_MANIFEST_DIR=. CARGO_MANIFEST_PATH=./Cargo.toml
            '';
          "#}
        .to_string(),
        SourceKind::Registry => {
            if source_id.is_crates_io() {
                let rendered: String = templates::render(
                    templates::UNPACK_CRATES_IO,
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

pub fn generate_manifest_environment_variables<'gctx>(
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
            let strip = git_package_subpath(unit, workspace.gctx())?;
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

pub fn generate_src<'gctx>(
    unit: &Unit,
    crate_name: &String,
    crate_version: &String,
    gctx: &'gctx GlobalContext,
    write_nix_buildsystem_options: &Option<NixBuildOptions>,
) -> CargoResult<String> {
    let source_id = unit.pkg.package_id().source_id();
    match source_id.kind() {
        SourceKind::Path => {
            let remote_src = write_nix_buildsystem_options.as_ref().and_then(|o| o.remote_src.as_ref());
            match remote_src {
                Some(remote_src) => {
                    let rendered: String = templates::render(
                        templates::FETCH_REMOTE_SRC,
                        &serde_json::json!({
                            "url": &remote_src.url,
                            "hash": &remote_src.hash
                        }),
                    )?;
                    return Ok(rendered.indentation(4));
                },
                None => {
                    // the filtered workspace, `fn.project_src` (default.nix): bound once, so all path crates share one
                    // evaluation and copy of it instead of each walking and hashing the whole tree
                    let template_str =
                        indoc! {
                            r#"
                                src = fn.project_src;
                            "#};
                    return Ok(template_str.to_string().indentation(4));
                }
            };
        }
        SourceKind::Git(_git_ref) => {
            if let Some(precise_rev) = source_id.precise_git_fragment() {
                let url: String = source_id.url().to_string();
                // cargo's own checkout, added to the store as the fetchgit output: no second download
                if let Some(root) = checkout_root(gctx, unit.pkg.root()) {
                    let source = git_source_in_store(&root, &url, &precise_rev.to_string())?;
                    let rendered: String = templates::render(
                        templates::FETCH_GIT_CHECKOUT,
                        &serde_json::json!({
                            "name": source.name,
                            "url": url,
                            "rev": precise_rev,
                            "hash": source.hash,
                        }),
                    )?;
                    return Ok(rendered.indentation(4));
                }
                // a vendored git source (no checkout of cargo's): nix-prefetch-git downloads it
                let meta_data = download_git_for_metadata(
                    &url,
                    &precise_rev.to_string(),
                    &"".to_string(),
                    &gctx,
                )?;

                let rendered: String = templates::render(
                    templates::FETCH_GIT,
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
                let hash: &str = match unit.pkg.manifest().summary().checksum() {
                    Some(h) => h,
                    None => {
                        return Err(anyhow!(
                            "hash for pkgs.fetchurl is missing for {crate_name}-{crate_version}"
                        )
                        .into());
                    }
                };
                let rendered: String = templates::render(
                    templates::FETCH_CRATES_IO,
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