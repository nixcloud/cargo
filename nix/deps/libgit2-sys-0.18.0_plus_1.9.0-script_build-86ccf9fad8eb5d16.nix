# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libgit2-sys-0_18_0_plus_1_9_0-script_build-86ccf9fad8eb5d16";
    meta.cargo_crate_info = {
      name = "libgit2-sys";
      version = "0.18.0+1.9.0";
      crate_hash = "86ccf9fad8eb5d16";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cc-1_2_16-aaebd3b60c7751f8 pkg-config-0_3_31-74aa6e3930289a4b];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libgit2-sys/0.18.0+1.9.0/download";
      sha256 = "e1a117465e7e1597e8febea8bb0c410f1c7fb93b1e1cddf34363f8390367ffec";
    };
    unpackPhase = ''
      tar xf $src
      cd libgit2-sys-0.18.0+1.9.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Josh Triplett <josh@joshtriplett.org>:Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Native bindings to the libgit2 library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libgit2-sys";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/git2-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.18.0+1.9.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "18";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m libgit2-sys-0_18_0_plus_1_9_0-script_build-86ccf9fad8eb5d16"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2018 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="https"' \
        --cfg 'feature="libssh2-sys"' \
        --cfg 'feature="openssl-sys"' \
        --cfg 'feature="ssh"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("https", "libssh2-sys", "openssl-sys", "ssh", "vendored", "vendored-openssl", "zlib-ng-compat"))' \
        -C metadata=a4b6985bcee4e07e \
        -C extra-filename=-86ccf9fad8eb5d16 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern cc=${cc-1_2_16-aaebd3b60c7751f8}/libcc-aaebd3b60c7751f8.rlib \
        --extern pkg_config=${pkg-config-0_3_31-74aa6e3930289a4b}/libpkg_config-74aa6e3930289a4b.rlib \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-86ccf9fad8eb5d16 $OUT_DIR/build_script_build
      )
    '';
}
