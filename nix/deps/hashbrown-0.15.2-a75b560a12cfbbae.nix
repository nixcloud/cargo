# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "hashbrown-0_15_2-a75b560a12cfbbae";
    meta.cargo_crate_info = {
      name = "hashbrown";
      version = "0.15.2";
      crate_hash = "a75b560a12cfbbae";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [foldhash-0_1_4-96860c9f2ddf0951];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/hashbrown/0.15.2/download";
      sha256 = "bf151400ff0baff5465007dd2f3e717f3fe502074ca563069ce3a6629d07b289";
    };
    unpackPhase = ''
      tar xf $src
      cd hashbrown-0.15.2
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
    CARGO_PKG_RUST_VERSION = "1.65.0";
    CARGO_PKG_VERSION = "0.15.2";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "15";
    CARGO_PKG_VERSION_PATCH = "2";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m hashbrown-0_15_2-a75b560a12cfbbae"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name hashbrown \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default-hasher"' \
        --cfg 'feature="inline-more"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "allocator-api2", "compiler_builtins", "core", "default", "default-hasher", "equivalent", "inline-more", "nightly", "raw-entry", "rayon", "rustc-dep-of-std", "rustc-internal-api", "serde"))' \
        -C metadata=18367f2f10ce4ba5 \
        -C extra-filename=-a75b560a12cfbbae \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern foldhash=${foldhash-0_1_4-96860c9f2ddf0951}/libfoldhash-96860c9f2ddf0951.rmeta \
        --cap-lints allow
      )
    '';
}
