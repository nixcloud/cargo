# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "pasetors-0_7_2-58098e8bbd680953";
    meta.cargo_crate_info = {
      name = "pasetors";
      version = "0.7.2";
      crate_hash = "58098e8bbd680953";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [ct-codecs-1_1_3-a023751389fe5581 ed25519-compact-2_1_1-862308207d017840 getrandom-0_3_1-5e852dc8efdab777 orion-0_17_8-cff1406525559add p384-0_13_1-a28f746b99f2cde1 rand_core-0_6_4-fe99bd26a150a053 regex-1_11_1-81271cb7b4167e0c serde-1_0_218-c4e47f01a1cedfa0 serde_json-1_0_139-578ab230a253fef1 sha2-0_10_8-b220b83b63166903 subtle-2_6_1-0482376bbaa3bb74 time-0_3_37-913b3e2f5fba81ad zeroize-1_8_1-aaf7cdda91519e7c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/pasetors/0.7.2/download";
      sha256 = "c54944fa25a6e7c9c5b3315f118d360cc00d555cf53bb2b2fdf32dd31c71b729";
    };
    unpackPhase = ''
      tar xf $src
      cd pasetors-0.7.2
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "pasetors";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "brycx <brycx@protonmail.com>";
    CARGO_PKG_DESCRIPTION = "PASETO: Platform-Agnostic Security Tokens (in Rust)";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "pasetors";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/brycx/pasetors";
    CARGO_PKG_RUST_VERSION = "1.80.0";
    CARGO_PKG_VERSION = "0.7.2";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "2";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m pasetors-0_7_2-58098e8bbd680953"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name pasetors \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="ed25519-compact"' \
        --cfg 'feature="orion"' \
        --cfg 'feature="p384"' \
        --cfg 'feature="paserk"' \
        --cfg 'feature="rand_core"' \
        --cfg 'feature="regex"' \
        --cfg 'feature="serde"' \
        --cfg 'feature="serde_json"' \
        --cfg 'feature="sha2"' \
        --cfg 'feature="std"' \
        --cfg 'feature="time"' \
        --cfg 'feature="v3"' \
        --cfg 'feature="v4"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "ed25519-compact", "orion", "p384", "paserk", "rand_core", "regex", "serde", "serde_json", "sha2", "std", "time", "v2", "v3", "v4"))' \
        -C metadata=92ff345db8c21cb2 \
        -C extra-filename=-58098e8bbd680953 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern ct_codecs=${ct-codecs-1_1_3-a023751389fe5581}/libct_codecs-a023751389fe5581.rmeta \
        --extern ed25519_compact=${ed25519-compact-2_1_1-862308207d017840}/libed25519_compact-862308207d017840.rmeta \
        --extern getrandom=${getrandom-0_3_1-5e852dc8efdab777}/libgetrandom-5e852dc8efdab777.rmeta \
        --extern orion=${orion-0_17_8-cff1406525559add}/liborion-cff1406525559add.rmeta \
        --extern p384=${p384-0_13_1-a28f746b99f2cde1}/libp384-a28f746b99f2cde1.rmeta \
        --extern rand_core=${rand_core-0_6_4-fe99bd26a150a053}/librand_core-fe99bd26a150a053.rmeta \
        --extern regex=${regex-1_11_1-81271cb7b4167e0c}/libregex-81271cb7b4167e0c.rmeta \
        --extern serde=${serde-1_0_218-c4e47f01a1cedfa0}/libserde-c4e47f01a1cedfa0.rmeta \
        --extern serde_json=${serde_json-1_0_139-578ab230a253fef1}/libserde_json-578ab230a253fef1.rmeta \
        --extern sha2=${sha2-0_10_8-b220b83b63166903}/libsha2-b220b83b63166903.rmeta \
        --extern subtle=${subtle-2_6_1-0482376bbaa3bb74}/libsubtle-0482376bbaa3bb74.rmeta \
        --extern time=${time-0_3_37-913b3e2f5fba81ad}/libtime-913b3e2f5fba81ad.rmeta \
        --extern zeroize=${zeroize-1_8_1-aaf7cdda91519e7c}/libzeroize-aaf7cdda91519e7c.rmeta \
        --cap-lints allow
      )
    '';
}
