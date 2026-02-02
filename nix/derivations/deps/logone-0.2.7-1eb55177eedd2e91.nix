# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "logone-0_2_7-1eb55177eedd2e91";
    meta.cargo_crate_info = {
      name = "logone";
      version = "0.2.7";
      crate_hash = "1eb55177eedd2e91";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [anyhow-1_0_96-139173be5e005a44 chrono-0_4_42-96bd1c38842d70ed clap-4_5_31-a6f5f68162f5c661 console-0_15_11-5031eeae5635e303 crossterm-0_27_0-a8da3ec9393855f8 regex-1_11_1-c278e9a7e455d20f serde-1_0_218-472e28b9f131b02c serde_json-1_0_139-ae78ec5bae97c420 thiserror-1_0_69-19f3044926d2abbd];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/logone/0.2.7/download";
      sha256 = "9bd3d81d8fa984ac773497473f7443299ef24c2fa1d8e1c9bda78d6bb4a7cec9";
    };
    unpackPhase = ''
      tar xf $src
      cd logone-0.2.7
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "logone";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Joachim Schiele <js@lastlog.de>";
    CARGO_PKG_DESCRIPTION = "A command-line tool that parses Nix's --log-format json-internal output as standalone and crate library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "logone";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/nixcloud/logone";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.2.7";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "7";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m logone-0_2_7-1eb55177eedd2e91"
      echo "@cargo { \"type\":0, \"crate_name\":\"logone\", \"id\":\"logone-0_2_7-1eb55177eedd2e91\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name logone \
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
              -C metadata=68822e25c00425f7 \
              -C extra-filename=-1eb55177eedd2e91 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern anyhow=${anyhow-1_0_96-139173be5e005a44}/libanyhow-139173be5e005a44.rmeta \
              --extern chrono=${chrono-0_4_42-96bd1c38842d70ed}/libchrono-96bd1c38842d70ed.rmeta \
              --extern clap=${clap-4_5_31-a6f5f68162f5c661}/libclap-a6f5f68162f5c661.rmeta \
              --extern console=${console-0_15_11-5031eeae5635e303}/libconsole-5031eeae5635e303.rmeta \
              --extern crossterm=${crossterm-0_27_0-a8da3ec9393855f8}/libcrossterm-a8da3ec9393855f8.rmeta \
              --extern regex=${regex-1_11_1-c278e9a7e455d20f}/libregex-c278e9a7e455d20f.rmeta \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
              --extern serde_json=${serde_json-1_0_139-ae78ec5bae97c420}/libserde_json-ae78ec5bae97c420.rmeta \
              --extern thiserror=${thiserror-1_0_69-19f3044926d2abbd}/libthiserror-19f3044926d2abbd.rmeta \
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
          --arg fullname "logone-0_2_7-1eb55177eedd2e91" \
          --arg crate_name "logone" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
