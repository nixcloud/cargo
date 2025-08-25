# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "matchers-0_1_0-7609a5f40b73546f";
    meta.cargo_crate_info = {
      name = "matchers";
      version = "0.1.0";
      crate_hash = "7609a5f40b73546f";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [regex-automata-0_1_10-c3b93ceea2d9380b];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/matchers/0.1.0/download";
      sha256 = "8263075bb86c5a1b1427b5ae862e8889656f126e9f77c484496e8b47cf5c5558";
    };
    unpackPhase = ''
      tar xf $src
      cd matchers-0.1.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "matchers";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Eliza Weisman <eliza@buoyant.io>";
    CARGO_PKG_DESCRIPTION = "Regex matching on character and byte streams.
";
    CARGO_PKG_HOMEPAGE = "https://github.com/hawkw/matchers";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "matchers";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/hawkw/matchers";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.1.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m matchers-0_1_0-7609a5f40b73546f"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name matchers \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=33c220cd2ca5d455 \
        -C extra-filename=-7609a5f40b73546f \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern regex_automata=${regex-automata-0_1_10-c3b93ceea2d9380b}/libregex_automata-c3b93ceea2d9380b.rmeta \
        --cap-lints allow
      )
    '';
}
