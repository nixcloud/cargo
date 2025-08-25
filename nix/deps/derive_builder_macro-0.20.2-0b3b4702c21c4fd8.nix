# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "derive_builder_macro-0_20_2-0b3b4702c21c4fd8";
    meta.cargo_crate_info = {
      name = "derive_builder_macro";
      version = "0.20.2";
      crate_hash = "0b3b4702c21c4fd8";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [derive_builder_core-0_20_2-c3337173a60f2241 syn-2_0_98-2ed9ce1dac2090c2];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/derive_builder_macro/0.20.2/download";
      sha256 = "ab63b0e2bf4d5928aff72e83a7dace85d7bba5fe12dcc3c5a572d78caffd3f3c";
    };
    unpackPhase = ''
      tar xf $src
      cd derive_builder_macro-0.20.2
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "derive_builder_macro";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Colin Kiegel <kiegel@gmx.de>:Pascal Hertleif <killercup@gmail.com>:Jan-Erik Rediger <janerik@fnordig.de>:Ted Driggs <ted.driggs@outlook.com>";
    CARGO_PKG_DESCRIPTION = "Rust macro to automatically implement the builder pattern for arbitrary structs.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "derive_builder_macro";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/colin-kiegel/rust-derive-builder";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.20.2";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "20";
    CARGO_PKG_VERSION_PATCH = "2";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m derive_builder_macro-0_20_2-0b3b4702c21c4fd8"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name derive_builder_macro \
        --edition=2018 src/lib.rs \
        --crate-type proc-macro \
        --emit=dep-info,link \
        -C prefer-dynamic \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="lib_has_std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "clippy", "lib_has_std"))' \
        -C metadata=e8597143e9525ad6 \
        -C extra-filename=-0b3b4702c21c4fd8 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern derive_builder_core=${derive_builder_core-0_20_2-c3337173a60f2241}/libderive_builder_core-c3337173a60f2241.rlib \
        --extern syn=${syn-2_0_98-2ed9ce1dac2090c2}/libsyn-2ed9ce1dac2090c2.rlib \
        --extern proc_macro \
        --cap-lints allow
      )
    '';
}
