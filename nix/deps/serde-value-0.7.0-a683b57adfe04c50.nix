# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "serde-value-0_7_0-a683b57adfe04c50";
    meta.cargo_crate_info = {
      name = "serde-value";
      version = "0.7.0";
      crate_hash = "a683b57adfe04c50";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [ordered-float-2_10_1-5b13fae397bcc890 serde-1_0_218-c4e47f01a1cedfa0];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/serde-value/0.7.0/download";
      sha256 = "f3a1a3341211875ef120e117ea7fd5228530ae7e7036a779fdc9117be6b3282c";
    };
    unpackPhase = ''
      tar xf $src
      cd serde-value-0.7.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "serde_value";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "arcnmx";
    CARGO_PKG_DESCRIPTION = "Serialization value trees";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "serde-value";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/arcnmx/serde-value";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.7.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m serde-value-0_7_0-a683b57adfe04c50"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name serde_value \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=16f366abe2c5771c \
        -C extra-filename=-a683b57adfe04c50 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern ordered_float=${ordered-float-2_10_1-5b13fae397bcc890}/libordered_float-5b13fae397bcc890.rmeta \
        --extern serde=${serde-1_0_218-c4e47f01a1cedfa0}/libserde-c4e47f01a1cedfa0.rmeta \
        --cap-lints allow
      )
    '';
}
