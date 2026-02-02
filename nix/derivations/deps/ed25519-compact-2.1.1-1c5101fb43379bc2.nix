# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "ed25519-compact-2_1_1-1c5101fb43379bc2";
    meta.cargo_crate_info = {
      name = "ed25519-compact";
      version = "2.1.1";
      crate_hash = "1c5101fb43379bc2";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [getrandom-0_2_15-8bcd08ec7ff910e6];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/ed25519-compact/2.1.1/download";
      sha256 = "e9b3460f44bea8cd47f45a0c70892f1eff856d97cd55358b2f73f663789f6190";
    };
    unpackPhase = ''
      tar xf $src
      cd ed25519-compact-2.1.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "ed25519_compact";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Frank Denis <github@pureftpd.org>";
    CARGO_PKG_DESCRIPTION = "A small, self-contained, wasm-friendly Ed25519 implementation";
    CARGO_PKG_HOMEPAGE = "https://github.com/jedisct1/rust-ed25519-compact";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "ed25519-compact";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/jedisct1/rust-ed25519-compact";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "2.1.1";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m ed25519-compact-2_1_1-1c5101fb43379bc2"
      echo "@cargo { \"type\":0, \"crate_name\":\"ed25519-compact\", \"id\":\"ed25519-compact-2_1_1-1c5101fb43379bc2\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name ed25519_compact \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="getrandom"' \
              --cfg 'feature="random"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("blind-keys", "ct-codecs", "default", "disable-signatures", "ed25519", "getrandom", "opt_size", "pem", "random", "self-verify", "std", "traits", "x25519"))' \
              -C metadata=5896bf0f396bf3f6 \
              -C extra-filename=-1c5101fb43379bc2 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern getrandom=${getrandom-0_2_15-8bcd08ec7ff910e6}/libgetrandom-8bcd08ec7ff910e6.rmeta \
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
          --arg fullname "ed25519-compact-2_1_1-1c5101fb43379bc2" \
          --arg crate_name "ed25519-compact" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
