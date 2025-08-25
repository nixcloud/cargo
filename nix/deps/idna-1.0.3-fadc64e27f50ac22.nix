# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "idna-1_0_3-fadc64e27f50ac22";
    meta.cargo_crate_info = {
      name = "idna";
      version = "1.0.3";
      crate_hash = "fadc64e27f50ac22";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [idna_adapter-1_2_0-7d17ccbf2ca41a29 smallvec-1_13_2-453c588ad74a5894 utf8_iter-1_0_4-4dd926676127a369];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/idna/1.0.3/download";
      sha256 = "686f825264d630750a544639377bae737628043f20d38bbc029e8f29ea968a7e";
    };
    unpackPhase = ''
      tar xf $src
      cd idna-1.0.3
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "idna";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The rust-url developers";
    CARGO_PKG_DESCRIPTION = "IDNA (Internationalizing Domain Names in Applications) and Punycode.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "idna";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/servo/rust-url/";
    CARGO_PKG_RUST_VERSION = "1.57";
    CARGO_PKG_VERSION = "1.0.3";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "3";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m idna-1_0_3-fadc64e27f50ac22"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name idna \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="compiled_data"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "compiled_data", "default", "std"))' \
        -C metadata=9f3534439bb6ea71 \
        -C extra-filename=-fadc64e27f50ac22 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern idna_adapter=${idna_adapter-1_2_0-7d17ccbf2ca41a29}/libidna_adapter-7d17ccbf2ca41a29.rmeta \
        --extern smallvec=${smallvec-1_13_2-453c588ad74a5894}/libsmallvec-453c588ad74a5894.rmeta \
        --extern utf8_iter=${utf8_iter-1_0_4-4dd926676127a369}/libutf8_iter-4dd926676127a369.rmeta \
        --cap-lints allow
      )
    '';
}
