# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "crates-io-0_40_10-cb0425982b906266";
    meta.cargo_crate_info = {
      name = "crates-io";
      version = "0.40.10";
      crate_hash = "cb0425982b906266";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [curl-0_4_47-f684c2bd7b0f950d percent-encoding-2_3_1-e8b9e34a5db857ef serde-1_0_218-472e28b9f131b02c serde_json-1_0_139-ae78ec5bae97c420 thiserror-2_0_11-a57592ffa4ea41e0 url-2_5_4-7b68be8bb56d0713];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "crates/crates-io/lib.rs"
      ];
    };

    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "crates_io";
    CARGO_MANIFEST_DIR = "./crates/crates-io";
    CARGO_MANIFEST_PATH = "./crates/crates-io/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Helpers for interacting with crates.io";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "crates-io";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.40.10";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "40";
    CARGO_PKG_VERSION_PATCH = "10";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m crates-io-0_40_10-cb0425982b906266"
      echo "@cargo { \"type\":0, \"crate_name\":\"crates-io\", \"id\":\"crates-io-0_40_10-cb0425982b906266\" }"



  #     start_time=$(date +%s%3N)
  #     set -x +e
  #  ${RUSTC} \
  #             --crate-name crates_io \
  #             --edition=2021 crates/crates-io/lib.rs \
  #             --crate-type lib \
  #             --emit=dep-info \
  #             ${fn.rustc_arguments passthru.rust_crate_parent} \
  #             --check-cfg 'cfg(docsrs,test)' \
  #             --check-cfg 'cfg(feature, values())' \
  #             -C metadata=db61783e969f2888 \
  #             -C extra-filename=-cb0425982b906266 \
  #             --out-dir $OUT_DIR 2>/dev/null
  #     end_time=$(date +%s%3N)
  #     elapsed=$(( end_time - start_time ))
  #     echo "Elapsed time between XXX and YYY: $elapsed ms"
  #     cat $out/*.d
  #     exit 1




      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name crates_io \
              --edition=2021 crates/crates-io/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --allow=clippy::all \
              --warn=clippy::correctness \
              --warn=clippy::self_named_module_files \
              --warn=rust_2018_idioms \
              --allow=rustdoc::private_intra_doc_links \
              --warn=clippy::print_stdout \
              --warn=clippy::print_stderr \
              --warn=clippy::disallowed_methods \
              --warn=clippy::dbg_macro \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values())' \
              -C metadata=db61783e969f2888 \
              -C extra-filename=-cb0425982b906266 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern curl=${curl-0_4_47-f684c2bd7b0f950d}/libcurl-f684c2bd7b0f950d.rmeta \
              --extern percent_encoding=${percent-encoding-2_3_1-e8b9e34a5db857ef}/libpercent_encoding-e8b9e34a5db857ef.rmeta \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
              --extern serde_json=${serde_json-1_0_139-ae78ec5bae97c420}/libserde_json-ae78ec5bae97c420.rmeta \
              --extern thiserror=${thiserror-2_0_11-a57592ffa4ea41e0}/libthiserror-a57592ffa4ea41e0.rmeta \
              --extern url=${url-2_5_4-7b68be8bb56d0713}/liburl-7b68be8bb56d0713.rmeta 2> $rustc_json_output_lines
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
          --arg fullname "crates-io-0_40_10-cb0425982b906266" \
          --arg crate_name "crates-io" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
