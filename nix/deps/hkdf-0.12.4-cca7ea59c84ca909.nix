# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "hkdf-0_12_4-cca7ea59c84ca909";
    meta.cargo_crate_info = {
      name = "hkdf";
      version = "0.12.4";
      crate_hash = "cca7ea59c84ca909";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [hmac-0_12_1-fd2e0dad2a9c7cc4];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/hkdf/0.12.4/download";
      sha256 = "7b5f8eb2ad728638ea2c7d47a21db23b7b58a72ed6a38256b8a1849f15fbbdf7";
    };
    unpackPhase = ''
      tar xf $src
      cd hkdf-0.12.4
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "hkdf";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "HMAC-based Extract-and-Expand Key Derivation Function (HKDF)";
    CARGO_PKG_HOMEPAGE = "https://github.com/RustCrypto/KDFs/";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "hkdf";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/KDFs/";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.12.4";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "12";
    CARGO_PKG_VERSION_PATCH = "4";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m hkdf-0_12_4-cca7ea59c84ca909"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name hkdf \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("std"))' \
        -C metadata=d7165a840087d420 \
        -C extra-filename=-cca7ea59c84ca909 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern hmac=${hmac-0_12_1-fd2e0dad2a9c7cc4}/libhmac-fd2e0dad2a9c7cc4.rmeta \
        --cap-lints allow
      )
    '';
}
