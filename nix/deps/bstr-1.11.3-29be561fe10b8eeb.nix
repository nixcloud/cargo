# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "bstr-1_11_3-29be561fe10b8eeb";
    meta.cargo_crate_info = {
      name = "bstr";
      version = "1.11.3";
      crate_hash = "29be561fe10b8eeb";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [memchr-2_7_4-df7138072aead54d regex-automata-0_4_9-db977915fa9b8508];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/bstr/1.11.3/download";
      sha256 = "531a9155a481e2ee699d4f98f43c0ca4ff8ee1bfd55c31e9e98fb29d2b176fe0";
    };
    unpackPhase = ''
      tar xf $src
      cd bstr-1.11.3
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "bstr";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A string type that is not required to be valid UTF-8.";
    CARGO_PKG_HOMEPAGE = "https://github.com/BurntSushi/bstr";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "bstr";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/BurntSushi/bstr";
    CARGO_PKG_RUST_VERSION = "1.73";
    CARGO_PKG_VERSION = "1.11.3";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "11";
    CARGO_PKG_VERSION_PATCH = "3";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m bstr-1_11_3-29be561fe10b8eeb"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name bstr \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --cfg 'feature="unicode"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "default", "serde", "std", "unicode"))' \
        -C metadata=18dfaf167cf9e415 \
        -C extra-filename=-29be561fe10b8eeb \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern memchr=${memchr-2_7_4-df7138072aead54d}/libmemchr-df7138072aead54d.rmeta \
        --extern regex_automata=${regex-automata-0_4_9-db977915fa9b8508}/libregex_automata-db977915fa9b8508.rmeta \
        --cap-lints allow
      )
    '';
}
