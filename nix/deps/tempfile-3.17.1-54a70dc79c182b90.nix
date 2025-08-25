# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tempfile-3_17_1-54a70dc79c182b90";
    meta.cargo_crate_info = {
      name = "tempfile";
      version = "3.17.1";
      crate_hash = "54a70dc79c182b90";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cfg-if-1_0_0-f52ed1292e79c10c fastrand-2_3_0-f3010612e1a3785f getrandom-0_3_1-5e852dc8efdab777 once_cell-1_20_3-5c63a4de5995f261 rustix-0_38_44-c73c53514f7b96d9];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tempfile/3.17.1/download";
      sha256 = "22e5a0acb1f3f55f65cc4a866c361b2fb2a0ff6366785ae6fbb5f85df07ba230";
    };
    unpackPhase = ''
      tar xf $src
      cd tempfile-3.17.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "tempfile";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Steven Allen <steven@stebalien.com>:The Rust Project Developers:Ashley Mannix <ashleymannix@live.com.au>:Jason White <me@jasonwhite.io>";
    CARGO_PKG_DESCRIPTION = "A library for managing temporary files and directories.";
    CARGO_PKG_HOMEPAGE = "https://stebalien.com/projects/tempfile-rs/";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tempfile";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/Stebalien/tempfile";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "3.17.1";
    CARGO_PKG_VERSION_MAJOR = "3";
    CARGO_PKG_VERSION_MINOR = "17";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m tempfile-3_17_1-54a70dc79c182b90"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name tempfile \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="getrandom"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "getrandom", "nightly"))' \
        -C metadata=1d79185ef923b54d \
        -C extra-filename=-54a70dc79c182b90 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern cfg_if=${cfg-if-1_0_0-f52ed1292e79c10c}/libcfg_if-f52ed1292e79c10c.rmeta \
        --extern fastrand=${fastrand-2_3_0-f3010612e1a3785f}/libfastrand-f3010612e1a3785f.rmeta \
        --extern getrandom=${getrandom-0_3_1-5e852dc8efdab777}/libgetrandom-5e852dc8efdab777.rmeta \
        --extern once_cell=${once_cell-1_20_3-5c63a4de5995f261}/libonce_cell-5c63a4de5995f261.rmeta \
        --extern rustix=${rustix-0_38_44-c73c53514f7b96d9}/librustix-c73c53514f7b96d9.rmeta \
        --cap-lints allow
      )
    '';
}
