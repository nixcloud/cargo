# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "rand_core-0_9_0-56c10e419464a859";
    meta.cargo_crate_info = {
      name = "rand_core";
      version = "0.9.0";
      crate_hash = "56c10e419464a859";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [getrandom-0_3_1-5e852dc8efdab777 zerocopy-0_8_17-fbe6072789cd833a];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/rand_core/0.9.0/download";
      sha256 = "b08f3c9802962f7e1b25113931d94f43ed9725bebc59db9d0c3e9a23b67e15ff";
    };
    unpackPhase = ''
      tar xf $src
      cd rand_core-0.9.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "rand_core";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Rand Project Developers:The Rust Project Developers";
    CARGO_PKG_DESCRIPTION = "Core random number generator traits and tools for implementation.
";
    CARGO_PKG_HOMEPAGE = "https://rust-random.github.io/book";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "rand_core";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-random/rand";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "0.9.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "9";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m rand_core-0_9_0-56c10e419464a859"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name rand_core \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="os_rng"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("os_rng", "serde", "std"))' \
        -C metadata=74b4ffe120e61346 \
        -C extra-filename=-56c10e419464a859 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern getrandom=${getrandom-0_3_1-5e852dc8efdab777}/libgetrandom-5e852dc8efdab777.rmeta \
        --extern zerocopy=${zerocopy-0_8_17-fbe6072789cd833a}/libzerocopy-fbe6072789cd833a.rmeta \
        --cap-lints allow
      )
    '';
}
