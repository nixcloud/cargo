# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "crypto-bigint-0_5_5-7c029ff6ce945fef";
    meta.cargo_crate_info = {
      name = "crypto-bigint";
      version = "0.5.5";
      crate_hash = "7c029ff6ce945fef";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [generic-array-0_14_7-a73c62568a2134d9 rand_core-0_6_4-fe99bd26a150a053 subtle-2_6_1-0482376bbaa3bb74 zeroize-1_8_1-aaf7cdda91519e7c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/crypto-bigint/0.5.5/download";
      sha256 = "0dc92fb57ca44df6db8059111ab3af99a63d5d0f8375d9972e319a379c6bab76";
    };
    unpackPhase = ''
      tar xf $src
      cd crypto-bigint-0.5.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "crypto_bigint";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of a big integer library which has been designed from
the ground-up for use in cryptographic applications. Provides constant-time,
no_std-friendly implementations of modern formulas using const generics.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "crypto-bigint";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/crypto-bigint";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.5.5";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "5";
    CARGO_PKG_VERSION_PATCH = "5";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m crypto-bigint-0_5_5-7c029ff6ce945fef"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name crypto_bigint \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="generic-array"' \
        --cfg 'feature="rand_core"' \
        --cfg 'feature="zeroize"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "default", "der", "extra-sizes", "generic-array", "rand", "rand_core", "rlp", "serde", "zeroize"))' \
        -C metadata=d589dd69b042a773 \
        -C extra-filename=-7c029ff6ce945fef \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern generic_array=${generic-array-0_14_7-a73c62568a2134d9}/libgeneric_array-a73c62568a2134d9.rmeta \
        --extern rand_core=${rand_core-0_6_4-fe99bd26a150a053}/librand_core-fe99bd26a150a053.rmeta \
        --extern subtle=${subtle-2_6_1-0482376bbaa3bb74}/libsubtle-0482376bbaa3bb74.rmeta \
        --extern zeroize=${zeroize-1_8_1-aaf7cdda91519e7c}/libzeroize-aaf7cdda91519e7c.rmeta \
        --cap-lints allow
      )
    '';
}
