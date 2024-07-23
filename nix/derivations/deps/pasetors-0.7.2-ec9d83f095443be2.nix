# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "pasetors-0_7_2-ec9d83f095443be2";
    meta.cargo_crate_info = {
      name = "pasetors";
      version = "0.7.2";
      crate_hash = "ec9d83f095443be2";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [ct-codecs-1_1_3-7a8152012b595d7e ed25519-compact-2_1_1-7a9cae9574606b40 getrandom-0_3_1-e63b8caed24af524 orion-0_17_8-5d62f2ea845e8b5f p384-0_13_1-7d858bca7ae4dcb6 rand_core-0_6_4-fb3f0a376173ae44 regex-1_11_1-78f28ee524c2cf84 serde-1_0_218-ed8707ff8dc168e7 serde_json-1_0_139-17182eb61f3853cc sha2-0_10_8-259709e389f530eb subtle-2_6_1-0584afad8ebd85c1 time-0_3_37-470f9c4ebcfb97a1 zeroize-1_8_1-966e26bee9773779];
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
              -C opt-level=3 \
              -C embed-bitcode=no \
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
              -C metadata=cfe56901c4479465 \
              -C extra-filename=-ec9d83f095443be2 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern ct_codecs=${ct-codecs-1_1_3-7a8152012b595d7e}/libct_codecs-7a8152012b595d7e.rmeta \
              --extern ed25519_compact=${ed25519-compact-2_1_1-7a9cae9574606b40}/libed25519_compact-7a9cae9574606b40.rmeta \
              --extern getrandom=${getrandom-0_3_1-e63b8caed24af524}/libgetrandom-e63b8caed24af524.rmeta \
              --extern orion=${orion-0_17_8-5d62f2ea845e8b5f}/liborion-5d62f2ea845e8b5f.rmeta \
              --extern p384=${p384-0_13_1-7d858bca7ae4dcb6}/libp384-7d858bca7ae4dcb6.rmeta \
              --extern rand_core=${rand_core-0_6_4-fb3f0a376173ae44}/librand_core-fb3f0a376173ae44.rmeta \
              --extern regex=${regex-1_11_1-78f28ee524c2cf84}/libregex-78f28ee524c2cf84.rmeta \
              --extern serde=${serde-1_0_218-ed8707ff8dc168e7}/libserde-ed8707ff8dc168e7.rmeta \
              --extern serde_json=${serde_json-1_0_139-17182eb61f3853cc}/libserde_json-17182eb61f3853cc.rmeta \
              --extern sha2=${sha2-0_10_8-259709e389f530eb}/libsha2-259709e389f530eb.rmeta \
              --extern subtle=${subtle-2_6_1-0584afad8ebd85c1}/libsubtle-0584afad8ebd85c1.rmeta \
              --extern time=${time-0_3_37-470f9c4ebcfb97a1}/libtime-470f9c4ebcfb97a1.rmeta \
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
