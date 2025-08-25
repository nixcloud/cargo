# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "kstring-2_0_2-1b0752db97618130";
    meta.cargo_crate_info = {
      name = "kstring";
      version = "2.0.2";
      crate_hash = "1b0752db97618130";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [static_assertions-1_1_0-9ad90952c22c4102];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/kstring/2.0.2/download";
      sha256 = "558bf9508a558512042d3095138b1f7b8fe90c5467d94f9f1da28b3731c5dbd1";
    };
    unpackPhase = ''
      tar xf $src
      cd kstring-2.0.2
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "kstring";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Ed Page <eopage@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Key String: optimized for map keys";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "kstring";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/cobalt-org/kstring";
    CARGO_PKG_RUST_VERSION = "1.73";
    CARGO_PKG_VERSION = "2.0.2";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "2";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m kstring-2_0_2-1b0752db97618130"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name kstring \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --cfg 'feature="unsafe"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("arc", "default", "document-features", "max_inline", "serde", "std", "unsafe", "unstable_bench_subset"))' \
        -C metadata=675e0a20f228c2cf \
        -C extra-filename=-1b0752db97618130 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern static_assertions=${static_assertions-1_1_0-9ad90952c22c4102}/libstatic_assertions-9ad90952c22c4102.rmeta \
        --cap-lints allow
      )
    '';
}
