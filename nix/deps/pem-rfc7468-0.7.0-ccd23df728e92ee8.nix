# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "pem-rfc7468-0_7_0-ccd23df728e92ee8";
    meta.cargo_crate_info = {
      name = "pem-rfc7468";
      version = "0.7.0";
      crate_hash = "ccd23df728e92ee8";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [base64ct-1_6_0-0f00ae0bae3259aa];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/pem-rfc7468/0.7.0/download";
      sha256 = "88b39c9bfcfc231068454382784bb460aae594343fb030d46e9f50a645418412";
    };
    unpackPhase = ''
      tar xf $src
      cd pem-rfc7468-0.7.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "pem_rfc7468";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "PEM Encoding (RFC 7468) for PKIX, PKCS, and CMS Structures, implementing a
strict subset of the original Privacy-Enhanced Mail encoding intended
specifically for use with cryptographic keys, certificates, and other messages.
Provides a no_std-friendly, constant-time implementation suitable for use with
cryptographic private keys.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "pem-rfc7468";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/formats/tree/master/pem-rfc7468";
    CARGO_PKG_RUST_VERSION = "1.60";
    CARGO_PKG_VERSION = "0.7.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m pem-rfc7468-0_7_0-ccd23df728e92ee8"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name pem_rfc7468 \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "std"))' \
        -C metadata=a38caea58be756f5 \
        -C extra-filename=-ccd23df728e92ee8 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern base64ct=${base64ct-1_6_0-0f00ae0bae3259aa}/libbase64ct-0f00ae0bae3259aa.rmeta \
        --cap-lints allow
      )
    '';
}
