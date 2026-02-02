# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "elliptic-curve-0_13_8-62624c894feb112b";
    meta.cargo_crate_info = {
      name = "elliptic-curve";
      version = "0.13.8";
      crate_hash = "62624c894feb112b";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [base16ct-0_2_0-9e432686303aee04 crypto-bigint-0_5_5-5115490596bc9280 digest-0_10_7-d61413dd55c3b709 ff-0_13_0-c7a3e6a3c0308f8f generic-array-0_14_7-cf1af5fa7e31ffd0 group-0_13_0-b2c2c02d111760d6 hkdf-0_12_4-bbec6e1cfb889215 pem-rfc7468-0_7_0-9363a4c91bcb7bc9 pkcs8-0_10_2-1efc71bd7be4e9c5 rand_core-0_6_4-5078be04f75dc0b2 sec1-0_7_3-c1e3b07f235180b4 subtle-2_6_1-61dbca2d742edabc zeroize-1_8_1-9a1357fe1b2d7a82];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/elliptic-curve/0.13.8/download";
      sha256 = "b5e6043086bf7973472e0c7dff2142ea0b680d30e18d9cc40f267efbf222bd47";
    };
    unpackPhase = ''
      tar xf $src
      cd elliptic-curve-0.13.8
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "elliptic_curve";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "General purpose Elliptic Curve Cryptography (ECC) support, including types
and traits for representing various elliptic curve forms, scalars, points,
and public/secret keys composed thereof.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "elliptic-curve";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/traits/tree/master/elliptic-curve";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.13.8";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "13";
    CARGO_PKG_VERSION_PATCH = "8";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m elliptic-curve-0_13_8-62624c894feb112b"
      echo "@cargo { \"type\":0, \"crate_name\":\"elliptic-curve\", \"id\":\"elliptic-curve-0_13_8-62624c894feb112b\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name elliptic_curve \
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
              --cfg 'feature="arithmetic"' \
              --cfg 'feature="digest"' \
              --cfg 'feature="ecdh"' \
              --cfg 'feature="ff"' \
              --cfg 'feature="group"' \
              --cfg 'feature="hazmat"' \
              --cfg 'feature="pem"' \
              --cfg 'feature="pkcs8"' \
              --cfg 'feature="sec1"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "arithmetic", "bits", "default", "dev", "digest", "ecdh", "ff", "group", "hash2curve", "hazmat", "jwk", "pem", "pkcs8", "sec1", "serde", "std", "voprf"))' \
              -C metadata=518b8cd030c0709f \
              -C extra-filename=-62624c894feb112b \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern base16ct=${base16ct-0_2_0-9e432686303aee04}/libbase16ct-9e432686303aee04.rmeta \
              --extern crypto_bigint=${crypto-bigint-0_5_5-5115490596bc9280}/libcrypto_bigint-5115490596bc9280.rmeta \
              --extern digest=${digest-0_10_7-d61413dd55c3b709}/libdigest-d61413dd55c3b709.rmeta \
              --extern ff=${ff-0_13_0-c7a3e6a3c0308f8f}/libff-c7a3e6a3c0308f8f.rmeta \
              --extern generic_array=${generic-array-0_14_7-cf1af5fa7e31ffd0}/libgeneric_array-cf1af5fa7e31ffd0.rmeta \
              --extern group=${group-0_13_0-b2c2c02d111760d6}/libgroup-b2c2c02d111760d6.rmeta \
              --extern hkdf=${hkdf-0_12_4-bbec6e1cfb889215}/libhkdf-bbec6e1cfb889215.rmeta \
              --extern pem_rfc7468=${pem-rfc7468-0_7_0-9363a4c91bcb7bc9}/libpem_rfc7468-9363a4c91bcb7bc9.rmeta \
              --extern pkcs8=${pkcs8-0_10_2-1efc71bd7be4e9c5}/libpkcs8-1efc71bd7be4e9c5.rmeta \
              --extern rand_core=${rand_core-0_6_4-5078be04f75dc0b2}/librand_core-5078be04f75dc0b2.rmeta \
              --extern sec1=${sec1-0_7_3-c1e3b07f235180b4}/libsec1-c1e3b07f235180b4.rmeta \
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
          --arg fullname "elliptic-curve-0_13_8-62624c894feb112b" \
          --arg crate_name "elliptic-curve" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
