# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "getrandom-0_3_1-script_build-98277d42d436743f";
    meta.cargo_crate_info = {
      name = "getrandom";
      version = "0.3.1";
      crate_hash = "98277d42d436743f";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/getrandom/0.3.1/download";
      sha256 = "43a49c392881ce6d5c3b8cb70f98717b7c07aabbdff06687b9030dbfbe2725f8";
    };
    unpackPhase = ''
      tar xf $src
      cd getrandom-0.3.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Rand Project Developers";
    CARGO_PKG_DESCRIPTION = "A small cross-platform library for retrieving random data from system source";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "getrandom";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-random/getrandom";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "0.3.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m getrandom-0_3_1-script_build-98277d42d436743f"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2021 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        --warn=unexpected_cfgs \
        --check-cfg 'cfg(getrandom_backend, values("custom", "rdrand", "rndr", "linux_getrandom", "wasm_js"))' \
        --check-cfg 'cfg(getrandom_msan)' \
        --check-cfg 'cfg(getrandom_test_linux_fallback)' \
        --check-cfg 'cfg(getrandom_test_netbsd_fallback)' \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="std"' \
        --cfg 'feature="wasm_js"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("rustc-dep-of-std", "std", "wasm_js"))' \
        -C metadata=16482db76576c267 \
        -C extra-filename=-98277d42d436743f \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-98277d42d436743f $OUT_DIR/build_script_build
      )
    '';
}
