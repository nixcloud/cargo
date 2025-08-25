# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "nom-7_1_3-7d8dc522cfd9fb29";
    meta.cargo_crate_info = {
      name = "nom";
      version = "7.1.3";
      crate_hash = "7d8dc522cfd9fb29";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [memchr-2_7_4-df7138072aead54d minimal-lexical-0_2_1-af041fc8ed3e4293];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/nom/7.1.3/download";
      sha256 = "d273983c5a657a70a3e8f2a01329822f3b8c8172b73826411a55751e404a0a4a";
    };
    unpackPhase = ''
      tar xf $src
      cd nom-7.1.3
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "nom";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "contact@geoffroycouprie.com";
    CARGO_PKG_DESCRIPTION = "A byte-oriented, zero-copy, parser combinators library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "nom";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/Geal/nom";
    CARGO_PKG_RUST_VERSION = "1.48";
    CARGO_PKG_VERSION = "7.1.3";
    CARGO_PKG_VERSION_MAJOR = "7";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "3";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m nom-7_1_3-7d8dc522cfd9fb29"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name nom \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "default", "docsrs", "std"))' \
        -C metadata=ab421c6536806b3c \
        -C extra-filename=-7d8dc522cfd9fb29 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern memchr=${memchr-2_7_4-df7138072aead54d}/libmemchr-df7138072aead54d.rmeta \
        --extern minimal_lexical=${minimal-lexical-0_2_1-af041fc8ed3e4293}/libminimal_lexical-af041fc8ed3e4293.rmeta \
        --cap-lints allow
      )
    '';
}
