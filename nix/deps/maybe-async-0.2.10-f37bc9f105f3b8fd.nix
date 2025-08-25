# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "maybe-async-0_2_10-f37bc9f105f3b8fd";
    meta.cargo_crate_info = {
      name = "maybe-async";
      version = "0.2.10";
      crate_hash = "f37bc9f105f3b8fd";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [proc-macro2-1_0_93-e285fc8594787700 quote-1_0_38-5b0706e2cc2f4ea8 syn-2_0_98-2ed9ce1dac2090c2];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/maybe-async/0.2.10/download";
      sha256 = "5cf92c10c7e361d6b99666ec1c6f9805b0bea2c3bd8c78dc6fe98ac5bd78db11";
    };
    unpackPhase = ''
      tar xf $src
      cd maybe-async-0.2.10
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "maybe_async";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Guoli Lyu <guoli-lv@hotmail.com>";
    CARGO_PKG_DESCRIPTION = "A procedure macro to unify SYNC and ASYNC implementation";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "maybe-async";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/fMeow/maybe-async-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.2.10";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "10";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m maybe-async-0_2_10-f37bc9f105f3b8fd"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name maybe_async \
        --edition=2021 src/lib.rs \
        --crate-type proc-macro \
        --emit=dep-info,link \
        -C prefer-dynamic \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="is_sync"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "is_sync"))' \
        -C metadata=f5b53f278134dcdb \
        -C extra-filename=-f37bc9f105f3b8fd \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern proc_macro2=${proc-macro2-1_0_93-e285fc8594787700}/libproc_macro2-e285fc8594787700.rlib \
        --extern quote=${quote-1_0_38-5b0706e2cc2f4ea8}/libquote-5b0706e2cc2f4ea8.rlib \
        --extern syn=${syn-2_0_98-2ed9ce1dac2090c2}/libsyn-2ed9ce1dac2090c2.rlib \
        --extern proc_macro \
        --cap-lints allow
      )
    '';
}
