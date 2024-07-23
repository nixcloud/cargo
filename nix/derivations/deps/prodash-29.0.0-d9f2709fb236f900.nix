# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "prodash-29_0_0-d9f2709fb236f900";
    meta.cargo_crate_info = {
      name = "prodash";
      version = "29.0.0";
      crate_hash = "d9f2709fb236f900";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [log-0_4_25-fde7ab722b325b0e parking_lot-0_12_3-bd00df7ddce28121];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/prodash/29.0.0/download";
      sha256 = "a266d8d6020c61a437be704c5e618037588e1985c7dbb7bf8d265db84cffe325";
    };

    unpackPhase = ''
      tar xf $src
      cd prodash-29.0.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "prodash";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Sebastian Thiel <sebastian.thiel@icloud.com>";
    CARGO_PKG_DESCRIPTION = "A dashboard for visualizing progress of asynchronous and possibly blocking tasks";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "prodash";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/Byron/prodash";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "29.0.0";
    CARGO_PKG_VERSION_MAJOR = "29";
    CARGO_PKG_VERSION_MINOR = "0";
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
              --crate-name prodash \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="log"' \
              --cfg 'feature="parking_lot"' \
              --cfg 'feature="progress-tree"' \
              --cfg 'feature="progress-tree-log"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("async-io", "bytesize", "crosstermion", "ctrlc", "dashmap", "default", "futures-core", "futures-lite", "human_format", "humantime", "is-terminal", "jiff", "local-time", "log", "parking_lot", "progress-log", "progress-tree", "progress-tree-hp-hashmap", "progress-tree-log", "render-line", "render-line-autoconfigure", "render-line-crossterm", "render-tui", "render-tui-crossterm", "signal-hook", "tui", "tui-react", "unicode-segmentation", "unicode-width", "unit-bytes", "unit-duration", "unit-human"))' \
              -C metadata=3cbc763e8f10b864 \
              -C extra-filename=-d9f2709fb236f900 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern log=${log-0_4_25-fde7ab722b325b0e}/liblog-fde7ab722b325b0e.rmeta \
              --extern parking_lot=${parking_lot-0_12_3-bd00df7ddce28121}/libparking_lot-bd00df7ddce28121.rmeta \
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
