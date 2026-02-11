# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "ucd-trie-0_1_7-174fa1c20d2742b4";
    meta.cargo_crate_info = {
      name = "ucd-trie";
      version = "0.1.7";
      crate_hash = "174fa1c20d2742b4";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/ucd-trie/0.1.7/download";
      sha256 = "2896d95c02a80c6d6a5d6e953d479f5ddf2dfdb6a244441010e373ac0fb88971";
    };
    unpackPhase = ''
      tar xf $src
      cd ucd-trie-0.1.7
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "ucd_trie";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A trie for storing Unicode codepoint sets and maps.";
    CARGO_PKG_HOMEPAGE = "https://github.com/BurntSushi/ucd-generate";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "ucd-trie";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/BurntSushi/ucd-generate";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.1.7";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "7";
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
              --crate-name ucd_trie \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "std"))' \
              -C metadata=39937d71b7f2bb18 \
              -C extra-filename=-174fa1c20d2742b4 \
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
