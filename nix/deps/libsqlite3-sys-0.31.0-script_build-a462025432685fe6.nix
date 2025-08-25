# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libsqlite3-sys-0_31_0-script_build-a462025432685fe6";
    meta.cargo_crate_info = {
      name = "libsqlite3-sys";
      version = "0.31.0";
      crate_hash = "a462025432685fe6";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cc-1_2_16-aaebd3b60c7751f8 pkg-config-0_3_31-74aa6e3930289a4b vcpkg-0_2_15-ec038215c0a44778];
    passthru.rust_crate_parent = [];
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

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
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

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m libsqlite3-sys-0_31_0-script_build-a462025432685fe6"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2021 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="bundled"' \
        --cfg 'feature="bundled_bindings"' \
        --cfg 'feature="cc"' \
        --cfg 'feature="default"' \
        --cfg 'feature="min_sqlite_version_3_14_0"' \
        --cfg 'feature="pkg-config"' \
        --cfg 'feature="vcpkg"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("bindgen", "buildtime_bindgen", "bundled", "bundled-sqlcipher", "bundled-sqlcipher-vendored-openssl", "bundled-windows", "bundled_bindings", "cc", "default", "in_gecko", "loadable_extension", "min_sqlite_version_3_14_0", "openssl-sys", "pkg-config", "prettyplease", "preupdate_hook", "quote", "session", "sqlcipher", "syn", "unlock_notify", "vcpkg", "wasm32-wasi-vfs", "with-asan"))' \
        -C metadata=5496fa2d583bee5a \
        -C extra-filename=-a462025432685fe6 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern cc=${cc-1_2_16-aaebd3b60c7751f8}/libcc-aaebd3b60c7751f8.rlib \
        --extern pkg_config=${pkg-config-0_3_31-74aa6e3930289a4b}/libpkg_config-74aa6e3930289a4b.rlib \
        --extern vcpkg=${vcpkg-0_2_15-ec038215c0a44778}/libvcpkg-ec038215c0a44778.rlib \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-a462025432685fe6 $OUT_DIR/build_script_build
      )
    '';
}
