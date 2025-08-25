# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "elliptic-curve-0_13_8-e634328cfbf25fca";
    meta.cargo_crate_info = {
      name = "elliptic-curve";
      version = "0.13.8";
      crate_hash = "e634328cfbf25fca";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [base16ct-0_2_0-b54d8ed0612b165e crypto-bigint-0_5_5-7c029ff6ce945fef digest-0_10_7-fb3b4a12386762cc ff-0_13_0-d4779cf8cd3e0739 generic-array-0_14_7-a73c62568a2134d9 group-0_13_0-fffbf73b819b51c3 hkdf-0_12_4-cca7ea59c84ca909 pem-rfc7468-0_7_0-ccd23df728e92ee8 pkcs8-0_10_2-6d04f0295ea30205 rand_core-0_6_4-fe99bd26a150a053 sec1-0_7_3-57ab02f044e2482c subtle-2_6_1-0482376bbaa3bb74 zeroize-1_8_1-aaf7cdda91519e7c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/elliptic-curve/0.13.8/download";
      sha256 = "b5e6043086bf7973472e0c7dff2142ea0b680d30e18d9cc40f267efbf222bd47";
    };
    unpackPhase = ''
      tar xf $src
      cd elliptic-curve-0.13.8
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "elliptic_curve";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "General purpose Elliptic Curve Cryptography (ECC) support, including types
and traits for representing various elliptic curve forms, scalars, points,
and public/secret keys composed thereof.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "elliptic-curve";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/traits/tree/master/elliptic-curve";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.13.8";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "13";
    CARGO_PKG_VERSION_PATCH = "8";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m elliptic-curve-0_13_8-e634328cfbf25fca"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name elliptic_curve \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="arithmetic"' \
        --cfg 'feature="digest"' \
        --cfg 'feature="ecdh"' \
        --cfg 'feature="ff"' \
        --cfg 'feature="group"' \
        --cfg 'feature="hazmat"' \
        --cfg 'feature="pem"' \
        --cfg 'feature="pkcs8"' \
        --cfg 'feature="sec1"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "arithmetic", "bits", "default", "dev", "digest", "ecdh", "ff", "group", "hash2curve", "hazmat", "jwk", "pem", "pkcs8", "sec1", "serde", "std", "voprf"))' \
        -C metadata=53b29bd6d27a9b1f \
        -C extra-filename=-e634328cfbf25fca \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern base16ct=${base16ct-0_2_0-b54d8ed0612b165e}/libbase16ct-b54d8ed0612b165e.rmeta \
        --extern crypto_bigint=${crypto-bigint-0_5_5-7c029ff6ce945fef}/libcrypto_bigint-7c029ff6ce945fef.rmeta \
        --extern digest=${digest-0_10_7-fb3b4a12386762cc}/libdigest-fb3b4a12386762cc.rmeta \
        --extern ff=${ff-0_13_0-d4779cf8cd3e0739}/libff-d4779cf8cd3e0739.rmeta \
        --extern generic_array=${generic-array-0_14_7-a73c62568a2134d9}/libgeneric_array-a73c62568a2134d9.rmeta \
        --extern group=${group-0_13_0-fffbf73b819b51c3}/libgroup-fffbf73b819b51c3.rmeta \
        --extern hkdf=${hkdf-0_12_4-cca7ea59c84ca909}/libhkdf-cca7ea59c84ca909.rmeta \
        --extern pem_rfc7468=${pem-rfc7468-0_7_0-ccd23df728e92ee8}/libpem_rfc7468-ccd23df728e92ee8.rmeta \
        --extern pkcs8=${pkcs8-0_10_2-6d04f0295ea30205}/libpkcs8-6d04f0295ea30205.rmeta \
        --extern rand_core=${rand_core-0_6_4-fe99bd26a150a053}/librand_core-fe99bd26a150a053.rmeta \
        --extern sec1=${sec1-0_7_3-57ab02f044e2482c}/libsec1-57ab02f044e2482c.rmeta \
        --extern subtle=${subtle-2_6_1-0482376bbaa3bb74}/libsubtle-0482376bbaa3bb74.rmeta \
        --extern zeroize=${zeroize-1_8_1-aaf7cdda91519e7c}/libzeroize-aaf7cdda91519e7c.rmeta \
        --cap-lints allow
      )
    '';
}
