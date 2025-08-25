# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "group-0_13_0-fffbf73b819b51c3";
    meta.cargo_crate_info = {
      name = "group";
      version = "0.13.0";
      crate_hash = "fffbf73b819b51c3";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [ff-0_13_0-d4779cf8cd3e0739 rand_core-0_6_4-fe99bd26a150a053 subtle-2_6_1-0482376bbaa3bb74];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/group/0.13.0/download";
      sha256 = "f0f9ef7462f7c099f518d754361858f86d8a07af53ba9af0fe635bbccb151a63";
    };
    unpackPhase = ''
      tar xf $src
      cd group-0.13.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "group";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Sean Bowe <ewillbefull@gmail.com>:Jack Grigg <jack@z.cash>";
    CARGO_PKG_DESCRIPTION = "Elliptic curve group traits and utilities";
    CARGO_PKG_HOMEPAGE = "https://github.com/zkcrypto/group";
    CARGO_PKG_LICENSE = "MIT/Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "group";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/zkcrypto/group";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.13.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "13";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m group-0_13_0-fffbf73b819b51c3"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name group \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "default", "memuse", "rand", "rand_xorshift", "tests", "wnaf-memuse"))' \
        -C metadata=c1412735a5430a6a \
        -C extra-filename=-fffbf73b819b51c3 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern ff=${ff-0_13_0-d4779cf8cd3e0739}/libff-d4779cf8cd3e0739.rmeta \
        --extern rand_core=${rand_core-0_6_4-fe99bd26a150a053}/librand_core-fe99bd26a150a053.rmeta \
        --extern subtle=${subtle-2_6_1-0482376bbaa3bb74}/libsubtle-0482376bbaa3bb74.rmeta \
        --cap-lints allow
      )
    '';
}
