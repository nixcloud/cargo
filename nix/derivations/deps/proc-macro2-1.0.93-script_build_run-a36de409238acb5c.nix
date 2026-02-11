# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, fn, cargo, rustc, deps, build_parser }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "proc-macro2-1_0_93-script_build_run-a36de409238acb5c";
    meta.cargo_crate_info = {
      name = "proc-macro2";
      version = "1.0.93";
      crate_hash = "a36de409238acb5c";
      type = "(build.rs run)";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [proc-macro2-1_0_93-script_build-44658edbe8e1d4ac];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/proc-macro2/1.0.93/download";
      sha256 = "60946a68e5f9d28b0dc1c21bb8a97ee7d018a8b322fa57838ba31cc878e22d99";
    };
    unpackPhase = ''
      tar xf $src
      cd proc-macro2-1.0.93
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CFG_FEATURE = "default,proc-macro";
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
    CARGO_FEATURE_PROC_MACRO = "1";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "David Tolnay <dtolnay@gmail.com>:Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "A substitute implementation of the compiler's `proc_macro` API to decouple token-based libraries from the procedural macro use case.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "proc-macro2";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/dtolnay/proc-macro2";
    CARGO_PKG_RUST_VERSION = "1.56";
    CARGO_PKG_VERSION = "1.0.93";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "93";
    CARGO_PKG_VERSION_PRE = "";
    DEBUG = "false";
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
      ${fn.import_bash_function_helpers}
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)
      cd $CARGO_MANIFEST_DIR
      mkdir -p $out/nix
      export OUT_DIR=$out

      print_compiling_message "${name}"
      print_cargo_message_type_0 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}"
      load_environment_variables_from_files "${fn.environment_variables passthru.rust_script_build_run}"
      build_script_build_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${ proc-macro2-1_0_93-script_build-44658edbe8e1d4ac }/build_script_build > $OUT_DIR/nix/build_script_build.out 2> $build_script_build_output_lines
      build_script_build_exit_value=$?
      set +x -e
      
      if [ "$build_script_build_exit_value" -ne 0 ]; then
          print_cargo_message_type_3 "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" "There was an error executing build_script_build in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/proc-macro2-1.0.93-script_build_run-a36de409238acb5c.nix':" $build_script_build_exit_value $build_script_build_output_lines
          cat "$build_script_build_output_lines"
          exit $build_script_build_exit_value
      fi
      
      build_parser_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${build_parser}/bin/cargo-build_script_build-parser $OUT_DIR/nix/build_script_build.out --out-path $out/nix write-results 2> $build_parser_output_lines
      build_parser_exit_value=$?
      set +x -e
      
      if [ "$build_parser_exit_value" -ne 0 ]; then
          print_cargo_message_type_3 "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" "There was an error executing build_parser in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/proc-macro2-1.0.93-script_build_run-a36de409238acb5c.nix':" $build_script_build_exit_value $build_script_build_output_lines
          cat $build_parser_output_lines
          exit $build_parser_exit_value
      fi
      echo "@cargo {\"type\": 3, \"crate_name\": \"${meta.cargo_crate_info.name}\", \"crate_type\": \"${meta.cargo_crate_info.type}\", \"exit_code\": 0, \"messages\": []}"
    '';

}
