# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "adler2-2_0_0-eda9a489aa60b7f0";
    meta.cargo_crate_info = {
      name = "adler2";
      version = "2.0.0";
      crate_hash = "eda9a489aa60b7f0";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/adler2/2.0.0/download";
      sha256 = "512761e0bb2578dd7380c6baaa0f4ce03e84f95e960231d1dec8bf4d7d6e2627";
    };
    unpackPhase = ''
      tar xf $src
      cd adler2-2.0.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "adler2";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Jonas Schievink <jonasschievink@gmail.com>:oyvindln <oyvindln@users.noreply.github.com>";
    CARGO_PKG_DESCRIPTION = "A simple clean-room implementation of the Adler-32 checksum";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "0BSD OR MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "adler2";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/oyvindln/adler2";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "2.0.0";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m adler2-2_0_0-eda9a489aa60b7f0"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name adler2 \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("compiler_builtins", "core", "default", "rustc-dep-of-std", "std"))' \
        -C metadata=6fa7dc1f15e07951 \
        -C extra-filename=-eda9a489aa60b7f0 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
