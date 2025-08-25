# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "ignore-0_4_23-853f4c5fbe46d77c";
    meta.cargo_crate_info = {
      name = "ignore";
      version = "0.4.23";
      crate_hash = "853f4c5fbe46d77c";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [crossbeam-deque-0_8_6-96a47349b63fbb1b globset-0_4_15-f4cebf8c64963b2b log-0_4_25-f053b1d34dfd0749 memchr-2_7_4-df7138072aead54d regex-automata-0_4_9-db977915fa9b8508 same-file-1_0_6-fa3759c6ae4b4446 walkdir-2_5_0-edbfc6d2b455f0bf];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/ignore/0.4.23/download";
      sha256 = "6d89fd380afde86567dfba715db065673989d6253f42b88179abd3eae47bda4b";
    };
    unpackPhase = ''
      tar xf $src
      cd ignore-0.4.23
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "ignore";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A fast library for efficiently matching ignore files such as `.gitignore`
against file paths.
";
    CARGO_PKG_HOMEPAGE = "https://github.com/BurntSushi/ripgrep/tree/master/crates/ignore";
    CARGO_PKG_LICENSE = "Unlicense OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "ignore";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/BurntSushi/ripgrep/tree/master/crates/ignore";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.4.23";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "23";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m ignore-0_4_23-853f4c5fbe46d77c"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name ignore \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("simd-accel"))' \
        -C metadata=a0f148392dfe74f2 \
        -C extra-filename=-853f4c5fbe46d77c \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern crossbeam_deque=${crossbeam-deque-0_8_6-96a47349b63fbb1b}/libcrossbeam_deque-96a47349b63fbb1b.rmeta \
        --extern globset=${globset-0_4_15-f4cebf8c64963b2b}/libglobset-f4cebf8c64963b2b.rmeta \
        --extern log=${log-0_4_25-f053b1d34dfd0749}/liblog-f053b1d34dfd0749.rmeta \
        --extern memchr=${memchr-2_7_4-df7138072aead54d}/libmemchr-df7138072aead54d.rmeta \
        --extern regex_automata=${regex-automata-0_4_9-db977915fa9b8508}/libregex_automata-db977915fa9b8508.rmeta \
        --extern same_file=${same-file-1_0_6-fa3759c6ae4b4446}/libsame_file-fa3759c6ae4b4446.rmeta \
        --extern walkdir=${walkdir-2_5_0-edbfc6d2b455f0bf}/libwalkdir-edbfc6d2b455f0bf.rmeta \
        --cap-lints allow
      )
    '';
}
