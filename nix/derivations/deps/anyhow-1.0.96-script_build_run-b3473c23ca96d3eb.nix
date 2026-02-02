# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, fn, cargo, rustc, deps, build_parser }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "anyhow-1_0_96-script_build_run-b3473c23ca96d3eb";
    meta.cargo_crate_info = {
      name = "anyhow";
      version = "1.0.96";
      crate_hash = "b3473c23ca96d3eb";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [anyhow-1_0_96-script_build-118337b27fb502c0];
    passthru.rust_script_build_run = [];
    phases = "";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/anyhow/1.0.96/download";
      sha256 = "6b964d184e89d9b6b67dd2715bc8e74cf3107fb2b529990c90cf517326150bf4";
    };
    unpackPhase = ''
      tar xf $src
      cd anyhow-1.0.96
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CFG_FEATURE = "default,std";
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
    CARGO_FEATURE_DEFAULT = "1";
    CARGO_FEATURE_STD = "1";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "David Tolnay <dtolnay@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Flexible concrete Error type built on std::error::Error";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "anyhow";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/dtolnay/anyhow";
    CARGO_PKG_RUST_VERSION = "1.39";
    CARGO_PKG_VERSION = "1.0.96";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "96";
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

      echo -e "\e[92mCompiling\e[0m anyhow-1_0_96-script_build_run-b3473c23ca96d3eb"
      echo "@cargo { \"type\":0, \"crate_name\":\"anyhow\", \"id\":\"anyhow-1_0_96-script_build_run-b3473c23ca96d3eb\" }"
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
      ${ anyhow-1_0_96-script_build-118337b27fb502c0 }/build_script_build > $OUT_DIR/nix/build_script_build.out 2> $build_script_build_output_lines
      build_script_build_exit_value=$?
      set +x -e
      if [ "$build_script_build_exit_value" -ne 0 ]; then
          output=$(${pkgs.jq}/bin/jq -c -n \
              --arg crate_name "anyhow" \
              --arg notice "There was an error executing build_script_build in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/anyhow-1.0.96-script_build_run-b3473c23ca96d3eb.nix':" \
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
              --arg crate_name "anyhow" \
              --arg notice "There was an error executing build_parser in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/anyhow-1.0.96-script_build_run-b3473c23ca96d3eb.nix':" \
              --arg exit_code "$build_parser_exit_value" \
              --rawfile msg $build_parser_output_lines \
              '{type: 3, crate_name: $crate_name, exit_code: ($exit_code|tonumber), messages: [ $notice, $msg ] }')
          printf '@cargo %s\n' "$output"
          cat $build_parser_output_lines
          exit $build_parser_exit_value
      fi
      echo "@cargo {\"type\": 3, \"crate_name\": \"anyhow\", \"exit_code\": 0, \"messages\": []}"
    '';

}
