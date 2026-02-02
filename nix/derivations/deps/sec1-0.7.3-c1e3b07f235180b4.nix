# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "sec1-0_7_3-c1e3b07f235180b4";
    meta.cargo_crate_info = {
      name = "sec1";
      version = "0.7.3";
      crate_hash = "c1e3b07f235180b4";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [base16ct-0_2_0-9e432686303aee04 der-0_7_9-39bc94e6d7deac42 generic-array-0_14_7-cf1af5fa7e31ffd0 pkcs8-0_10_2-1efc71bd7be4e9c5 subtle-2_6_1-61dbca2d742edabc zeroize-1_8_1-9a1357fe1b2d7a82];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/sec1/0.7.3/download";
      sha256 = "d3e97a565f76233a6003f9f5c54be1d9c5bdfa3eccfb189469f11ec4901c47dc";
    };
    unpackPhase = ''
      tar xf $src
      cd sec1-0.7.3
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "sec1";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of SEC1: Elliptic Curve Cryptography encoding formats
including ASN.1 DER-serialized private keys as well as the
Elliptic-Curve-Point-to-Octet-String encoding
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "sec1";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/formats/tree/master/sec1";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.7.3";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "3";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m sec1-0_7_3-c1e3b07f235180b4"
      echo "@cargo { \"type\":0, \"crate_name\":\"sec1\", \"id\":\"sec1-0_7_3-c1e3b07f235180b4\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name sec1 \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --cfg 'feature="default"' \
              --cfg 'feature="der"' \
              --cfg 'feature="pem"' \
              --cfg 'feature="pkcs8"' \
              --cfg 'feature="point"' \
              --cfg 'feature="std"' \
              --cfg 'feature="subtle"' \
              --cfg 'feature="zeroize"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "default", "der", "pem", "pkcs8", "point", "serde", "std", "subtle", "zeroize"))' \
              -C metadata=9d97e43075e245e1 \
              -C extra-filename=-c1e3b07f235180b4 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern base16ct=${base16ct-0_2_0-9e432686303aee04}/libbase16ct-9e432686303aee04.rmeta \
              --extern der=${der-0_7_9-39bc94e6d7deac42}/libder-39bc94e6d7deac42.rmeta \
              --extern generic_array=${generic-array-0_14_7-cf1af5fa7e31ffd0}/libgeneric_array-cf1af5fa7e31ffd0.rmeta \
              --extern pkcs8=${pkcs8-0_10_2-1efc71bd7be4e9c5}/libpkcs8-1efc71bd7be4e9c5.rmeta \
              --extern subtle=${subtle-2_6_1-61dbca2d742edabc}/libsubtle-61dbca2d742edabc.rmeta \
              --extern zeroize=${zeroize-1_8_1-9a1357fe1b2d7a82}/libzeroize-9a1357fe1b2d7a82.rmeta \
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
          --arg fullname "sec1-0_7_3-c1e3b07f235180b4" \
          --arg crate_name "sec1" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
