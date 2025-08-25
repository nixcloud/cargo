# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "sized-chunks-0_6_5-046f699445e99791";
    meta.cargo_crate_info = {
      name = "sized-chunks";
      version = "0.6.5";
      crate_hash = "046f699445e99791";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [bitmaps-2_1_0-51933aba5ef55341 typenum-1_17_0-218683b74ca28981];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/sized-chunks/0.6.5/download";
      sha256 = "16d69225bde7a69b235da73377861095455d298f2b970996eec25ddbb42b3d1e";
    };
    unpackPhase = ''
      tar xf $src
      cd sized-chunks-0.6.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "sized_chunks";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Bodil Stokke <bodil@bodil.org>";
    CARGO_PKG_DESCRIPTION = "Efficient sized chunk datatypes";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MPL-2.0+";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "sized-chunks";
    CARGO_PKG_README = "./README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/bodil/sized-chunks";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.6.5";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "6";
    CARGO_PKG_VERSION_PATCH = "5";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m sized-chunks-0_6_5-046f699445e99791"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name sized_chunks \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("arbitrary", "array-ops", "default", "refpool", "ringbuffer", "std"))' \
        -C metadata=19c219031e8b6e00 \
        -C extra-filename=-046f699445e99791 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern bitmaps=${bitmaps-2_1_0-51933aba5ef55341}/libbitmaps-51933aba5ef55341.rmeta \
        --extern typenum=${typenum-1_17_0-218683b74ca28981}/libtypenum-218683b74ca28981.rmeta \
        --cap-lints allow
      )
    '';
}
