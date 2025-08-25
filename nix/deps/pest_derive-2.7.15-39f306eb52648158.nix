# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "pest_derive-2_7_15-39f306eb52648158";
    meta.cargo_crate_info = {
      name = "pest_derive";
      version = "2.7.15";
      crate_hash = "39f306eb52648158";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [pest-2_7_15-5e8407991b8a5627 pest_generator-2_7_15-7374dcf24f8bb175];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/pest_derive/2.7.15/download";
      sha256 = "816518421cfc6887a0d62bf441b6ffb4536fcc926395a69e1a85852d4363f57e";
    };
    unpackPhase = ''
      tar xf $src
      cd pest_derive-2.7.15
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "pest_derive";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Dragoș Tiselice <dragostiselice@gmail.com>";
    CARGO_PKG_DESCRIPTION = "pest's derive macro";
    CARGO_PKG_HOMEPAGE = "https://pest.rs/";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "pest_derive";
    CARGO_PKG_README = "_README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/pest-parser/pest";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "2.7.15";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "15";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m pest_derive-2_7_15-39f306eb52648158"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name pest_derive \
        --edition=2021 src/lib.rs \
        --crate-type proc-macro \
        --emit=dep-info,link \
        -C prefer-dynamic \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "grammar-extras", "not-bootstrap-in-src", "std"))' \
        -C metadata=7284741bd6f0925a \
        -C extra-filename=-39f306eb52648158 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern pest=${pest-2_7_15-5e8407991b8a5627}/libpest-5e8407991b8a5627.rlib \
        --extern pest_generator=${pest_generator-2_7_15-7374dcf24f8bb175}/libpest_generator-7374dcf24f8bb175.rlib \
        --extern proc_macro \
        --cap-lints allow
      )
    '';
}
