# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "serde-untagged-0_1_6-6d07b1ee988da762";
    meta.cargo_crate_info = {
      name = "serde-untagged";
      version = "0.1.6";
      crate_hash = "6d07b1ee988da762";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [erased-serde-0_4_5-f987b2e59c60f727 serde-1_0_218-472e28b9f131b02c typeid-1_0_2-e066b933ff0261e3];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/serde-untagged/0.1.6/download";
      sha256 = "2676ba99bd82f75cae5cbd2c8eda6fa0b8760f18978ea840e980dd5567b5c5b6";
    };
    unpackPhase = ''
      tar xf $src
      cd serde-untagged-0.1.6
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "serde_untagged";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "David Tolnay <dtolnay@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Serde `Visitor` implementation for deserializing untagged enums";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "serde-untagged";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/dtolnay/serde-untagged";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "0.1.6";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "6";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m serde-untagged-0_1_6-6d07b1ee988da762"
      echo "@cargo { \"type\":0, \"crate_name\":\"serde-untagged\", \"id\":\"serde-untagged-0_1_6-6d07b1ee988da762\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name serde_untagged \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values())' \
              -C metadata=4f41083d4b930297 \
              -C extra-filename=-6d07b1ee988da762 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern erased_serde=${erased-serde-0_4_5-f987b2e59c60f727}/liberased_serde-f987b2e59c60f727.rmeta \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
              --extern typeid=${typeid-1_0_2-e066b933ff0261e3}/libtypeid-e066b933ff0261e3.rmeta \
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
          --arg fullname "serde-untagged-0_1_6-6d07b1ee988da762" \
          --arg crate_name "serde-untagged" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
