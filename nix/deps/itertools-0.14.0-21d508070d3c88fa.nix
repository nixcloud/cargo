# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "itertools-0_14_0-21d508070d3c88fa";
    meta.cargo_crate_info = {
      name = "itertools";
      version = "0.14.0";
      crate_hash = "21d508070d3c88fa";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [either-1_13_0-6837b249a36b084d];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/itertools/0.14.0/download";
      sha256 = "2b192c782037fadd9cfa75548310488aabdbf3d2da73885b31bd0abd03351285";
    };
    unpackPhase = ''
      tar xf $src
      cd itertools-0.14.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "itertools";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "bluss";
    CARGO_PKG_DESCRIPTION = "Extra iterator adaptors, iterator methods, free functions, and macros.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "itertools";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-itertools/itertools";
    CARGO_PKG_RUST_VERSION = "1.63.0";
    CARGO_PKG_VERSION = "0.14.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "14";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m itertools-0_14_0-21d508070d3c88fa"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name itertools \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="use_alloc"' \
        --cfg 'feature="use_std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "use_alloc", "use_std"))' \
        -C metadata=a56a9e3e5b3f9906 \
        -C extra-filename=-21d508070d3c88fa \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern either=${either-1_13_0-6837b249a36b084d}/libeither-6837b249a36b084d.rmeta \
        --cap-lints allow
      )
    '';
}
