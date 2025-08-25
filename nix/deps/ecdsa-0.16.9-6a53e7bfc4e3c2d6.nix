# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "ecdsa-0_16_9-6a53e7bfc4e3c2d6";
    meta.cargo_crate_info = {
      name = "ecdsa";
      version = "0.16.9";
      crate_hash = "6a53e7bfc4e3c2d6";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [der-0_7_9-0b8f21d9d6fb9dc5 digest-0_10_7-fb3b4a12386762cc elliptic-curve-0_13_8-e634328cfbf25fca rfc6979-0_4_0-c107aca286cce8dc signature-2_2_0-910e7f986199d267 spki-0_7_3-3bcadc84ba337c41];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/ecdsa/0.16.9/download";
      sha256 = "ee27f32b5c5292967d2d4a9d7f1e0b0aed2c15daded5a60300e4abb9d8020bca";
    };
    unpackPhase = ''
      tar xf $src
      cd ecdsa-0.16.9
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "ecdsa";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of the Elliptic Curve Digital Signature Algorithm
(ECDSA) as specified in FIPS 186-4 (Digital Signature Standard), providing
RFC6979 deterministic signatures as well as support for added entropy
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "ecdsa";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/signatures/tree/master/ecdsa";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.16.9";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "16";
    CARGO_PKG_VERSION_PATCH = "9";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m ecdsa-0_16_9-6a53e7bfc4e3c2d6"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name ecdsa \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="arithmetic"' \
        --cfg 'feature="der"' \
        --cfg 'feature="digest"' \
        --cfg 'feature="hazmat"' \
        --cfg 'feature="pem"' \
        --cfg 'feature="pkcs8"' \
        --cfg 'feature="rfc6979"' \
        --cfg 'feature="signing"' \
        --cfg 'feature="spki"' \
        --cfg 'feature="std"' \
        --cfg 'feature="verifying"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "arithmetic", "default", "der", "dev", "digest", "hazmat", "pem", "pkcs8", "rfc6979", "serde", "serdect", "sha2", "signing", "spki", "std", "verifying"))' \
        -C metadata=a7b046867ea0fb00 \
        -C extra-filename=-6a53e7bfc4e3c2d6 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern der=${der-0_7_9-0b8f21d9d6fb9dc5}/libder-0b8f21d9d6fb9dc5.rmeta \
        --extern digest=${digest-0_10_7-fb3b4a12386762cc}/libdigest-fb3b4a12386762cc.rmeta \
        --extern elliptic_curve=${elliptic-curve-0_13_8-e634328cfbf25fca}/libelliptic_curve-e634328cfbf25fca.rmeta \
        --extern rfc6979=${rfc6979-0_4_0-c107aca286cce8dc}/librfc6979-c107aca286cce8dc.rmeta \
        --extern signature=${signature-2_2_0-910e7f986199d267}/libsignature-910e7f986199d267.rmeta \
        --extern spki=${spki-0_7_3-3bcadc84ba337c41}/libspki-3bcadc84ba337c41.rmeta \
        --cap-lints allow
      )
    '';
}
