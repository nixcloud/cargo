# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tracing-chrome-0_7_2-ac9a4cc9edeed658";
    meta.cargo_crate_info = {
      name = "tracing-chrome";
      version = "0.7.2";
      crate_hash = "ac9a4cc9edeed658";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [serde_json-1_0_139-578ab230a253fef1 tracing-core-0_1_33-f06771044d6f65f3 tracing-subscriber-0_3_19-58efa32ae6e128ef];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tracing-chrome/0.7.2/download";
      sha256 = "bf0a738ed5d6450a9fb96e86a23ad808de2b727fd1394585da5cdd6788ffe724";
    };
    unpackPhase = ''
      tar xf $src
      cd tracing-chrome-0.7.2
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "tracing_chrome";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Thoren Paulson <thoren.paulson@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A Layer for tracing-subscriber that outputs Chrome-style traces.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tracing-chrome";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/thoren-d/tracing-chrome";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.7.2";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "2";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m tracing-chrome-0_7_2-ac9a4cc9edeed658"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name tracing_chrome \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=ac14e818009d13e8 \
        -C extra-filename=-ac9a4cc9edeed658 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern serde_json=${serde_json-1_0_139-578ab230a253fef1}/libserde_json-578ab230a253fef1.rmeta \
        --extern tracing_core=${tracing-core-0_1_33-f06771044d6f65f3}/libtracing_core-f06771044d6f65f3.rmeta \
        --extern tracing_subscriber=${tracing-subscriber-0_3_19-58efa32ae6e128ef}/libtracing_subscriber-58efa32ae6e128ef.rmeta \
        --cap-lints allow
      )
    '';
}
