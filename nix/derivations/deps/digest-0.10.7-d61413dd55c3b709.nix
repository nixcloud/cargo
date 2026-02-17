# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "digest-0_10_7-d61413dd55c3b709";
    meta.cargo_crate_info = {
      name = "digest";
      version = "0.10.7";
      crate_hash = "d61413dd55c3b709";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [block-buffer-0_10_4-8ecc6e390505da10 const-oid-0_9_6-78dc06c180518cb4 crypto-common-0_1_6-761785559be53d0e subtle-2_6_1-61dbca2d742edabc];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/digest/0.10.7/download";
      sha256 = "9ed9a281f7bc9b7576e61468ba615a66a5c8cfdff42420a70aa82701a3b1e292";
    };
    unpackPhase = ''
      tar xf $src
      cd digest-0.10.7
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "digest";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Traits for cryptographic hash functions and message authentication codes";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "digest";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/traits";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.10.7";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "10";
    CARGO_PKG_VERSION_PATCH = "7";
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
              --crate-name digest \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --cfg 'feature="block-buffer"' \
              --cfg 'feature="const-oid"' \
              --cfg 'feature="core-api"' \
              --cfg 'feature="default"' \
              --cfg 'feature="mac"' \
              --cfg 'feature="oid"' \
              --cfg 'feature="std"' \
              --cfg 'feature="subtle"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "blobby", "block-buffer", "const-oid", "core-api", "default", "dev", "mac", "oid", "rand_core", "std", "subtle"))' \
              -C metadata=2650d8701cb6b957 \
              -C extra-filename=-d61413dd55c3b709 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern block_buffer=${block-buffer-0_10_4-8ecc6e390505da10}/libblock_buffer-8ecc6e390505da10.rmeta \
              --extern const_oid=${const-oid-0_9_6-78dc06c180518cb4}/libconst_oid-78dc06c180518cb4.rmeta \
              --extern crypto_common=${crypto-common-0_1_6-761785559be53d0e}/libcrypto_common-761785559be53d0e.rmeta \
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
