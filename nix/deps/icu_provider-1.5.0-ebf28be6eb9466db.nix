# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_provider-1_5_0-ebf28be6eb9466db";
    meta.cargo_crate_info = {
      name = "icu_provider";
      version = "1.5.0";
      crate_hash = "ebf28be6eb9466db";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [displaydoc-0_2_5-671eefa7d702e219 icu_locid-1_5_0-a7d9c7c935ce06a1 icu_provider_macros-1_5_0-2b2544cc7c5e1efe stable_deref_trait-1_2_0-567eccf8a716e5cb tinystr-0_7_6-c2c777090d19f167 writeable-0_5_5-db6a66dd17f3debd yoke-0_7_5-0ce4dd6b1a767ef5 zerofrom-0_1_5-3373e8a7a0cdd76c zerovec-0_10_4-d0c2e8d8391d639e];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/icu_provider/1.5.0/download";
      sha256 = "6ed421c8a8ef78d3e2dbc98a973be2f3770cb42b606e3ab18d6237c4dfde68d9";
    };
    unpackPhase = ''
      tar xf $src
      cd icu_provider-1.5.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "icu_provider";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "Trait and struct definitions for the ICU data provider";
    CARGO_PKG_HOMEPAGE = "https://icu4x.unicode.org";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "icu_provider";
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

      echo -e "\e[92mCompiling\e[0m icu_provider-1_5_0-ebf28be6eb9466db"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name icu_provider \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="macros"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("bench", "datagen", "deserialize_bincode_1", "deserialize_json", "deserialize_postcard_1", "experimental", "log_error_context", "logging", "macros", "serde", "std", "sync"))' \
        -C metadata=6dc0b21783fbc1a1 \
        -C extra-filename=-ebf28be6eb9466db \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern displaydoc=${displaydoc-0_2_5-671eefa7d702e219}/libdisplaydoc-671eefa7d702e219.so \
        --extern icu_locid=${icu_locid-1_5_0-a7d9c7c935ce06a1}/libicu_locid-a7d9c7c935ce06a1.rmeta \
        --extern icu_provider_macros=${icu_provider_macros-1_5_0-2b2544cc7c5e1efe}/libicu_provider_macros-2b2544cc7c5e1efe.so \
        --extern stable_deref_trait=${stable_deref_trait-1_2_0-567eccf8a716e5cb}/libstable_deref_trait-567eccf8a716e5cb.rmeta \
        --extern tinystr=${tinystr-0_7_6-c2c777090d19f167}/libtinystr-c2c777090d19f167.rmeta \
        --extern writeable=${writeable-0_5_5-db6a66dd17f3debd}/libwriteable-db6a66dd17f3debd.rmeta \
        --extern yoke=${yoke-0_7_5-0ce4dd6b1a767ef5}/libyoke-0ce4dd6b1a767ef5.rmeta \
        --extern zerofrom=${zerofrom-0_1_5-3373e8a7a0cdd76c}/libzerofrom-3373e8a7a0cdd76c.rmeta \
        --extern zerovec=${zerovec-0_10_4-d0c2e8d8391d639e}/libzerovec-d0c2e8d8391d639e.rmeta \
        --cap-lints allow
      )
    '';
}
