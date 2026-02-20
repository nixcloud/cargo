# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tracing-subscriber-0_3_19-5f4c4d18551b276c";
    meta.cargo_crate_info = {
      name = "tracing-subscriber";
      version = "0.3.19";
      crate_hash = "5f4c4d18551b276c";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [matchers-0_1_0-cf1bfca3c1f785d1 nu-ansi-term-0_46_0-7a72ea8fdd3dc3c3 once_cell-1_20_3-65600a49c06310f1 regex-1_11_1-78f28ee524c2cf84 sharded-slab-0_1_7-36acbe64fa71ca81 smallvec-1_13_2-0ef9b24879be6fdc thread_local-1_1_8-c649412a866b5e65 tracing-0_1_41-f95fa3c0b6430cd1 tracing-core-0_1_33-aece38920b28e8c6 tracing-log-0_2_0-d275e906c288b142];
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
              -C opt-level=3 \
              -C embed-bitcode=no \
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
              -C metadata=2ee661eff8405cb2 \
              -C extra-filename=-5f4c4d18551b276c \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern matchers=${matchers-0_1_0-cf1bfca3c1f785d1}/libmatchers-cf1bfca3c1f785d1.rmeta \
              --extern nu_ansi_term=${nu-ansi-term-0_46_0-7a72ea8fdd3dc3c3}/libnu_ansi_term-7a72ea8fdd3dc3c3.rmeta \
              --extern once_cell=${once_cell-1_20_3-65600a49c06310f1}/libonce_cell-65600a49c06310f1.rmeta \
              --extern regex=${regex-1_11_1-78f28ee524c2cf84}/libregex-78f28ee524c2cf84.rmeta \
              --extern sharded_slab=${sharded-slab-0_1_7-36acbe64fa71ca81}/libsharded_slab-36acbe64fa71ca81.rmeta \
              --extern smallvec=${smallvec-1_13_2-0ef9b24879be6fdc}/libsmallvec-0ef9b24879be6fdc.rmeta \
              --extern thread_local=${thread_local-1_1_8-c649412a866b5e65}/libthread_local-c649412a866b5e65.rmeta \
              --extern tracing=${tracing-0_1_41-f95fa3c0b6430cd1}/libtracing-f95fa3c0b6430cd1.rmeta \
              --extern tracing_core=${tracing-core-0_1_33-aece38920b28e8c6}/libtracing_core-aece38920b28e8c6.rmeta \
              --extern tracing_log=${tracing-log-0_2_0-d275e906c288b142}/libtracing_log-d275e906c288b142.rmeta \
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
