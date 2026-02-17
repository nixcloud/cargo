# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tracing-subscriber-0_3_19-8f98042188b2d3ba";
    meta.cargo_crate_info = {
      name = "tracing-subscriber";
      version = "0.3.19";
      crate_hash = "8f98042188b2d3ba";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [matchers-0_1_0-2e1fa76cca5e7310 nu-ansi-term-0_46_0-f0dd67bbc4fc7bc7 once_cell-1_20_3-60992a3834e62ae0 regex-1_11_1-c278e9a7e455d20f sharded-slab-0_1_7-10e31a831cdc1a9e smallvec-1_13_2-e5874423828ed52b thread_local-1_1_8-e251696b830b4015 tracing-0_1_41-7b5284fa1d5dcd0d tracing-core-0_1_33-a96acb2d986ff9b2 tracing-log-0_2_0-42539ffc045b2c08];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tracing-subscriber/0.3.19/download";
      sha256 = "e8189decb5ac0fa7bc8b96b7cb9b2701d60d48805aca84a238004d665fcc4008";
    };
    unpackPhase = ''
      tar xf $src
      cd tracing-subscriber-0.3.19
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "tracing_subscriber";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Eliza Weisman <eliza@buoyant.io>:David Barsky <me@davidbarsky.com>:Tokio Contributors <team@tokio.rs>";
    CARGO_PKG_DESCRIPTION = "Utilities for implementing and composing `tracing` subscribers.";
    CARGO_PKG_HOMEPAGE = "https://tokio.rs";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tracing-subscriber";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/tokio-rs/tracing";
    CARGO_PKG_RUST_VERSION = "1.63.0";
    CARGO_PKG_VERSION = "0.3.19";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "19";
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
              --crate-name tracing_subscriber \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --warn=unexpected_cfgs \
              --check-cfg 'cfg(flaky_tests)' \
              --check-cfg 'cfg(tracing_unstable)' \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --cfg 'feature="ansi"' \
              --cfg 'feature="default"' \
              --cfg 'feature="env-filter"' \
              --cfg 'feature="fmt"' \
              --cfg 'feature="matchers"' \
              --cfg 'feature="nu-ansi-term"' \
              --cfg 'feature="once_cell"' \
              --cfg 'feature="regex"' \
              --cfg 'feature="registry"' \
              --cfg 'feature="sharded-slab"' \
              --cfg 'feature="smallvec"' \
              --cfg 'feature="std"' \
              --cfg 'feature="thread_local"' \
              --cfg 'feature="tracing"' \
              --cfg 'feature="tracing-log"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "ansi", "chrono", "default", "env-filter", "fmt", "json", "local-time", "matchers", "nu-ansi-term", "once_cell", "parking_lot", "regex", "registry", "serde", "serde_json", "sharded-slab", "smallvec", "std", "thread_local", "time", "tracing", "tracing-log", "tracing-serde", "valuable", "valuable-serde", "valuable_crate"))' \
              -C metadata=aef3962e9afd83db \
              -C extra-filename=-8f98042188b2d3ba \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern matchers=${matchers-0_1_0-2e1fa76cca5e7310}/libmatchers-2e1fa76cca5e7310.rmeta \
              --extern nu_ansi_term=${nu-ansi-term-0_46_0-f0dd67bbc4fc7bc7}/libnu_ansi_term-f0dd67bbc4fc7bc7.rmeta \
              --extern once_cell=${once_cell-1_20_3-60992a3834e62ae0}/libonce_cell-60992a3834e62ae0.rmeta \
              --extern regex=${regex-1_11_1-c278e9a7e455d20f}/libregex-c278e9a7e455d20f.rmeta \
              --extern sharded_slab=${sharded-slab-0_1_7-10e31a831cdc1a9e}/libsharded_slab-10e31a831cdc1a9e.rmeta \
              --extern smallvec=${smallvec-1_13_2-e5874423828ed52b}/libsmallvec-e5874423828ed52b.rmeta \
              --extern thread_local=${thread_local-1_1_8-e251696b830b4015}/libthread_local-e251696b830b4015.rmeta \
              --extern tracing=${tracing-0_1_41-7b5284fa1d5dcd0d}/libtracing-7b5284fa1d5dcd0d.rmeta \
              --extern tracing_core=${tracing-core-0_1_33-a96acb2d986ff9b2}/libtracing_core-a96acb2d986ff9b2.rmeta \
              --extern tracing_log=${tracing-log-0_2_0-42539ffc045b2c08}/libtracing_log-42539ffc045b2c08.rmeta \
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
