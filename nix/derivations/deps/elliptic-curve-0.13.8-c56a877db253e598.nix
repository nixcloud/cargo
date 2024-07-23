# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "elliptic-curve-0_13_8-c56a877db253e598";
    meta.cargo_crate_info = {
      name = "elliptic-curve";
      version = "0.13.8";
      crate_hash = "c56a877db253e598";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [base16ct-0_2_0-03a13dfc8db9d885 crypto-bigint-0_5_5-0bcc8357eda397b9 digest-0_10_7-07ce6216f0c2d433 ff-0_13_0-9c81edae7543beed generic-array-0_14_7-28e5836782b73319 group-0_13_0-959c7bb78c337d72 hkdf-0_12_4-5fa923505668b238 pem-rfc7468-0_7_0-a2854727203f56cc pkcs8-0_10_2-d9da1a442d6d1c2e rand_core-0_6_4-fb3f0a376173ae44 sec1-0_7_3-405cf947070e5373 subtle-2_6_1-0584afad8ebd85c1 zeroize-1_8_1-966e26bee9773779];
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
    CARGO_CRATE_NAME = "elliptic_curve";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "General purpose Elliptic Curve Cryptography (ECC) support, including types
and traits for representing various elliptic curve forms, scalars, points,
and public/secret keys composed thereof.";
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
      ${fn.import_bash_function_helpers}
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)
      
      mkdir -p $out/nix
      export OUT_DIR=$out

      print_compiling_message "${name}"
      print_cargo_message_type_0 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name elliptic_curve \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
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
              -C metadata=6d7c13b777f43b69 \
              -C extra-filename=-c56a877db253e598 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern base16ct=${base16ct-0_2_0-03a13dfc8db9d885}/libbase16ct-03a13dfc8db9d885.rmeta \
              --extern crypto_bigint=${crypto-bigint-0_5_5-0bcc8357eda397b9}/libcrypto_bigint-0bcc8357eda397b9.rmeta \
              --extern digest=${digest-0_10_7-07ce6216f0c2d433}/libdigest-07ce6216f0c2d433.rmeta \
              --extern ff=${ff-0_13_0-9c81edae7543beed}/libff-9c81edae7543beed.rmeta \
              --extern generic_array=${generic-array-0_14_7-28e5836782b73319}/libgeneric_array-28e5836782b73319.rmeta \
              --extern group=${group-0_13_0-959c7bb78c337d72}/libgroup-959c7bb78c337d72.rmeta \
              --extern hkdf=${hkdf-0_12_4-5fa923505668b238}/libhkdf-5fa923505668b238.rmeta \
              --extern pem_rfc7468=${pem-rfc7468-0_7_0-a2854727203f56cc}/libpem_rfc7468-a2854727203f56cc.rmeta \
              --extern pkcs8=${pkcs8-0_10_2-d9da1a442d6d1c2e}/libpkcs8-d9da1a442d6d1c2e.rmeta \
              --extern rand_core=${rand_core-0_6_4-fb3f0a376173ae44}/librand_core-fb3f0a376173ae44.rmeta \
              --extern sec1=${sec1-0_7_3-405cf947070e5373}/libsec1-405cf947070e5373.rmeta \
              --extern subtle=${subtle-2_6_1-0584afad8ebd85c1}/libsubtle-0584afad8ebd85c1.rmeta \
              --extern zeroize=${zeroize-1_8_1-966e26bee9773779}/libzeroize-966e26bee9773779.rmeta \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
