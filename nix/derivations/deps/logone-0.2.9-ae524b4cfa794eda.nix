# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "logone-0_2_9-ae524b4cfa794eda";
    meta.cargo_crate_info = {
      name = "logone";
      version = "0.2.9";
      crate_hash = "ae524b4cfa794eda";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [anyhow-1_0_96-61bbc4e08b05614c chrono-0_4_42-ed2e7c7c8edbe153 clap-4_5_31-436756512d3af050 console-0_15_11-d380249dfaf73f99 crossterm-0_27_0-2318486ecaee02e1 regex-1_11_1-78f28ee524c2cf84 serde-1_0_218-ed8707ff8dc168e7 serde_json-1_0_139-17182eb61f3853cc thiserror-1_0_69-61a1a8bbaffd387d];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/logone/0.2.9/download";
      sha256 = "6e6c48f01e67da3f8e4226dd3cf7d21ce8d74d649b8e2fd71608d3168cfdcb06";
    };

    unpackPhase = ''
      tar xf $src
      cd logone-0.2.9
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "logone";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Joachim Schiele <js@lastlog.de>";
    CARGO_PKG_DESCRIPTION = "A command-line tool that parses Nix's --log-format json-internal output as standalone and crate library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "logone";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/nixcloud/logone";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.2.9";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "9";
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
              --crate-name logone \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values())' \
              -C metadata=6cefcf6d6fe921e1 \
              -C extra-filename=-ae524b4cfa794eda \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern anyhow=${anyhow-1_0_96-61bbc4e08b05614c}/libanyhow-61bbc4e08b05614c.rmeta \
              --extern chrono=${chrono-0_4_42-ed2e7c7c8edbe153}/libchrono-ed2e7c7c8edbe153.rmeta \
              --extern clap=${clap-4_5_31-436756512d3af050}/libclap-436756512d3af050.rmeta \
              --extern console=${console-0_15_11-d380249dfaf73f99}/libconsole-d380249dfaf73f99.rmeta \
              --extern crossterm=${crossterm-0_27_0-2318486ecaee02e1}/libcrossterm-2318486ecaee02e1.rmeta \
              --extern regex=${regex-1_11_1-78f28ee524c2cf84}/libregex-78f28ee524c2cf84.rmeta \
              --extern serde=${serde-1_0_218-ed8707ff8dc168e7}/libserde-ed8707ff8dc168e7.rmeta \
              --extern serde_json=${serde_json-1_0_139-17182eb61f3853cc}/libserde_json-17182eb61f3853cc.rmeta \
              --extern thiserror=${thiserror-1_0_69-61a1a8bbaffd387d}/libthiserror-61a1a8bbaffd387d.rmeta \
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
