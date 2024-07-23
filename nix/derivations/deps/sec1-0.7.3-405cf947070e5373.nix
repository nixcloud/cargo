# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "sec1-0_7_3-405cf947070e5373";
    meta.cargo_crate_info = {
      name = "sec1";
      version = "0.7.3";
      crate_hash = "405cf947070e5373";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [base16ct-0_2_0-03a13dfc8db9d885 der-0_7_9-9223185c0fceb330 generic-array-0_14_7-28e5836782b73319 pkcs8-0_10_2-d9da1a442d6d1c2e subtle-2_6_1-0584afad8ebd85c1 zeroize-1_8_1-966e26bee9773779];
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
    CARGO_CRATE_NAME = "sec1";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of SEC1: Elliptic Curve Cryptography encoding formats
including ASN.1 DER-serialized private keys as well as the
Elliptic-Curve-Point-to-Octet-String encoding";
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
              --crate-name sec1 \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
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
              -C metadata=13cc7f88371e1250 \
              -C extra-filename=-405cf947070e5373 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern base16ct=${base16ct-0_2_0-03a13dfc8db9d885}/libbase16ct-03a13dfc8db9d885.rmeta \
              --extern der=${der-0_7_9-9223185c0fceb330}/libder-9223185c0fceb330.rmeta \
              --extern generic_array=${generic-array-0_14_7-28e5836782b73319}/libgeneric_array-28e5836782b73319.rmeta \
              --extern pkcs8=${pkcs8-0_10_2-d9da1a442d6d1c2e}/libpkcs8-d9da1a442d6d1c2e.rmeta \
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
