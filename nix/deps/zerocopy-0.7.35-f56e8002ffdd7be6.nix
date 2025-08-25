# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "zerocopy-0_7_35-f56e8002ffdd7be6";
    meta.cargo_crate_info = {
      name = "zerocopy";
      version = "0.7.35";
      crate_hash = "f56e8002ffdd7be6";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [byteorder-1_5_0-497f9896e2739e1d zerocopy-derive-0_7_35-ba4dbf194bcf684c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/zerocopy/0.7.35/download";
      sha256 = "1b9b4fd18abc82b8136838da5d50bae7bdea537c574d8dc1a34ed098d6c166f0";
    };
    unpackPhase = ''
      tar xf $src
      cd zerocopy-0.7.35
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "zerocopy";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Joshua Liebow-Feeser <joshlf@google.com>";
    CARGO_PKG_DESCRIPTION = "Utilities for zero-copy parsing and serialization";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "BSD-2-Clause OR Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "zerocopy";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/google/zerocopy";
    CARGO_PKG_RUST_VERSION = "1.60.0";
    CARGO_PKG_VERSION = "0.7.35";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "35";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m zerocopy-0_7_35-f56e8002ffdd7be6"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name zerocopy \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="byteorder"' \
        --cfg 'feature="default"' \
        --cfg 'feature="derive"' \
        --cfg 'feature="simd"' \
        --cfg 'feature="zerocopy-derive"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("__internal_use_only_features_that_work_on_stable", "alloc", "byteorder", "default", "derive", "simd", "simd-nightly", "zerocopy-derive"))' \
        -C metadata=70218c6b58a3429f \
        -C extra-filename=-f56e8002ffdd7be6 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern byteorder=${byteorder-1_5_0-497f9896e2739e1d}/libbyteorder-497f9896e2739e1d.rmeta \
        --extern zerocopy_derive=${zerocopy-derive-0_7_35-ba4dbf194bcf684c}/libzerocopy_derive-ba4dbf194bcf684c.so \
        --cap-lints allow
      )
    '';
}
