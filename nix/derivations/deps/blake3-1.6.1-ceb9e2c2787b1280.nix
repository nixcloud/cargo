# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "blake3-1_6_1-ceb9e2c2787b1280";
    meta.cargo_crate_info = {
      name = "blake3";
      version = "1.6.1";
      crate_hash = "ceb9e2c2787b1280";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [arrayref-0_3_9-b991aefb74018707 arrayvec-0_7_6-6c3d4fac0079d5d1 cfg-if-1_0_0-424abd49c6d5f017 constant_time_eq-0_3_1-94020b1cb70f9a08];
    passthru.rust_crate_parent = [blake3-1_6_1-script_build_run-ca3cbed55d4f6861];
    passthru.rust_script_build_run = [blake3-1_6_1-script_build_run-ca3cbed55d4f6861];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/blake3/1.6.1/download";
      sha256 = "675f87afced0413c9bb02843499dbbd3882a237645883f71a2b59644a6d2f753";
    };

    unpackPhase = ''
      tar xf $src
      cd blake3-1.6.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "blake3";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Jack O'Connor <oconnor663@gmail.com>:Samuel Neves";
    CARGO_PKG_DESCRIPTION = "the BLAKE3 hash function";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "CC0-1.0 OR Apache-2.0 OR Apache-2.0 WITH LLVM-exception";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "blake3";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/BLAKE3-team/BLAKE3";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "1.6.1";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "6";
    CARGO_PKG_VERSION_PATCH = "1";
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
              --crate-name blake3 \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "digest", "mmap", "neon", "no_avx2", "no_avx512", "no_neon", "no_sse2", "no_sse41", "prefer_intrinsics", "pure", "rayon", "serde", "std", "traits-preview", "zeroize"))' \
              -C metadata=de2ca4f91932ec0a \
              -C extra-filename=-ceb9e2c2787b1280 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern arrayref=${arrayref-0_3_9-b991aefb74018707}/libarrayref-b991aefb74018707.rmeta \
              --extern arrayvec=${arrayvec-0_7_6-6c3d4fac0079d5d1}/libarrayvec-6c3d4fac0079d5d1.rmeta \
              --extern cfg_if=${cfg-if-1_0_0-424abd49c6d5f017}/libcfg_if-424abd49c6d5f017.rmeta \
              --extern constant_time_eq=${constant_time_eq-0_3_1-94020b1cb70f9a08}/libconstant_time_eq-94020b1cb70f9a08.rmeta \
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
