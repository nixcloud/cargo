# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "filetime-0_2_25-862af764b19c0992";
    meta.cargo_crate_info = {
      name = "filetime";
      version = "0.2.25";
      crate_hash = "862af764b19c0992";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cfg-if-1_0_0-f52ed1292e79c10c libc-0_2_170-d46a143b0470970d];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/filetime/0.2.25/download";
      sha256 = "35c0522e981e68cbfa8c3f978441a5f34b30b96e146b33cd3359176b50fe8586";
    };
    unpackPhase = ''
      tar xf $src
      cd filetime-0.2.25
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "filetime";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Platform-agnostic accessors of timestamps in File metadata
";
    CARGO_PKG_HOMEPAGE = "https://github.com/alexcrichton/filetime";
    CARGO_PKG_LICENSE = "MIT/Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "filetime";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/alexcrichton/filetime";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.2.25";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "25";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m filetime-0_2_25-862af764b19c0992"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name filetime \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=ef4cc078abb4db1a \
        -C extra-filename=-862af764b19c0992 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern cfg_if=${cfg-if-1_0_0-f52ed1292e79c10c}/libcfg_if-f52ed1292e79c10c.rmeta \
        --extern libc=${libc-0_2_170-d46a143b0470970d}/liblibc-d46a143b0470970d.rmeta \
        --cap-lints allow
      )
    '';
}
