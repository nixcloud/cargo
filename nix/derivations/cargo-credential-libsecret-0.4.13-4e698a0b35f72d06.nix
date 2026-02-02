# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root, cargo-credential-0_4_8-a5adc6ab9fe103b0 }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-credential-libsecret-0_4_13-4e698a0b35f72d06";
    meta.cargo_crate_info = {
      name = "cargo-credential-libsecret";
      version = "0.4.13";
      crate_hash = "4e698a0b35f72d06";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [anyhow-1_0_96-139173be5e005a44 cargo-credential-0_4_8-a5adc6ab9fe103b0 libloading-0_8_6-2aeac1c54ae56457];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "credential/cargo-credential-libsecret/src/lib.rs"
      ];
    };
    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "cargo_credential_libsecret";
    CARGO_MANIFEST_DIR = "./credential/cargo-credential-libsecret";
    CARGO_MANIFEST_PATH = "./credential/cargo-credential-libsecret/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "A Cargo credential process that stores tokens with GNOME libsecret.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo-credential-libsecret";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.4.13";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "13";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m cargo-credential-libsecret-0_4_13-4e698a0b35f72d06"
      echo "@cargo { \"type\":0, \"crate_name\":\"cargo-credential-libsecret\", \"id\":\"cargo-credential-libsecret-0_4_13-4e698a0b35f72d06\" }"




    #   start_time=$(date +%s%3N)
    #   set -x +e

    #  ${RUSTC} \
    #           --crate-name cargo_credential_libsecret \
    #           --edition=2021 credential/cargo-credential-libsecret/src/lib.rs \
    #           --error-format=json \
    #           --json=diagnostic-rendered-ansi,artifacts,future-incompat \
    #           --diagnostic-width=170 \
    #           --crate-type lib \
    #           --emit=dep-info \
    #           -C embed-bitcode=no \
    #           -C debuginfo=2 \
    #           --allow=clippy::all \
    #           --warn=clippy::correctness \
    #           --warn=clippy::self_named_module_files \
    #           --warn=rust_2018_idioms \
    #           --allow=rustdoc::private_intra_doc_links \
    #           --warn=clippy::print_stdout \
    #           --warn=clippy::print_stderr \
    #           --warn=clippy::disallowed_methods \
    #           --warn=clippy::dbg_macro \
    #           ${fn.rustc_arguments passthru.rust_crate_parent} \
    #           --check-cfg 'cfg(docsrs,test)' \
    #           --check-cfg 'cfg(feature, values())' \
    #           -C metadata=b63e23bc179845d9 \
    #           -C extra-filename=-4e698a0b35f72d06 \
    #           --out-dir $OUT_DIR 2>/dev/null
    #   end_time=$(date +%s%3N)
    #   elapsed=$(( end_time - start_time ))
    #   echo "Elapsed time between XXX and YYY: $elapsed ms"
    #   cat $out/*.d
    #   exit 1














      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name cargo_credential_libsecret \
              --edition=2021 credential/cargo-credential-libsecret/src/lib.rs \
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
              -C metadata=b63e23bc179845d9 \
              -C extra-filename=-4e698a0b35f72d06 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern anyhow=${anyhow-1_0_96-139173be5e005a44}/libanyhow-139173be5e005a44.rmeta \
              --extern cargo_credential=${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.rmeta \
              --extern libloading=${libloading-0_8_6-2aeac1c54ae56457}/liblibloading-2aeac1c54ae56457.rmeta 2> $rustc_json_output_lines
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
          --arg fullname "cargo-credential-libsecret-0_4_13-4e698a0b35f72d06" \
          --arg crate_name "cargo-credential-libsecret" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
