# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "home-0_5_11-aaab8970bcca687f";
    meta.cargo_crate_info = {
      name = "home";
      version = "0.5.11";
      crate_hash = "aaab8970bcca687f";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/home/0.5.11/download";
      sha256 = "589533453244b0995c858700322199b2becb13b627df2851f64a2775d024abcf";
    };
    unpackPhase = ''
      tar xf $src
      cd home-0.5.11
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "home";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Brian Anderson <andersrb@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Shared definitions of home directories.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "home";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.81";
    CARGO_PKG_VERSION = "0.5.11";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "5";
    CARGO_PKG_VERSION_PATCH = "11";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m home-0_5_11-aaab8970bcca687f"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name home \
        --edition=2021 src/lib.rs \
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
        -C metadata=7e8d82234c215c06 \
        -C extra-filename=-aaab8970bcca687f \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
