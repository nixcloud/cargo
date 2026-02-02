# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-credential-0_4_8-a5adc6ab9fe103b0";
    meta.cargo_crate_info = {
      name = "cargo-credential";
      version = "0.4.8";
      crate_hash = "a5adc6ab9fe103b0";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [anyhow-1_0_96-139173be5e005a44 libc-0_2_175-df0687d6868fdede serde-1_0_218-472e28b9f131b02c serde_json-1_0_139-ae78ec5bae97c420 thiserror-2_0_11-a57592ffa4ea41e0 time-0_3_37-b73d8cae561973b7];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "credential/cargo-credential/src/lib.rs"
        "credential/cargo-credential/src/error.rs"
        "credential/cargo-credential/src/secret.rs"
        "credential/cargo-credential/src/stdio.rs"
        "credential/cargo-credential/src/../examples/file-provider.rs"
      ];
    };
    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "cargo_credential";
    CARGO_MANIFEST_DIR = "./credential/cargo-credential";
    CARGO_MANIFEST_PATH = "./credential/cargo-credential/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "A library to assist writing Cargo credential helpers.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo-credential";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.83";
    CARGO_PKG_VERSION = "0.4.8";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "8";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m cargo-credential-0_4_8-a5adc6ab9fe103b0"
      echo "@cargo { \"type\":0, \"crate_name\":\"cargo-credential\", \"id\":\"cargo-credential-0_4_8-a5adc6ab9fe103b0\" }"




  #     start_time=$(date +%s%3N)
  #     set -x +e
  # ${RUSTC} \
  #     --crate-name cargo_credential \
  #             --edition=2021 credential/cargo-credential/src/lib.rs \
  #             --error-format=json \
  #             --json=diagnostic-rendered-ansi,artifacts,future-incompat \
  #             --diagnostic-width=170 \
  #             --crate-type lib \
  #             --emit=dep-info \
  #             -C embed-bitcode=no \
  #             -C debuginfo=2 \
  #             --allow=clippy::all \
  #             --warn=clippy::correctness \
  #             --warn=clippy::self_named_module_files \
  #             --warn=rust_2018_idioms \
  #             --allow=rustdoc::private_intra_doc_links \
  #             --warn=clippy::print_stdout \
  #             --warn=clippy::print_stderr \
  #             --warn=clippy::disallowed_methods \
  #             --warn=clippy::dbg_macro \
  #             ${fn.rustc_arguments passthru.rust_crate_parent} \
  #             --check-cfg 'cfg(docsrs,test)' \
  #             --check-cfg 'cfg(feature, values())' \
  #             -C metadata=49224332bd1eba21 \
  #             -C extra-filename=-a5adc6ab9fe103b0 \
  #             --out-dir $OUT_DIR  2>/dev/null
  #     end_time=$(date +%s%3N)
  #     elapsed=$(( end_time - start_time ))
  #     echo "Elapsed time between XXX and YYY: $elapsed ms"

  #     ls -la $out
  #     cat $out/cargo_credential-a5adc6ab9fe103b0.d
  #     exit 1







      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name cargo_credential \
              --edition=2021 credential/cargo-credential/src/lib.rs \
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
              -C metadata=49224332bd1eba21 \
              -C extra-filename=-a5adc6ab9fe103b0 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern anyhow=${anyhow-1_0_96-139173be5e005a44}/libanyhow-139173be5e005a44.rmeta \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
              --extern serde_json=${serde_json-1_0_139-ae78ec5bae97c420}/libserde_json-ae78ec5bae97c420.rmeta \
              --extern thiserror=${thiserror-2_0_11-a57592ffa4ea41e0}/libthiserror-a57592ffa4ea41e0.rmeta \
              --extern time=${time-0_3_37-b73d8cae561973b7}/libtime-b73d8cae561973b7.rmeta 2> $rustc_json_output_lines
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
          --arg fullname "cargo-credential-0_4_8-a5adc6ab9fe103b0" \
          --arg crate_name "cargo-credential" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
