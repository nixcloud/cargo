# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "sharded-slab-0_1_7-d6c2afa47dbbbf49";
    meta.cargo_crate_info = {
      name = "sharded-slab";
      version = "0.1.7";
      crate_hash = "d6c2afa47dbbbf49";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [lazy_static-1_5_0-82b154891a502d9d];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/sharded-slab/0.1.7/download";
      sha256 = "f40ca3c46823713e0d4209592e8d6e826aa57e928f09752619fc696c499637f6";
    };
    unpackPhase = ''
      tar xf $src
      cd sharded-slab-0.1.7
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "sharded_slab";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Eliza Weisman <eliza@buoyant.io>";
    CARGO_PKG_DESCRIPTION = "A lock-free concurrent slab.
";
    CARGO_PKG_HOMEPAGE = "https://github.com/hawkw/sharded-slab";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "sharded-slab";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/hawkw/sharded-slab";
    CARGO_PKG_RUST_VERSION = "1.42.0";
    CARGO_PKG_VERSION = "0.1.7";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "7";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m sharded-slab-0_1_7-d6c2afa47dbbbf49"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name sharded_slab \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("loom"))' \
        -C metadata=7a447c52fac121a3 \
        -C extra-filename=-d6c2afa47dbbbf49 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern lazy_static=${lazy_static-1_5_0-82b154891a502d9d}/liblazy_static-82b154891a502d9d.rmeta \
        --cap-lints allow
      )
    '';
}
