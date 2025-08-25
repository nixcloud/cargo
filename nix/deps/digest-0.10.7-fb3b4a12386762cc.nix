# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "digest-0_10_7-fb3b4a12386762cc";
    meta.cargo_crate_info = {
      name = "digest";
      version = "0.10.7";
      crate_hash = "fb3b4a12386762cc";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [block-buffer-0_10_4-56967ee641f931bb const-oid-0_9_6-ad9d3ce34581342d crypto-common-0_1_6-93b13849bbda486e subtle-2_6_1-0482376bbaa3bb74];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/digest/0.10.7/download";
      sha256 = "9ed9a281f7bc9b7576e61468ba615a66a5c8cfdff42420a70aa82701a3b1e292";
    };
    unpackPhase = ''
      tar xf $src
      cd digest-0.10.7
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "digest";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Traits for cryptographic hash functions and message authentication codes";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "digest";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/traits";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.10.7";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "10";
    CARGO_PKG_VERSION_PATCH = "7";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m digest-0_10_7-fb3b4a12386762cc"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name digest \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="block-buffer"' \
        --cfg 'feature="const-oid"' \
        --cfg 'feature="core-api"' \
        --cfg 'feature="default"' \
        --cfg 'feature="mac"' \
        --cfg 'feature="oid"' \
        --cfg 'feature="std"' \
        --cfg 'feature="subtle"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "blobby", "block-buffer", "const-oid", "core-api", "default", "dev", "mac", "oid", "rand_core", "std", "subtle"))' \
        -C metadata=8bbd8ac9c6fe7fcb \
        -C extra-filename=-fb3b4a12386762cc \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern block_buffer=${block-buffer-0_10_4-56967ee641f931bb}/libblock_buffer-56967ee641f931bb.rmeta \
        --extern const_oid=${const-oid-0_9_6-ad9d3ce34581342d}/libconst_oid-ad9d3ce34581342d.rmeta \
        --extern crypto_common=${crypto-common-0_1_6-93b13849bbda486e}/libcrypto_common-93b13849bbda486e.rmeta \
        --extern subtle=${subtle-2_6_1-0482376bbaa3bb74}/libsubtle-0482376bbaa3bb74.rmeta \
        --cap-lints allow
      )
    '';
}
