# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "serde-1_0_218-472e28b9f131b02c";
    meta.cargo_crate_info = {
      name = "serde";
      version = "1.0.218";
      crate_hash = "472e28b9f131b02c";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [serde_derive-1_0_218-5e91c4ae42a1c7c1];
    passthru.rust_crate_parent = [serde-1_0_218-script_build_run-e17f586beb12995f];
    passthru.rust_script_build_run = [serde-1_0_218-script_build_run-e17f586beb12995f];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/serde/1.0.218/download";
      sha256 = "e8dfc9d19bdbf6d17e22319da49161d5d0108e4188e8b680aef6299eed22df60";
    };
    unpackPhase = ''
      tar xf $src
      cd serde-1.0.218
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "serde";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Erick Tryzelaar <erick.tryzelaar@gmail.com>:David Tolnay <dtolnay@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A generic serialization/deserialization framework";
    CARGO_PKG_HOMEPAGE = "https://serde.rs";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "serde";
    CARGO_PKG_README = "crates-io.md";
    CARGO_PKG_REPOSITORY = "https://github.com/serde-rs/serde";
    CARGO_PKG_RUST_VERSION = "1.31";
    CARGO_PKG_VERSION = "1.0.218";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "218";
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
              --crate-name serde \
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
              --cfg 'feature="derive"' \
              --cfg 'feature="serde_derive"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "default", "derive", "rc", "serde_derive", "std", "unstable"))' \
              -C metadata=f9774c37174dd7cf \
              -C extra-filename=-472e28b9f131b02c \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern serde_derive=${serde_derive-1_0_218-5e91c4ae42a1c7c1}/libserde_derive-5e91c4ae42a1c7c1.so \
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
