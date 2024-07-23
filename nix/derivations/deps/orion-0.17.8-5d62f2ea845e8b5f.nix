# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "orion-0_17_8-5d62f2ea845e8b5f";
    meta.cargo_crate_info = {
      name = "orion";
      version = "0.17.8";
      crate_hash = "5d62f2ea845e8b5f";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [fiat-crypto-0_2_9-037e45f01d16bb63 subtle-2_6_1-0584afad8ebd85c1 zeroize-1_8_1-966e26bee9773779];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/orion/0.17.8/download";
      sha256 = "dd806049e71da4c4a7880466b37afdc5a4c5b35a398b0d4fd9ff5d278d3b4db9";
    };

    unpackPhase = ''
      tar xf $src
      cd orion-0.17.8
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "orion";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "brycx <brycx@protonmail.com>";
    CARGO_PKG_DESCRIPTION = "Usable, easy and safe pure-Rust crypto";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "orion";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/orion-rs/orion";
    CARGO_PKG_RUST_VERSION = "1.80";
    CARGO_PKG_VERSION = "0.17.8";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "17";
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
              --crate-name orion \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "ct-codecs", "default", "experimental", "getrandom", "safe_api", "serde"))' \
              -C metadata=a9e0dd2b523bdf25 \
              -C extra-filename=-5d62f2ea845e8b5f \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern fiat_crypto=${fiat-crypto-0_2_9-037e45f01d16bb63}/libfiat_crypto-037e45f01d16bb63.rmeta \
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
