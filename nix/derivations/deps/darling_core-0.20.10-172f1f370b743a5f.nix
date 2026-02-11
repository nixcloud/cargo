# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "darling_core-0_20_10-172f1f370b743a5f";
    meta.cargo_crate_info = {
      name = "darling_core";
      version = "0.20.10";
      crate_hash = "172f1f370b743a5f";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [fnv-1_0_7-e86d9923dc926ea6 ident_case-1_0_1-2dc10d9b37d5f124 proc-macro2-1_0_93-cfe81a59cf98819f quote-1_0_38-12b99e3192e30e82 strsim-0_11_1-08697f8fab7ff2ae syn-2_0_98-93aa0f13dad61a07];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/darling_core/0.20.10/download";
      sha256 = "95133861a8032aaea082871032f5815eb9e98cef03fa916ab4500513994df9e5";
    };
    unpackPhase = ''
      tar xf $src
      cd darling_core-0.20.10
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "darling_core";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Ted Driggs <ted.driggs@outlook.com>";
    CARGO_PKG_DESCRIPTION = "Helper crate for proc-macro library for reading attributes into structs when
implementing custom derives. Use https://crates.io/crates/darling in your code.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "darling_core";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/TedDriggs/darling";
    CARGO_PKG_RUST_VERSION = "1.56";
    CARGO_PKG_VERSION = "0.20.10";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "20";
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
              --crate-name darling_core \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="strsim"' \
              --cfg 'feature="suggestions"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("diagnostics", "strsim", "suggestions"))' \
              -C metadata=9433e817f2fb57c3 \
              -C extra-filename=-172f1f370b743a5f \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern fnv=${fnv-1_0_7-e86d9923dc926ea6}/libfnv-e86d9923dc926ea6.rmeta \
              --extern ident_case=${ident_case-1_0_1-2dc10d9b37d5f124}/libident_case-2dc10d9b37d5f124.rmeta \
              --extern proc_macro2=${proc-macro2-1_0_93-cfe81a59cf98819f}/libproc_macro2-cfe81a59cf98819f.rmeta \
              --extern quote=${quote-1_0_38-12b99e3192e30e82}/libquote-12b99e3192e30e82.rmeta \
              --extern strsim=${strsim-0_11_1-08697f8fab7ff2ae}/libstrsim-08697f8fab7ff2ae.rmeta \
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
