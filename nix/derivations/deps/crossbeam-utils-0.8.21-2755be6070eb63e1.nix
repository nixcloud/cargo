# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "crossbeam-utils-0_8_21-2755be6070eb63e1";
    meta.cargo_crate_info = {
      name = "crossbeam-utils";
      version = "0.8.21";
      crate_hash = "2755be6070eb63e1";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [crossbeam-utils-0_8_21-script_build_run-fe6d54db4bf41090];
    passthru.rust_script_build_run = [crossbeam-utils-0_8_21-script_build_run-fe6d54db4bf41090];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/crossbeam-utils/0.8.21/download";
      sha256 = "d0a5c400df2834b80a4c3327b3aad3a4c4cd4de0629063962b03235697506a28";
    };
    unpackPhase = ''
      tar xf $src
      cd crossbeam-utils-0.8.21
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "crossbeam_utils";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Utilities for concurrent programming";
    CARGO_PKG_HOMEPAGE = "https://github.com/crossbeam-rs/crossbeam/tree/master/crossbeam-utils";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "crossbeam-utils";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/crossbeam-rs/crossbeam";
    CARGO_PKG_RUST_VERSION = "1.60";
    CARGO_PKG_VERSION = "0.8.21";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "21";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      ${fn.import_bash_function_helpers}
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)
      
      mkdir -p $out/nix
      export OUT_DIR=$out

      print_compiling_message "${name}"
      print_cargo_message_type_0 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}"
      copy_build_script_run_results_over_with_nix "${fn.get_rust_crate_parent passthru.rust_crate_parent}"
      for file in $out/environment-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
          if [ -f "$file" ]; then
          sed -i "s|${fn.get_rust_crate_parent passthru.rust_crate_parent}|$out|g" "$file"
          fi
      done
      load_environment_variables_from_files "${fn.environment_variables passthru.rust_script_build_run}"
      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name crossbeam_utils \
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
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "loom", "nightly", "std"))' \
              -C metadata=97f97e476b04a4d2 \
              -C extra-filename=-2755be6070eb63e1 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
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
