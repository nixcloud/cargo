//! The handlebars templates of the generated build system, parsed once per process: rendered for each unit, a
//! registry per call parsed the same templates again for every one of them (~1700 parses for cargo's 432 units).
//! The templates are constants; all that differs between units is the data they are rendered with.

use std::sync::LazyLock;

use handlebars::Handlebars;
use indoc::indoc;

use crate::core::compiler::nix_build::nix_code::IndentationExt;
use crate::util::CargoResult;

// files of templates/
pub const CARGO_BUILD_CALLER: &str = "cargo_build_caller";
pub const BUILD_RS_LIBNIX: &str = "build_rs_libnix";
pub const DEFAULT: &str = "default";
pub const TARGET: &str = "target";
pub const RUSTC_CALL: &str = "rustc-call";
// snippets
pub const BUILD_SCRIPT_RUN_COMMAND_LINE: &str = "build_script_run_command_line";
pub const RUSTC_COMMAND_LINE: &str = "rustc_command_line";
pub const UNPACK_CRATES_IO: &str = "unpack_crates_io";
pub const FETCH_REMOTE_SRC: &str = "fetch_remote_src";
pub const FETCH_GIT_CHECKOUT: &str = "fetch_git_checkout";
pub const FETCH_GIT: &str = "fetch_git";
pub const FETCH_CRATES_IO: &str = "fetch_crates_io";

/// The build phase of a build script run: runs it, then build-rs-libnix on its output.
const BUILD_SCRIPT_RUN_COMMAND_LINE_SRC: &str = indoc! {
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
"#};

/// The build phase of a rustc call.
const RUSTC_COMMAND_LINE_SRC: &str = indoc! {
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
    "#};

const UNPACK_CRATES_IO_SRC: &str = indoc! {
    r#"
        unpackPhase = ''
          tar xf $src
          cd {{{crate_name}}}-{{{crate_version}}}
        '';
    "#};

/// The workspace's path crates from the tarball of `write-nix-buildsystem --url/--hash`.
const FETCH_REMOTE_SRC_SRC: &str = indoc! {
    r#"
    src = pkgs.fetchurl {
        url = "{{{url}}}";
        sha256 = "{{{hash}}}";
    };
    "#};

/// cargo's own checkout, added to the store as the fetchgit output: no second download.
const FETCH_GIT_CHECKOUT_SRC: &str = indoc! {
    r#"
      src = pkgs.fetchgit {
        name = "{{{name}}}";
        url = "{{{url}}}";
        rev = "{{{rev}}}";
        hash = "{{{hash}}}";
        fetchSubmodules = true;
        # nixpkgs 26.05: detached git maintenance/gc in submodules races the .git removal and
        # makes the output non-deterministic (NixOS/nixpkgs#524215, fixed upstream by 88cfc54552d5
        # and 5b5c421f525b). Drop this once the pinned nixpkgs has both.
        preFetch = "export GIT_CONFIG_COUNT=3 GIT_CONFIG_KEY_0=maintenance.auto GIT_CONFIG_VALUE_0=false GIT_CONFIG_KEY_1=gc.auto GIT_CONFIG_VALUE_1=0 GIT_CONFIG_KEY_2=gc.autoDetach GIT_CONFIG_VALUE_2=false";
      };
    "#};

/// A vendored git source (no checkout of cargo's): nix-prefetch-git downloads it.
const FETCH_GIT_SRC: &str = indoc! {
    r#"
      src = pkgs.fetchgit {
        url = "{{{url}}}";
        rev = "{{{rev}}}";
        sha256 = "{{{sha256}}}";
      };
    "#};

const FETCH_CRATES_IO_SRC: &str = indoc! {
    r#"
      src = pkgs.fetchurl {
        # named like nixpkgs' importCargoLock, so the store path matches (and cache.nixos.org may have it);
        # without a name it would be `download`, after the last URL segment
        name = "crate-{{{crate_name}}}-{{{crate_version}}}.tar.gz";
        url = "https://crates.io/api/v1/crates/{{{crate_name}}}/{{{crate_version}}}/download";
        sha256 = "{{{hash}}}";
      };
    "#};

static TEMPLATES: LazyLock<Handlebars<'static>> = LazyLock::new(|| {
    let mut handlebars = Handlebars::new();
    let mut register = |name: &str, template: &str| {
        // a template error is a bug of the generator, not of the project
        handlebars
            .register_template_string(name, template)
            .unwrap_or_else(|e| panic!("nix_build template {name}: {e}"));
    };
    register(CARGO_BUILD_CALLER, include_str!("templates/cargo_build_caller.nix.handlebars"));
    register(BUILD_RS_LIBNIX, include_str!("templates/build_rs_libnix.nix.handlebars"));
    register(DEFAULT, include_str!("templates/default.nix.handlebars"));
    register(TARGET, include_str!("templates/target.nix.handlebars"));
    register(RUSTC_CALL, include_str!("templates/rustc-call.nix.handlebars"));
    register(
        BUILD_SCRIPT_RUN_COMMAND_LINE,
        &BUILD_SCRIPT_RUN_COMMAND_LINE_SRC.to_string().indentation(6),
    );
    register(RUSTC_COMMAND_LINE, RUSTC_COMMAND_LINE_SRC);
    register(UNPACK_CRATES_IO, UNPACK_CRATES_IO_SRC);
    register(FETCH_REMOTE_SRC, FETCH_REMOTE_SRC_SRC);
    register(FETCH_GIT_CHECKOUT, FETCH_GIT_CHECKOUT_SRC);
    register(FETCH_GIT, FETCH_GIT_SRC);
    register(FETCH_CRATES_IO, FETCH_CRATES_IO_SRC);
    handlebars
});

/// Renders the template `name` (one of the constants above) with `data`.
pub fn render(name: &str, data: &serde_json::Value) -> CargoResult<String> {
    Ok(TEMPLATES.render(name, data)?)
}
