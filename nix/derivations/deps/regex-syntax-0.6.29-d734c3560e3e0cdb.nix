# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "regex-syntax-0_6_29-d734c3560e3e0cdb";
    meta.cargo_crate_info = {
      name = "regex-syntax";
      version = "0.6.29";
      crate_hash = "d734c3560e3e0cdb";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/regex-syntax/0.6.29/download";
      sha256 = "f162c6dd7b008981e4d40210aca20b4bd0f9b60ca9271061b07f78537722f2e1";
    };
    unpackPhase = ''
      tar xf $src
      cd regex-syntax-0.6.29
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "regex_syntax";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Rust Project Developers";
    CARGO_PKG_DESCRIPTION = "A regular expression parser.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/regex";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "regex-syntax";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/regex";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.6.29";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "6";
    CARGO_PKG_VERSION_PATCH = "29";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      ${fn.import_bash_function_helpers}
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)
      
      mkdir -p $out/nix
      export OUT_DIR=$out

      print_compiling_message "${name}"
      print_cargo_message_type_0 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name regex_syntax \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="unicode"' \
              --cfg 'feature="unicode-age"' \
              --cfg 'feature="unicode-bool"' \
              --cfg 'feature="unicode-case"' \
              --cfg 'feature="unicode-gencat"' \
              --cfg 'feature="unicode-perl"' \
              --cfg 'feature="unicode-script"' \
              --cfg 'feature="unicode-segment"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "unicode", "unicode-age", "unicode-bool", "unicode-case", "unicode-gencat", "unicode-perl", "unicode-script", "unicode-segment"))' \
              -C metadata=6514efede556326d \
              -C extra-filename=-d734c3560e3e0cdb \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
