# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "der-0_7_9-39bc94e6d7deac42";
    meta.cargo_crate_info = {
      name = "der";
      version = "0.7.9";
      crate_hash = "39bc94e6d7deac42";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [const-oid-0_9_6-78dc06c180518cb4 pem-rfc7468-0_7_0-9363a4c91bcb7bc9 zeroize-1_8_1-9a1357fe1b2d7a82];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/der/0.7.9/download";
      sha256 = "f55bf8e7b65898637379c1b74eb1551107c8294ed26d855ceb9fd1a09cfc9bc0";
    };
    unpackPhase = ''
      tar xf $src
      cd der-0.7.9
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "der";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust embedded-friendly implementation of the Distinguished Encoding Rules
(DER) for Abstract Syntax Notation One (ASN.1) as described in ITU X.690 with
full support for heapless no_std targets";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "der";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/formats/tree/master/der";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.7.9";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
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
              --crate-name der \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --cfg 'feature="oid"' \
              --cfg 'feature="pem"' \
              --cfg 'feature="std"' \
              --cfg 'feature="zeroize"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "arbitrary", "bytes", "derive", "flagset", "oid", "pem", "real", "std", "time", "zeroize"))' \
              -C metadata=521cb274a623f6e0 \
              -C extra-filename=-39bc94e6d7deac42 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern const_oid=${const-oid-0_9_6-78dc06c180518cb4}/libconst_oid-78dc06c180518cb4.rmeta \
              --extern pem_rfc7468=${pem-rfc7468-0_7_0-9363a4c91bcb7bc9}/libpem_rfc7468-9363a4c91bcb7bc9.rmeta \
              --extern zeroize=${zeroize-1_8_1-9a1357fe1b2d7a82}/libzeroize-9a1357fe1b2d7a82.rmeta \
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
