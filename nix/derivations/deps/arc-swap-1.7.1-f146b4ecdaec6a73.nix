# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "arc-swap-1_7_1-f146b4ecdaec6a73";
    meta.cargo_crate_info = {
      name = "arc-swap";
      version = "1.7.1";
      crate_hash = "f146b4ecdaec6a73";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/arc-swap/1.7.1/download";
      sha256 = "69f7f8c3906b62b754cd5326047894316021dcfe5a194c8ea52bdd94934a3457";
    };
    unpackPhase = ''
      tar xf $src
      cd arc-swap-1.7.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "arc_swap";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Michal 'vorner' Vaner <vorner@vorner.cz>";
    CARGO_PKG_DESCRIPTION = "Atomically swappable Arc";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "arc-swap";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/vorner/arc-swap";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "1.7.1";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m arc-swap-1_7_1-f146b4ecdaec6a73"
      echo "@cargo { \"type\":0, \"crate_name\":\"arc-swap\", \"id\":\"arc-swap-1_7_1-f146b4ecdaec6a73\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name arc_swap \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("experimental-strategies", "experimental-thread-local", "internal-test-strategies", "serde", "weak"))' \
              -C metadata=846f9025b60670bb \
              -C extra-filename=-f146b4ecdaec6a73 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
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
          --arg fullname "arc-swap-1_7_1-f146b4ecdaec6a73" \
          --arg crate_name "arc-swap" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
