# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "orion-0_17_8-cff1406525559add";
    meta.cargo_crate_info = {
      name = "orion";
      version = "0.17.8";
      crate_hash = "cff1406525559add";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [fiat-crypto-0_2_9-f33a0e6bd8ac2bb3 subtle-2_6_1-0482376bbaa3bb74 zeroize-1_8_1-aaf7cdda91519e7c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/orion/0.17.8/download";
      sha256 = "dd806049e71da4c4a7880466b37afdc5a4c5b35a398b0d4fd9ff5d278d3b4db9";
    };
    unpackPhase = ''
      tar xf $src
      cd orion-0.17.8
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "orion";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "brycx <brycx@protonmail.com>";
    CARGO_PKG_DESCRIPTION = "Usable, easy and safe pure-Rust crypto";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "orion";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/orion-rs/orion";
    CARGO_PKG_RUST_VERSION = "1.80";
    CARGO_PKG_VERSION = "0.17.8";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "17";
    CARGO_PKG_VERSION_PATCH = "8";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m orion-0_17_8-cff1406525559add"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name orion \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "ct-codecs", "default", "experimental", "getrandom", "safe_api", "serde"))' \
        -C metadata=60929113c28316d3 \
        -C extra-filename=-cff1406525559add \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern fiat_crypto=${fiat-crypto-0_2_9-f33a0e6bd8ac2bb3}/libfiat_crypto-f33a0e6bd8ac2bb3.rmeta \
        --extern subtle=${subtle-2_6_1-0482376bbaa3bb74}/libsubtle-0482376bbaa3bb74.rmeta \
        --extern zeroize=${zeroize-1_8_1-aaf7cdda91519e7c}/libzeroize-aaf7cdda91519e7c.rmeta \
        --cap-lints allow
      )
    '';
}
