# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "rfc6979-0_4_0-c107aca286cce8dc";
    meta.cargo_crate_info = {
      name = "rfc6979";
      version = "0.4.0";
      crate_hash = "c107aca286cce8dc";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [hmac-0_12_1-fd2e0dad2a9c7cc4 subtle-2_6_1-0482376bbaa3bb74];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/rfc6979/0.4.0/download";
      sha256 = "f8dd2a808d456c4a54e300a23e9f5a67e122c3024119acbfd73e3bf664491cb2";
    };
    unpackPhase = ''
      tar xf $src
      cd rfc6979-0.4.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "rfc6979";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of RFC6979: Deterministic Usage of the
Digital Signature Algorithm (DSA) and Elliptic Curve Digital Signature Algorithm (ECDSA)
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "rfc6979";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/signatures/tree/master/rfc6979";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "0.4.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m rfc6979-0_4_0-c107aca286cce8dc"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name rfc6979 \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=48ff9d0f2c8bc634 \
        -C extra-filename=-c107aca286cce8dc \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern hmac=${hmac-0_12_1-fd2e0dad2a9c7cc4}/libhmac-fd2e0dad2a9c7cc4.rmeta \
        --extern subtle=${subtle-2_6_1-0482376bbaa3bb74}/libsubtle-0482376bbaa3bb74.rmeta \
        --cap-lints allow
      )
    '';
}
