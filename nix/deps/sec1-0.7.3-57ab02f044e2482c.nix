# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "sec1-0_7_3-57ab02f044e2482c";
    meta.cargo_crate_info = {
      name = "sec1";
      version = "0.7.3";
      crate_hash = "57ab02f044e2482c";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [base16ct-0_2_0-b54d8ed0612b165e der-0_7_9-0b8f21d9d6fb9dc5 generic-array-0_14_7-a73c62568a2134d9 pkcs8-0_10_2-6d04f0295ea30205 subtle-2_6_1-0482376bbaa3bb74 zeroize-1_8_1-aaf7cdda91519e7c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/sec1/0.7.3/download";
      sha256 = "d3e97a565f76233a6003f9f5c54be1d9c5bdfa3eccfb189469f11ec4901c47dc";
    };
    unpackPhase = ''
      tar xf $src
      cd sec1-0.7.3
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "sec1";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of SEC1: Elliptic Curve Cryptography encoding formats
including ASN.1 DER-serialized private keys as well as the
Elliptic-Curve-Point-to-Octet-String encoding
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "sec1";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/formats/tree/master/sec1";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.7.3";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "3";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m sec1-0_7_3-57ab02f044e2482c"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name sec1 \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="default"' \
        --cfg 'feature="der"' \
        --cfg 'feature="pem"' \
        --cfg 'feature="pkcs8"' \
        --cfg 'feature="point"' \
        --cfg 'feature="std"' \
        --cfg 'feature="subtle"' \
        --cfg 'feature="zeroize"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "default", "der", "pem", "pkcs8", "point", "serde", "std", "subtle", "zeroize"))' \
        -C metadata=ca39890a101d5548 \
        -C extra-filename=-57ab02f044e2482c \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern base16ct=${base16ct-0_2_0-b54d8ed0612b165e}/libbase16ct-b54d8ed0612b165e.rmeta \
        --extern der=${der-0_7_9-0b8f21d9d6fb9dc5}/libder-0b8f21d9d6fb9dc5.rmeta \
        --extern generic_array=${generic-array-0_14_7-a73c62568a2134d9}/libgeneric_array-a73c62568a2134d9.rmeta \
        --extern pkcs8=${pkcs8-0_10_2-6d04f0295ea30205}/libpkcs8-6d04f0295ea30205.rmeta \
        --extern subtle=${subtle-2_6_1-0482376bbaa3bb74}/libsubtle-0482376bbaa3bb74.rmeta \
        --extern zeroize=${zeroize-1_8_1-aaf7cdda91519e7c}/libzeroize-aaf7cdda91519e7c.rmeta \
        --cap-lints allow
      )
    '';
}
