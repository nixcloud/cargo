# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-credential-0_4_8-b614317587c5a56a";
    meta.cargo_crate_info = {
      name = "cargo-credential";
      version = "0.4.8";
      crate_hash = "b614317587c5a56a";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [anyhow-1_0_96-08accda0b9ade607 libc-0_2_170-d46a143b0470970d serde-1_0_218-c4e47f01a1cedfa0 serde_json-1_0_139-578ab230a253fef1 thiserror-2_0_11-266d93aab4cee78a time-0_3_37-913b3e2f5fba81ad];
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

    CARGO_CRATE_NAME = "cargo_credential";
    CARGO_MANIFEST_DIR = "./credential/cargo-credential";
    CARGO_MANIFEST_PATH = "./credential/cargo-credential/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "A library to assist writing Cargo credential helpers.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo-credential";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.83";
    CARGO_PKG_VERSION = "0.4.8";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "8";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m cargo-credential-0_4_8-b614317587c5a56a"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name cargo_credential \
        --edition=2021 credential/cargo-credential/src/lib.rs \
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
        --check-cfg 'cfg(feature, values())' \
        -C metadata=a4ff9dbfa728630c \
        -C extra-filename=-b614317587c5a56a \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern anyhow=${anyhow-1_0_96-08accda0b9ade607}/libanyhow-08accda0b9ade607.rmeta \
        --extern libc=${libc-0_2_170-d46a143b0470970d}/liblibc-d46a143b0470970d.rmeta \
        --extern serde=${serde-1_0_218-c4e47f01a1cedfa0}/libserde-c4e47f01a1cedfa0.rmeta \
        --extern serde_json=${serde_json-1_0_139-578ab230a253fef1}/libserde_json-578ab230a253fef1.rmeta \
        --extern thiserror=${thiserror-2_0_11-266d93aab4cee78a}/libthiserror-266d93aab4cee78a.rmeta \
        --extern time=${time-0_3_37-913b3e2f5fba81ad}/libtime-913b3e2f5fba81ad.rmeta
      )
    '';
}
