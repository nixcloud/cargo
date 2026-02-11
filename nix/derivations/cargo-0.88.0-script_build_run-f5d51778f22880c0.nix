# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, fn, cargo, rustc, deps, project_root, build_parser, cargo-0_88_0-script_build-cfc654fccb259515 }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-0_88_0-script_build_run-f5d51778f22880c0";
    meta.cargo_crate_info = {
      name = "cargo";
      version = "0.88.0";
      crate_hash = "f5d51778f22880c0";
      type = "(build.rs run)";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [cargo-0_88_0-script_build-cfc654fccb259515];
    passthru.rust_script_build_run = [curl-sys-0_4_80_plus_curl-8_12_1-db5fbe1d9680c71f libgit2-sys-0_18_0_plus_1_9_0-86c4b3f8f5bf526a];
    phases = "unpackPhase buildPhase";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "src/etc/man/cargo-add.1"
        "src/etc/man/cargo-bench.1"
        "src/etc/man/cargo-build.1"
        "src/etc/man/cargo-check.1"
        "src/etc/man/cargo-clean.1"
        "src/etc/man/cargo-doc.1"
        "src/etc/man/cargo-fetch.1"
        "src/etc/man/cargo-fix.1"
        "src/etc/man/cargo-generate-lockfile.1"
        "src/etc/man/cargo-help.1"
        "src/etc/man/cargo-info.1"
        "src/etc/man/cargo-init.1"
        "src/etc/man/cargo-install.1"
        "src/etc/man/cargo-locate-project.1"
        "src/etc/man/cargo-login.1"
        "src/etc/man/cargo-logout.1"
        "src/etc/man/cargo-metadata.1"
        "src/etc/man/cargo-new.1"
        "src/etc/man/cargo-owner.1"
        "src/etc/man/cargo-package.1"
        "src/etc/man/cargo-pkgid.1"
        "src/etc/man/cargo-publish.1"
        "src/etc/man/cargo-remove.1"
        "src/etc/man/cargo-report.1"
        "src/etc/man/cargo-run.1"
        "src/etc/man/cargo-rustc.1"
        "src/etc/man/cargo-rustdoc.1"
        "src/etc/man/cargo-search.1"
        "src/etc/man/cargo-test.1"
        "src/etc/man/cargo-tree.1"
        "src/etc/man/cargo-uninstall.1"
        "src/etc/man/cargo-update.1"
        "src/etc/man/cargo-vendor.1"
        "src/etc/man/cargo-version.1"
        "src/etc/man/cargo-yank.1"
        "src/etc/man/cargo.1"
        "src/doc/man/generated_txt/cargo-add.txt"
        "src/doc/man/generated_txt/cargo-bench.txt"
        "src/doc/man/generated_txt/cargo-build.txt"
        "src/doc/man/generated_txt/cargo-check.txt"
        "src/doc/man/generated_txt/cargo-clean.txt"
        "src/doc/man/generated_txt/cargo-doc.txt"
        "src/doc/man/generated_txt/cargo-fetch.txt"
        "src/doc/man/generated_txt/cargo-fix.txt"
        "src/doc/man/generated_txt/cargo-generate-lockfile.txt"
        "src/doc/man/generated_txt/cargo-help.txt"
        "src/doc/man/generated_txt/cargo-info.txt"
        "src/doc/man/generated_txt/cargo-init.txt"
        "src/doc/man/generated_txt/cargo-install.txt"
        "src/doc/man/generated_txt/cargo-locate-project.txt"
        "src/doc/man/generated_txt/cargo-login.txt"
        "src/doc/man/generated_txt/cargo-logout.txt"
        "src/doc/man/generated_txt/cargo-metadata.txt"
        "src/doc/man/generated_txt/cargo-new.txt"
        "src/doc/man/generated_txt/cargo-owner.txt"
        "src/doc/man/generated_txt/cargo-package.txt"
        "src/doc/man/generated_txt/cargo-pkgid.txt"
        "src/doc/man/generated_txt/cargo-publish.txt"
        "src/doc/man/generated_txt/cargo-remove.txt"
        "src/doc/man/generated_txt/cargo-report.txt"
        "src/doc/man/generated_txt/cargo-run.txt"
        "src/doc/man/generated_txt/cargo-rustc.txt"
        "src/doc/man/generated_txt/cargo-rustdoc.txt"
        "src/doc/man/generated_txt/cargo-search.txt"
        "src/doc/man/generated_txt/cargo-test.txt"
        "src/doc/man/generated_txt/cargo-tree.txt"
        "src/doc/man/generated_txt/cargo-uninstall.txt"
        "src/doc/man/generated_txt/cargo-update.txt"
        "src/doc/man/generated_txt/cargo-vendor.txt"
        "src/doc/man/generated_txt/cargo-version.txt"
        "src/doc/man/generated_txt/cargo-yank.txt"
        "src/doc/man/generated_txt/cargo.txt"
      ];
    };
    unpackPhase = "";

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
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Cargo, a package manager for Rust.";
    CARGO_PKG_HOMEPAGE = "https://doc.rust-lang.org/cargo/index.html";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.88.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "88";
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
      ${ cargo-0_88_0-script_build-cfc654fccb259515 }/build_script_build > $OUT_DIR/nix/build_script_build.out 2> $build_script_build_output_lines
      build_script_build_exit_value=$?
      set +x -e
      
      if [ "$build_script_build_exit_value" -ne 0 ]; then
          print_cargo_message_type_3 "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" "There was an error executing build_script_build in file: '/home/nixos/cargo/target/debug/nix/derivations/cargo-0.88.0-script_build_run-f5d51778f22880c0.nix':" $build_script_build_exit_value $build_script_build_output_lines
          cat "$build_script_build_output_lines"
          exit $build_script_build_exit_value
      fi
      
      build_parser_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${build_parser}/bin/cargo-build_script_build-parser $OUT_DIR/nix/build_script_build.out --out-path $out/nix write-results 2> $build_parser_output_lines
      build_parser_exit_value=$?
      set +x -e
      
      if [ "$build_parser_exit_value" -ne 0 ]; then
          print_cargo_message_type_3 "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" "There was an error executing build_parser in file: '/home/nixos/cargo/target/debug/nix/derivations/cargo-0.88.0-script_build_run-f5d51778f22880c0.nix':" $build_script_build_exit_value $build_script_build_output_lines
          cat $build_parser_output_lines
          exit $build_parser_exit_value
      fi
      echo "@cargo {\"type\": 3, \"crate_name\": \"${meta.cargo_crate_info.name}\", \"crate_type\": \"${meta.cargo_crate_info.type}\", \"exit_code\": 0, \"messages\": []}"
    '';

}
