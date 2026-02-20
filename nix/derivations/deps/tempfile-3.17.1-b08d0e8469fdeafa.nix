# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tempfile-3_17_1-b08d0e8469fdeafa";
    meta.cargo_crate_info = {
      name = "tempfile";
      version = "3.17.1";
      crate_hash = "b08d0e8469fdeafa";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [cfg-if-1_0_0-424abd49c6d5f017 fastrand-2_3_0-a6e21b8cf3724d00 getrandom-0_3_1-e63b8caed24af524 once_cell-1_20_3-65600a49c06310f1 rustix-0_38_44-bb44290fdf9a9b11];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tempfile/3.17.1/download";
      sha256 = "22e5a0acb1f3f55f65cc4a866c361b2fb2a0ff6366785ae6fbb5f85df07ba230";
    };

    unpackPhase = ''
      tar xf $src
      cd tempfile-3.17.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "tempfile";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Steven Allen <steven@stebalien.com>:The Rust Project Developers:Ashley Mannix <ashleymannix@live.com.au>:Jason White <me@jasonwhite.io>";
    CARGO_PKG_DESCRIPTION = "A library for managing temporary files and directories.";
    CARGO_PKG_HOMEPAGE = "https://stebalien.com/projects/tempfile-rs/";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tempfile";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/Stebalien/tempfile";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "3.17.1";
    CARGO_PKG_VERSION_MAJOR = "3";
    CARGO_PKG_VERSION_MINOR = "17";
    CARGO_PKG_VERSION_PATCH = "1";
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
              --crate-name tempfile \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="getrandom"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "getrandom", "nightly"))' \
              -C metadata=1899115a0b5cb3b3 \
              -C extra-filename=-b08d0e8469fdeafa \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern cfg_if=${cfg-if-1_0_0-424abd49c6d5f017}/libcfg_if-424abd49c6d5f017.rmeta \
              --extern fastrand=${fastrand-2_3_0-a6e21b8cf3724d00}/libfastrand-a6e21b8cf3724d00.rmeta \
              --extern getrandom=${getrandom-0_3_1-e63b8caed24af524}/libgetrandom-e63b8caed24af524.rmeta \
              --extern once_cell=${once_cell-1_20_3-65600a49c06310f1}/libonce_cell-65600a49c06310f1.rmeta \
              --extern rustix=${rustix-0_38_44-bb44290fdf9a9b11}/librustix-bb44290fdf9a9b11.rmeta \
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
