# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, fn, cargo, rustc, deps, build_parser }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "signal-hook-0_3_18-script_build_run-40557db598ae01b9";
    meta.cargo_crate_info = {
      name = "signal-hook";
      version = "0.3.18";
      crate_hash = "40557db598ae01b9";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [signal-hook-0_3_18-script_build-1ac0ce670fbb2a9a];
    passthru.rust_script_build_run = [];
    phases = "";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/signal-hook/0.3.18/download";
      sha256 = "d881a16cf4426aa584979d30bd82cb33429027e42122b169753d6ef1085ed6e2";
    };
    unpackPhase = ''
      tar xf $src
      cd signal-hook-0.3.18
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CFG_FEATURE = "channel,default,iterator";
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
    CARGO_FEATURE_CHANNEL = "1";
    CARGO_FEATURE_DEFAULT = "1";
    CARGO_FEATURE_ITERATOR = "1";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Michal 'vorner' Vaner <vorner@vorner.cz>:Thomas Himmelstoss <thimm@posteo.de>";
    CARGO_PKG_DESCRIPTION = "Unix signal handling";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0/MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "signal-hook";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/vorner/signal-hook";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.3.18";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "18";
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

      echo -e "\e[92mCompiling\e[0m signal-hook-0_3_18-script_build_run-40557db598ae01b9"
      echo "@cargo { \"type\":0, \"crate_name\":\"signal-hook\", \"id\":\"signal-hook-0_3_18-script_build_run-40557db598ae01b9\" }"
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
      ${ signal-hook-0_3_18-script_build-1ac0ce670fbb2a9a }/build_script_build > $OUT_DIR/nix/build_script_build.out 2> $build_script_build_output_lines
      build_script_build_exit_value=$?
      set +x -e
      if [ "$build_script_build_exit_value" -ne 0 ]; then
          output=$(${pkgs.jq}/bin/jq -c -n \
              --arg crate_name "signal-hook" \
              --arg notice "There was an error executing build_script_build in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/signal-hook-0.3.18-script_build_run-40557db598ae01b9.nix':" \
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
              --arg crate_name "signal-hook" \
              --arg notice "There was an error executing build_parser in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/signal-hook-0.3.18-script_build_run-40557db598ae01b9.nix':" \
              --arg exit_code "$build_parser_exit_value" \
              --rawfile msg $build_parser_output_lines \
              '{type: 3, crate_name: $crate_name, exit_code: ($exit_code|tonumber), messages: [ $notice, $msg ] }')
          printf '@cargo %s\n' "$output"
          cat $build_parser_output_lines
          exit $build_parser_exit_value
      fi
      echo "@cargo {\"type\": 3, \"crate_name\": \"signal-hook\", \"exit_code\": 0, \"messages\": []}"
    '';

}
