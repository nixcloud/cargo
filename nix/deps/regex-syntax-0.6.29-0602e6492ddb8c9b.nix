# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "regex-syntax-0_6_29-0602e6492ddb8c9b";
    meta.cargo_crate_info = {
      name = "regex-syntax";
      version = "0.6.29";
      crate_hash = "0602e6492ddb8c9b";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/regex-syntax/0.6.29/download";
      sha256 = "f162c6dd7b008981e4d40210aca20b4bd0f9b60ca9271061b07f78537722f2e1";
    };
    unpackPhase = ''
      tar xf $src
      cd regex-syntax-0.6.29
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "regex_syntax";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Rust Project Developers";
    CARGO_PKG_DESCRIPTION = "A regular expression parser.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/regex";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "regex-syntax";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/regex";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.6.29";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "6";
    CARGO_PKG_VERSION_PATCH = "29";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m regex-syntax-0_6_29-0602e6492ddb8c9b"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name regex_syntax \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="unicode"' \
        --cfg 'feature="unicode-age"' \
        --cfg 'feature="unicode-bool"' \
        --cfg 'feature="unicode-case"' \
        --cfg 'feature="unicode-gencat"' \
        --cfg 'feature="unicode-perl"' \
        --cfg 'feature="unicode-script"' \
        --cfg 'feature="unicode-segment"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "unicode", "unicode-age", "unicode-bool", "unicode-case", "unicode-gencat", "unicode-perl", "unicode-script", "unicode-segment"))' \
        -C metadata=a9ba43cc8e2ad643 \
        -C extra-filename=-0602e6492ddb8c9b \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
