# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "num-traits-0_2_19-script_build-22cedb865e2464c9";
    meta.cargo_crate_info = {
      name = "num-traits";
      version = "0.2.19";
      crate_hash = "22cedb865e2464c9";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [autocfg-1_4_0-6353892153b58c07];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/num-traits/0.2.19/download";
      sha256 = "071dfc062690e90b734c0b2273ce72ad0ffa95f0c74596bc250dcfd960262841";
    };
    unpackPhase = ''
      tar xf $src
      cd num-traits-0.2.19
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Rust Project Developers";
    CARGO_PKG_DESCRIPTION = "Numeric traits for generic mathematics";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-num/num-traits";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "num-traits";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-num/num-traits";
    CARGO_PKG_RUST_VERSION = "1.60";
    CARGO_PKG_VERSION = "0.2.19";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "19";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m num-traits-0_2_19-script_build-22cedb865e2464c9"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2021 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "i128", "libm", "std"))' \
        -C metadata=2e3604ae50a791fa \
        -C extra-filename=-22cedb865e2464c9 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern autocfg=${autocfg-1_4_0-6353892153b58c07}/libautocfg-6353892153b58c07.rlib \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-22cedb865e2464c9 $OUT_DIR/build_script_build
      )
    '';
}
