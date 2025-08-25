# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "unicode-normalization-0_1_24-44075d834d14633a";
    meta.cargo_crate_info = {
      name = "unicode-normalization";
      version = "0.1.24";
      crate_hash = "44075d834d14633a";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [tinyvec-1_8_1-baa23f723564fa79];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/unicode-normalization/0.1.24/download";
      sha256 = "5033c97c4262335cded6d6fc3e5c18ab755e1a3dc96376350f3d8e9f009ad956";
    };
    unpackPhase = ''
      tar xf $src
      cd unicode-normalization-0.1.24
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "unicode_normalization";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "kwantam <kwantam@gmail.com>:Manish Goregaokar <manishsmail@gmail.com>";
    CARGO_PKG_DESCRIPTION = "This crate provides functions for normalization of
Unicode strings, including Canonical and Compatible
Decomposition and Recomposition, as described in
Unicode Standard Annex #15.
";
    CARGO_PKG_HOMEPAGE = "https://github.com/unicode-rs/unicode-normalization";
    CARGO_PKG_LICENSE = "MIT/Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "unicode-normalization";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/unicode-rs/unicode-normalization";
    CARGO_PKG_RUST_VERSION = "1.36";
    CARGO_PKG_VERSION = "0.1.24";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "24";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m unicode-normalization-0_1_24-44075d834d14633a"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name unicode_normalization \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "std"))' \
        -C metadata=5d6fc8076a8f7048 \
        -C extra-filename=-44075d834d14633a \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern tinyvec=${tinyvec-1_8_1-baa23f723564fa79}/libtinyvec-baa23f723564fa79.rmeta \
        --cap-lints allow
      )
    '';
}
