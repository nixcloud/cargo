# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tracing-log-0_2_0-42539ffc045b2c08";
    meta.cargo_crate_info = {
      name = "tracing-log";
      version = "0.2.0";
      crate_hash = "42539ffc045b2c08";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [log-0_4_25-7616f5eb69eb8f7e once_cell-1_20_3-60992a3834e62ae0 tracing-core-0_1_33-a96acb2d986ff9b2];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tracing-log/0.2.0/download";
      sha256 = "ee855f1f400bd0e5c02d150ae5de3840039a3f54b025156404e34c23c03f47c3";
    };
    unpackPhase = ''
      tar xf $src
      cd tracing-log-0.2.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "tracing_log";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Tokio Contributors <team@tokio.rs>";
    CARGO_PKG_DESCRIPTION = "Provides compatibility between `tracing` and the `log` crate.";
    CARGO_PKG_HOMEPAGE = "https://tokio.rs";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tracing-log";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/tokio-rs/tracing";
    CARGO_PKG_RUST_VERSION = "1.56.0";
    CARGO_PKG_VERSION = "0.2.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "0";
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
              --crate-name tracing_log \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="log-tracer"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("ahash", "default", "interest-cache", "log-tracer", "lru", "std"))' \
              -C metadata=811cb77bed489c72 \
              -C extra-filename=-42539ffc045b2c08 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern log=${log-0_4_25-7616f5eb69eb8f7e}/liblog-7616f5eb69eb8f7e.rmeta \
              --extern once_cell=${once_cell-1_20_3-60992a3834e62ae0}/libonce_cell-60992a3834e62ae0.rmeta \
              --extern tracing_core=${tracing-core-0_1_33-a96acb2d986ff9b2}/libtracing_core-a96acb2d986ff9b2.rmeta \
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
