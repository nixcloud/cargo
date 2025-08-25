# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "ahash-0_8_11-script_build-49923e8374b98165";
    meta.cargo_crate_info = {
      name = "ahash";
      version = "0.8.11";
      crate_hash = "49923e8374b98165";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [version_check-0_9_5-284e8375b5dd3310];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/ahash/0.8.11/download";
      sha256 = "e89da841a80418a9b391ebaea17f5c112ffaaa96f621d2c285b5174da76b9011";
    };
    unpackPhase = ''
      tar xf $src
      cd ahash-0.8.11
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Tom Kaitchuck <Tom.Kaitchuck@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A non-cryptographic hash function using AES-NI for high performance";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "ahash";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/tkaitchuck/ahash";
    CARGO_PKG_RUST_VERSION = "1.60.0";
    CARGO_PKG_VERSION = "0.8.11";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "11";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m ahash-0_8_11-script_build-49923e8374b98165"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2018 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("atomic-polyfill", "compile-time-rng", "const-random", "default", "getrandom", "nightly-arm-aes", "no-rng", "runtime-rng", "serde", "std"))' \
        -C metadata=acd0cba1e3da909c \
        -C extra-filename=-49923e8374b98165 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern version_check=${version_check-0_9_5-284e8375b5dd3310}/libversion_check-284e8375b5dd3310.rlib \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-49923e8374b98165 $OUT_DIR/build_script_build
      )
    '';
}
