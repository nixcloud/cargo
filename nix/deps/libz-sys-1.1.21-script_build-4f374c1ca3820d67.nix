# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libz-sys-1_1_21-script_build-4f374c1ca3820d67";
    meta.cargo_crate_info = {
      name = "libz-sys";
      version = "1.1.21";
      crate_hash = "4f374c1ca3820d67";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cc-1_2_16-aaebd3b60c7751f8 pkg-config-0_3_31-74aa6e3930289a4b vcpkg-0_2_15-ec038215c0a44778];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libz-sys/1.1.21/download";
      sha256 = "df9b68e50e6e0b26f672573834882eb57759f6db9b3be2ea3c35c91188bb4eaa";
    };
    unpackPhase = ''
      tar xf $src
      cd libz-sys-1.1.21
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>:Josh Triplett <josh@joshtriplett.org>:Sebastian Thiel <sebastian.thiel@icloud.com>";
    CARGO_PKG_DESCRIPTION = "Low-level bindings to the system libz library (also known as zlib).";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libz-sys";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/libz-sys";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "1.1.21";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "21";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m libz-sys-1_1_21-script_build-4f374c1ca3820d67"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2018 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        --warn=unexpected_cfgs \
        --check-cfg 'cfg(zng)' \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="libc"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("asm", "cmake", "default", "libc", "static", "stock-zlib", "zlib-ng", "zlib-ng-no-cmake-experimental-community-maintained"))' \
        -C metadata=0bd3ba74fe79536f \
        -C extra-filename=-4f374c1ca3820d67 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern cc=${cc-1_2_16-aaebd3b60c7751f8}/libcc-aaebd3b60c7751f8.rlib \
        --extern pkg_config=${pkg-config-0_3_31-74aa6e3930289a4b}/libpkg_config-74aa6e3930289a4b.rlib \
        --extern vcpkg=${vcpkg-0_2_15-ec038215c0a44778}/libvcpkg-ec038215c0a44778.rlib \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-4f374c1ca3820d67 $OUT_DIR/build_script_build
      )
    '';
}
