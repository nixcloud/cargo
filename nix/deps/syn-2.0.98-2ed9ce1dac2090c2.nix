# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "syn-2_0_98-2ed9ce1dac2090c2";
    meta.cargo_crate_info = {
      name = "syn";
      version = "2.0.98";
      crate_hash = "2ed9ce1dac2090c2";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [proc-macro2-1_0_93-e285fc8594787700 quote-1_0_38-5b0706e2cc2f4ea8 unicode-ident-1_0_17-99075dc129e34e77];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/syn/2.0.98/download";
      sha256 = "36147f1a48ae0ec2b5b3bc5b537d267457555a10dc06f3dbc8cb11ba3006d3b1";
    };
    unpackPhase = ''
      tar xf $src
      cd syn-2.0.98
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "syn";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "David Tolnay <dtolnay@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Parser for Rust source code";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "syn";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/dtolnay/syn";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "2.0.98";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "98";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m syn-2_0_98-2ed9ce1dac2090c2"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name syn \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="clone-impls"' \
        --cfg 'feature="default"' \
        --cfg 'feature="derive"' \
        --cfg 'feature="extra-traits"' \
        --cfg 'feature="fold"' \
        --cfg 'feature="full"' \
        --cfg 'feature="parsing"' \
        --cfg 'feature="printing"' \
        --cfg 'feature="proc-macro"' \
        --cfg 'feature="visit"' \
        --cfg 'feature="visit-mut"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("clone-impls", "default", "derive", "extra-traits", "fold", "full", "parsing", "printing", "proc-macro", "test", "visit", "visit-mut"))' \
        -C metadata=4f935bb5b2f27df9 \
        -C extra-filename=-2ed9ce1dac2090c2 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern proc_macro2=${proc-macro2-1_0_93-e285fc8594787700}/libproc_macro2-e285fc8594787700.rmeta \
        --extern quote=${quote-1_0_38-5b0706e2cc2f4ea8}/libquote-5b0706e2cc2f4ea8.rmeta \
        --extern unicode_ident=${unicode-ident-1_0_17-99075dc129e34e77}/libunicode_ident-99075dc129e34e77.rmeta \
        --cap-lints allow
      )
    '';
}
