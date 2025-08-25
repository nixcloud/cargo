# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-util-0_2_20-e1e52a96aad3a2c8";
    meta.cargo_crate_info = {
      name = "cargo-util";
      version = "0.2.20";
      crate_hash = "e1e52a96aad3a2c8";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [anyhow-1_0_96-08accda0b9ade607 filetime-0_2_25-862af764b19c0992 hex-0_4_3-dd0d71cb863a3089 ignore-0_4_23-853f4c5fbe46d77c jobserver-0_1_32-11f288c905f4bb8b libc-0_2_170-d46a143b0470970d same-file-1_0_6-fa3759c6ae4b4446 sha2-0_10_8-b220b83b63166903 shell-escape-0_1_5-3e2e155bbe040858 tempfile-3_17_1-54a70dc79c182b90 tracing-0_1_41-4ef8fb354e141157 walkdir-2_5_0-edbfc6d2b455f0bf];
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

    CARGO_CRATE_NAME = "cargo_util";
    CARGO_MANIFEST_DIR = "./crates/cargo-util";
    CARGO_MANIFEST_PATH = "./crates/cargo-util/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Miscellaneous support code used by Cargo.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo-util";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.2.20";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "20";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m cargo-util-0_2_20-e1e52a96aad3a2c8"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name cargo_util \
        --edition=2021 crates/cargo-util/src/lib.rs \
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
        -C metadata=1b3b8c475a896ff7 \
        -C extra-filename=-e1e52a96aad3a2c8 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern anyhow=${anyhow-1_0_96-08accda0b9ade607}/libanyhow-08accda0b9ade607.rmeta \
        --extern filetime=${filetime-0_2_25-862af764b19c0992}/libfiletime-862af764b19c0992.rmeta \
        --extern hex=${hex-0_4_3-dd0d71cb863a3089}/libhex-dd0d71cb863a3089.rmeta \
        --extern ignore=${ignore-0_4_23-853f4c5fbe46d77c}/libignore-853f4c5fbe46d77c.rmeta \
        --extern jobserver=${jobserver-0_1_32-11f288c905f4bb8b}/libjobserver-11f288c905f4bb8b.rmeta \
        --extern libc=${libc-0_2_170-d46a143b0470970d}/liblibc-d46a143b0470970d.rmeta \
        --extern same_file=${same-file-1_0_6-fa3759c6ae4b4446}/libsame_file-fa3759c6ae4b4446.rmeta \
        --extern sha2=${sha2-0_10_8-b220b83b63166903}/libsha2-b220b83b63166903.rmeta \
        --extern shell_escape=${shell-escape-0_1_5-3e2e155bbe040858}/libshell_escape-3e2e155bbe040858.rmeta \
        --extern tempfile=${tempfile-3_17_1-54a70dc79c182b90}/libtempfile-54a70dc79c182b90.rmeta \
        --extern tracing=${tracing-0_1_41-4ef8fb354e141157}/libtracing-4ef8fb354e141157.rmeta \
        --extern walkdir=${walkdir-2_5_0-edbfc6d2b455f0bf}/libwalkdir-edbfc6d2b455f0bf.rmeta
      )
    '';
}
