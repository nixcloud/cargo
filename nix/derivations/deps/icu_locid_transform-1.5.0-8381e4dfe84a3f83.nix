# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_locid_transform-1_5_0-8381e4dfe84a3f83";
    meta.cargo_crate_info = {
      name = "icu_locid_transform";
      version = "1.5.0";
      crate_hash = "8381e4dfe84a3f83";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [displaydoc-0_2_5-ff04277df12d4cce icu_locid-1_5_0-91abdeb33e173e23 icu_locid_transform_data-1_5_0-5001d6ff6fb192db icu_provider-1_5_0-a18007741f2feb04 tinystr-0_7_6-96e7f5be7ff0a0c7 zerovec-0_10_4-b38efa70d7d8c99c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/icu_locid_transform/1.5.0/download";
      sha256 = "01d11ac35de8e40fdeda00d9e1e9d92525f3f9d887cdd7aa81d727596788b54e";
    };

    unpackPhase = ''
      tar xf $src
      cd icu_locid_transform-1.5.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "icu_locid_transform";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "API for Unicode Language and Locale Identifiers canonicalization";
    CARGO_PKG_HOMEPAGE = "https://icu4x.unicode.org";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "icu_locid_transform";
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
              --crate-name icu_locid_transform \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="compiled_data"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("bench", "compiled_data", "datagen", "default", "serde", "std"))' \
              -C metadata=eb32ba42a3764fb6 \
              -C extra-filename=-8381e4dfe84a3f83 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern displaydoc=${displaydoc-0_2_5-ff04277df12d4cce}/libdisplaydoc-ff04277df12d4cce.so \
              --extern icu_locid=${icu_locid-1_5_0-91abdeb33e173e23}/libicu_locid-91abdeb33e173e23.rmeta \
              --extern icu_locid_transform_data=${icu_locid_transform_data-1_5_0-5001d6ff6fb192db}/libicu_locid_transform_data-5001d6ff6fb192db.rmeta \
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
