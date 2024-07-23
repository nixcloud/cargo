# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-credential-0_4_8-04d496e2b8c4b2ba";
    meta.cargo_crate_info = {
      name = "cargo-credential";
      version = "0.4.8";
      crate_hash = "04d496e2b8c4b2ba";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [anyhow-1_0_96-61bbc4e08b05614c libc-0_2_175-b265bb513a0388f3 serde-1_0_218-ed8707ff8dc168e7 serde_json-1_0_139-17182eb61f3853cc thiserror-2_0_11-c6c4ee382aacde15 time-0_3_37-470f9c4ebcfb97a1];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "credential/cargo-credential/src/lib.rs"
        "credential/cargo-credential/src/error.rs"
        "credential/cargo-credential/src/secret.rs"
        "credential/cargo-credential/src/stdio.rs"
        "credential/cargo-credential/src/../examples/file-provider.rs"
      ];
    };

    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "cargo_credential";
    CARGO_MANIFEST_DIR = "./credential/cargo-credential";
    CARGO_MANIFEST_PATH = "./credential/cargo-credential/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "A library to assist writing Cargo credential helpers.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo-credential";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.83";
    CARGO_PKG_VERSION = "0.4.8";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "8";
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
              --crate-name cargo_credential \
              --edition=2021 credential/cargo-credential/src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
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
              -C metadata=ff7f1ebe4c279053 \
              -C extra-filename=-04d496e2b8c4b2ba \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern anyhow=${anyhow-1_0_96-61bbc4e08b05614c}/libanyhow-61bbc4e08b05614c.rmeta \
              --extern libc=${libc-0_2_175-b265bb513a0388f3}/liblibc-b265bb513a0388f3.rmeta \
              --extern serde=${serde-1_0_218-ed8707ff8dc168e7}/libserde-ed8707ff8dc168e7.rmeta \
              --extern serde_json=${serde_json-1_0_139-17182eb61f3853cc}/libserde_json-17182eb61f3853cc.rmeta \
              --extern thiserror=${thiserror-2_0_11-c6c4ee382aacde15}/libthiserror-c6c4ee382aacde15.rmeta \
              --extern time=${time-0_3_37-470f9c4ebcfb97a1}/libtime-470f9c4ebcfb97a1.rmeta 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
