# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "primeorder-0_13_6-6879bd6d224334d7";
    meta.cargo_crate_info = {
      name = "primeorder";
      version = "0.13.6";
      crate_hash = "6879bd6d224334d7";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [elliptic-curve-0_13_8-e634328cfbf25fca];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/primeorder/0.13.6/download";
      sha256 = "353e1ca18966c16d9deb1c69278edbc5f194139612772bd9537af60ac231e1e6";
    };
    unpackPhase = ''
      tar xf $src
      cd primeorder-0.13.6
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "primeorder";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of complete addition formulas for prime order elliptic
curves (Renes-Costello-Batina 2015). Generic over field elements and curve
equation coefficients
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "primeorder";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/elliptic-curves/tree/master/primeorder";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.13.6";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "13";
    CARGO_PKG_VERSION_PATCH = "6";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m primeorder-0_13_6-6879bd6d224334d7"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name primeorder \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "dev", "serde", "serdect", "std"))' \
        -C metadata=0f949205cc00ff76 \
        -C extra-filename=-6879bd6d224334d7 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern elliptic_curve=${elliptic-curve-0_13_8-e634328cfbf25fca}/libelliptic_curve-e634328cfbf25fca.rmeta \
        --cap-lints allow
      )
    '';
}
