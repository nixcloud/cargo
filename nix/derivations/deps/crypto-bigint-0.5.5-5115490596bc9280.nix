# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "crypto-bigint-0_5_5-5115490596bc9280";
    meta.cargo_crate_info = {
      name = "crypto-bigint";
      version = "0.5.5";
      crate_hash = "5115490596bc9280";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [generic-array-0_14_7-cf1af5fa7e31ffd0 rand_core-0_6_4-5078be04f75dc0b2 subtle-2_6_1-61dbca2d742edabc zeroize-1_8_1-9a1357fe1b2d7a82];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/crypto-bigint/0.5.5/download";
      sha256 = "0dc92fb57ca44df6db8059111ab3af99a63d5d0f8375d9972e319a379c6bab76";
    };
    unpackPhase = ''
      tar xf $src
      cd crypto-bigint-0.5.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "crypto_bigint";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of a big integer library which has been designed from
the ground-up for use in cryptographic applications. Provides constant-time,
no_std-friendly implementations of modern formulas using const generics.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "crypto-bigint";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/crypto-bigint";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.5.5";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "5";
    CARGO_PKG_VERSION_PATCH = "5";
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
              --crate-name crypto_bigint \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="generic-array"' \
              --cfg 'feature="rand_core"' \
              --cfg 'feature="zeroize"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "default", "der", "extra-sizes", "generic-array", "rand", "rand_core", "rlp", "serde", "zeroize"))' \
              -C metadata=30a3c1e70e148f39 \
              -C extra-filename=-5115490596bc9280 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern generic_array=${generic-array-0_14_7-cf1af5fa7e31ffd0}/libgeneric_array-cf1af5fa7e31ffd0.rmeta \
              --extern rand_core=${rand_core-0_6_4-5078be04f75dc0b2}/librand_core-5078be04f75dc0b2.rmeta \
              --extern subtle=${subtle-2_6_1-61dbca2d742edabc}/libsubtle-61dbca2d742edabc.rmeta \
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
