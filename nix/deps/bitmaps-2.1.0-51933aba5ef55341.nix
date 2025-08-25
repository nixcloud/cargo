# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "bitmaps-2_1_0-51933aba5ef55341";
    meta.cargo_crate_info = {
      name = "bitmaps";
      version = "2.1.0";
      crate_hash = "51933aba5ef55341";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [typenum-1_17_0-218683b74ca28981];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/bitmaps/2.1.0/download";
      sha256 = "031043d04099746d8db04daf1fa424b2bc8bd69d92b25962dcde24da39ab64a2";
    };
    unpackPhase = ''
      tar xf $src
      cd bitmaps-2.1.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "bitmaps";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Bodil Stokke <bodil@bodil.org>";
    CARGO_PKG_DESCRIPTION = "Fixed size boolean arrays";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MPL-2.0+";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "bitmaps";
    CARGO_PKG_README = "./README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/bodil/bitmaps";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "2.1.0";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m bitmaps-2_1_0-51933aba5ef55341"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name bitmaps \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "std"))' \
        -C metadata=fd31e01de8d11891 \
        -C extra-filename=-51933aba5ef55341 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern typenum=${typenum-1_17_0-218683b74ca28981}/libtypenum-218683b74ca28981.rmeta \
        --cap-lints allow
      )
    '';
}
