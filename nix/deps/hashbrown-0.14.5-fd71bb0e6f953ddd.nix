# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "hashbrown-0_14_5-fd71bb0e6f953ddd";
    meta.cargo_crate_info = {
      name = "hashbrown";
      version = "0.14.5";
      crate_hash = "fd71bb0e6f953ddd";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [ahash-0_8_11-73d915e025327915 allocator-api2-0_2_21-824e74dd2449b33c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/hashbrown/0.14.5/download";
      sha256 = "e5274423e17b7c9fc20b6e7e208532f9b19825d82dfd615708b70edd83df41f1";
    };
    unpackPhase = ''
      tar xf $src
      cd hashbrown-0.14.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "hashbrown";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Amanieu d'Antras <amanieu@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A Rust port of Google's SwissTable hash map";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "hashbrown";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/hashbrown";
    CARGO_PKG_RUST_VERSION = "1.63.0";
    CARGO_PKG_VERSION = "0.14.5";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "14";
    CARGO_PKG_VERSION_PATCH = "5";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m hashbrown-0_14_5-fd71bb0e6f953ddd"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name hashbrown \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="ahash"' \
        --cfg 'feature="allocator-api2"' \
        --cfg 'feature="default"' \
        --cfg 'feature="inline-more"' \
        --cfg 'feature="raw"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("ahash", "alloc", "allocator-api2", "compiler_builtins", "core", "default", "equivalent", "inline-more", "nightly", "raw", "rayon", "rkyv", "rustc-dep-of-std", "rustc-internal-api", "serde"))' \
        -C metadata=ec880d9afdaf042a \
        -C extra-filename=-fd71bb0e6f953ddd \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern ahash=${ahash-0_8_11-73d915e025327915}/libahash-73d915e025327915.rmeta \
        --extern allocator_api2=${allocator-api2-0_2_21-824e74dd2449b33c}/liballocator_api2-824e74dd2449b33c.rmeta \
        --cap-lints allow
      )
    '';
}
