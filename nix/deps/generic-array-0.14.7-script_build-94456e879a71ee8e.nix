# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "generic-array-0_14_7-script_build-94456e879a71ee8e";
    meta.cargo_crate_info = {
      name = "generic-array";
      version = "0.14.7";
      crate_hash = "94456e879a71ee8e";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [version_check-0_9_5-284e8375b5dd3310];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/generic-array/0.14.7/download";
      sha256 = "85649ca51fd72272d7821adaf274ad91c288277713d9c18820d8499a7ff69e9a";
    };
    unpackPhase = ''
      tar xf $src
      cd generic-array-0.14.7
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Bartłomiej Kamiński <fizyk20@gmail.com>:Aaron Trent <novacrazy@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Generic types implementing functionality of arrays";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "generic-array";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/fizyk20/generic-array.git";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.14.7";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "14";
    CARGO_PKG_VERSION_PATCH = "7";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m generic-array-0_14_7-script_build-94456e879a71ee8e"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2015 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="more_lengths"' \
        --cfg 'feature="zeroize"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("more_lengths", "serde", "zeroize"))' \
        -C metadata=2cdd84002aabaf9e \
        -C extra-filename=-94456e879a71ee8e \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern version_check=${version_check-0_9_5-284e8375b5dd3310}/libversion_check-284e8375b5dd3310.rlib \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-94456e879a71ee8e $OUT_DIR/build_script_build
      )
    '';
}
