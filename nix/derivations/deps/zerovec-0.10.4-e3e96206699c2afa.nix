# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "zerovec-0_10_4-e3e96206699c2afa";
    meta.cargo_crate_info = {
      name = "zerovec";
      version = "0.10.4";
      crate_hash = "e3e96206699c2afa";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [yoke-0_7_5-06c6b7b4d71d5784 zerofrom-0_1_5-67ba692659162de9 zerovec-derive-0_10_3-229ca38161287853];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/zerovec/0.10.4/download";
      sha256 = "aa2b893d79df23bfb12d5461018d408ea19dfafe76c2c7ef6d4eba614f8ff079";
    };
    unpackPhase = ''
      tar xf $src
      cd zerovec-0.10.4
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "zerovec";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The ICU4X Project Developers";
    CARGO_PKG_DESCRIPTION = "Zero-copy vector backed by a byte array";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "zerovec";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/unicode-org/icu4x";
    CARGO_PKG_RUST_VERSION = "1.67";
    CARGO_PKG_VERSION = "0.10.4";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "10";
    CARGO_PKG_VERSION_PATCH = "4";
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
              --crate-name zerovec \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="derive"' \
              --cfg 'feature="yoke"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("bench", "databake", "derive", "hashmap", "serde", "std", "yoke"))' \
              -C metadata=e8318a1ad228fdd5 \
              -C extra-filename=-e3e96206699c2afa \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern yoke=${yoke-0_7_5-06c6b7b4d71d5784}/libyoke-06c6b7b4d71d5784.rmeta \
              --extern zerofrom=${zerofrom-0_1_5-67ba692659162de9}/libzerofrom-67ba692659162de9.rmeta \
              --extern zerovec_derive=${zerovec-derive-0_10_3-229ca38161287853}/libzerovec_derive-229ca38161287853.so \
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
