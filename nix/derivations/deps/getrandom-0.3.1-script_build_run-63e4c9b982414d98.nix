# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, fn, cargo, rustc, deps, build_parser }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "getrandom-0_3_1-script_build_run-63e4c9b982414d98";
    meta.cargo_crate_info = {
      name = "getrandom";
      version = "0.3.1";
      crate_hash = "63e4c9b982414d98";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [getrandom-0_3_1-script_build-84bfc3afc25bedc8];
    passthru.rust_script_build_run = [];
    phases = "";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/getrandom/0.3.1/download";
      sha256 = "43a49c392881ce6d5c3b8cb70f98717b7c07aabbdff06687b9030dbfbe2725f8";
    };
    unpackPhase = ''
      tar xf $src
      cd getrandom-0.3.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CFG_FEATURE = "std,wasm_js";
    CARGO_CFG_PANIC = "unwind";
    CARGO_CFG_TARGET_ABI = "";
    CARGO_CFG_TARGET_ARCH = "x86_64";
    CARGO_CFG_TARGET_ENDIAN = "little";
    CARGO_CFG_TARGET_ENV = "gnu";
    CARGO_CFG_TARGET_FAMILY = "unix";
    CARGO_CFG_TARGET_FEATURE = "fxsr,sse,sse2";
    CARGO_CFG_TARGET_HAS_ATOMIC = "16,32,64,8,ptr";
    CARGO_CFG_TARGET_OS = "linux";
    CARGO_CFG_TARGET_POINTER_WIDTH = "64";
    CARGO_CFG_TARGET_VENDOR = "unknown";
    CARGO_CFG_UNIX = "";
    CARGO_ENCODED_RUSTFLAGS = "";
    CARGO_FEATURE_STD = "1";
    CARGO_FEATURE_WASM_JS = "1";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Rand Project Developers";
    CARGO_PKG_DESCRIPTION = "A small cross-platform library for retrieving random data from system source";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "getrandom";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-random/getrandom";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "0.3.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";
    DEBUG = "true";
    HOST = "x86_64-unknown-linux-gnu";
    NUM_JOBS = "8";
    OPT_LEVEL = "0";
    PROFILE = "debug";
    RUSTC_WORKSPACE_WRAPPER = "";
    RUSTC_WRAPPER = "";
    RUSTDOC = "rustdoc";
    RUSTFLAGS = "";
    TARGET = "x86_64-unknown-linux-gnu";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m getrandom-0_3_1-script_build_run-63e4c9b982414d98"
      echo "@cargo { \"type\":0, \"crate_name\":\"getrandom\", \"id\":\"getrandom-0_3_1-script_build_run-63e4c9b982414d98\" }"
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
      build_script_build_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${ getrandom-0_3_1-script_build-84bfc3afc25bedc8 }/build_script_build > $OUT_DIR/nix/build_script_build.out 2> $build_script_build_output_lines
      build_script_build_exit_value=$?
      set +x -e
      if [ "$build_script_build_exit_value" -ne 0 ]; then
          output=$(${pkgs.jq}/bin/jq -c -n \
              --arg crate_name "getrandom" \
              --arg notice "There was an error executing build_script_build in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/getrandom-0.3.1-script_build_run-63e4c9b982414d98.nix':" \
              --arg exit_code "$build_script_build_exit_value" \
              --rawfile msg $build_script_build_output_lines \
              '{type: 3, crate_name: $crate_name, exit_code: ($exit_code|tonumber), messages: [ $notice, $msg ] }')
          printf '@cargo %s\n' "$output"
          cat "$build_script_build_output_lines"
          exit $build_script_build_exit_value
      fi
      
      build_parser_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${build_parser}/bin/cargo-build_script_build-parser $OUT_DIR/nix/build_script_build.out --out-path $out/nix write-results 2> $build_parser_output_lines
      build_parser_exit_value=$?
      set +x -e
      if [ "$build_parser_exit_value" -ne 0 ]; then
          output=$(${pkgs.jq}/bin/jq -c -n \
              --arg crate_name "getrandom" \
              --arg notice "There was an error executing build_parser in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/getrandom-0.3.1-script_build_run-63e4c9b982414d98.nix':" \
              --arg exit_code "$build_parser_exit_value" \
              --rawfile msg $build_parser_output_lines \
              '{type: 3, crate_name: $crate_name, exit_code: ($exit_code|tonumber), messages: [ $notice, $msg ] }')
          printf '@cargo %s\n' "$output"
          cat $build_parser_output_lines
          exit $build_parser_exit_value
      fi
      echo "@cargo {\"type\": 3, \"crate_name\": \"getrandom\", \"exit_code\": 0, \"messages\": []}"
    '';

}
