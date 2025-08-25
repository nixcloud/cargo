# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "zerovec-0_10_4-d0c2e8d8391d639e";
    meta.cargo_crate_info = {
      name = "zerovec";
      version = "0.10.4";
      crate_hash = "d0c2e8d8391d639e";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [yoke-0_7_5-0ce4dd6b1a767ef5 zerofrom-0_1_5-3373e8a7a0cdd76c zerovec-derive-0_10_3-7a2b2556e53e6ecd];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/zerovec/0.10.4/download";
      sha256 = "aa2b893d79df23bfb12d5461018d408ea19dfafe76c2c7ef6d4eba614f8ff079";
    };
    unpackPhase = ''
      tar xf $src
      cd zerovec-0.10.4
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "zerovec";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "Zero-copy vector backed by a byte array";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "zerovec";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/unicode-org/icu4x";
    CARGO_PKG_RUST_VERSION = "1.67";
    CARGO_PKG_VERSION = "0.10.4";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "10";
    CARGO_PKG_VERSION_PATCH = "4";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m zerovec-0_10_4-d0c2e8d8391d639e"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name zerovec \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="derive"' \
        --cfg 'feature="yoke"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("bench", "databake", "derive", "hashmap", "serde", "std", "yoke"))' \
        -C metadata=2e2c428ff64e95eb \
        -C extra-filename=-d0c2e8d8391d639e \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern yoke=${yoke-0_7_5-0ce4dd6b1a767ef5}/libyoke-0ce4dd6b1a767ef5.rmeta \
        --extern zerofrom=${zerofrom-0_1_5-3373e8a7a0cdd76c}/libzerofrom-3373e8a7a0cdd76c.rmeta \
        --extern zerovec_derive=${zerovec-derive-0_10_3-7a2b2556e53e6ecd}/libzerovec_derive-7a2b2556e53e6ecd.so \
        --cap-lints allow
      )
    '';
}
