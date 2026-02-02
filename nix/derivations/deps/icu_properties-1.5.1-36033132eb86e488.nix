# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "icu_properties-1_5_1-36033132eb86e488";
    meta.cargo_crate_info = {
      name = "icu_properties";
      version = "1.5.1";
      crate_hash = "36033132eb86e488";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [displaydoc-0_2_5-a3932aec884d58b9 icu_collections-1_5_0-4d027eaae4cb9000 icu_locid_transform-1_5_0-291edb4addc628ca icu_properties_data-1_5_0-4f08bfd4250192ce icu_provider-1_5_0-df823559bbe57634 tinystr-0_7_6-887be2ca1a583610 zerovec-0_10_4-e3e96206699c2afa];
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
    CARGO = "${cargo}/bin/cargo";

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
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m icu_properties-1_5_1-36033132eb86e488"
      echo "@cargo { \"type\":0, \"crate_name\":\"icu_properties\", \"id\":\"icu_properties-1_5_1-36033132eb86e488\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name icu_properties \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="compiled_data"' \
              --cfg 'feature="default"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("bidi", "compiled_data", "datagen", "default", "serde", "std"))' \
              -C metadata=1f5fea9679e6c74e \
              -C extra-filename=-36033132eb86e488 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern displaydoc=${displaydoc-0_2_5-a3932aec884d58b9}/libdisplaydoc-a3932aec884d58b9.so \
              --extern icu_collections=${icu_collections-1_5_0-4d027eaae4cb9000}/libicu_collections-4d027eaae4cb9000.rmeta \
              --extern icu_locid_transform=${icu_locid_transform-1_5_0-291edb4addc628ca}/libicu_locid_transform-291edb4addc628ca.rmeta \
              --extern icu_properties_data=${icu_properties_data-1_5_0-4f08bfd4250192ce}/libicu_properties_data-4f08bfd4250192ce.rmeta \
              --extern icu_provider=${icu_provider-1_5_0-df823559bbe57634}/libicu_provider-df823559bbe57634.rmeta \
              --extern tinystr=${tinystr-0_7_6-887be2ca1a583610}/libtinystr-887be2ca1a583610.rmeta \
              --extern zerovec=${zerovec-0_10_4-e3e96206699c2afa}/libzerovec-e3e96206699c2afa.rmeta \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      # print errors
      while IFS= read -r line
      do
          tmpFile=$(${pkgs.mktemp}/bin/mktemp)
          echo "$line" > $tmpFile
          ${pkgs.jq}/bin/jq -r -c 'select(."$message_type"=="diagnostic") | .rendered' $tmpFile
      done < $rustc_json_output_lines
      
      
      # return structured formatted errors for later processing
      output=$(${pkgs.jq}/bin/jq -s -r -c \
          --arg fullname "icu_properties-1_5_1-36033132eb86e488" \
          --arg crate_name "icu_properties" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
