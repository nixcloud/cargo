# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "darling_core-0_20_10-30d57e16863c2a7a";
    meta.cargo_crate_info = {
      name = "darling_core";
      version = "0.20.10";
      crate_hash = "30d57e16863c2a7a";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [fnv-1_0_7-e363583e1b6fdae8 ident_case-1_0_1-a638840d0ec16955 proc-macro2-1_0_93-e285fc8594787700 quote-1_0_38-5b0706e2cc2f4ea8 strsim-0_11_1-cd89ec10c58c8c9e syn-2_0_98-2ed9ce1dac2090c2];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/darling_core/0.20.10/download";
      sha256 = "95133861a8032aaea082871032f5815eb9e98cef03fa916ab4500513994df9e5";
    };
    unpackPhase = ''
      tar xf $src
      cd darling_core-0.20.10
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "darling_core";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Ted Driggs <ted.driggs@outlook.com>";
    CARGO_PKG_DESCRIPTION = "Helper crate for proc-macro library for reading attributes into structs when
implementing custom derives. Use https://crates.io/crates/darling in your code.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "darling_core";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/TedDriggs/darling";
    CARGO_PKG_RUST_VERSION = "1.56";
    CARGO_PKG_VERSION = "0.20.10";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "20";
    CARGO_PKG_VERSION_PATCH = "10";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m darling_core-0_20_10-30d57e16863c2a7a"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name darling_core \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="strsim"' \
        --cfg 'feature="suggestions"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("diagnostics", "strsim", "suggestions"))' \
        -C metadata=f7f70b075b6bcfbf \
        -C extra-filename=-30d57e16863c2a7a \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern fnv=${fnv-1_0_7-e363583e1b6fdae8}/libfnv-e363583e1b6fdae8.rmeta \
        --extern ident_case=${ident_case-1_0_1-a638840d0ec16955}/libident_case-a638840d0ec16955.rmeta \
        --extern proc_macro2=${proc-macro2-1_0_93-e285fc8594787700}/libproc_macro2-e285fc8594787700.rmeta \
        --extern quote=${quote-1_0_38-5b0706e2cc2f4ea8}/libquote-5b0706e2cc2f4ea8.rmeta \
        --extern strsim=${strsim-0_11_1-cd89ec10c58c8c9e}/libstrsim-cd89ec10c58c8c9e.rmeta \
        --extern syn=${syn-2_0_98-2ed9ce1dac2090c2}/libsyn-2ed9ce1dac2090c2.rmeta \
        --cap-lints allow
      )
    '';
}
