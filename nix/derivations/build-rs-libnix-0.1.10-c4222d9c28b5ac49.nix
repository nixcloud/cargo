# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "build-rs-libnix-0_1_10-c4222d9c28b5ac49";
    meta.cargo_crate_info = {
      name = "build-rs-libnix";
      version = "0.1.10";
      crate_hash = "c4222d9c28b5ac49";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [anyhow-1_0_96-139173be5e005a44 clap-4_5_31-a6f5f68162f5c661 colored-3_1_1-c3f17f7b73321ed9 regex-1_11_1-c278e9a7e455d20f];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "crates/build-rs-libnix/src/lib.rs"
        "crates/build-rs-libnix/src/tests.rs"
      ];
    };

    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "build_rs_libnix";
    CARGO_MANIFEST_DIR = "./crates/build-rs-libnix";
    CARGO_MANIFEST_PATH = "./crates/build-rs-libnix/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "build-rs-libnix";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.83";
    CARGO_PKG_VERSION = "0.1.10";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "10";
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
              --crate-name build_rs_libnix \
              --edition=2021 crates/build-rs-libnix/src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values())' \
              -C metadata=2809509b08d0fa29 \
              -C extra-filename=-c4222d9c28b5ac49 \
              --out-dir $OUT_DIR \
              -C incremental=$INC_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern anyhow=${anyhow-1_0_96-139173be5e005a44}/libanyhow-139173be5e005a44.rmeta \
              --extern clap=${clap-4_5_31-a6f5f68162f5c661}/libclap-a6f5f68162f5c661.rmeta \
              --extern colored=${colored-3_1_1-c3f17f7b73321ed9}/libcolored-c3f17f7b73321ed9.rmeta \
              --extern regex=${regex-1_11_1-c278e9a7e455d20f}/libregex-c278e9a7e455d20f.rmeta 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
