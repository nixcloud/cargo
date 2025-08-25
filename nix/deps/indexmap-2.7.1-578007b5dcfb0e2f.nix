# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "indexmap-2_7_1-578007b5dcfb0e2f";
    meta.cargo_crate_info = {
      name = "indexmap";
      version = "2.7.1";
      crate_hash = "578007b5dcfb0e2f";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [equivalent-1_0_1-82253b26ca019f5d hashbrown-0_15_2-a75b560a12cfbbae];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/indexmap/2.7.1/download";
      sha256 = "8c9c992b02b5b4c94ea26e32fe5bccb7aa7d9f390ab5c1221ff895bc7ea8b652";
    };
    unpackPhase = ''
      tar xf $src
      cd indexmap-2.7.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "indexmap";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "A hash table with consistent order and fast iteration.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "indexmap";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/indexmap-rs/indexmap";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "2.7.1";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m indexmap-2_7_1-578007b5dcfb0e2f"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name indexmap \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        --allow=clippy::style \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("arbitrary", "borsh", "default", "quickcheck", "rayon", "rustc-rayon", "serde", "std", "test_debug"))' \
        -C metadata=78b55da4a4bf41ae \
        -C extra-filename=-578007b5dcfb0e2f \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern equivalent=${equivalent-1_0_1-82253b26ca019f5d}/libequivalent-82253b26ca019f5d.rmeta \
        --extern hashbrown=${hashbrown-0_15_2-a75b560a12cfbbae}/libhashbrown-a75b560a12cfbbae.rmeta \
        --cap-lints allow
      )
    '';
}
