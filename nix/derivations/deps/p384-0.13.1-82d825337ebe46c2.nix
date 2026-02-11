# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "p384-0_13_1-82d825337ebe46c2";
    meta.cargo_crate_info = {
      name = "p384";
      version = "0.13.1";
      crate_hash = "82d825337ebe46c2";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [ecdsa-0_16_9-95753d738a0973a7 elliptic-curve-0_13_8-62624c894feb112b primeorder-0_13_6-348bf520b75b2852 sha2-0_10_8-bdde0649695b7ac6];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/p384/0.13.1/download";
      sha256 = "fe42f1670a52a47d448f14b6a5c61dd78fce51856e68edaa38f7ae3a46b8d6b6";
    };
    unpackPhase = ''
      tar xf $src
      cd p384-0.13.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "p384";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers:Frank Denis <github@pureftpd.org>";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of the NIST P-384 (a.k.a. secp384r1) elliptic curve
as defined in SP 800-186 with support for ECDH, ECDSA signing/verification,
and general purpose curve arithmetic support.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "p384";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/elliptic-curves/tree/master/p384";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.13.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "13";
    CARGO_PKG_VERSION_PATCH = "1";
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
              --crate-name p384 \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --cfg 'feature="arithmetic"' \
              --cfg 'feature="default"' \
              --cfg 'feature="digest"' \
              --cfg 'feature="ecdh"' \
              --cfg 'feature="ecdsa"' \
              --cfg 'feature="ecdsa-core"' \
              --cfg 'feature="pem"' \
              --cfg 'feature="pkcs8"' \
              --cfg 'feature="sha2"' \
              --cfg 'feature="sha384"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "arithmetic", "bits", "default", "digest", "ecdh", "ecdsa", "ecdsa-core", "expose-field", "hash2curve", "hex-literal", "jwk", "pem", "pkcs8", "serde", "serdect", "sha2", "sha384", "std", "test-vectors", "voprf"))' \
              -C metadata=05d7c812b7857b3d \
              -C extra-filename=-82d825337ebe46c2 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern ecdsa_core=${ecdsa-0_16_9-95753d738a0973a7}/libecdsa-95753d738a0973a7.rmeta \
              --extern elliptic_curve=${elliptic-curve-0_13_8-62624c894feb112b}/libelliptic_curve-62624c894feb112b.rmeta \
              --extern primeorder=${primeorder-0_13_6-348bf520b75b2852}/libprimeorder-348bf520b75b2852.rmeta \
              --extern sha2=${sha2-0_10_8-bdde0649695b7ac6}/libsha2-bdde0649695b7ac6.rmeta \
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
