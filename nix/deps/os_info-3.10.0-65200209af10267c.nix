# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "os_info-3_10_0-65200209af10267c";
    meta.cargo_crate_info = {
      name = "os_info";
      version = "3.10.0";
      crate_hash = "65200209af10267c";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [log-0_4_25-f053b1d34dfd0749];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/os_info/3.10.0/download";
      sha256 = "2a604e53c24761286860eba4e2c8b23a0161526476b1de520139d69cdb85a6b5";
    };
    unpackPhase = ''
      tar xf $src
      cd os_info-3.10.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "os_info";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Jan Schulte <hello@unexpected-co.de>:Stanislav Tkach <stanislav.tkach@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Detect the operating system type and version.";
    CARGO_PKG_HOMEPAGE = "https://github.com/stanislav-tkach/os_info";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "os_info";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/stanislav-tkach/os_info";
    CARGO_PKG_RUST_VERSION = "1.60";
    CARGO_PKG_VERSION = "3.10.0";
    CARGO_PKG_VERSION_MAJOR = "3";
    CARGO_PKG_VERSION_MINOR = "10";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m os_info-3_10_0-65200209af10267c"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name os_info \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "serde"))' \
        -C metadata=ea38e98c04fd9571 \
        -C extra-filename=-65200209af10267c \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern log=${log-0_4_25-f053b1d34dfd0749}/liblog-f053b1d34dfd0749.rmeta \
        --cap-lints allow
      )
    '';
}
