# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libssh2-sys-0_3_1-script_build-71f3d8598b2fc2ae";
    meta.cargo_crate_info = {
      name = "libssh2-sys";
      version = "0.3.1";
      crate_hash = "71f3d8598b2fc2ae";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cc-1_2_16-aaebd3b60c7751f8 pkg-config-0_3_31-74aa6e3930289a4b];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libssh2-sys/0.3.1/download";
      sha256 = "220e4f05ad4a218192533b300327f5150e809b54c4ec83b5a1d91833601811b9";
    };
    unpackPhase = ''
      tar xf $src
      cd libssh2-sys-0.3.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>:Wez Furlong <wez@wezfurlong.org>:Matteo Bigoi <bigo@crisidev.org>";
    CARGO_PKG_DESCRIPTION = "Native bindings to the libssh2 library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libssh2-sys";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/alexcrichton/ssh2-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.3.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m libssh2-sys-0_3_1-script_build-71f3d8598b2fc2ae"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2015 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("openssl-on-win32", "openssl-sys", "vendored-openssl", "zlib-ng-compat"))' \
        -C metadata=57846aa0822dd8e4 \
        -C extra-filename=-71f3d8598b2fc2ae \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern cc=${cc-1_2_16-aaebd3b60c7751f8}/libcc-aaebd3b60c7751f8.rlib \
        --extern pkg_config=${pkg-config-0_3_31-74aa6e3930289a4b}/libpkg_config-74aa6e3930289a4b.rlib \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-71f3d8598b2fc2ae $OUT_DIR/build_script_build
      )
    '';
}
