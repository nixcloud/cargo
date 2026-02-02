# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "crossterm-0_27_0-a8da3ec9393855f8";
    meta.cargo_crate_info = {
      name = "crossterm";
      version = "0.27.0";
      crate_hash = "a8da3ec9393855f8";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [bitflags-2_8_0-d8308ebf07e22afd libc-0_2_175-df0687d6868fdede mio-0_8_11-6d022cfdfb03dec5 parking_lot-0_12_3-4fd4df098a55c376 signal-hook-0_3_18-1abb298067a85eda signal-hook-mio-0_2_4-cd56e28dfd710f50];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/crossterm/0.27.0/download";
      sha256 = "f476fe445d41c9e991fd07515a6f463074b782242ccf4a5b7b1d1012e70824df";
    };
    unpackPhase = ''
      tar xf $src
      cd crossterm-0.27.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "crossterm";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "T. Post";
    CARGO_PKG_DESCRIPTION = "A crossplatform terminal library for manipulating terminals.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "crossterm";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/crossterm-rs/crossterm";
    CARGO_PKG_RUST_VERSION = "1.58.0";
    CARGO_PKG_VERSION = "0.27.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "27";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m crossterm-0_27_0-a8da3ec9393855f8"
      echo "@cargo { \"type\":0, \"crate_name\":\"crossterm\", \"id\":\"crossterm-0_27_0-a8da3ec9393855f8\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name crossterm \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="bracketed-paste"' \
              --cfg 'feature="default"' \
              --cfg 'feature="events"' \
              --cfg 'feature="windows"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("bracketed-paste", "default", "event-stream", "events", "filedescriptor", "serde", "use-dev-tty", "windows"))' \
              -C metadata=20baa0d9f642c3fd \
              -C extra-filename=-a8da3ec9393855f8 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern bitflags=${bitflags-2_8_0-d8308ebf07e22afd}/libbitflags-d8308ebf07e22afd.rmeta \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern mio=${mio-0_8_11-6d022cfdfb03dec5}/libmio-6d022cfdfb03dec5.rmeta \
              --extern parking_lot=${parking_lot-0_12_3-4fd4df098a55c376}/libparking_lot-4fd4df098a55c376.rmeta \
              --extern signal_hook=${signal-hook-0_3_18-1abb298067a85eda}/libsignal_hook-1abb298067a85eda.rmeta \
              --extern signal_hook_mio=${signal-hook-mio-0_2_4-cd56e28dfd710f50}/libsignal_hook_mio-cd56e28dfd710f50.rmeta \
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
          --arg fullname "crossterm-0_27_0-a8da3ec9393855f8" \
          --arg crate_name "crossterm" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
