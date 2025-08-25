# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tinyvec-1_8_1-baa23f723564fa79";
    meta.cargo_crate_info = {
      name = "tinyvec";
      version = "1.8.1";
      crate_hash = "baa23f723564fa79";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [tinyvec_macros-0_1_1-f1e26974e998ba99];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tinyvec/1.8.1/download";
      sha256 = "022db8904dfa342efe721985167e9fcd16c29b226db4397ed752a761cfce81e8";
    };
    unpackPhase = ''
      tar xf $src
      cd tinyvec-1.8.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "tinyvec";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Lokathor <zefria@gmail.com>";
    CARGO_PKG_DESCRIPTION = "`tinyvec` provides 100% safe vec-like data structures.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Zlib OR Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tinyvec";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/Lokathor/tinyvec";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "1.8.1";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m tinyvec-1_8_1-baa23f723564fa79"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name tinyvec \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="default"' \
        --cfg 'feature="tinyvec_macros"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "arbitrary", "debugger_visualizer", "default", "experimental_write_impl", "grab_spare_slice", "nightly_slice_partition_dedup", "real_blackbox", "rustc_1_40", "rustc_1_55", "rustc_1_57", "rustc_1_61", "serde", "std", "tinyvec_macros"))' \
        -C metadata=b29cc7cbce3adfc3 \
        -C extra-filename=-baa23f723564fa79 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern tinyvec_macros=${tinyvec_macros-0_1_1-f1e26974e998ba99}/libtinyvec_macros-f1e26974e998ba99.rmeta \
        --cap-lints allow
      )
    '';
}
