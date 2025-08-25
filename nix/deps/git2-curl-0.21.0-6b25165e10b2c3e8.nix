# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "git2-curl-0_21_0-6b25165e10b2c3e8";
    meta.cargo_crate_info = {
      name = "git2-curl";
      version = "0.21.0";
      crate_hash = "6b25165e10b2c3e8";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [curl-0_4_47-4c74e17a5eefce17 git2-0_20_0-73cd3d9b5537d1b3 log-0_4_25-f053b1d34dfd0749 url-2_5_4-f84eb31ea66b0c06];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/git2-curl/0.21.0/download";
      sha256 = "be8dcabbc09ece4d30a9aa983d5804203b7e2f8054a171f792deff59b56d31fa";
    };
    unpackPhase = ''
      tar xf $src
      cd git2-curl-0.21.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "git2_curl";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Josh Triplett <josh@joshtriplett.org>:Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Backend for an HTTP transport in libgit2 powered by libcurl.

Intended to be used with the git2 crate.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "git2-curl";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/git2-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.21.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "21";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m git2-curl-0_21_0-6b25165e10b2c3e8"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name git2_curl \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("zlib-ng-compat"))' \
        -C metadata=a6757875d97ae488 \
        -C extra-filename=-6b25165e10b2c3e8 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern curl=${curl-0_4_47-4c74e17a5eefce17}/libcurl-4c74e17a5eefce17.rmeta \
        --extern git2=${git2-0_20_0-73cd3d9b5537d1b3}/libgit2-73cd3d9b5537d1b3.rmeta \
        --extern log=${log-0_4_25-f053b1d34dfd0749}/liblog-f053b1d34dfd0749.rmeta \
        --extern url=${url-2_5_4-f84eb31ea66b0c06}/liburl-f84eb31ea66b0c06.rmeta \
        --cap-lints allow
      )
    '';
}
