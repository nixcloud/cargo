# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "thiserror-2_0_11-a57592ffa4ea41e0";
    meta.cargo_crate_info = {
      name = "thiserror";
      version = "2.0.11";
      crate_hash = "a57592ffa4ea41e0";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [thiserror-impl-2_0_11-66c29e07c551aa3d];
    passthru.rust_crate_parent = [thiserror-2_0_11-script_build_run-83d85e9483fbe13c];
    passthru.rust_script_build_run = [thiserror-2_0_11-script_build_run-83d85e9483fbe13c];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/thiserror/2.0.11/download";
      sha256 = "d452f284b73e6d76dd36758a0c8684b1d5be31f92b89d07fd5822175732206fc";
    };
    unpackPhase = ''
      tar xf $src
      cd thiserror-2.0.11
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "thiserror";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "David Tolnay <dtolnay@gmail.com>";
    CARGO_PKG_DESCRIPTION = "derive(Error)";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "thiserror";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/dtolnay/thiserror";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "2.0.11";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "11";
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
              --crate-name thiserror \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "std"))' \
              -C metadata=5f2a14a8905d4b31 \
              -C extra-filename=-a57592ffa4ea41e0 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern thiserror_impl=${thiserror-impl-2_0_11-66c29e07c551aa3d}/libthiserror_impl-66c29e07c551aa3d.so \
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
