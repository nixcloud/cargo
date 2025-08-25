# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libloading-0_8_6-cdb9b9cb6b1a437a";
    meta.cargo_crate_info = {
      name = "libloading";
      version = "0.8.6";
      crate_hash = "cdb9b9cb6b1a437a";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cfg-if-1_0_0-f52ed1292e79c10c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libloading/0.8.6/download";
      sha256 = "fc2f4eb4bc735547cfed7c0a4922cbd04a4655978c09b54f1f7b228750664c34";
    };
    unpackPhase = ''
      tar xf $src
      cd libloading-0.8.6
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "libloading";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Simonas Kazlauskas <libloading@kazlauskas.me>";
    CARGO_PKG_DESCRIPTION = "Bindings around the platform's dynamic library loading primitives with greatly improved memory safety.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "ISC";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libloading";
    CARGO_PKG_README = "README.mkd";
    CARGO_PKG_REPOSITORY = "https://github.com/nagisa/rust_libloading/";
    CARGO_PKG_RUST_VERSION = "1.56.0";
    CARGO_PKG_VERSION = "0.8.6";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "6";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m libloading-0_8_6-cdb9b9cb6b1a437a"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name libloading \
        --edition=2015 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        --warn=unexpected_cfgs \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=ede99ce550fc96f7 \
        -C extra-filename=-cdb9b9cb6b1a437a \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern cfg_if=${cfg-if-1_0_0-f52ed1292e79c10c}/libcfg_if-f52ed1292e79c10c.rmeta \
        --cap-lints allow
      )
    '';
}
