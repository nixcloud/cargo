# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "crossbeam-deque-0_8_6-33404d844ef9489b";
    meta.cargo_crate_info = {
      name = "crossbeam-deque";
      version = "0.8.6";
      crate_hash = "33404d844ef9489b";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [crossbeam-epoch-0_9_18-f5fba84889add492 crossbeam-utils-0_8_21-2755be6070eb63e1];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/crossbeam-deque/0.8.6/download";
      sha256 = "9dd111b7b7f7d55b72c0a6ae361660ee5853c9af73f70c3c2ef6858b950e2e51";
    };
    unpackPhase = ''
      tar xf $src
      cd crossbeam-deque-0.8.6
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "crossbeam_deque";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Concurrent work-stealing deque";
    CARGO_PKG_HOMEPAGE = "https://github.com/crossbeam-rs/crossbeam/tree/master/crossbeam-deque";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "crossbeam-deque";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/crossbeam-rs/crossbeam";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "0.8.6";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "6";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      ${fn.import_bash_function_helpers}
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)
      
      mkdir -p $out/nix
      export OUT_DIR=$out

      print_compiling_message "${name}"
      print_cargo_message_type_0 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name crossbeam_deque \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --warn=unexpected_cfgs \
              --allow=clippy::lint_groups_priority \
              --allow=clippy::declare_interior_mutable_const \
              --check-cfg 'cfg(crossbeam_loom)' \
              --check-cfg 'cfg(crossbeam_sanitize)' \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "std"))' \
              -C metadata=36f0a8f0888effab \
              -C extra-filename=-33404d844ef9489b \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern crossbeam_epoch=${crossbeam-epoch-0_9_18-f5fba84889add492}/libcrossbeam_epoch-f5fba84889add492.rmeta \
              --extern crossbeam_utils=${crossbeam-utils-0_8_21-2755be6070eb63e1}/libcrossbeam_utils-2755be6070eb63e1.rmeta \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
