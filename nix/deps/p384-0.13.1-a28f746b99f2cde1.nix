# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "p384-0_13_1-a28f746b99f2cde1";
    meta.cargo_crate_info = {
      name = "p384";
      version = "0.13.1";
      crate_hash = "a28f746b99f2cde1";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [ecdsa-0_16_9-6a53e7bfc4e3c2d6 elliptic-curve-0_13_8-e634328cfbf25fca primeorder-0_13_6-6879bd6d224334d7 sha2-0_10_8-b220b83b63166903];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/p384/0.13.1/download";
      sha256 = "fe42f1670a52a47d448f14b6a5c61dd78fce51856e68edaa38f7ae3a46b8d6b6";
    };
    unpackPhase = ''
      tar xf $src
      cd p384-0.13.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "p384";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers:Frank Denis <github@pureftpd.org>";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of the NIST P-384 (a.k.a. secp384r1) elliptic curve
as defined in SP 800-186 with support for ECDH, ECDSA signing/verification,
and general purpose curve arithmetic support.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "p384";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/elliptic-curves/tree/master/p384";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.13.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "13";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m p384-0_13_1-a28f746b99f2cde1"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name p384 \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="arithmetic"' \
        --cfg 'feature="default"' \
        --cfg 'feature="digest"' \
        --cfg 'feature="ecdh"' \
        --cfg 'feature="ecdsa"' \
        --cfg 'feature="ecdsa-core"' \
        --cfg 'feature="pem"' \
        --cfg 'feature="pkcs8"' \
        --cfg 'feature="sha2"' \
        --cfg 'feature="sha384"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "arithmetic", "bits", "default", "digest", "ecdh", "ecdsa", "ecdsa-core", "expose-field", "hash2curve", "hex-literal", "jwk", "pem", "pkcs8", "serde", "serdect", "sha2", "sha384", "std", "test-vectors", "voprf"))' \
        -C metadata=18b145a2d9cebe3e \
        -C extra-filename=-a28f746b99f2cde1 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern ecdsa_core=${ecdsa-0_16_9-6a53e7bfc4e3c2d6}/libecdsa-6a53e7bfc4e3c2d6.rmeta \
        --extern elliptic_curve=${elliptic-curve-0_13_8-e634328cfbf25fca}/libelliptic_curve-e634328cfbf25fca.rmeta \
        --extern primeorder=${primeorder-0_13_6-6879bd6d224334d7}/libprimeorder-6879bd6d224334d7.rmeta \
        --extern sha2=${sha2-0_10_8-b220b83b63166903}/libsha2-b220b83b63166903.rmeta \
        --cap-lints allow
      )
    '';
}
