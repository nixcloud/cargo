# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "zerocopy-0_8_17-script_build-16ac01a1f5e52d2a";
    meta.cargo_crate_info = {
      name = "zerocopy";
      version = "0.8.17";
      crate_hash = "16ac01a1f5e52d2a";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/zerocopy/0.8.17/download";
      sha256 = "aa91407dacce3a68c56de03abe2760159582b846c6a4acd2f456618087f12713";
    };
    unpackPhase = ''
      tar xf $src
      cd zerocopy-0.8.17
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Joshua Liebow-Feeser <joshlf@google.com>";
    CARGO_PKG_DESCRIPTION = "Zerocopy makes zero-cost memory manipulation effortless. We write \"unsafe\" so you don't have to.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "BSD-2-Clause OR Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "zerocopy";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/google/zerocopy";
    CARGO_PKG_RUST_VERSION = "1.56.0";
    CARGO_PKG_VERSION = "0.8.17";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "17";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m zerocopy-0_8_17-script_build-16ac01a1f5e52d2a"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2021 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="simd"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("__internal_use_only_features_that_work_on_stable", "alloc", "derive", "float-nightly", "simd", "simd-nightly", "std", "zerocopy-derive"))' \
        -C metadata=6729af430a2b06ef \
        -C extra-filename=-16ac01a1f5e52d2a \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-16ac01a1f5e52d2a $OUT_DIR/build_script_build
      )
    '';
}
