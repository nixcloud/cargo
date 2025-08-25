# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cc-1_2_16-aaebd3b60c7751f8";
    meta.cargo_crate_info = {
      name = "cc";
      version = "1.2.16";
      crate_hash = "aaebd3b60c7751f8";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [jobserver-0_1_32-11f288c905f4bb8b libc-0_2_170-d46a143b0470970d shlex-1_3_0-2bc6e0a0e5c36322];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/cc/1.2.16/download";
      sha256 = "be714c154be609ec7f5dad223a33bf1482fff90472de28f7362806e6d4832b8c";
    };
    unpackPhase = ''
      tar xf $src
      cd cc-1.2.16
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "cc";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "A build-time dependency for Cargo build scripts to assist in invoking the native
C compiler to compile native C code into a static archive to be linked into Rust
code.
";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cc-rs";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cc";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cc-rs";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "1.2.16";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "16";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m cc-1_2_16-aaebd3b60c7751f8"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name cc \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="parallel"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("jobserver", "parallel"))' \
        -C metadata=c9425fe499e824d2 \
        -C extra-filename=-aaebd3b60c7751f8 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern jobserver=${jobserver-0_1_32-11f288c905f4bb8b}/libjobserver-11f288c905f4bb8b.rmeta \
        --extern libc=${libc-0_2_170-d46a143b0470970d}/liblibc-d46a143b0470970d.rmeta \
        --extern shlex=${shlex-1_3_0-2bc6e0a0e5c36322}/libshlex-2bc6e0a0e5c36322.rmeta \
        --cap-lints allow
      )
    '';
}
