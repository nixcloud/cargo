# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "pest_generator-2_7_15-7374dcf24f8bb175";
    meta.cargo_crate_info = {
      name = "pest_generator";
      version = "2.7.15";
      crate_hash = "7374dcf24f8bb175";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [pest-2_7_15-5e8407991b8a5627 pest_meta-2_7_15-117bcedaa71aa492 proc-macro2-1_0_93-e285fc8594787700 quote-1_0_38-5b0706e2cc2f4ea8 syn-2_0_98-2ed9ce1dac2090c2];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/pest_generator/2.7.15/download";
      sha256 = "7d1396fd3a870fc7838768d171b4616d5c91f6cc25e377b673d714567d99377b";
    };
    unpackPhase = ''
      tar xf $src
      cd pest_generator-2.7.15
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "pest_generator";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Dragoș Tiselice <dragostiselice@gmail.com>";
    CARGO_PKG_DESCRIPTION = "pest code generator";
    CARGO_PKG_HOMEPAGE = "https://pest.rs/";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "pest_generator";
    CARGO_PKG_README = "_README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/pest-parser/pest";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "2.7.15";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "15";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m pest_generator-2_7_15-7374dcf24f8bb175"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name pest_generator \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "export-internal", "grammar-extras", "not-bootstrap-in-src", "std"))' \
        -C metadata=52c5431348dadcf5 \
        -C extra-filename=-7374dcf24f8bb175 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern pest=${pest-2_7_15-5e8407991b8a5627}/libpest-5e8407991b8a5627.rmeta \
        --extern pest_meta=${pest_meta-2_7_15-117bcedaa71aa492}/libpest_meta-117bcedaa71aa492.rmeta \
        --extern proc_macro2=${proc-macro2-1_0_93-e285fc8594787700}/libproc_macro2-e285fc8594787700.rmeta \
        --extern quote=${quote-1_0_38-5b0706e2cc2f4ea8}/libquote-5b0706e2cc2f4ea8.rmeta \
        --extern syn=${syn-2_0_98-2ed9ce1dac2090c2}/libsyn-2ed9ce1dac2090c2.rmeta \
        --cap-lints allow
      )
    '';
}
