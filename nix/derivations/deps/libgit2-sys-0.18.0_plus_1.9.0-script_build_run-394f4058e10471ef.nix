# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, fn, cargo, rustc, deps, build_parser }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libgit2-sys-0_18_0_plus_1_9_0-script_build_run-394f4058e10471ef";
    meta.cargo_crate_info = {
      name = "libgit2-sys";
      version = "0.18.0+1.9.0";
      crate_hash = "394f4058e10471ef";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [libgit2-sys-0_18_0_plus_1_9_0-script_build-df53d2b5ce2efa6a];
    passthru.rust_script_build_run = [libssh2-sys-0_3_1-7b0b3bce8fea88d8 libz-sys-1_1_21-69f52d4cc5a20a24 openssl-sys-0_9_106-adcaf6cb517a5566];
    phases = "";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libgit2-sys/0.18.0+1.9.0/download";
      sha256 = "e1a117465e7e1597e8febea8bb0c410f1c7fb93b1e1cddf34363f8390367ffec";
    };
    unpackPhase = ''
      tar xf $src
      cd libgit2-sys-0.18.0+1.9.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CFG_FEATURE = "https,libssh2-sys,openssl-sys,ssh";
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
    CARGO_FEATURE_HTTPS = "1";
    CARGO_FEATURE_LIBSSH2_SYS = "1";
    CARGO_FEATURE_OPENSSL_SYS = "1";
    CARGO_FEATURE_SSH = "1";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_LINKS = "git2";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Josh Triplett <josh@joshtriplett.org>:Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Native bindings to the libgit2 library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libgit2-sys";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/git2-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.18.0+1.9.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "18";
    CARGO_PKG_VERSION_PATCH = "0";
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

      echo -e "\e[92mCompiling\e[0m libgit2-sys-0_18_0_plus_1_9_0-script_build_run-394f4058e10471ef"
      echo "@cargo { \"type\":0, \"crate_name\":\"libgit2-sys\", \"id\":\"libgit2-sys-0_18_0_plus_1_9_0-script_build_run-394f4058e10471ef\" }"
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
      ${ libgit2-sys-0_18_0_plus_1_9_0-script_build-df53d2b5ce2efa6a }/build_script_build > $OUT_DIR/nix/build_script_build.out 2> $build_script_build_output_lines
      build_script_build_exit_value=$?
      set +x -e
      if [ "$build_script_build_exit_value" -ne 0 ]; then
          output=$(${pkgs.jq}/bin/jq -c -n \
              --arg crate_name "libgit2-sys" \
              --arg notice "There was an error executing build_script_build in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/libgit2-sys-0.18.0_plus_1.9.0-script_build_run-394f4058e10471ef.nix':" \
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
              --arg crate_name "libgit2-sys" \
              --arg notice "There was an error executing build_parser in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/libgit2-sys-0.18.0_plus_1.9.0-script_build_run-394f4058e10471ef.nix':" \
              --arg exit_code "$build_parser_exit_value" \
              --rawfile msg $build_parser_output_lines \
              '{type: 3, crate_name: $crate_name, exit_code: ($exit_code|tonumber), messages: [ $notice, $msg ] }')
          printf '@cargo %s\n' "$output"
          cat $build_parser_output_lines
          exit $build_parser_exit_value
      fi
      echo "@cargo {\"type\": 3, \"crate_name\": \"libgit2-sys\", \"exit_code\": 0, \"messages\": []}"
    '';

}
