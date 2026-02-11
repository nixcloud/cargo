# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tempfile-3_17_1-94ecc3046797cc75";
    meta.cargo_crate_info = {
      name = "tempfile";
      version = "3.17.1";
      crate_hash = "94ecc3046797cc75";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [cfg-if-1_0_0-616d46354eebf850 fastrand-2_3_0-02ab7f4546011650 getrandom-0_3_1-f98539da635491d1 once_cell-1_20_3-60992a3834e62ae0 rustix-0_38_44-83758b3e1a43a320];
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
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="getrandom"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "getrandom", "nightly"))' \
              -C metadata=5904ae41f20bff3d \
              -C extra-filename=-94ecc3046797cc75 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern cfg_if=${cfg-if-1_0_0-616d46354eebf850}/libcfg_if-616d46354eebf850.rmeta \
              --extern fastrand=${fastrand-2_3_0-02ab7f4546011650}/libfastrand-02ab7f4546011650.rmeta \
              --extern getrandom=${getrandom-0_3_1-f98539da635491d1}/libgetrandom-f98539da635491d1.rmeta \
              --extern once_cell=${once_cell-1_20_3-60992a3834e62ae0}/libonce_cell-60992a3834e62ae0.rmeta \
              --extern rustix=${rustix-0_38_44-83758b3e1a43a320}/librustix-83758b3e1a43a320.rmeta \
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
