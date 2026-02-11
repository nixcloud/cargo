# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "synstructure-0_13_1-b52c6310fdbcc413";
    meta.cargo_crate_info = {
      name = "synstructure";
      version = "0.13.1";
      crate_hash = "b52c6310fdbcc413";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [proc-macro2-1_0_93-cfe81a59cf98819f quote-1_0_38-12b99e3192e30e82 syn-2_0_98-93aa0f13dad61a07];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/synstructure/0.13.1/download";
      sha256 = "c8af7666ab7b6390ab78131fb5b0fce11d6b7a6951602017c35fa82800708971";
    };
    unpackPhase = ''
      tar xf $src
      cd synstructure-0.13.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "synstructure";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Nika Layzell <nika@thelayzells.com>";
    CARGO_PKG_DESCRIPTION = "Helper methods and macros for custom derives";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "synstructure";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/mystor/synstructure";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.13.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "13";
    CARGO_PKG_VERSION_PATCH = "1";
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
              --crate-name synstructure \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="proc-macro"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "proc-macro"))' \
              -C metadata=34bf0ad8011293b3 \
              -C extra-filename=-b52c6310fdbcc413 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern proc_macro2=${proc-macro2-1_0_93-cfe81a59cf98819f}/libproc_macro2-cfe81a59cf98819f.rmeta \
              --extern quote=${quote-1_0_38-12b99e3192e30e82}/libquote-12b99e3192e30e82.rmeta \
              --extern syn=${syn-2_0_98-93aa0f13dad61a07}/libsyn-93aa0f13dad61a07.rmeta \
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
