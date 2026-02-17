# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "pest_meta-2_7_15-31f9acc074a73589";
    meta.cargo_crate_info = {
      name = "pest_meta";
      version = "2.7.15";
      crate_hash = "31f9acc074a73589";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [once_cell-1_20_3-60992a3834e62ae0 pest-2_7_15-a8485b5b1580dc17];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/pest_meta/2.7.15/download";
      sha256 = "e1e58089ea25d717bfd31fb534e4f3afcc2cc569c70de3e239778991ea3b7dea";
    };
    unpackPhase = ''
      tar xf $src
      cd pest_meta-2.7.15
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "pest_meta";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Dragoș Tiselice <dragostiselice@gmail.com>";
    CARGO_PKG_DESCRIPTION = "pest meta language parser and validator";
    CARGO_PKG_HOMEPAGE = "https://pest.rs/";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "pest_meta";
    CARGO_PKG_README = "_README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/pest-parser/pest";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "2.7.15";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "15";
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
              --crate-name pest_meta \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "grammar-extras", "not-bootstrap-in-src"))' \
              -C metadata=2c43579f605f6828 \
              -C extra-filename=-31f9acc074a73589 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern once_cell=${once_cell-1_20_3-60992a3834e62ae0}/libonce_cell-60992a3834e62ae0.rmeta \
              --extern pest=${pest-2_7_15-a8485b5b1580dc17}/libpest-a8485b5b1580dc17.rmeta \
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
