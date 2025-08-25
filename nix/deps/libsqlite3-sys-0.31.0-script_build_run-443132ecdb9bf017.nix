# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps, build_parser }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libsqlite3-sys-0_31_0-script_build_run-443132ecdb9bf017";
    meta.cargo_crate_info = {
      name = "libsqlite3-sys";
      version = "0.31.0";
      crate_hash = "443132ecdb9bf017";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [libsqlite3-sys-0_31_0-script_build-a462025432685fe6];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libsqlite3-sys/0.31.0/download";
      sha256 = "ad8935b44e7c13394a179a438e0cebba0fe08fe01b54f152e29a93b5cf993fd4";
    };
    unpackPhase = ''
      tar xf $src
      cd libsqlite3-sys-0.31.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CFG_FEATURE = "bundled,bundled_bindings,cc,default,min_sqlite_version_3_14_0,pkg-config,vcpkg";
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
    CARGO_FEATURE_BUNDLED = "1";
    CARGO_FEATURE_BUNDLED_BINDINGS = "1";
    CARGO_FEATURE_CC = "1";
    CARGO_FEATURE_DEFAULT = "1";
    CARGO_FEATURE_MIN_SQLITE_VERSION_3_14_0 = "1";
    CARGO_FEATURE_PKG_CONFIG = "1";
    CARGO_FEATURE_VCPKG = "1";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_LINKS = "sqlite3";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The rusqlite developers";
    CARGO_PKG_DESCRIPTION = "Native bindings to the libsqlite3 library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libsqlite3-sys";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rusqlite/rusqlite";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.31.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "31";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";
    DEBUG = "true";
    HOST = "x86_64-unknown-linux-gnu";
    NUM_JOBS = "16";
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
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m libsqlite3-sys-0_31_0-script_build_run-443132ecdb9bf017"
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
      (set -x 
      ${libsqlite3-sys-0_31_0-script_build-a462025432685fe6}/build_script_build > $OUT_DIR/nix/build_script_build.out
      ${build_parser}/bin/cargo-build_script_build-parser $OUT_DIR/nix/build_script_build.out --out-path $out/nix write-results
      )
    '';
}
