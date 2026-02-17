# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "pasetors-0_7_2-0e3e06d4cbb54d3a";
    meta.cargo_crate_info = {
      name = "pasetors";
      version = "0.7.2";
      crate_hash = "0e3e06d4cbb54d3a";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [ct-codecs-1_1_3-4c4f37d16030cc7d ed25519-compact-2_1_1-1c5101fb43379bc2 getrandom-0_3_1-f98539da635491d1 orion-0_17_8-a6cc6ad3939ba568 p384-0_13_1-82d825337ebe46c2 rand_core-0_6_4-5078be04f75dc0b2 regex-1_11_1-c278e9a7e455d20f serde-1_0_218-472e28b9f131b02c serde_json-1_0_139-ae78ec5bae97c420 sha2-0_10_8-bdde0649695b7ac6 subtle-2_6_1-61dbca2d742edabc time-0_3_37-b73d8cae561973b7 zeroize-1_8_1-9a1357fe1b2d7a82];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/pasetors/0.7.2/download";
      sha256 = "c54944fa25a6e7c9c5b3315f118d360cc00d555cf53bb2b2fdf32dd31c71b729";
    };
    unpackPhase = ''
      tar xf $src
      cd pasetors-0.7.2
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "pasetors";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "brycx <brycx@protonmail.com>";
    CARGO_PKG_DESCRIPTION = "PASETO: Platform-Agnostic Security Tokens (in Rust)";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "pasetors";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/brycx/pasetors";
    CARGO_PKG_RUST_VERSION = "1.80.0";
    CARGO_PKG_VERSION = "0.7.2";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "2";
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
              --crate-name pasetors \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="ed25519-compact"' \
              --cfg 'feature="orion"' \
              --cfg 'feature="p384"' \
              --cfg 'feature="paserk"' \
              --cfg 'feature="rand_core"' \
              --cfg 'feature="regex"' \
              --cfg 'feature="serde"' \
              --cfg 'feature="serde_json"' \
              --cfg 'feature="sha2"' \
              --cfg 'feature="std"' \
              --cfg 'feature="time"' \
              --cfg 'feature="v3"' \
              --cfg 'feature="v4"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "ed25519-compact", "orion", "p384", "paserk", "rand_core", "regex", "serde", "serde_json", "sha2", "std", "time", "v2", "v3", "v4"))' \
              -C metadata=433638bcbef80458 \
              -C extra-filename=-0e3e06d4cbb54d3a \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern ct_codecs=${ct-codecs-1_1_3-4c4f37d16030cc7d}/libct_codecs-4c4f37d16030cc7d.rmeta \
              --extern ed25519_compact=${ed25519-compact-2_1_1-1c5101fb43379bc2}/libed25519_compact-1c5101fb43379bc2.rmeta \
              --extern getrandom=${getrandom-0_3_1-f98539da635491d1}/libgetrandom-f98539da635491d1.rmeta \
              --extern orion=${orion-0_17_8-a6cc6ad3939ba568}/liborion-a6cc6ad3939ba568.rmeta \
              --extern p384=${p384-0_13_1-82d825337ebe46c2}/libp384-82d825337ebe46c2.rmeta \
              --extern rand_core=${rand_core-0_6_4-5078be04f75dc0b2}/librand_core-5078be04f75dc0b2.rmeta \
              --extern regex=${regex-1_11_1-c278e9a7e455d20f}/libregex-c278e9a7e455d20f.rmeta \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
              --extern serde_json=${serde_json-1_0_139-ae78ec5bae97c420}/libserde_json-ae78ec5bae97c420.rmeta \
              --extern sha2=${sha2-0_10_8-bdde0649695b7ac6}/libsha2-bdde0649695b7ac6.rmeta \
              --extern subtle=${subtle-2_6_1-61dbca2d742edabc}/libsubtle-61dbca2d742edabc.rmeta \
              --extern time=${time-0_3_37-b73d8cae561973b7}/libtime-b73d8cae561973b7.rmeta \
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
