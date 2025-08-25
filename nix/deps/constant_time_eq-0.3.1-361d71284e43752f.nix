# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "constant_time_eq-0_3_1-361d71284e43752f";
    meta.cargo_crate_info = {
      name = "constant_time_eq";
      version = "0.3.1";
      crate_hash = "361d71284e43752f";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/constant_time_eq/0.3.1/download";
      sha256 = "7c74b8349d32d297c9134b8c88677813a227df8f779daa29bfc29c183fe3dca6";
    };
    unpackPhase = ''
      tar xf $src
      cd constant_time_eq-0.3.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "constant_time_eq";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Cesar Eduardo Barros <cesarb@cesarb.eti.br>";
    CARGO_PKG_DESCRIPTION = "Compares two equal-sized byte strings in constant time.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "CC0-1.0 OR MIT-0 OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "constant_time_eq";
    CARGO_PKG_README = "README";
    CARGO_PKG_REPOSITORY = "https://github.com/cesarb/constant_time_eq";
    CARGO_PKG_RUST_VERSION = "1.66.0";
    CARGO_PKG_VERSION = "0.3.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m constant_time_eq-0_3_1-361d71284e43752f"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name constant_time_eq \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("count_instructions_test"))' \
        -C metadata=550460c7ea147dcb \
        -C extra-filename=-361d71284e43752f \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
