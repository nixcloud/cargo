# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "smallvec-1_13_2-453c588ad74a5894";
    meta.cargo_crate_info = {
      name = "smallvec";
      version = "1.13.2";
      crate_hash = "453c588ad74a5894";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/smallvec/1.13.2/download";
      sha256 = "3c5e1a9a646d36c3599cd173a41282daf47c44583ad367b8e6837255952e5c67";
    };
    unpackPhase = ''
      tar xf $src
      cd smallvec-1.13.2
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "smallvec";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Servo Project Developers";
    CARGO_PKG_DESCRIPTION = "'Small vector' optimization: store up to a small number of items on the stack";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "smallvec";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/servo/rust-smallvec";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "1.13.2";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "13";
    CARGO_PKG_VERSION_PATCH = "2";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m smallvec-1_13_2-453c588ad74a5894"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name smallvec \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="const_generics"' \
        --cfg 'feature="write"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("arbitrary", "const_generics", "const_new", "debugger_visualizer", "drain_filter", "drain_keep_rest", "may_dangle", "serde", "specialization", "union", "write"))' \
        -C metadata=be6ba210813e9f37 \
        -C extra-filename=-453c588ad74a5894 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
