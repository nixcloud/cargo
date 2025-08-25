# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "yoke-0_7_5-0ce4dd6b1a767ef5";
    meta.cargo_crate_info = {
      name = "yoke";
      version = "0.7.5";
      crate_hash = "0ce4dd6b1a767ef5";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [stable_deref_trait-1_2_0-567eccf8a716e5cb yoke-derive-0_7_5-3bf0f9b0baa11d02 zerofrom-0_1_5-3373e8a7a0cdd76c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/yoke/0.7.5/download";
      sha256 = "120e6aef9aa629e3d4f52dc8cc43a015c7724194c97dfaf45180d2daf2b77f40";
    };
    unpackPhase = ''
      tar xf $src
      cd yoke-0.7.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "yoke";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Manish Goregaokar <manishsmail@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Abstraction allowing borrowed data to be carried along with the backing data it borrows from";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "yoke";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/unicode-org/icu4x";
    CARGO_PKG_RUST_VERSION = "1.71.1";
    CARGO_PKG_VERSION = "0.7.5";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "5";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m yoke-0_7_5-0ce4dd6b1a767ef5"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name yoke \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="default"' \
        --cfg 'feature="derive"' \
        --cfg 'feature="zerofrom"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "default", "derive", "serde", "zerofrom"))' \
        -C metadata=86a6904be2b66314 \
        -C extra-filename=-0ce4dd6b1a767ef5 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern stable_deref_trait=${stable_deref_trait-1_2_0-567eccf8a716e5cb}/libstable_deref_trait-567eccf8a716e5cb.rmeta \
        --extern yoke_derive=${yoke-derive-0_7_5-3bf0f9b0baa11d02}/libyoke_derive-3bf0f9b0baa11d02.so \
        --extern zerofrom=${zerofrom-0_1_5-3373e8a7a0cdd76c}/libzerofrom-3373e8a7a0cdd76c.rmeta \
        --cap-lints allow
      )
    '';
}
