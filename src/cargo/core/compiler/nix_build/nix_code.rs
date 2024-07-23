use std::path::{Component, Path, PathBuf};
use anyhow::anyhow;
use indoc::indoc;
use cargo_util::ProcessBuilder;
use handlebars::Handlebars;

use crate::core::compiler::nix_build::crate_build_type;
use crate::core::compiler::nix_build::asserts::{assert_valid_nix_file_name, assert_valid_nix_attr_name};
use crate::core::compiler::nix_build::download::download_git_for_metadata;
use crate::core::compiler::nix_build::{NixNameMode, CrateBuildType, mode_string, kind_string};
use crate::util::command_prelude::NixBuildOptions;
use crate::core::compiler::BuildRunner;
use crate::core::compiler::Unit;
use crate::core::workspace::Workspace;
use crate::core::SourceKind;
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

    let crate_type: &str = match crate_build_type(&unit) {
        CrateBuildType::LibBuild => "",
        CrateBuildType::ScriptBuild => "(build.rs build)",
        CrateBuildType::ScriptBuildRun => "(build.rs run)",
        CrateBuildType::BinBuild => "(bin)",
        CrateBuildType::Other => "(?)",
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

pub fn generate_environment_variables<'gctx>(
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

pub fn generate_src<'gctx>(
    workspace: &Workspace<'gctx>,
    unit: &Unit,
    crate_name: &String,
    crate_version: &String,
    gctx: &'gctx GlobalContext,
    write_nix_buildsystem_options: &Option<NixBuildOptions>,
) -> CargoResult<String> {
    let source_id = unit.pkg.package_id().source_id();
    match source_id.kind() {
        SourceKind::Path => {
            match write_nix_buildsystem_options {
                Some(ref write_nix_buildsystem_options) => {
                    let mut handlebars = Handlebars::new();
                    let template_str = indoc! {
                    r#"
                    src = pkgs.fetchurl {
                        url = "{{{url}}}";
                        sha256 = "{{{hash}}}";
                    };
                    "#};
                    handlebars.register_template_string("fetch", template_str)?;
                    let rendered: String = handlebars.render(
                        "fetch",
                        &serde_json::json!({
                            "url": &write_nix_buildsystem_options.url,
                            "hash": &write_nix_buildsystem_options.hash
                        }),
                    )?;
                    return Ok(rendered.indentation(4));
                },
                None => {
                    let src = workspace.root().display().to_string();
                    let mut handlebars = Handlebars::new();
                    let template_str = 
                        indoc! {
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
            }; 
        }
        SourceKind::Git(_git_ref) => {
            if let Some(precise_rev) = source_id.precise_git_fragment() {
                let url: String = source_id.url().to_string();
                let meta_data = download_git_for_metadata(
                    &url,
                    &precise_rev.to_string(),
                    &"".to_string(),
                    &gctx,
                )?;

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