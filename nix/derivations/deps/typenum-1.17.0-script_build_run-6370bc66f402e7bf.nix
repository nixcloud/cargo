# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, fn, cargo, rustc, deps, project_root, build_parser }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "typenum-1_17_0-script_build_run-6370bc66f402e7bf";
    meta.cargo_crate_info = {
      name = "typenum";
      version = "1.17.0";
      crate_hash = "6370bc66f402e7bf";
      type = "(build.rs run)";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [typenum-1_17_0-script_build-4ca096dc05fa85f4];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/typenum/1.17.0/download";
      sha256 = "42ff0bf0c66b8238c6f3b578df37d0b7848e55df8577b3f74f92a69acceeb825";
    };
    unpackPhase = ''
      tar xf $src
      cd typenum-1.17.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CFG_FEATURE = "";
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
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Paho Lurie-Gregg <paho@paholg.com>:Andre Bogus <bogusandre@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Typenum is a Rust library for type-level numbers evaluated at
    compile time. It currently supports bits, unsigned integers, and signed
    integers. It also provides a type-level array of type-level numbers, but its
    implementation is incomplete.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "typenum";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/paholg/typenum";
    CARGO_PKG_RUST_VERSION = "1.37.0";
    CARGO_PKG_VERSION = "1.17.0";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "17";
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
      ${ typenum-1_17_0-script_build-4ca096dc05fa85f4 }/build_script_build > $OUT_DIR/nix/build_script_build.out 2> $build_script_build_output_lines
      build_script_build_exit_value=$?
      set +x -e
      
      if [ "$build_script_build_exit_value" -ne 0 ]; then
          print_cargo_message_type_3 "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" "There was an error executing build_script_build in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/typenum-1.17.0-script_build_run-6370bc66f402e7bf.nix':" $build_script_build_exit_value $build_script_build_output_lines
          cat "$build_script_build_output_lines"
          exit $build_script_build_exit_value
      fi
      
      build_parser_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${build_parser}/bin/build-rs-libnix --script-output $OUT_DIR/nix/build_script_build.out --out-dir $out/nix 2> $build_parser_output_lines
      #${build_parser}/bin/cargo-build_script_build-parser $OUT_DIR/nix/build_script_build.out --out-path $out/nix write-results 2> $build_parser_output_lines
      build_parser_exit_value=$?
      set +x -e
      
      if [ "$build_parser_exit_value" -ne 0 ]; then
          print_cargo_message_type_3 "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" "There was an error executing build_parser in file: '/home/nixos/cargo/target/debug/nix/derivations/deps/typenum-1.17.0-script_build_run-6370bc66f402e7bf.nix':" $build_script_build_exit_value $build_script_build_output_lines
          cat $build_parser_output_lines
          exit $build_parser_exit_value
      fi
      echo "@cargo {\"type\": 3, \"crate_name\": \"${meta.cargo_crate_info.name}\", \"crate_type\": \"${meta.cargo_crate_info.type}\", \"exit_code\": 0, \"messages\": []}"
    '';

}
