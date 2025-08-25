# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "form_urlencoded-1_2_1-25d070486319ce04";
    meta.cargo_crate_info = {
      name = "form_urlencoded";
      version = "1.2.1";
      crate_hash = "25d070486319ce04";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [percent-encoding-2_3_1-3c9d9c63ad89d268];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/form_urlencoded/1.2.1/download";
      sha256 = "e13624c2627564efccf4934284bdd98cbaa14e79b0b5a141218e507b3a823456";
    };
    unpackPhase = ''
      tar xf $src
      cd form_urlencoded-1.2.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "form_urlencoded";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The rust-url developers";
    CARGO_PKG_DESCRIPTION = "Parser and serializer for the application/x-www-form-urlencoded syntax, as used by HTML forms.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "form_urlencoded";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/servo/rust-url";
    CARGO_PKG_RUST_VERSION = "1.51";
    CARGO_PKG_VERSION = "1.2.1";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m form_urlencoded-1_2_1-25d070486319ce04"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name form_urlencoded \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "default", "std"))' \
        -C metadata=9d562d0a4a096057 \
        -C extra-filename=-25d070486319ce04 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern percent_encoding=${percent-encoding-2_3_1-3c9d9c63ad89d268}/libpercent_encoding-3c9d9c63ad89d268.rmeta \
        --cap-lints allow
      )
    '';
}
