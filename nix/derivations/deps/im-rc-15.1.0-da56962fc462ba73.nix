# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "im-rc-15_1_0-da56962fc462ba73";
    meta.cargo_crate_info = {
      name = "im-rc";
      version = "15.1.0";
      crate_hash = "da56962fc462ba73";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [bitmaps-2_1_0-2e9cf441e3de2772 rand_core-0_6_4-fb3f0a376173ae44 rand_xoshiro-0_6_0-85d0bd006bb29f8e sized-chunks-0_6_5-c0f56a3159cd521e typenum-1_17_0-2372da56c1d08181];
    passthru.rust_crate_parent = [im-rc-15_1_0-script_build_run-d8792684cc68fdb8];
    passthru.rust_script_build_run = [im-rc-15_1_0-script_build_run-d8792684cc68fdb8];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/im-rc/15.1.0/download";
      sha256 = "af1955a75fa080c677d3972822ec4bad316169ab1cfc6c257a942c2265dbe5fe";
    };

    unpackPhase = ''
      tar xf $src
      cd im-rc-15.1.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "im_rc";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Bodil Stokke <bodil@bodil.org>";
    CARGO_PKG_DESCRIPTION = "Immutable collection datatypes (the fast but not thread safe version)";
    CARGO_PKG_HOMEPAGE = "http://immutable.rs/";
    CARGO_PKG_LICENSE = "MPL-2.0+";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "im-rc";
    CARGO_PKG_README = "../../README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/bodil/im-rs";
    CARGO_PKG_RUST_VERSION = "1.46.0";
    CARGO_PKG_VERSION = "15.1.0";
    CARGO_PKG_VERSION_MAJOR = "15";
    CARGO_PKG_VERSION_MINOR = "1";
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
      copy_build_script_run_results_over_with_nix "${fn.get_rust_crate_parent passthru.rust_crate_parent}"
      for file in $out/environment-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
          if [ -f "$file" ]; then
          sed -i "s|${fn.get_rust_crate_parent passthru.rust_crate_parent}|$out|g" "$file"
          fi
      done
      load_environment_variables_from_files "${fn.environment_variables passthru.rust_script_build_run}"
      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name im_rc \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("arbitrary", "debug", "pool", "proptest", "quickcheck", "rayon", "refpool", "serde"))' \
              -C metadata=8db94d9d1fc93cb6 \
              -C extra-filename=-da56962fc462ba73 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern bitmaps=${bitmaps-2_1_0-2e9cf441e3de2772}/libbitmaps-2e9cf441e3de2772.rmeta \
              --extern rand_core=${rand_core-0_6_4-fb3f0a376173ae44}/librand_core-fb3f0a376173ae44.rmeta \
              --extern rand_xoshiro=${rand_xoshiro-0_6_0-85d0bd006bb29f8e}/librand_xoshiro-85d0bd006bb29f8e.rmeta \
              --extern sized_chunks=${sized-chunks-0_6_5-c0f56a3159cd521e}/libsized_chunks-c0f56a3159cd521e.rmeta \
              --extern typenum=${typenum-1_17_0-2372da56c1d08181}/libtypenum-2372da56c1d08181.rmeta \
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
