# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "ecdsa-0_16_9-833b4c6c9b0d846b";
    meta.cargo_crate_info = {
      name = "ecdsa";
      version = "0.16.9";
      crate_hash = "833b4c6c9b0d846b";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [der-0_7_9-9223185c0fceb330 digest-0_10_7-07ce6216f0c2d433 elliptic-curve-0_13_8-c56a877db253e598 rfc6979-0_4_0-efb691326bf41a38 signature-2_2_0-6f3debade63d7ac5 spki-0_7_3-75041267a176d535];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/ecdsa/0.16.9/download";
      sha256 = "ee27f32b5c5292967d2d4a9d7f1e0b0aed2c15daded5a60300e4abb9d8020bca";
    };

    unpackPhase = ''
      tar xf $src
      cd ecdsa-0.16.9
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "ecdsa";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of the Elliptic Curve Digital Signature Algorithm
(ECDSA) as specified in FIPS 186-4 (Digital Signature Standard), providing
RFC6979 deterministic signatures as well as support for added entropy";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "ecdsa";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/signatures/tree/master/ecdsa";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.16.9";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "16";
    CARGO_PKG_VERSION_PATCH = "9";
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
              --crate-name ecdsa \
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
              --cfg 'feature="der"' \
              --cfg 'feature="digest"' \
              --cfg 'feature="hazmat"' \
              --cfg 'feature="pem"' \
              --cfg 'feature="pkcs8"' \
              --cfg 'feature="rfc6979"' \
              --cfg 'feature="signing"' \
              --cfg 'feature="spki"' \
              --cfg 'feature="std"' \
              --cfg 'feature="verifying"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "arithmetic", "default", "der", "dev", "digest", "hazmat", "pem", "pkcs8", "rfc6979", "serde", "serdect", "sha2", "signing", "spki", "std", "verifying"))' \
              -C metadata=0a8132496fdde6c8 \
              -C extra-filename=-833b4c6c9b0d846b \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern der=${der-0_7_9-9223185c0fceb330}/libder-9223185c0fceb330.rmeta \
              --extern digest=${digest-0_10_7-07ce6216f0c2d433}/libdigest-07ce6216f0c2d433.rmeta \
              --extern elliptic_curve=${elliptic-curve-0_13_8-c56a877db253e598}/libelliptic_curve-c56a877db253e598.rmeta \
              --extern rfc6979=${rfc6979-0_4_0-efb691326bf41a38}/librfc6979-efb691326bf41a38.rmeta \
              --extern signature=${signature-2_2_0-6f3debade63d7ac5}/libsignature-6f3debade63d7ac5.rmeta \
              --extern spki=${spki-0_7_3-75041267a176d535}/libspki-75041267a176d535.rmeta \
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
