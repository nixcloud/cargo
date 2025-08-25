# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "handlebars-6_3_1-5c73ade78aa41eb5";
    meta.cargo_crate_info = {
      name = "handlebars";
      version = "6.3.1";
      crate_hash = "5c73ade78aa41eb5";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [derive_builder-0_20_2-a0b63957c70092d3 log-0_4_25-f053b1d34dfd0749 num-order-1_2_0-ac9840262d82f2c3 pest-2_7_15-5e8407991b8a5627 pest_derive-2_7_15-39f306eb52648158 serde-1_0_218-c4e47f01a1cedfa0 serde_json-1_0_139-578ab230a253fef1 thiserror-2_0_11-266d93aab4cee78a walkdir-2_5_0-edbfc6d2b455f0bf];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/handlebars/6.3.1/download";
      sha256 = "d752747ddabc4c1a70dd28e72f2e3c218a816773e0d7faf67433f1acfa6cba7c";
    };
    unpackPhase = ''
      tar xf $src
      cd handlebars-6.3.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "handlebars";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Ning Sun <sunng@pm.me>";
    CARGO_PKG_DESCRIPTION = "Handlebars templating implemented in Rust.";
    CARGO_PKG_HOMEPAGE = "https://github.com/sunng87/handlebars-rust";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "handlebars";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/sunng87/handlebars-rust";
    CARGO_PKG_RUST_VERSION = "1.73";
    CARGO_PKG_VERSION = "6.3.1";
    CARGO_PKG_VERSION_MAJOR = "6";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m handlebars-6_3_1-5c73ade78aa41eb5"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name handlebars \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="dir_source"' \
        --cfg 'feature="walkdir"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "dir_source", "heck", "no_logging", "rhai", "rust-embed", "script_helper", "string_helpers", "walkdir"))' \
        -C metadata=354bbc641e9e31e4 \
        -C extra-filename=-5c73ade78aa41eb5 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern derive_builder=${derive_builder-0_20_2-a0b63957c70092d3}/libderive_builder-a0b63957c70092d3.rmeta \
        --extern log=${log-0_4_25-f053b1d34dfd0749}/liblog-f053b1d34dfd0749.rmeta \
        --extern num_order=${num-order-1_2_0-ac9840262d82f2c3}/libnum_order-ac9840262d82f2c3.rmeta \
        --extern pest=${pest-2_7_15-5e8407991b8a5627}/libpest-5e8407991b8a5627.rmeta \
        --extern pest_derive=${pest_derive-2_7_15-39f306eb52648158}/libpest_derive-39f306eb52648158.so \
        --extern serde=${serde-1_0_218-c4e47f01a1cedfa0}/libserde-c4e47f01a1cedfa0.rmeta \
        --extern serde_json=${serde_json-1_0_139-578ab230a253fef1}/libserde_json-578ab230a253fef1.rmeta \
        --extern thiserror=${thiserror-2_0_11-266d93aab4cee78a}/libthiserror-266d93aab4cee78a.rmeta \
        --extern walkdir=${walkdir-2_5_0-edbfc6d2b455f0bf}/libwalkdir-edbfc6d2b455f0bf.rmeta \
        --cap-lints allow
      )
    '';
}
