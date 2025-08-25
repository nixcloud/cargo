# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "unicode-bom-2_0_3-791ebb1e77c846a2";
    meta.cargo_crate_info = {
      name = "unicode-bom";
      version = "2.0.3";
      crate_hash = "791ebb1e77c846a2";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/unicode-bom/2.0.3/download";
      sha256 = "7eec5d1121208364f6793f7d2e222bf75a915c19557537745b195b253dd64217";
    };
    unpackPhase = ''
      tar xf $src
      cd unicode-bom-2.0.3
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "unicode_bom";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Phil Booth <pmbooth@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Unicode byte-order mark detection for files and byte arrays.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "unicode-bom";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://gitlab.com/philbooth/unicode-bom";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "2.0.3";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "3";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m unicode-bom-2_0_3-791ebb1e77c846a2"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name unicode_bom \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=4357bbd9614ecbcc \
        -C extra-filename=-791ebb1e77c846a2 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
