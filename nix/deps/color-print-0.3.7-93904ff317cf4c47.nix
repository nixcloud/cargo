# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "color-print-0_3_7-93904ff317cf4c47";
    meta.cargo_crate_info = {
      name = "color-print";
      version = "0.3.7";
      crate_hash = "93904ff317cf4c47";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [color-print-proc-macro-0_3_7-331ec64f3156ab6c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/color-print/0.3.7/download";
      sha256 = "3aa954171903797d5623e047d9ab69d91b493657917bdfb8c2c80ecaf9cdb6f4";
    };
    unpackPhase = ''
      tar xf $src
      cd color-print-0.3.7
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "color_print";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Johann David <johann.david.dev@protonmail.com>";
    CARGO_PKG_DESCRIPTION = "Colorize and stylize strings for terminal at compile-time, by using an HTML-like syntax";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "color-print";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://gitlab.com/dajoha/color-print";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.3.7";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "7";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m color-print-0_3_7-93904ff317cf4c47"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name color_print \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("lazy_static", "terminfo", "terminfo_crate"))' \
        -C metadata=89f255563fd62e06 \
        -C extra-filename=-93904ff317cf4c47 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern color_print_proc_macro=${color-print-proc-macro-0_3_7-331ec64f3156ab6c}/libcolor_print_proc_macro-331ec64f3156ab6c.so \
        --cap-lints allow
      )
    '';
}
