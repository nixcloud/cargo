# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, fn, cargo, rustc, deps, build_parser }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "generic-array-0_14_7-script_build_run-c657b946b2e7d7ad";
    meta.cargo_crate_info = {
      name = "generic-array";
      version = "0.14.7";
      crate_hash = "c657b946b2e7d7ad";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [generic-array-0_14_7-script_build-c51e36621e4a3a62];
    passthru.rust_script_build_run = [];
    phases = "";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/generic-array/0.14.7/download";
      sha256 = "85649ca51fd72272d7821adaf274ad91c288277713d9c18820d8499a7ff69e9a";
    };
    unpackPhase = ''
      tar xf $src
      cd generic-array-0.14.7
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CFG_FEATURE = "more_lengths,zeroize";
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
    CARGO_FEATURE_MORE_LENGTHS = "1";
    CARGO_FEATURE_ZEROIZE = "1";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Bartłomiej Kamiński <fizyk20@gmail.com>:Aaron Trent <novacrazy@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Generic types implementing functionality of arrays";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "generic-array";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/fizyk20/generic-array.git";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.14.7";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "14";
    CARGO_PKG_VERSION_PATCH = "7";
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

      echo -e "\e[92mCompiling\e[0m generic-array-0_14_7-script_build_run-c657b946b2e7d7ad"
      echo "@cargo { \"type\":0, \"crate_name\":\"generic-array\", \"id\":\"generic-array-0_14_7-script_build_run-c657b946b2e7d7ad\" }"
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
      ${ generic-array-0_14_7-script_build-c51e36621e4a3a62 }/build_script_build > $OUT_DIR/nix/build_script_build.out 2> $build_script_build_output_lines
      build_script_build_exit_value=$?
      set +x -e
      if [ "$build_script_build_exit_value" -ne 0 ]; then
          output=$(${pkgs.jq}/bin/jq -c -n \
              --arg crate_name "generic-array" \
              --arg notice "There was an error executing build_script_build in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/generic-array-0.14.7-script_build_run-c657b946b2e7d7ad.nix':" \
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
              --arg crate_name "generic-array" \
              --arg notice "There was an error executing build_parser in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/generic-array-0.14.7-script_build_run-c657b946b2e7d7ad.nix':" \
              --arg exit_code "$build_parser_exit_value" \
              --rawfile msg $build_parser_output_lines \
              '{type: 3, crate_name: $crate_name, exit_code: ($exit_code|tonumber), messages: [ $notice, $msg ] }')
          printf '@cargo %s\n' "$output"
          cat $build_parser_output_lines
          exit $build_parser_exit_value
      fi
      echo "@cargo {\"type\": 3, \"crate_name\": \"generic-array\", \"exit_code\": 0, \"messages\": []}"
    '';

}
