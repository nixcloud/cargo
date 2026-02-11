# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "crates-io-0_40_10-cb0425982b906266";
    meta.cargo_crate_info = {
      name = "crates-io";
      version = "0.40.10";
      crate_hash = "cb0425982b906266";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [curl-0_4_47-f684c2bd7b0f950d percent-encoding-2_3_1-e8b9e34a5db857ef serde-1_0_218-472e28b9f131b02c serde_json-1_0_139-ae78ec5bae97c420 thiserror-2_0_11-a57592ffa4ea41e0 url-2_5_4-7b68be8bb56d0713];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";


    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "crates/crates-io/lib.rs"
      ];
    };
    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "crates_io";
    CARGO_MANIFEST_DIR = "./crates/crates-io";
    CARGO_MANIFEST_PATH = "./crates/crates-io/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Helpers for interacting with crates.io";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "crates-io";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.40.10";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "40";
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
              --crate-name crates_io \
              --edition=2021 crates/crates-io/lib.rs \
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
              -C metadata=db61783e969f2888 \
              -C extra-filename=-cb0425982b906266 \
              --out-dir $OUT_DIR \
              -C incremental=$INC_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern curl=${curl-0_4_47-f684c2bd7b0f950d}/libcurl-f684c2bd7b0f950d.rmeta \
              --extern percent_encoding=${percent-encoding-2_3_1-e8b9e34a5db857ef}/libpercent_encoding-e8b9e34a5db857ef.rmeta \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
              --extern serde_json=${serde_json-1_0_139-ae78ec5bae97c420}/libserde_json-ae78ec5bae97c420.rmeta \
              --extern thiserror=${thiserror-2_0_11-a57592ffa4ea41e0}/libthiserror-a57592ffa4ea41e0.rmeta \
              --extern url=${url-2_5_4-7b68be8bb56d0713}/liburl-7b68be8bb56d0713.rmeta 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
