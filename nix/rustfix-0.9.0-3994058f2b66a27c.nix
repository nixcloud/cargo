# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "rustfix-0_9_0-3994058f2b66a27c";
    meta.cargo_crate_info = {
      name = "rustfix";
      version = "0.9.0";
      crate_hash = "3994058f2b66a27c";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [serde-1_0_218-c4e47f01a1cedfa0 serde_json-1_0_139-578ab230a253fef1 thiserror-2_0_11-266d93aab4cee78a tracing-0_1_41-4ef8fb354e141157];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = builtins.filterSource
      (path: type:
        let base = baseNameOf path;
        in !(base == "target" || base == "result" || builtins.match "result-*" base != null)
      ) /home/nixos/cargo;
    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "rustfix";
    CARGO_MANIFEST_DIR = "./crates/rustfix";
    CARGO_MANIFEST_PATH = "./crates/rustfix/Cargo.toml";
    CARGO_PKG_AUTHORS = "Pascal Hertleif <killercup@gmail.com>:Oliver Schneider <oli-obk@users.noreply.github.com>";
    CARGO_PKG_DESCRIPTION = "Automatically apply the suggestions made by rustc";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "rustfix";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.83";
    CARGO_PKG_VERSION = "0.9.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "9";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m rustfix-0_9_0-3994058f2b66a27c"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name rustfix \
        --edition=2021 crates/rustfix/src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        --allow=clippy::all \
        --warn=clippy::correctness \
        --warn=clippy::self_named_module_files \
        --warn=rust_2018_idioms \
        --allow=rustdoc::private_intra_doc_links \
        --warn=clippy::print_stdout \
        --warn=clippy::print_stderr \
        --warn=clippy::disallowed_methods \
        --warn=clippy::dbg_macro \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=e126f9dd05764974 \
        -C extra-filename=-3994058f2b66a27c \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern serde=${serde-1_0_218-c4e47f01a1cedfa0}/libserde-c4e47f01a1cedfa0.rmeta \
        --extern serde_json=${serde_json-1_0_139-578ab230a253fef1}/libserde_json-578ab230a253fef1.rmeta \
        --extern thiserror=${thiserror-2_0_11-266d93aab4cee78a}/libthiserror-266d93aab4cee78a.rmeta \
        --extern tracing=${tracing-0_1_41-4ef8fb354e141157}/libtracing-4ef8fb354e141157.rmeta
      )
    '';
}
