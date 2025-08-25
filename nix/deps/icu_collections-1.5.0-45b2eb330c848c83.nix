# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_collections-1_5_0-45b2eb330c848c83";
    meta.cargo_crate_info = {
      name = "icu_collections";
      version = "1.5.0";
      crate_hash = "45b2eb330c848c83";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [displaydoc-0_2_5-671eefa7d702e219 yoke-0_7_5-0ce4dd6b1a767ef5 zerofrom-0_1_5-3373e8a7a0cdd76c zerovec-0_10_4-d0c2e8d8391d639e];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/icu_collections/1.5.0/download";
      sha256 = "db2fa452206ebee18c4b5c2274dbf1de17008e874b4dc4f0aea9d01ca79e4526";
    };
    unpackPhase = ''
      tar xf $src
      cd icu_collections-1.5.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "icu_collections";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "Collection of API for use in ICU libraries.";
    CARGO_PKG_HOMEPAGE = "https://icu4x.unicode.org";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "icu_collections";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/unicode-org/icu4x";
    CARGO_PKG_RUST_VERSION = "1.67";
    CARGO_PKG_VERSION = "1.5.0";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "5";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m icu_collections-1_5_0-45b2eb330c848c83"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name icu_collections \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("bench", "databake", "serde", "std"))' \
        -C metadata=1aabebfaf7659994 \
        -C extra-filename=-45b2eb330c848c83 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern displaydoc=${displaydoc-0_2_5-671eefa7d702e219}/libdisplaydoc-671eefa7d702e219.so \
        --extern yoke=${yoke-0_7_5-0ce4dd6b1a767ef5}/libyoke-0ce4dd6b1a767ef5.rmeta \
        --extern zerofrom=${zerofrom-0_1_5-3373e8a7a0cdd76c}/libzerofrom-3373e8a7a0cdd76c.rmeta \
        --extern zerovec=${zerovec-0_10_4-d0c2e8d8391d639e}/libzerovec-d0c2e8d8391d639e.rmeta \
        --cap-lints allow
      )
    '';
}
