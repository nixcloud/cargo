# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "zerovec-derive-0_10_3-7a2b2556e53e6ecd";
    meta.cargo_crate_info = {
      name = "zerovec-derive";
      version = "0.10.3";
      crate_hash = "7a2b2556e53e6ecd";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [proc-macro2-1_0_93-e285fc8594787700 quote-1_0_38-5b0706e2cc2f4ea8 syn-2_0_98-2ed9ce1dac2090c2];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/zerovec-derive/0.10.3/download";
      sha256 = "6eafa6dfb17584ea3e2bd6e76e0cc15ad7af12b09abdd1ca55961bed9b1063c6";
    };
    unpackPhase = ''
      tar xf $src
      cd zerovec-derive-0.10.3
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "zerovec_derive";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Manish Goregaokar <manishsmail@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Custom derive for the zerovec crate";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "zerovec-derive";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/unicode-org/icu4x";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.10.3";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "10";
    CARGO_PKG_VERSION_PATCH = "3";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m zerovec-derive-0_10_3-7a2b2556e53e6ecd"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name zerovec_derive \
        --edition=2021 src/lib.rs \
        --crate-type proc-macro \
        --emit=dep-info,link \
        -C prefer-dynamic \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=c675c2f7032d6367 \
        -C extra-filename=-7a2b2556e53e6ecd \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern proc_macro2=${proc-macro2-1_0_93-e285fc8594787700}/libproc_macro2-e285fc8594787700.rlib \
        --extern quote=${quote-1_0_38-5b0706e2cc2f4ea8}/libquote-5b0706e2cc2f4ea8.rlib \
        --extern syn=${syn-2_0_98-2ed9ce1dac2090c2}/libsyn-2ed9ce1dac2090c2.rlib \
        --extern proc_macro \
        --cap-lints allow
      )
    '';
}
