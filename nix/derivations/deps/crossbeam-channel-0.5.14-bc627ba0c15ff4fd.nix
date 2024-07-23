# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "crossbeam-channel-0_5_14-bc627ba0c15ff4fd";
    meta.cargo_crate_info = {
      name = "crossbeam-channel";
      version = "0.5.14";
      crate_hash = "bc627ba0c15ff4fd";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [crossbeam-utils-0_8_21-33005183671c1b28];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/crossbeam-channel/0.5.14/download";
      sha256 = "06ba6d68e24814cb8de6bb986db8222d3a027d15872cabc0d18817bc3c0e4471";
    };

    unpackPhase = ''
      tar xf $src
      cd crossbeam-channel-0.5.14
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "crossbeam_channel";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Multi-producer multi-consumer channels for message passing";
    CARGO_PKG_HOMEPAGE = "https://github.com/crossbeam-rs/crossbeam/tree/master/crossbeam-channel";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "crossbeam-channel";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/crossbeam-rs/crossbeam";
    CARGO_PKG_RUST_VERSION = "1.60";
    CARGO_PKG_VERSION = "0.5.14";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "5";
    CARGO_PKG_VERSION_PATCH = "14";
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
              --crate-name crossbeam_channel \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
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
              -C metadata=663b3b3c53df1b88 \
              -C extra-filename=-bc627ba0c15ff4fd \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern crossbeam_utils=${crossbeam-utils-0_8_21-33005183671c1b28}/libcrossbeam_utils-33005183671c1b28.rmeta \
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
