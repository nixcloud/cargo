# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "ppv-lite86-0_2_20-1a076b8c5baa06d5";
    meta.cargo_crate_info = {
      name = "ppv-lite86";
      version = "0.2.20";
      crate_hash = "1a076b8c5baa06d5";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [zerocopy-0_7_35-f56e8002ffdd7be6];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/ppv-lite86/0.2.20/download";
      sha256 = "77957b295656769bb8ad2b6a6b09d897d94f05c41b069aede1fcdaa675eaea04";
    };
    unpackPhase = ''
      tar xf $src
      cd ppv-lite86-0.2.20
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "ppv_lite86";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The CryptoCorrosion Contributors";
    CARGO_PKG_DESCRIPTION = "Implementation of the crypto-simd API for x86";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT/Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "ppv-lite86";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/cryptocorrosion/cryptocorrosion";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "0.2.20";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "20";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m ppv-lite86-0_2_20-1a076b8c5baa06d5"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name ppv_lite86 \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="simd"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "no_simd", "simd", "std"))' \
        -C metadata=2d1e939369a0e7c8 \
        -C extra-filename=-1a076b8c5baa06d5 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern zerocopy=${zerocopy-0_7_35-f56e8002ffdd7be6}/libzerocopy-f56e8002ffdd7be6.rmeta \
        --cap-lints allow
      )
    '';
}
