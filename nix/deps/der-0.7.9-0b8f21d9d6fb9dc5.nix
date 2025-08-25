# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "der-0_7_9-0b8f21d9d6fb9dc5";
    meta.cargo_crate_info = {
      name = "der";
      version = "0.7.9";
      crate_hash = "0b8f21d9d6fb9dc5";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [const-oid-0_9_6-ad9d3ce34581342d pem-rfc7468-0_7_0-ccd23df728e92ee8 zeroize-1_8_1-aaf7cdda91519e7c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/der/0.7.9/download";
      sha256 = "f55bf8e7b65898637379c1b74eb1551107c8294ed26d855ceb9fd1a09cfc9bc0";
    };
    unpackPhase = ''
      tar xf $src
      cd der-0.7.9
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "der";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust embedded-friendly implementation of the Distinguished Encoding Rules
(DER) for Abstract Syntax Notation One (ASN.1) as described in ITU X.690 with
full support for heapless no_std targets
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "der";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/formats/tree/master/der";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.7.9";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "9";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m der-0_7_9-0b8f21d9d6fb9dc5"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name der \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="oid"' \
        --cfg 'feature="pem"' \
        --cfg 'feature="std"' \
        --cfg 'feature="zeroize"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "arbitrary", "bytes", "derive", "flagset", "oid", "pem", "real", "std", "time", "zeroize"))' \
        -C metadata=3241e495a2f8c2f4 \
        -C extra-filename=-0b8f21d9d6fb9dc5 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern const_oid=${const-oid-0_9_6-ad9d3ce34581342d}/libconst_oid-ad9d3ce34581342d.rmeta \
        --extern pem_rfc7468=${pem-rfc7468-0_7_0-ccd23df728e92ee8}/libpem_rfc7468-ccd23df728e92ee8.rmeta \
        --extern zeroize=${zeroize-1_8_1-aaf7cdda91519e7c}/libzeroize-aaf7cdda91519e7c.rmeta \
        --cap-lints allow
      )
    '';
}
