# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_properties-1_5_1-18787856e82c3207";
    meta.cargo_crate_info = {
      name = "icu_properties";
      version = "1.5.1";
      crate_hash = "18787856e82c3207";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [displaydoc-0_2_5-671eefa7d702e219 icu_collections-1_5_0-45b2eb330c848c83 icu_locid_transform-1_5_0-1b92296cf93b8359 icu_properties_data-1_5_0-2325023fb5c18f26 icu_provider-1_5_0-ebf28be6eb9466db tinystr-0_7_6-c2c777090d19f167 zerovec-0_10_4-d0c2e8d8391d639e];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/icu_properties/1.5.1/download";
      sha256 = "93d6020766cfc6302c15dbbc9c8778c37e62c14427cb7f6e601d849e092aeef5";
    };
    unpackPhase = ''
      tar xf $src
      cd icu_properties-1.5.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "icu_properties";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "Definitions for Unicode properties";
    CARGO_PKG_HOMEPAGE = "https://icu4x.unicode.org";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "icu_properties";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/unicode-org/icu4x";
    CARGO_PKG_RUST_VERSION = "1.67";
    CARGO_PKG_VERSION = "1.5.1";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "5";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m icu_properties-1_5_1-18787856e82c3207"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name icu_properties \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="compiled_data"' \
        --cfg 'feature="default"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("bidi", "compiled_data", "datagen", "default", "serde", "std"))' \
        -C metadata=bcf466a1ef0ad2ea \
        -C extra-filename=-18787856e82c3207 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern displaydoc=${displaydoc-0_2_5-671eefa7d702e219}/libdisplaydoc-671eefa7d702e219.so \
        --extern icu_collections=${icu_collections-1_5_0-45b2eb330c848c83}/libicu_collections-45b2eb330c848c83.rmeta \
        --extern icu_locid_transform=${icu_locid_transform-1_5_0-1b92296cf93b8359}/libicu_locid_transform-1b92296cf93b8359.rmeta \
        --extern icu_properties_data=${icu_properties_data-1_5_0-2325023fb5c18f26}/libicu_properties_data-2325023fb5c18f26.rmeta \
        --extern icu_provider=${icu_provider-1_5_0-ebf28be6eb9466db}/libicu_provider-ebf28be6eb9466db.rmeta \
        --extern tinystr=${tinystr-0_7_6-c2c777090d19f167}/libtinystr-c2c777090d19f167.rmeta \
        --extern zerovec=${zerovec-0_10_4-d0c2e8d8391d639e}/libzerovec-d0c2e8d8391d639e.rmeta \
        --cap-lints allow
      )
    '';
}
