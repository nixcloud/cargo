# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_properties-1_5_1-6d849a19734066a4";
    meta.cargo_crate_info = {
      name = "icu_properties";
      version = "1.5.1";
      crate_hash = "6d849a19734066a4";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [displaydoc-0_2_5-ff04277df12d4cce icu_collections-1_5_0-90410059e9afb9fa icu_locid_transform-1_5_0-8381e4dfe84a3f83 icu_properties_data-1_5_0-c313818f7216e2a4 icu_provider-1_5_0-a18007741f2feb04 tinystr-0_7_6-96e7f5be7ff0a0c7 zerovec-0_10_4-b38efa70d7d8c99c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/icu_properties/1.5.1/download";
      sha256 = "93d6020766cfc6302c15dbbc9c8778c37e62c14427cb7f6e601d849e092aeef5";
    };

    unpackPhase = ''
      tar xf $src
      cd icu_properties-1.5.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "icu_properties";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "Definitions for Unicode properties";
    CARGO_PKG_HOMEPAGE = "https://icu4x.unicode.org";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "icu_properties";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/unicode-org/icu4x";
    CARGO_PKG_RUST_VERSION = "1.67";
    CARGO_PKG_VERSION = "1.5.1";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "5";
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
              --crate-name icu_properties \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="compiled_data"' \
              --cfg 'feature="default"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("bidi", "compiled_data", "datagen", "default", "serde", "std"))' \
              -C metadata=985e7ef52a11ca25 \
              -C extra-filename=-6d849a19734066a4 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern displaydoc=${displaydoc-0_2_5-ff04277df12d4cce}/libdisplaydoc-ff04277df12d4cce.so \
              --extern icu_collections=${icu_collections-1_5_0-90410059e9afb9fa}/libicu_collections-90410059e9afb9fa.rmeta \
              --extern icu_locid_transform=${icu_locid_transform-1_5_0-8381e4dfe84a3f83}/libicu_locid_transform-8381e4dfe84a3f83.rmeta \
              --extern icu_properties_data=${icu_properties_data-1_5_0-c313818f7216e2a4}/libicu_properties_data-c313818f7216e2a4.rmeta \
              --extern icu_provider=${icu_provider-1_5_0-a18007741f2feb04}/libicu_provider-a18007741f2feb04.rmeta \
              --extern tinystr=${tinystr-0_7_6-96e7f5be7ff0a0c7}/libtinystr-96e7f5be7ff0a0c7.rmeta \
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
