# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "jiff-0_1_29-6073339ee3f5ed98";
    meta.cargo_crate_info = {
      name = "jiff";
      version = "0.1.29";
      crate_hash = "6073339ee3f5ed98";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/jiff/0.1.29/download";
      sha256 = "c04ef77ae73f3cf50510712722f0c4e8b46f5aaa1bf5ffad2ae213e6495e78e5";
    };
    unpackPhase = ''
      tar xf $src
      cd jiff-0.1.29
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "jiff";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A date-time library that encourages you to jump into the pit of success.

This library is heavily inspired by the Temporal project.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Unlicense OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "jiff";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/BurntSushi/jiff";
    CARGO_PKG_RUST_VERSION = "1.70";
    CARGO_PKG_VERSION = "0.1.29";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "29";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m jiff-0_1_29-6073339ee3f5ed98"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name jiff \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --cfg 'feature="tz-system"' \
        --cfg 'feature="tzdb-bundle-platform"' \
        --cfg 'feature="tzdb-concatenated"' \
        --cfg 'feature="tzdb-zoneinfo"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "default", "js", "logging", "serde", "std", "tz-system", "tzdb-bundle-always", "tzdb-bundle-platform", "tzdb-concatenated", "tzdb-zoneinfo"))' \
        -C metadata=2ac6475491faa650 \
        -C extra-filename=-6073339ee3f5ed98 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
