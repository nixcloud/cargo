# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libnghttp2-sys-0_1_11_plus_1_64_0-script_build-f0b5a3b5b091ecfe";
    meta.cargo_crate_info = {
      name = "libnghttp2-sys";
      version = "0.1.11+1.64.0";
      crate_hash = "f0b5a3b5b091ecfe";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cc-1_2_16-aaebd3b60c7751f8];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libnghttp2-sys/0.1.11+1.64.0/download";
      sha256 = "1b6c24e48a7167cffa7119da39d577fa482e66c688a4aac016bee862e1a713c4";
    };
    unpackPhase = ''
      tar xf $src
      cd libnghttp2-sys-0.1.11+1.64.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "FFI bindings for libnghttp2 (nghttp2)
";
    CARGO_PKG_HOMEPAGE = "https://github.com/alexcrichton/nghttp2-rs";
    CARGO_PKG_LICENSE = "MIT/Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libnghttp2-sys";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/alexcrichton/nghttp2-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.1.11+1.64.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "11";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m libnghttp2-sys-0_1_11_plus_1_64_0-script_build-f0b5a3b5b091ecfe"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2015 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=7d43aa4cc7ace282 \
        -C extra-filename=-f0b5a3b5b091ecfe \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern cc=${cc-1_2_16-aaebd3b60c7751f8}/libcc-aaebd3b60c7751f8.rlib \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-f0b5a3b5b091ecfe $OUT_DIR/build_script_build
      )
    '';
}
