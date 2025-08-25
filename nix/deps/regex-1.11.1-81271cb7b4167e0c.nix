# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "regex-1_11_1-81271cb7b4167e0c";
    meta.cargo_crate_info = {
      name = "regex";
      version = "1.11.1";
      crate_hash = "81271cb7b4167e0c";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [aho-corasick-1_1_3-e16ae6995589aa8b memchr-2_7_4-df7138072aead54d regex-automata-0_4_9-db977915fa9b8508 regex-syntax-0_8_5-e9911f1b4a36081d];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/regex/1.11.1/download";
      sha256 = "b544ef1b4eac5dc2db33ea63606ae9ffcfac26c1416a2806ae0bf5f56b201191";
    };
    unpackPhase = ''
      tar xf $src
      cd regex-1.11.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "regex";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Rust Project Developers:Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "An implementation of regular expressions for Rust. This implementation uses
finite automata and guarantees linear time matching on all inputs.
";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/regex";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "regex";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/regex";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "1.11.1";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "11";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m regex-1_11_1-81271cb7b4167e0c"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name regex \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="perf"' \
        --cfg 'feature="perf-backtrack"' \
        --cfg 'feature="perf-cache"' \
        --cfg 'feature="perf-dfa"' \
        --cfg 'feature="perf-inline"' \
        --cfg 'feature="perf-literal"' \
        --cfg 'feature="perf-onepass"' \
        --cfg 'feature="std"' \
        --cfg 'feature="unicode"' \
        --cfg 'feature="unicode-age"' \
        --cfg 'feature="unicode-bool"' \
        --cfg 'feature="unicode-case"' \
        --cfg 'feature="unicode-gencat"' \
        --cfg 'feature="unicode-perl"' \
        --cfg 'feature="unicode-script"' \
        --cfg 'feature="unicode-segment"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "logging", "pattern", "perf", "perf-backtrack", "perf-cache", "perf-dfa", "perf-dfa-full", "perf-inline", "perf-literal", "perf-onepass", "std", "unicode", "unicode-age", "unicode-bool", "unicode-case", "unicode-gencat", "unicode-perl", "unicode-script", "unicode-segment", "unstable", "use_std"))' \
        -C metadata=285f2f2b337c2a31 \
        -C extra-filename=-81271cb7b4167e0c \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern aho_corasick=${aho-corasick-1_1_3-e16ae6995589aa8b}/libaho_corasick-e16ae6995589aa8b.rmeta \
        --extern memchr=${memchr-2_7_4-df7138072aead54d}/libmemchr-df7138072aead54d.rmeta \
        --extern regex_automata=${regex-automata-0_4_9-db977915fa9b8508}/libregex_automata-db977915fa9b8508.rmeta \
        --extern regex_syntax=${regex-syntax-0_8_5-e9911f1b4a36081d}/libregex_syntax-e9911f1b4a36081d.rmeta \
        --cap-lints allow
      )
    '';
}
