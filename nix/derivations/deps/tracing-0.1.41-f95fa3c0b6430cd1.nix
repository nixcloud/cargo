# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tracing-0_1_41-f95fa3c0b6430cd1";
    meta.cargo_crate_info = {
      name = "tracing";
      version = "0.1.41";
      crate_hash = "f95fa3c0b6430cd1";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [pin-project-lite-0_2_16-f8d8932d926df9e6 tracing-attributes-0_1_28-93b80f5e76ca28cd tracing-core-0_1_33-aece38920b28e8c6];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tracing/0.1.41/download";
      sha256 = "784e0ac535deb450455cbfa28a6f0df145ea1bb7ae51b821cf5e7927fdcfbdd0";
    };

    unpackPhase = ''
      tar xf $src
      cd tracing-0.1.41
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "tracing";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Eliza Weisman <eliza@buoyant.io>:Tokio Contributors <team@tokio.rs>";
    CARGO_PKG_DESCRIPTION = "Application-level tracing for Rust.";
    CARGO_PKG_HOMEPAGE = "https://tokio.rs";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tracing";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/tokio-rs/tracing";
    CARGO_PKG_RUST_VERSION = "1.63.0";
    CARGO_PKG_VERSION = "0.1.41";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "41";
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
              --crate-name tracing \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              --warn=unexpected_cfgs \
              --check-cfg 'cfg(flaky_tests)' \
              --check-cfg 'cfg(tracing_unstable)' \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="attributes"' \
              --cfg 'feature="std"' \
              --cfg 'feature="tracing-attributes"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("async-await", "attributes", "default", "log", "log-always", "max_level_debug", "max_level_error", "max_level_info", "max_level_off", "max_level_trace", "max_level_warn", "release_max_level_debug", "release_max_level_error", "release_max_level_info", "release_max_level_off", "release_max_level_trace", "release_max_level_warn", "std", "tracing-attributes", "valuable"))' \
              -C metadata=fabe44020fd95de4 \
              -C extra-filename=-f95fa3c0b6430cd1 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern pin_project_lite=${pin-project-lite-0_2_16-f8d8932d926df9e6}/libpin_project_lite-f8d8932d926df9e6.rmeta \
              --extern tracing_attributes=${tracing-attributes-0_1_28-93b80f5e76ca28cd}/libtracing_attributes-93b80f5e76ca28cd.so \
              --extern tracing_core=${tracing-core-0_1_33-aece38920b28e8c6}/libtracing_core-aece38920b28e8c6.rmeta \
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
