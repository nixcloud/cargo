# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "globset-0_4_15-f4cebf8c64963b2b";
    meta.cargo_crate_info = {
      name = "globset";
      version = "0.4.15";
      crate_hash = "f4cebf8c64963b2b";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [aho-corasick-1_1_3-e16ae6995589aa8b bstr-1_11_3-29be561fe10b8eeb log-0_4_25-f053b1d34dfd0749 regex-automata-0_4_9-db977915fa9b8508 regex-syntax-0_8_5-e9911f1b4a36081d];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/globset/0.4.15/download";
      sha256 = "15f1ce686646e7f1e19bf7d5533fe443a45dbfb990e00629110797578b42fb19";
    };
    unpackPhase = ''
      tar xf $src
      cd globset-0.4.15
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "globset";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Cross platform single glob and glob set matching. Glob set matching is the
process of matching one or more glob patterns against a single candidate path
simultaneously, and returning all of the globs that matched.
";
    CARGO_PKG_HOMEPAGE = "https://github.com/BurntSushi/ripgrep/tree/master/crates/globset";
    CARGO_PKG_LICENSE = "Unlicense OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "globset";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/BurntSushi/ripgrep/tree/master/crates/globset";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.4.15";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "15";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m globset-0_4_15-f4cebf8c64963b2b"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name globset \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="log"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "log", "serde", "serde1", "simd-accel"))' \
        -C metadata=44e693e14be105b3 \
        -C extra-filename=-f4cebf8c64963b2b \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern aho_corasick=${aho-corasick-1_1_3-e16ae6995589aa8b}/libaho_corasick-e16ae6995589aa8b.rmeta \
        --extern bstr=${bstr-1_11_3-29be561fe10b8eeb}/libbstr-29be561fe10b8eeb.rmeta \
        --extern log=${log-0_4_25-f053b1d34dfd0749}/liblog-f053b1d34dfd0749.rmeta \
        --extern regex_automata=${regex-automata-0_4_9-db977915fa9b8508}/libregex_automata-db977915fa9b8508.rmeta \
        --extern regex_syntax=${regex-syntax-0_8_5-e9911f1b4a36081d}/libregex_syntax-e9911f1b4a36081d.rmeta \
        --cap-lints allow
      )
    '';
}
