# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "crossbeam-deque-0_8_6-96a47349b63fbb1b";
    meta.cargo_crate_info = {
      name = "crossbeam-deque";
      version = "0.8.6";
      crate_hash = "96a47349b63fbb1b";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [crossbeam-epoch-0_9_18-1bd2af8d2ede3798 crossbeam-utils-0_8_21-c923d35455982b42];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/crossbeam-deque/0.8.6/download";
      sha256 = "9dd111b7b7f7d55b72c0a6ae361660ee5853c9af73f70c3c2ef6858b950e2e51";
    };
    unpackPhase = ''
      tar xf $src
      cd crossbeam-deque-0.8.6
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "crossbeam_deque";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Concurrent work-stealing deque";
    CARGO_PKG_HOMEPAGE = "https://github.com/crossbeam-rs/crossbeam/tree/master/crossbeam-deque";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "crossbeam-deque";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/crossbeam-rs/crossbeam";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "0.8.6";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "6";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m crossbeam-deque-0_8_6-96a47349b63fbb1b"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name crossbeam_deque \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        --warn=unexpected_cfgs \
        --allow=clippy::lint_groups_priority \
        --allow=clippy::declare_interior_mutable_const \
        --check-cfg 'cfg(crossbeam_loom)' \
        --check-cfg 'cfg(crossbeam_sanitize)' \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "std"))' \
        -C metadata=40b85964de2bf243 \
        -C extra-filename=-96a47349b63fbb1b \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern crossbeam_epoch=${crossbeam-epoch-0_9_18-1bd2af8d2ede3798}/libcrossbeam_epoch-1bd2af8d2ede3798.rmeta \
        --extern crossbeam_utils=${crossbeam-utils-0_8_21-c923d35455982b42}/libcrossbeam_utils-c923d35455982b42.rmeta \
        --cap-lints allow
      )
    '';
}
