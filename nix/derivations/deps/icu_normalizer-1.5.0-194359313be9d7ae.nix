# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_normalizer-1_5_0-194359313be9d7ae";
    meta.cargo_crate_info = {
      name = "icu_normalizer";
      version = "1.5.0";
      crate_hash = "194359313be9d7ae";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [displaydoc-0_2_5-ff04277df12d4cce icu_collections-1_5_0-90410059e9afb9fa icu_normalizer_data-1_5_0-619ec124c50639c9 icu_properties-1_5_1-6d849a19734066a4 icu_provider-1_5_0-a18007741f2feb04 smallvec-1_13_2-0ef9b24879be6fdc utf16_iter-1_0_5-ff3a92cdd008ffcf utf8_iter-1_0_4-e624cb7375090120 write16-1_0_0-5e50a6c748aa8579 zerovec-0_10_4-b38efa70d7d8c99c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/icu_normalizer/1.5.0/download";
      sha256 = "19ce3e0da2ec68599d193c93d088142efd7f9c5d6fc9b803774855747dc6a84f";
    };

    unpackPhase = ''
      tar xf $src
      cd icu_normalizer-1.5.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "icu_normalizer";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "API for normalizing text into Unicode Normalization Forms";
    CARGO_PKG_HOMEPAGE = "https://icu4x.unicode.org";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "icu_normalizer";
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
              --crate-name icu_normalizer \
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
              --check-cfg 'cfg(feature, values("compiled_data", "datagen", "default", "experimental", "serde", "std"))' \
              -C metadata=375e22803ae58187 \
              -C extra-filename=-194359313be9d7ae \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern displaydoc=${displaydoc-0_2_5-ff04277df12d4cce}/libdisplaydoc-ff04277df12d4cce.so \
              --extern icu_collections=${icu_collections-1_5_0-90410059e9afb9fa}/libicu_collections-90410059e9afb9fa.rmeta \
              --extern icu_normalizer_data=${icu_normalizer_data-1_5_0-619ec124c50639c9}/libicu_normalizer_data-619ec124c50639c9.rmeta \
              --extern icu_properties=${icu_properties-1_5_1-6d849a19734066a4}/libicu_properties-6d849a19734066a4.rmeta \
              --extern icu_provider=${icu_provider-1_5_0-a18007741f2feb04}/libicu_provider-a18007741f2feb04.rmeta \
              --extern smallvec=${smallvec-1_13_2-0ef9b24879be6fdc}/libsmallvec-0ef9b24879be6fdc.rmeta \
              --extern utf16_iter=${utf16_iter-1_0_5-ff3a92cdd008ffcf}/libutf16_iter-ff3a92cdd008ffcf.rmeta \
              --extern utf8_iter=${utf8_iter-1_0_4-e624cb7375090120}/libutf8_iter-e624cb7375090120.rmeta \
              --extern write16=${write16-1_0_0-5e50a6c748aa8579}/libwrite16-5e50a6c748aa8579.rmeta \
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
