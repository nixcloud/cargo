# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "idna_adapter-1_2_0-7d17ccbf2ca41a29";
    meta.cargo_crate_info = {
      name = "idna_adapter";
      version = "1.2.0";
      crate_hash = "7d17ccbf2ca41a29";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [icu_normalizer-1_5_0-b758074d5ecda680 icu_properties-1_5_1-18787856e82c3207];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/idna_adapter/1.2.0/download";
      sha256 = "daca1df1c957320b2cf139ac61e7bd64fed304c5040df000a745aa1de3b4ef71";
    };
    unpackPhase = ''
      tar xf $src
      cd idna_adapter-1.2.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "idna_adapter";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The rust-url developers";
    CARGO_PKG_DESCRIPTION = "Back end adapter for idna";
    CARGO_PKG_HOMEPAGE = "https://docs.rs/crate/idna_adapter/latest";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "idna_adapter";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/hsivonen/idna_adapter";
    CARGO_PKG_RUST_VERSION = "1.67.0";
    CARGO_PKG_VERSION = "1.2.0";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m idna_adapter-1_2_0-7d17ccbf2ca41a29"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name idna_adapter \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="compiled_data"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("compiled_data"))' \
        -C metadata=25231fb09b516f95 \
        -C extra-filename=-7d17ccbf2ca41a29 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern icu_normalizer=${icu_normalizer-1_5_0-b758074d5ecda680}/libicu_normalizer-b758074d5ecda680.rmeta \
        --extern icu_properties=${icu_properties-1_5_1-18787856e82c3207}/libicu_properties-18787856e82c3207.rmeta \
        --cap-lints allow
      )
    '';
}
