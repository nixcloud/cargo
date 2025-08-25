# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps, cargo-credential-0_4_8-b614317587c5a56a }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-credential-libsecret-0_4_13-29580c6ca7639f8c";
    meta.cargo_crate_info = {
      name = "cargo-credential-libsecret";
      version = "0.4.13";
      crate_hash = "29580c6ca7639f8c";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [anyhow-1_0_96-08accda0b9ade607 cargo-credential-0_4_8-b614317587c5a56a libloading-0_8_6-cdb9b9cb6b1a437a];
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

    CARGO_CRATE_NAME = "cargo_credential_libsecret";
    CARGO_MANIFEST_DIR = "./credential/cargo-credential-libsecret";
    CARGO_MANIFEST_PATH = "./credential/cargo-credential-libsecret/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "A Cargo credential process that stores tokens with GNOME libsecret.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo-credential-libsecret";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.4.13";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "13";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m cargo-credential-libsecret-0_4_13-29580c6ca7639f8c"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name cargo_credential_libsecret \
        --edition=2021 credential/cargo-credential-libsecret/src/lib.rs \
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
        -C metadata=2e9255f6b79fd8a0 \
        -C extra-filename=-29580c6ca7639f8c \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern anyhow=${anyhow-1_0_96-08accda0b9ade607}/libanyhow-08accda0b9ade607.rmeta \
        --extern cargo_credential=${cargo-credential-0_4_8-b614317587c5a56a}/libcargo_credential-b614317587c5a56a.rmeta \
        --extern libloading=${libloading-0_8_6-cdb9b9cb6b1a437a}/liblibloading-cdb9b9cb6b1a437a.rmeta
      )
    '';
}
