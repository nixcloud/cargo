# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "regex-automata-0_4_9-db977915fa9b8508";
    meta.cargo_crate_info = {
      name = "regex-automata";
      version = "0.4.9";
      crate_hash = "db977915fa9b8508";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [aho-corasick-1_1_3-e16ae6995589aa8b memchr-2_7_4-df7138072aead54d regex-syntax-0_8_5-e9911f1b4a36081d];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/regex-automata/0.4.9/download";
      sha256 = "809e8dc61f6de73b46c85f4c96486310fe304c434cfa43669d7b40f711150908";
    };
    unpackPhase = ''
      tar xf $src
      cd regex-automata-0.4.9
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "regex_automata";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Rust Project Developers:Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Automata construction and matching using regular expressions.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "regex-automata";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/regex/tree/master/regex-automata";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.4.9";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "9";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m regex-automata-0_4_9-db977915fa9b8508"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name regex_automata \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="dfa-onepass"' \
        --cfg 'feature="dfa-search"' \
        --cfg 'feature="hybrid"' \
        --cfg 'feature="meta"' \
        --cfg 'feature="nfa"' \
        --cfg 'feature="nfa-backtrack"' \
        --cfg 'feature="nfa-pikevm"' \
        --cfg 'feature="nfa-thompson"' \
        --cfg 'feature="perf"' \
        --cfg 'feature="perf-inline"' \
        --cfg 'feature="perf-literal"' \
        --cfg 'feature="perf-literal-multisubstring"' \
        --cfg 'feature="perf-literal-substring"' \
        --cfg 'feature="std"' \
        --cfg 'feature="syntax"' \
        --cfg 'feature="unicode"' \
        --cfg 'feature="unicode-age"' \
        --cfg 'feature="unicode-bool"' \
        --cfg 'feature="unicode-case"' \
        --cfg 'feature="unicode-gencat"' \
        --cfg 'feature="unicode-perl"' \
        --cfg 'feature="unicode-script"' \
        --cfg 'feature="unicode-segment"' \
        --cfg 'feature="unicode-word-boundary"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "default", "dfa", "dfa-build", "dfa-onepass", "dfa-search", "hybrid", "internal-instrument", "internal-instrument-pikevm", "logging", "meta", "nfa", "nfa-backtrack", "nfa-pikevm", "nfa-thompson", "perf", "perf-inline", "perf-literal", "perf-literal-multisubstring", "perf-literal-substring", "std", "syntax", "unicode", "unicode-age", "unicode-bool", "unicode-case", "unicode-gencat", "unicode-perl", "unicode-script", "unicode-segment", "unicode-word-boundary"))' \
        -C metadata=7f7360a727e483f6 \
        -C extra-filename=-db977915fa9b8508 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern aho_corasick=${aho-corasick-1_1_3-e16ae6995589aa8b}/libaho_corasick-e16ae6995589aa8b.rmeta \
        --extern memchr=${memchr-2_7_4-df7138072aead54d}/libmemchr-df7138072aead54d.rmeta \
        --extern regex_syntax=${regex-syntax-0_8_5-e9911f1b4a36081d}/libregex_syntax-e9911f1b4a36081d.rmeta \
        --cap-lints allow
      )
    '';
}
