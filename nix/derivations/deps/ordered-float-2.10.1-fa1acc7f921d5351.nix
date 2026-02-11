# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "ordered-float-2_10_1-fa1acc7f921d5351";
    meta.cargo_crate_info = {
      name = "ordered-float";
      version = "2.10.1";
      crate_hash = "fa1acc7f921d5351";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [num-traits-0_2_19-8946f1ffa19e3055];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/ordered-float/2.10.1/download";
      sha256 = "68f19d67e5a2795c94e73e0bb1cc1a7edeb2e28efd39e2e1c9b7a40c1108b11c";
    };
    unpackPhase = ''
      tar xf $src
      cd ordered-float-2.10.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "ordered_float";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Jonathan Reem <jonathan.reem@gmail.com>:Matt Brubeck <mbrubeck@limpet.net>";
    CARGO_PKG_DESCRIPTION = "Wrappers for total ordering on floats";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "ordered-float";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/reem/rust-ordered-float";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "2.10.1";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "10";
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
              --crate-name ordered_float \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("arbitrary", "default", "proptest", "rand", "randtest", "rkyv", "schemars", "serde", "std"))' \
              -C metadata=c5efb08e51bbfeb0 \
              -C extra-filename=-fa1acc7f921d5351 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern num_traits=${num-traits-0_2_19-8946f1ffa19e3055}/libnum_traits-8946f1ffa19e3055.rmeta \
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
