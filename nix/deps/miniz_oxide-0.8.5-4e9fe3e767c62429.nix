# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "miniz_oxide-0_8_5-4e9fe3e767c62429";
    meta.cargo_crate_info = {
      name = "miniz_oxide";
      version = "0.8.5";
      crate_hash = "4e9fe3e767c62429";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [adler2-2_0_0-eda9a489aa60b7f0];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/miniz_oxide/0.8.5/download";
      sha256 = "8e3e04debbb59698c15bacbb6d93584a8c0ca9cc3213cb423d31f760d8843ce5";
    };
    unpackPhase = ''
      tar xf $src
      cd miniz_oxide-0.8.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "miniz_oxide";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Frommi <daniil.liferenko@gmail.com>:oyvindln <oyvindln@users.noreply.github.com>:Rich Geldreich richgel99@gmail.com";
    CARGO_PKG_DESCRIPTION = "DEFLATE compression and decompression library rewritten in Rust based on miniz";
    CARGO_PKG_HOMEPAGE = "https://github.com/Frommi/miniz_oxide/tree/master/miniz_oxide";
    CARGO_PKG_LICENSE = "MIT OR Zlib OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "miniz_oxide";
    CARGO_PKG_README = "Readme.md";
    CARGO_PKG_REPOSITORY = "https://github.com/Frommi/miniz_oxide/tree/master/miniz_oxide";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.8.5";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "5";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m miniz_oxide-0_8_5-4e9fe3e767c62429"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name miniz_oxide \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        --warn=unexpected_cfgs \
        --check-cfg 'cfg(fuzzing)' \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="with-alloc"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "compiler_builtins", "core", "default", "rustc-dep-of-std", "simd", "simd-adler32", "std", "with-alloc"))' \
        -C metadata=ca54025531d91446 \
        -C extra-filename=-4e9fe3e767c62429 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern adler2=${adler2-2_0_0-eda9a489aa60b7f0}/libadler2-eda9a489aa60b7f0.rmeta \
        --cap-lints allow
      )
    '';
}
