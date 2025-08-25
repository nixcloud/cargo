# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_locid_transform-1_5_0-1b92296cf93b8359";
    meta.cargo_crate_info = {
      name = "icu_locid_transform";
      version = "1.5.0";
      crate_hash = "1b92296cf93b8359";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [displaydoc-0_2_5-671eefa7d702e219 icu_locid-1_5_0-a7d9c7c935ce06a1 icu_locid_transform_data-1_5_0-8ad0c4a60b07d45b icu_provider-1_5_0-ebf28be6eb9466db tinystr-0_7_6-c2c777090d19f167 zerovec-0_10_4-d0c2e8d8391d639e];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/icu_locid_transform/1.5.0/download";
      sha256 = "01d11ac35de8e40fdeda00d9e1e9d92525f3f9d887cdd7aa81d727596788b54e";
    };
    unpackPhase = ''
      tar xf $src
      cd icu_locid_transform-1.5.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "icu_locid_transform";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "API for Unicode Language and Locale Identifiers canonicalization";
    CARGO_PKG_HOMEPAGE = "https://icu4x.unicode.org";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "icu_locid_transform";
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

      echo -e "\e[92mCompiling\e[0m icu_locid_transform-1_5_0-1b92296cf93b8359"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name icu_locid_transform \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="compiled_data"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("bench", "compiled_data", "datagen", "default", "serde", "std"))' \
        -C metadata=b5da088d351ca4e2 \
        -C extra-filename=-1b92296cf93b8359 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern displaydoc=${displaydoc-0_2_5-671eefa7d702e219}/libdisplaydoc-671eefa7d702e219.so \
        --extern icu_locid=${icu_locid-1_5_0-a7d9c7c935ce06a1}/libicu_locid-a7d9c7c935ce06a1.rmeta \
        --extern icu_locid_transform_data=${icu_locid_transform_data-1_5_0-8ad0c4a60b07d45b}/libicu_locid_transform_data-8ad0c4a60b07d45b.rmeta \
        --extern icu_provider=${icu_provider-1_5_0-ebf28be6eb9466db}/libicu_provider-ebf28be6eb9466db.rmeta \
        --extern tinystr=${tinystr-0_7_6-c2c777090d19f167}/libtinystr-c2c777090d19f167.rmeta \
        --extern zerovec=${zerovec-0_10_4-d0c2e8d8391d639e}/libzerovec-d0c2e8d8391d639e.rmeta \
        --cap-lints allow
      )
    '';
}
