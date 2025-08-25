# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "url-2_5_4-f84eb31ea66b0c06";
    meta.cargo_crate_info = {
      name = "url";
      version = "2.5.4";
      crate_hash = "f84eb31ea66b0c06";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [form_urlencoded-1_2_1-25d070486319ce04 idna-1_0_3-fadc64e27f50ac22 percent-encoding-2_3_1-3c9d9c63ad89d268];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/url/2.5.4/download";
      sha256 = "32f8b686cadd1473f4bd0117a5d28d36b1ade384ea9b5069a1c40aefed7fda60";
    };
    unpackPhase = ''
      tar xf $src
      cd url-2.5.4
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "url";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The rust-url developers";
    CARGO_PKG_DESCRIPTION = "URL library for Rust, based on the WHATWG URL Standard";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "url";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/servo/rust-url";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "2.5.4";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "5";
    CARGO_PKG_VERSION_PATCH = "4";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m url-2_5_4-f84eb31ea66b0c06"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name url \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("debugger_visualizer", "default", "expose_internals", "serde", "std"))' \
        -C metadata=e4c854254ca3ca3a \
        -C extra-filename=-f84eb31ea66b0c06 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern form_urlencoded=${form_urlencoded-1_2_1-25d070486319ce04}/libform_urlencoded-25d070486319ce04.rmeta \
        --extern idna=${idna-1_0_3-fadc64e27f50ac22}/libidna-fadc64e27f50ac22.rmeta \
        --extern percent_encoding=${percent-encoding-2_3_1-3c9d9c63ad89d268}/libpercent_encoding-3c9d9c63ad89d268.rmeta \
        --cap-lints allow
      )
    '';
}
