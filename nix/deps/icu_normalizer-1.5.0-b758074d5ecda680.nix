# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_normalizer-1_5_0-b758074d5ecda680";
    meta.cargo_crate_info = {
      name = "icu_normalizer";
      version = "1.5.0";
      crate_hash = "b758074d5ecda680";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [displaydoc-0_2_5-671eefa7d702e219 icu_collections-1_5_0-45b2eb330c848c83 icu_normalizer_data-1_5_0-5d1a678d344b291c icu_properties-1_5_1-18787856e82c3207 icu_provider-1_5_0-ebf28be6eb9466db smallvec-1_13_2-453c588ad74a5894 utf16_iter-1_0_5-c1d656f0774d7f77 utf8_iter-1_0_4-4dd926676127a369 write16-1_0_0-4a21213400bb3552 zerovec-0_10_4-d0c2e8d8391d639e];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/icu_normalizer/1.5.0/download";
      sha256 = "19ce3e0da2ec68599d193c93d088142efd7f9c5d6fc9b803774855747dc6a84f";
    };
    unpackPhase = ''
      tar xf $src
      cd icu_normalizer-1.5.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "icu_normalizer";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "API for normalizing text into Unicode Normalization Forms";
    CARGO_PKG_HOMEPAGE = "https://icu4x.unicode.org";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "icu_normalizer";
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

      echo -e "\e[92mCompiling\e[0m icu_normalizer-1_5_0-b758074d5ecda680"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name icu_normalizer \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="compiled_data"' \
        --cfg 'feature="default"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("compiled_data", "datagen", "default", "experimental", "serde", "std"))' \
        -C metadata=3dce72298ba2e54f \
        -C extra-filename=-b758074d5ecda680 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern displaydoc=${displaydoc-0_2_5-671eefa7d702e219}/libdisplaydoc-671eefa7d702e219.so \
        --extern icu_collections=${icu_collections-1_5_0-45b2eb330c848c83}/libicu_collections-45b2eb330c848c83.rmeta \
        --extern icu_normalizer_data=${icu_normalizer_data-1_5_0-5d1a678d344b291c}/libicu_normalizer_data-5d1a678d344b291c.rmeta \
        --extern icu_properties=${icu_properties-1_5_1-18787856e82c3207}/libicu_properties-18787856e82c3207.rmeta \
        --extern icu_provider=${icu_provider-1_5_0-ebf28be6eb9466db}/libicu_provider-ebf28be6eb9466db.rmeta \
        --extern smallvec=${smallvec-1_13_2-453c588ad74a5894}/libsmallvec-453c588ad74a5894.rmeta \
        --extern utf16_iter=${utf16_iter-1_0_5-c1d656f0774d7f77}/libutf16_iter-c1d656f0774d7f77.rmeta \
        --extern utf8_iter=${utf8_iter-1_0_4-4dd926676127a369}/libutf8_iter-4dd926676127a369.rmeta \
        --extern write16=${write16-1_0_0-4a21213400bb3552}/libwrite16-4a21213400bb3552.rmeta \
        --extern zerovec=${zerovec-0_10_4-d0c2e8d8391d639e}/libzerovec-d0c2e8d8391d639e.rmeta \
        --cap-lints allow
      )
    '';
}
