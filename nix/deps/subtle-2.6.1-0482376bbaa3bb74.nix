# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "subtle-2_6_1-0482376bbaa3bb74";
    meta.cargo_crate_info = {
      name = "subtle";
      version = "2.6.1";
      crate_hash = "0482376bbaa3bb74";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/subtle/2.6.1/download";
      sha256 = "13c2bddecc57b384dee18652358fb23172facb8a2c51ccc10d74c157bdea3292";
    };
    unpackPhase = ''
      tar xf $src
      cd subtle-2.6.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "subtle";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Isis Lovecruft <isis@patternsinthevoid.net>:Henry de Valence <hdevalence@hdevalence.ca>";
    CARGO_PKG_DESCRIPTION = "Pure-Rust traits and utilities for constant-time cryptographic implementations.";
    CARGO_PKG_HOMEPAGE = "https://dalek.rs/";
    CARGO_PKG_LICENSE = "BSD-3-Clause";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "subtle";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/dalek-cryptography/subtle";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "2.6.1";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "6";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m subtle-2_6_1-0482376bbaa3bb74"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name subtle \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="i128"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("const-generics", "core_hint_black_box", "default", "i128", "nightly", "std"))' \
        -C metadata=ecbd68b3bb77dce9 \
        -C extra-filename=-0482376bbaa3bb74 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
