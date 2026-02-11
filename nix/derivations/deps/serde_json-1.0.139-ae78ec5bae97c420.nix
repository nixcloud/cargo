# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "serde_json-1_0_139-ae78ec5bae97c420";
    meta.cargo_crate_info = {
      name = "serde_json";
      version = "1.0.139";
      crate_hash = "ae78ec5bae97c420";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [itoa-1_0_14-6ae7bc765ab6d9fa memchr-2_7_4-3cee6db17bbe0dde ryu-1_0_19-e43e7d32117cb8d6 serde-1_0_218-472e28b9f131b02c];
    passthru.rust_crate_parent = [serde_json-1_0_139-script_build_run-0c75c9c70c6b060e];
    passthru.rust_script_build_run = [serde_json-1_0_139-script_build_run-0c75c9c70c6b060e];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/serde_json/1.0.139/download";
      sha256 = "44f86c3acccc9c65b153fe1b85a3be07fe5515274ec9f0653b4a0875731c72a6";
    };
    unpackPhase = ''
      tar xf $src
      cd serde_json-1.0.139
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "serde_json";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Erick Tryzelaar <erick.tryzelaar@gmail.com>:David Tolnay <dtolnay@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A JSON serialization file format";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "serde_json";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/serde-rs/json";
    CARGO_PKG_RUST_VERSION = "1.56";
    CARGO_PKG_VERSION = "1.0.139";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "139";
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
              --crate-name serde_json \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="raw_value"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "arbitrary_precision", "default", "float_roundtrip", "indexmap", "preserve_order", "raw_value", "std", "unbounded_depth"))' \
              -C metadata=01f5033f039c19dc \
              -C extra-filename=-ae78ec5bae97c420 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern itoa=${itoa-1_0_14-6ae7bc765ab6d9fa}/libitoa-6ae7bc765ab6d9fa.rmeta \
              --extern memchr=${memchr-2_7_4-3cee6db17bbe0dde}/libmemchr-3cee6db17bbe0dde.rmeta \
              --extern ryu=${ryu-1_0_19-e43e7d32117cb8d6}/libryu-e43e7d32117cb8d6.rmeta \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
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
