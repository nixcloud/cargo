# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root, cargo-credential-0_4_8-a5adc6ab9fe103b0 }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-credential-libsecret-0_4_13-4e698a0b35f72d06";
    meta.cargo_crate_info = {
      name = "cargo-credential-libsecret";
      version = "0.4.13";
      crate_hash = "4e698a0b35f72d06";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [anyhow-1_0_96-139173be5e005a44 cargo-credential-0_4_8-a5adc6ab9fe103b0 libloading-0_8_6-2aeac1c54ae56457];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "credential/cargo-credential-libsecret/src/lib.rs"
      ];
    };
    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "cargo_credential_libsecret";
    CARGO_MANIFEST_DIR = "./credential/cargo-credential-libsecret";
    CARGO_MANIFEST_PATH = "./credential/cargo-credential-libsecret/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "A Cargo credential process that stores tokens with GNOME libsecret.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo-credential-libsecret";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.4.13";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "13";
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
              --crate-name cargo_credential_libsecret \
              --edition=2021 credential/cargo-credential-libsecret/src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
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
              -C metadata=b63e23bc179845d9 \
              -C extra-filename=-4e698a0b35f72d06 \
              --out-dir $OUT_DIR \
              -C incremental=$INC_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern anyhow=${anyhow-1_0_96-139173be5e005a44}/libanyhow-139173be5e005a44.rmeta \
              --extern cargo_credential=${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.rmeta \
              --extern libloading=${libloading-0_8_6-2aeac1c54ae56457}/liblibloading-2aeac1c54ae56457.rmeta 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
