# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_locid-1_5_0-294b75cdeaebd083";
    meta.cargo_crate_info = {
      name = "icu_locid";
      version = "1.5.0";
      crate_hash = "294b75cdeaebd083";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [displaydoc-0_2_5-a3932aec884d58b9 litemap-0_7_4-1f4d69d5dc04ca70 tinystr-0_7_6-887be2ca1a583610 writeable-0_5_5-126ae34b487ba069 zerovec-0_10_4-e3e96206699c2afa];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/icu_locid/1.5.0/download";
      sha256 = "13acbb8371917fc971be86fc8057c41a64b521c184808a698c02acc242dbf637";
    };
    unpackPhase = ''
      tar xf $src
      cd icu_locid-1.5.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "icu_locid";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "API for managing Unicode Language and Locale Identifiers";
    CARGO_PKG_HOMEPAGE = "https://icu4x.unicode.org";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "icu_locid";
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
              --crate-name icu_locid \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="zerovec"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("bench", "databake", "serde", "std", "zerovec"))' \
              -C metadata=f4a9c40ccc48bcec \
              -C extra-filename=-294b75cdeaebd083 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern displaydoc=${displaydoc-0_2_5-a3932aec884d58b9}/libdisplaydoc-a3932aec884d58b9.so \
              --extern litemap=${litemap-0_7_4-1f4d69d5dc04ca70}/liblitemap-1f4d69d5dc04ca70.rmeta \
              --extern tinystr=${tinystr-0_7_6-887be2ca1a583610}/libtinystr-887be2ca1a583610.rmeta \
              --extern writeable=${writeable-0_5_5-126ae34b487ba069}/libwriteable-126ae34b487ba069.rmeta \
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
