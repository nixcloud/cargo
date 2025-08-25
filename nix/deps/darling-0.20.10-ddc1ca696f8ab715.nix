# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "darling-0_20_10-ddc1ca696f8ab715";
    meta.cargo_crate_info = {
      name = "darling";
      version = "0.20.10";
      crate_hash = "ddc1ca696f8ab715";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [darling_core-0_20_10-30d57e16863c2a7a darling_macro-0_20_10-bffd10342e61beda];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/darling/0.20.10/download";
      sha256 = "6f63b86c8a8826a49b8c21f08a2d07338eec8d900540f8630dc76284be802989";
    };
    unpackPhase = ''
      tar xf $src
      cd darling-0.20.10
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "darling";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Ted Driggs <ted.driggs@outlook.com>";
    CARGO_PKG_DESCRIPTION = "A proc-macro library for reading attributes into structs when
implementing custom derives.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "darling";
    CARGO_PKG_README = "README.md";
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

      echo -e "\e[92mCompiling\e[0m darling-0_20_10-ddc1ca696f8ab715"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name darling \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="suggestions"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "diagnostics", "suggestions"))' \
        -C metadata=1bf1ec9e50d76e2b \
        -C extra-filename=-ddc1ca696f8ab715 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern darling_core=${darling_core-0_20_10-30d57e16863c2a7a}/libdarling_core-30d57e16863c2a7a.rmeta \
        --extern darling_macro=${darling_macro-0_20_10-bffd10342e61beda}/libdarling_macro-bffd10342e61beda.so \
        --cap-lints allow
      )
    '';
}
