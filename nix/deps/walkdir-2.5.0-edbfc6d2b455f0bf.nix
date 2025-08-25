# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "walkdir-2_5_0-edbfc6d2b455f0bf";
    meta.cargo_crate_info = {
      name = "walkdir";
      version = "2.5.0";
      crate_hash = "edbfc6d2b455f0bf";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [same-file-1_0_6-fa3759c6ae4b4446];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/walkdir/2.5.0/download";
      sha256 = "29790946404f91d9c5d06f9874efddea1dc06c5efe94541a7d6863108e3a5e4b";
    };
    unpackPhase = ''
      tar xf $src
      cd walkdir-2.5.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "walkdir";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Recursively walk a directory.";
    CARGO_PKG_HOMEPAGE = "https://github.com/BurntSushi/walkdir";
    CARGO_PKG_LICENSE = "Unlicense/MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "walkdir";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/BurntSushi/walkdir";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "2.5.0";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "5";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m walkdir-2_5_0-edbfc6d2b455f0bf"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name walkdir \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=d03fcb5245787f7c \
        -C extra-filename=-edbfc6d2b455f0bf \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern same_file=${same-file-1_0_6-fa3759c6ae4b4446}/libsame_file-fa3759c6ae4b4446.rmeta \
        --cap-lints allow
      )
    '';
}
