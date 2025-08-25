# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tracing-core-0_1_33-f06771044d6f65f3";
    meta.cargo_crate_info = {
      name = "tracing-core";
      version = "0.1.33";
      crate_hash = "f06771044d6f65f3";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [once_cell-1_20_3-5c63a4de5995f261];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tracing-core/0.1.33/download";
      sha256 = "e672c95779cf947c5311f83787af4fa8fffd12fb27e4993211a84bdfd9610f9c";
    };
    unpackPhase = ''
      tar xf $src
      cd tracing-core-0.1.33
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "tracing_core";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Tokio Contributors <team@tokio.rs>";
    CARGO_PKG_DESCRIPTION = "Core primitives for application-level tracing.
";
    CARGO_PKG_HOMEPAGE = "https://tokio.rs";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tracing-core";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/tokio-rs/tracing";
    CARGO_PKG_RUST_VERSION = "1.63.0";
    CARGO_PKG_VERSION = "0.1.33";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "33";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m tracing-core-0_1_33-f06771044d6f65f3"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name tracing_core \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        --warn=unexpected_cfgs \
        --check-cfg 'cfg(flaky_tests)' \
        --check-cfg 'cfg(tracing_unstable)' \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="once_cell"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "once_cell", "std", "valuable"))' \
        -C metadata=948ac55cf5bd12f5 \
        -C extra-filename=-f06771044d6f65f3 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern once_cell=${once_cell-1_20_3-5c63a4de5995f261}/libonce_cell-5c63a4de5995f261.rmeta \
        --cap-lints allow
      )
    '';
}
