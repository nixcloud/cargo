# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "utf8parse-0_2_2-ed0f948dddfa5152";
    meta.cargo_crate_info = {
      name = "utf8parse";
      version = "0.2.2";
      crate_hash = "ed0f948dddfa5152";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/utf8parse/0.2.2/download";
      sha256 = "06abde3611657adf66d383f00b093d7faecc7fa57071cce2578660c9f1010821";
    };
    unpackPhase = ''
      tar xf $src
      cd utf8parse-0.2.2
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "utf8parse";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Joe Wilm <joe@jwilm.com>:Christian Duerr <contact@christianduerr.com>";
    CARGO_PKG_DESCRIPTION = "Table-driven UTF-8 parser";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "utf8parse";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/alacritty/vte";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.2.2";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "2";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m utf8parse-0_2_2-ed0f948dddfa5152"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name utf8parse \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "nightly"))' \
        -C metadata=d05782b42b08091e \
        -C extra-filename=-ed0f948dddfa5152 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
