# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "ordered-float-2_10_1-5b13fae397bcc890";
    meta.cargo_crate_info = {
      name = "ordered-float";
      version = "2.10.1";
      crate_hash = "5b13fae397bcc890";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [num-traits-0_2_19-5af143ababf6bec7];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/ordered-float/2.10.1/download";
      sha256 = "68f19d67e5a2795c94e73e0bb1cc1a7edeb2e28efd39e2e1c9b7a40c1108b11c";
    };
    unpackPhase = ''
      tar xf $src
      cd ordered-float-2.10.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "ordered_float";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Jonathan Reem <jonathan.reem@gmail.com>:Matt Brubeck <mbrubeck@limpet.net>";
    CARGO_PKG_DESCRIPTION = "Wrappers for total ordering on floats";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "ordered-float";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/reem/rust-ordered-float";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "2.10.1";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "10";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m ordered-float-2_10_1-5b13fae397bcc890"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name ordered_float \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("arbitrary", "default", "proptest", "rand", "randtest", "rkyv", "schemars", "serde", "std"))' \
        -C metadata=5bb6285585cc8a4f \
        -C extra-filename=-5b13fae397bcc890 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern num_traits=${num-traits-0_2_19-5af143ababf6bec7}/libnum_traits-5af143ababf6bec7.rmeta \
        --cap-lints allow
      )
    '';
}
