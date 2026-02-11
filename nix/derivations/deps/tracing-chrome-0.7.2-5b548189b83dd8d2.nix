# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tracing-chrome-0_7_2-5b548189b83dd8d2";
    meta.cargo_crate_info = {
      name = "tracing-chrome";
      version = "0.7.2";
      crate_hash = "5b548189b83dd8d2";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [serde_json-1_0_139-ae78ec5bae97c420 tracing-core-0_1_33-a96acb2d986ff9b2 tracing-subscriber-0_3_19-8f98042188b2d3ba];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tracing-chrome/0.7.2/download";
      sha256 = "bf0a738ed5d6450a9fb96e86a23ad808de2b727fd1394585da5cdd6788ffe724";
    };
    unpackPhase = ''
      tar xf $src
      cd tracing-chrome-0.7.2
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "tracing_chrome";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Thoren Paulson <thoren.paulson@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A Layer for tracing-subscriber that outputs Chrome-style traces.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tracing-chrome";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/thoren-d/tracing-chrome";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.7.2";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "2";
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
              --crate-name tracing_chrome \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values())' \
              -C metadata=5b8eeb3491872aaa \
              -C extra-filename=-5b548189b83dd8d2 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern serde_json=${serde_json-1_0_139-ae78ec5bae97c420}/libserde_json-ae78ec5bae97c420.rmeta \
              --extern tracing_core=${tracing-core-0_1_33-a96acb2d986ff9b2}/libtracing_core-a96acb2d986ff9b2.rmeta \
              --extern tracing_subscriber=${tracing-subscriber-0_3_19-8f98042188b2d3ba}/libtracing_subscriber-8f98042188b2d3ba.rmeta \
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
