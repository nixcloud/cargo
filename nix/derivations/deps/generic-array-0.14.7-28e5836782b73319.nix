# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "generic-array-0_14_7-28e5836782b73319";
    meta.cargo_crate_info = {
      name = "generic-array";
      version = "0.14.7";
      crate_hash = "28e5836782b73319";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [typenum-1_17_0-2372da56c1d08181 zeroize-1_8_1-966e26bee9773779];
    passthru.rust_crate_parent = [generic-array-0_14_7-script_build_run-40414111f0038cbd];
    passthru.rust_script_build_run = [generic-array-0_14_7-script_build_run-40414111f0038cbd];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/generic-array/0.14.7/download";
      sha256 = "85649ca51fd72272d7821adaf274ad91c288277713d9c18820d8499a7ff69e9a";
    };

    unpackPhase = ''
      tar xf $src
      cd generic-array-0.14.7
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "generic_array";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Bartłomiej Kamiński <fizyk20@gmail.com>:Aaron Trent <novacrazy@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Generic types implementing functionality of arrays";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "generic-array";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/fizyk20/generic-array.git";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.14.7";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "14";
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
              --crate-name generic_array \
              --edition=2015 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="more_lengths"' \
              --cfg 'feature="zeroize"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("more_lengths", "serde", "zeroize"))' \
              -C metadata=e92c4c098cc6271e \
              -C extra-filename=-28e5836782b73319 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern typenum=${typenum-1_17_0-2372da56c1d08181}/libtypenum-2372da56c1d08181.rmeta \
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
