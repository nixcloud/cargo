# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "zerocopy-0_7_35-3bfa5c0641b64c54";
    meta.cargo_crate_info = {
      name = "zerocopy";
      version = "0.7.35";
      crate_hash = "3bfa5c0641b64c54";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [byteorder-1_5_0-a28b656e45fc3f61 zerocopy-derive-0_7_35-dd0eb8a6661fb4f3];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/zerocopy/0.7.35/download";
      sha256 = "1b9b4fd18abc82b8136838da5d50bae7bdea537c574d8dc1a34ed098d6c166f0";
    };

    unpackPhase = ''
      tar xf $src
      cd zerocopy-0.7.35
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "zerocopy";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Joshua Liebow-Feeser <joshlf@google.com>";
    CARGO_PKG_DESCRIPTION = "Utilities for zero-copy parsing and serialization";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "BSD-2-Clause OR Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "zerocopy";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/google/zerocopy";
    CARGO_PKG_RUST_VERSION = "1.60.0";
    CARGO_PKG_VERSION = "0.7.35";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
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
              --crate-name zerocopy \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="byteorder"' \
              --cfg 'feature="default"' \
              --cfg 'feature="derive"' \
              --cfg 'feature="simd"' \
              --cfg 'feature="zerocopy-derive"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("__internal_use_only_features_that_work_on_stable", "alloc", "byteorder", "default", "derive", "simd", "simd-nightly", "zerocopy-derive"))' \
              -C metadata=73a3257f3b93c673 \
              -C extra-filename=-3bfa5c0641b64c54 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern byteorder=${byteorder-1_5_0-a28b656e45fc3f61}/libbyteorder-a28b656e45fc3f61.rmeta \
              --extern zerocopy_derive=${zerocopy-derive-0_7_35-dd0eb8a6661fb4f3}/libzerocopy_derive-dd0eb8a6661fb4f3.so \
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
