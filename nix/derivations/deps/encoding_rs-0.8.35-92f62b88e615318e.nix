# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "encoding_rs-0_8_35-92f62b88e615318e";
    meta.cargo_crate_info = {
      name = "encoding_rs";
      version = "0.8.35";
      crate_hash = "92f62b88e615318e";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [cfg-if-1_0_0-616d46354eebf850];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/encoding_rs/0.8.35/download";
      sha256 = "75030f3c4f45dafd7586dd6780965a8c7e8e285a5ecb86713e63a79c5b2766f3";
    };
    unpackPhase = ''
      tar xf $src
      cd encoding_rs-0.8.35
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "encoding_rs";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Henri Sivonen <hsivonen@hsivonen.fi>";
    CARGO_PKG_DESCRIPTION = "A Gecko-oriented implementation of the Encoding Standard";
    CARGO_PKG_HOMEPAGE = "https://docs.rs/encoding_rs/";
    CARGO_PKG_LICENSE = "(Apache-2.0 OR MIT) AND BSD-3-Clause";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "encoding_rs";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/hsivonen/encoding_rs";
    CARGO_PKG_RUST_VERSION = "1.36";
    CARGO_PKG_VERSION = "0.8.35";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "35";
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
              --crate-name encoding_rs \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --cfg 'feature="default"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "any_all_workaround", "default", "fast-big5-hanzi-encode", "fast-gb-hanzi-encode", "fast-hangul-encode", "fast-hanja-encode", "fast-kanji-encode", "fast-legacy-encode", "less-slow-big5-hanzi-encode", "less-slow-gb-hanzi-encode", "less-slow-kanji-encode", "serde", "simd-accel"))' \
              -C metadata=d0631196d05a061d \
              -C extra-filename=-92f62b88e615318e \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern cfg_if=${cfg-if-1_0_0-616d46354eebf850}/libcfg_if-616d46354eebf850.rmeta \
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
