# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "flate2-1_1_0-272bc94b280c0438";
    meta.cargo_crate_info = {
      name = "flate2";
      version = "1.1.0";
      crate_hash = "272bc94b280c0438";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [crc32fast-1_4_2-364c5844de60373e libz-sys-1_1_21-205a06d961374cd1];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/flate2/1.1.0/download";
      sha256 = "11faaf5a5236997af9848be0bef4db95824b1d534ebc64d0f0c6cf3e67bd38dc";
    };
    unpackPhase = ''
      tar xf $src
      cd flate2-1.1.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "flate2";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>:Josh Triplett <josh@joshtriplett.org>";
    CARGO_PKG_DESCRIPTION = "DEFLATE compression and decompression exposed as Read/BufRead/Write streams.
Supports miniz_oxide and multiple zlib implementations. Supports zlib, gzip,
and raw deflate streams.
";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/flate2-rs";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "flate2";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/flate2-rs";
    CARGO_PKG_RUST_VERSION = "1.67.0";
    CARGO_PKG_VERSION = "1.1.0";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m flate2-1_1_0-272bc94b280c0438"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name flate2 \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="any_impl"' \
        --cfg 'feature="any_zlib"' \
        --cfg 'feature="libz-sys"' \
        --cfg 'feature="zlib"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("any_impl", "any_zlib", "cloudflare-zlib-sys", "cloudflare_zlib", "default", "libz-ng-sys", "libz-rs-sys", "libz-sys", "miniz-sys", "miniz_oxide", "rust_backend", "zlib", "zlib-default", "zlib-ng", "zlib-ng-compat", "zlib-rs"))' \
        -C metadata=d069fc16d43224f3 \
        -C extra-filename=-272bc94b280c0438 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern crc32fast=${crc32fast-1_4_2-364c5844de60373e}/libcrc32fast-364c5844de60373e.rmeta \
        --extern libz_sys=${libz-sys-1_1_21-205a06d961374cd1}/liblibz_sys-205a06d961374cd1.rmeta \
        --cap-lints allow
      )
    '';
}
