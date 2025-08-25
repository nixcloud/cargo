# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "hex-0_4_3-dd0d71cb863a3089";
    meta.cargo_crate_info = {
      name = "hex";
      version = "0.4.3";
      crate_hash = "dd0d71cb863a3089";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/hex/0.4.3/download";
      sha256 = "7f24254aa9a54b5c858eaee2f5bccdb46aaf0e486a595ed5fd8f86ba55232a70";
    };
    unpackPhase = ''
      tar xf $src
      cd hex-0.4.3
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "hex";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "KokaKiwi <kokakiwi@kokakiwi.net>";
    CARGO_PKG_DESCRIPTION = "Encoding and decoding data into/from hexadecimal representation.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "hex";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/KokaKiwi/rust-hex";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.4.3";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "3";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m hex-0_4_3-dd0d71cb863a3089"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name hex \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "default", "serde", "std"))' \
        -C metadata=c7b047d7405a5eaf \
        -C extra-filename=-dd0d71cb863a3089 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
