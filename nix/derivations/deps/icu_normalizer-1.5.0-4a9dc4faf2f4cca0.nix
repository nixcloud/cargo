# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_normalizer-1_5_0-4a9dc4faf2f4cca0";
    meta.cargo_crate_info = {
      name = "icu_normalizer";
      version = "1.5.0";
      crate_hash = "4a9dc4faf2f4cca0";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [displaydoc-0_2_5-a3932aec884d58b9 icu_collections-1_5_0-4d027eaae4cb9000 icu_normalizer_data-1_5_0-d2c229093da62481 icu_properties-1_5_1-36033132eb86e488 icu_provider-1_5_0-df823559bbe57634 smallvec-1_13_2-e5874423828ed52b utf16_iter-1_0_5-e2c4d90fc6d42e47 utf8_iter-1_0_4-09be6fe1c1163a1d write16-1_0_0-26b1931c23e70fcd zerovec-0_10_4-e3e96206699c2afa];
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
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="compiled_data"' \
              --cfg 'feature="default"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("compiled_data", "datagen", "default", "experimental", "serde", "std"))' \
              -C metadata=df5f39047a600278 \
              -C extra-filename=-4a9dc4faf2f4cca0 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern displaydoc=${displaydoc-0_2_5-a3932aec884d58b9}/libdisplaydoc-a3932aec884d58b9.so \
              --extern icu_collections=${icu_collections-1_5_0-4d027eaae4cb9000}/libicu_collections-4d027eaae4cb9000.rmeta \
              --extern icu_normalizer_data=${icu_normalizer_data-1_5_0-d2c229093da62481}/libicu_normalizer_data-d2c229093da62481.rmeta \
              --extern icu_properties=${icu_properties-1_5_1-36033132eb86e488}/libicu_properties-36033132eb86e488.rmeta \
              --extern icu_provider=${icu_provider-1_5_0-df823559bbe57634}/libicu_provider-df823559bbe57634.rmeta \
              --extern smallvec=${smallvec-1_13_2-e5874423828ed52b}/libsmallvec-e5874423828ed52b.rmeta \
              --extern utf16_iter=${utf16_iter-1_0_5-e2c4d90fc6d42e47}/libutf16_iter-e2c4d90fc6d42e47.rmeta \
              --extern utf8_iter=${utf8_iter-1_0_4-09be6fe1c1163a1d}/libutf8_iter-09be6fe1c1163a1d.rmeta \
              --extern write16=${write16-1_0_0-26b1931c23e70fcd}/libwrite16-26b1931c23e70fcd.rmeta \
              --extern zerovec=${zerovec-0_10_4-e3e96206699c2afa}/libzerovec-e3e96206699c2afa.rmeta \
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
