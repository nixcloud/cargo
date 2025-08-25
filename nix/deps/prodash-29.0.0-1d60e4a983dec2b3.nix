# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "prodash-29_0_0-1d60e4a983dec2b3";
    meta.cargo_crate_info = {
      name = "prodash";
      version = "29.0.0";
      crate_hash = "1d60e4a983dec2b3";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [log-0_4_25-f053b1d34dfd0749 parking_lot-0_12_3-ff08a1b844db7fce];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/prodash/29.0.0/download";
      sha256 = "a266d8d6020c61a437be704c5e618037588e1985c7dbb7bf8d265db84cffe325";
    };
    unpackPhase = ''
      tar xf $src
      cd prodash-29.0.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "prodash";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Sebastian Thiel <sebastian.thiel@icloud.com>";
    CARGO_PKG_DESCRIPTION = "A dashboard for visualizing progress of asynchronous and possibly blocking tasks";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "prodash";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/Byron/prodash";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "29.0.0";
    CARGO_PKG_VERSION_MAJOR = "29";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m prodash-29_0_0-1d60e4a983dec2b3"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name prodash \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="log"' \
        --cfg 'feature="parking_lot"' \
        --cfg 'feature="progress-tree"' \
        --cfg 'feature="progress-tree-log"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("async-io", "bytesize", "crosstermion", "ctrlc", "dashmap", "default", "futures-core", "futures-lite", "human_format", "humantime", "is-terminal", "jiff", "local-time", "log", "parking_lot", "progress-log", "progress-tree", "progress-tree-hp-hashmap", "progress-tree-log", "render-line", "render-line-autoconfigure", "render-line-crossterm", "render-tui", "render-tui-crossterm", "signal-hook", "tui", "tui-react", "unicode-segmentation", "unicode-width", "unit-bytes", "unit-duration", "unit-human"))' \
        -C metadata=06a76f3eb06504ed \
        -C extra-filename=-1d60e4a983dec2b3 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern log=${log-0_4_25-f053b1d34dfd0749}/liblog-f053b1d34dfd0749.rmeta \
        --extern parking_lot=${parking_lot-0_12_3-ff08a1b844db7fce}/libparking_lot-ff08a1b844db7fce.rmeta \
        --cap-lints allow
      )
    '';
}
