# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-util-schemas-0_8_1-46ed49ab1cd04c33";
    meta.cargo_crate_info = {
      name = "cargo-util-schemas";
      version = "0.8.1";
      crate_hash = "46ed49ab1cd04c33";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [semver-1_0_25-da00f457d140fad0 serde-1_0_218-c4e47f01a1cedfa0 serde-untagged-0_1_6-6b39be11e9642e68 serde-value-0_7_0-a683b57adfe04c50 thiserror-2_0_11-266d93aab4cee78a toml-0_8_20-50efb42ce9e83b37 unicode-xid-0_2_6-e8d225261872474a url-2_5_4-f84eb31ea66b0c06];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = builtins.filterSource
      (path: type:
        let base = baseNameOf path;
        in !(base == "target" || base == "result" || builtins.match "result-*" base != null)
      ) /home/nixos/cargo;
    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "cargo_util_schemas";
    CARGO_MANIFEST_DIR = "./crates/cargo-util-schemas";
    CARGO_MANIFEST_PATH = "./crates/cargo-util-schemas/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Deserialization schemas for Cargo";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo-util-schemas";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.8.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m cargo-util-schemas-0_8_1-46ed49ab1cd04c33"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name cargo_util_schemas \
        --edition=2021 crates/cargo-util-schemas/src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        --allow=clippy::all \
        --warn=clippy::correctness \
        --warn=clippy::self_named_module_files \
        --warn=rust_2018_idioms \
        --allow=rustdoc::private_intra_doc_links \
        --warn=clippy::print_stdout \
        --warn=clippy::print_stderr \
        --warn=clippy::disallowed_methods \
        --warn=clippy::dbg_macro \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("unstable-schema"))' \
        -C metadata=f015e0e00f183762 \
        -C extra-filename=-46ed49ab1cd04c33 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern semver=${semver-1_0_25-da00f457d140fad0}/libsemver-da00f457d140fad0.rmeta \
        --extern serde=${serde-1_0_218-c4e47f01a1cedfa0}/libserde-c4e47f01a1cedfa0.rmeta \
        --extern serde_untagged=${serde-untagged-0_1_6-6b39be11e9642e68}/libserde_untagged-6b39be11e9642e68.rmeta \
        --extern serde_value=${serde-value-0_7_0-a683b57adfe04c50}/libserde_value-a683b57adfe04c50.rmeta \
        --extern thiserror=${thiserror-2_0_11-266d93aab4cee78a}/libthiserror-266d93aab4cee78a.rmeta \
        --extern toml=${toml-0_8_20-50efb42ce9e83b37}/libtoml-50efb42ce9e83b37.rmeta \
        --extern unicode_xid=${unicode-xid-0_2_6-e8d225261872474a}/libunicode_xid-e8d225261872474a.rmeta \
        --extern url=${url-2_5_4-f84eb31ea66b0c06}/liburl-f84eb31ea66b0c06.rmeta
      )
    '';
}
