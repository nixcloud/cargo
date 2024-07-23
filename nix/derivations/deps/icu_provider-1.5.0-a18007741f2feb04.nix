# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_provider-1_5_0-a18007741f2feb04";
    meta.cargo_crate_info = {
      name = "icu_provider";
      version = "1.5.0";
      crate_hash = "a18007741f2feb04";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [displaydoc-0_2_5-ff04277df12d4cce icu_locid-1_5_0-91abdeb33e173e23 icu_provider_macros-1_5_0-2dc3f1777bf90bb8 stable_deref_trait-1_2_0-232ca7c28cd47370 tinystr-0_7_6-96e7f5be7ff0a0c7 writeable-0_5_5-97bfc8c1356c8584 yoke-0_7_5-0ab2f7371d50855c zerofrom-0_1_5-ea748ae3ec88a0de zerovec-0_10_4-b38efa70d7d8c99c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/icu_provider/1.5.0/download";
      sha256 = "6ed421c8a8ef78d3e2dbc98a973be2f3770cb42b606e3ab18d6237c4dfde68d9";
    };

    unpackPhase = ''
      tar xf $src
      cd icu_provider-1.5.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "icu_provider";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "Trait and struct definitions for the ICU data provider";
    CARGO_PKG_HOMEPAGE = "https://icu4x.unicode.org";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "icu_provider";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/unicode-org/icu4x";
    CARGO_PKG_RUST_VERSION = "1.67";
    CARGO_PKG_VERSION = "1.5.0";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "5";
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
              --crate-name icu_provider \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="macros"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("bench", "datagen", "deserialize_bincode_1", "deserialize_json", "deserialize_postcard_1", "experimental", "log_error_context", "logging", "macros", "serde", "std", "sync"))' \
              -C metadata=9b77c871fffd9096 \
              -C extra-filename=-a18007741f2feb04 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern displaydoc=${displaydoc-0_2_5-ff04277df12d4cce}/libdisplaydoc-ff04277df12d4cce.so \
              --extern icu_locid=${icu_locid-1_5_0-91abdeb33e173e23}/libicu_locid-91abdeb33e173e23.rmeta \
              --extern icu_provider_macros=${icu_provider_macros-1_5_0-2dc3f1777bf90bb8}/libicu_provider_macros-2dc3f1777bf90bb8.so \
              --extern stable_deref_trait=${stable_deref_trait-1_2_0-232ca7c28cd47370}/libstable_deref_trait-232ca7c28cd47370.rmeta \
              --extern tinystr=${tinystr-0_7_6-96e7f5be7ff0a0c7}/libtinystr-96e7f5be7ff0a0c7.rmeta \
              --extern writeable=${writeable-0_5_5-97bfc8c1356c8584}/libwriteable-97bfc8c1356c8584.rmeta \
              --extern yoke=${yoke-0_7_5-0ab2f7371d50855c}/libyoke-0ab2f7371d50855c.rmeta \
              --extern zerofrom=${zerofrom-0_1_5-ea748ae3ec88a0de}/libzerofrom-ea748ae3ec88a0de.rmeta \
              --extern zerovec=${zerovec-0_10_4-b38efa70d7d8c99c}/libzerovec-b38efa70d7d8c99c.rmeta \
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
