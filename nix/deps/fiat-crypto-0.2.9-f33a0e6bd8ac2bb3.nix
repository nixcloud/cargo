# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "fiat-crypto-0_2_9-f33a0e6bd8ac2bb3";
    meta.cargo_crate_info = {
      name = "fiat-crypto";
      version = "0.2.9";
      crate_hash = "f33a0e6bd8ac2bb3";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/fiat-crypto/0.2.9/download";
      sha256 = "28dea519a9695b9977216879a3ebfddf92f1c08c05d984f8996aecd6ecdc811d";
    };
    unpackPhase = ''
      tar xf $src
      cd fiat-crypto-0.2.9
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "fiat_crypto";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Fiat Crypto library authors <jgross@mit.edu>";
    CARGO_PKG_DESCRIPTION = "Fiat-crypto generated Rust";
    CARGO_PKG_HOMEPAGE = "https://github.com/mit-plv/fiat-crypto";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0 OR BSD-1-Clause";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "fiat-crypto";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/mit-plv/fiat-crypto";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.2.9";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "9";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m fiat-crypto-0_2_9-f33a0e6bd8ac2bb3"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name fiat_crypto \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "std"))' \
        -C metadata=88e26e7ffd16af3f \
        -C extra-filename=-f33a0e6bd8ac2bb3 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
