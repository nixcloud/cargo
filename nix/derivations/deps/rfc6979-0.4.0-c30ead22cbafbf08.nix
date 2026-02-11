# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "rfc6979-0_4_0-c30ead22cbafbf08";
    meta.cargo_crate_info = {
      name = "rfc6979";
      version = "0.4.0";
      crate_hash = "c30ead22cbafbf08";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [hmac-0_12_1-84aacd8a0108f7c5 subtle-2_6_1-61dbca2d742edabc];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/rfc6979/0.4.0/download";
      sha256 = "f8dd2a808d456c4a54e300a23e9f5a67e122c3024119acbfd73e3bf664491cb2";
    };
    unpackPhase = ''
      tar xf $src
      cd rfc6979-0.4.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "rfc6979";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of RFC6979: Deterministic Usage of the
Digital Signature Algorithm (DSA) and Elliptic Curve Digital Signature Algorithm (ECDSA)";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "rfc6979";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/signatures/tree/master/rfc6979";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "0.4.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "0";
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
              --crate-name rfc6979 \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values())' \
              -C metadata=638c3c67bd383cc8 \
              -C extra-filename=-c30ead22cbafbf08 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern hmac=${hmac-0_12_1-84aacd8a0108f7c5}/libhmac-84aacd8a0108f7c5.rmeta \
              --extern subtle=${subtle-2_6_1-61dbca2d742edabc}/libsubtle-61dbca2d742edabc.rmeta \
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
