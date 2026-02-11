# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "color-print-proc-macro-0_3_7-37e3c528ba1c98b5";
    meta.cargo_crate_info = {
      name = "color-print-proc-macro";
      version = "0.3.7";
      crate_hash = "37e3c528ba1c98b5";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [nom-7_1_3-f13dd91924a7c5d9 proc-macro2-1_0_93-cfe81a59cf98819f quote-1_0_38-12b99e3192e30e82 syn-2_0_98-93aa0f13dad61a07];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/color-print-proc-macro/0.3.7/download";
      sha256 = "692186b5ebe54007e45a59aea47ece9eb4108e141326c304cdc91699a7118a22";
    };
    unpackPhase = ''
      tar xf $src
      cd color-print-proc-macro-0.3.7
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "color_print_proc_macro";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Johann David <johann.david.dev@protonmail.com>";
    CARGO_PKG_DESCRIPTION = "Implementation for the package color-print";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "color-print-proc-macro";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://gitlab.com/dajoha/color-print";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.3.7";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "7";
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
              --crate-name color_print_proc_macro \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type proc-macro \
              --emit=dep-info,link \
              -C prefer-dynamic \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("terminfo"))' \
              -C metadata=43cdccee8c219796 \
              -C extra-filename=-37e3c528ba1c98b5 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern nom=${nom-7_1_3-f13dd91924a7c5d9}/libnom-f13dd91924a7c5d9.rlib \
              --extern proc_macro2=${proc-macro2-1_0_93-cfe81a59cf98819f}/libproc_macro2-cfe81a59cf98819f.rlib \
              --extern quote=${quote-1_0_38-12b99e3192e30e82}/libquote-12b99e3192e30e82.rlib \
              --extern syn=${syn-2_0_98-93aa0f13dad61a07}/libsyn-93aa0f13dad61a07.rlib \
              --extern proc_macro \
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
