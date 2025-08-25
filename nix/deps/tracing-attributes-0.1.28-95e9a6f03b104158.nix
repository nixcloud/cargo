# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tracing-attributes-0_1_28-95e9a6f03b104158";
    meta.cargo_crate_info = {
      name = "tracing-attributes";
      version = "0.1.28";
      crate_hash = "95e9a6f03b104158";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [proc-macro2-1_0_93-e285fc8594787700 quote-1_0_38-5b0706e2cc2f4ea8 syn-2_0_98-2ed9ce1dac2090c2];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tracing-attributes/0.1.28/download";
      sha256 = "395ae124c09f9e6918a2310af6038fba074bcf474ac352496d5910dd59a2226d";
    };
    unpackPhase = ''
      tar xf $src
      cd tracing-attributes-0.1.28
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "tracing_attributes";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Tokio Contributors <team@tokio.rs>:Eliza Weisman <eliza@buoyant.io>:David Barsky <dbarsky@amazon.com>";
    CARGO_PKG_DESCRIPTION = "Procedural macro attributes for automatically instrumenting functions.
";
    CARGO_PKG_HOMEPAGE = "https://tokio.rs";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tracing-attributes";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/tokio-rs/tracing";
    CARGO_PKG_RUST_VERSION = "1.63.0";
    CARGO_PKG_VERSION = "0.1.28";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "28";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m tracing-attributes-0_1_28-95e9a6f03b104158"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name tracing_attributes \
        --edition=2018 src/lib.rs \
        --crate-type proc-macro \
        --emit=dep-info,link \
        -C prefer-dynamic \
        -C embed-bitcode=no \
        --warn=unexpected_cfgs \
        --check-cfg 'cfg(flaky_tests)' \
        --check-cfg 'cfg(tracing_unstable)' \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("async-await"))' \
        -C metadata=ce4f1b6f91977c9c \
        -C extra-filename=-95e9a6f03b104158 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern proc_macro2=${proc-macro2-1_0_93-e285fc8594787700}/libproc_macro2-e285fc8594787700.rlib \
        --extern quote=${quote-1_0_38-5b0706e2cc2f4ea8}/libquote-5b0706e2cc2f4ea8.rlib \
        --extern syn=${syn-2_0_98-2ed9ce1dac2090c2}/libsyn-2ed9ce1dac2090c2.rlib \
        --extern proc_macro \
        --cap-lints allow
      )
    '';
}
