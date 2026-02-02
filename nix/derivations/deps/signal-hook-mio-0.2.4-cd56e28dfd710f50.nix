# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "signal-hook-mio-0_2_4-cd56e28dfd710f50";
    meta.cargo_crate_info = {
      name = "signal-hook-mio";
      version = "0.2.4";
      crate_hash = "cd56e28dfd710f50";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [libc-0_2_175-df0687d6868fdede mio-0_8_11-6d022cfdfb03dec5 signal-hook-0_3_18-1abb298067a85eda];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/signal-hook-mio/0.2.4/download";
      sha256 = "34db1a06d485c9142248b7a054f034b349b212551f3dfd19c94d45a754a217cd";
    };
    unpackPhase = ''
      tar xf $src
      cd signal-hook-mio-0.2.4
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "signal_hook_mio";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Michal 'vorner' Vaner <vorner@vorner.cz>:Thomas Himmelstoss <thimm@posteo.de>";
    CARGO_PKG_DESCRIPTION = "MIO support for signal-hook";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0/MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "signal-hook-mio";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/vorner/signal-hook";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.2.4";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "4";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m signal-hook-mio-0_2_4-cd56e28dfd710f50"
      echo "@cargo { \"type\":0, \"crate_name\":\"signal-hook-mio\", \"id\":\"signal-hook-mio-0_2_4-cd56e28dfd710f50\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name signal_hook_mio \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="mio-0_8"' \
              --cfg 'feature="support-v0_8"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("mio-0_6", "mio-0_7", "mio-0_8", "mio-1_0", "mio-uds", "support-v0_6", "support-v0_7", "support-v0_8", "support-v1_0"))' \
              -C metadata=d09d761df3219cf9 \
              -C extra-filename=-cd56e28dfd710f50 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern mio_0_8=${mio-0_8_11-6d022cfdfb03dec5}/libmio-6d022cfdfb03dec5.rmeta \
              --extern signal_hook=${signal-hook-0_3_18-1abb298067a85eda}/libsignal_hook-1abb298067a85eda.rmeta \
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
          --arg fullname "signal-hook-mio-0_2_4-cd56e28dfd710f50" \
          --arg crate_name "signal-hook-mio" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
