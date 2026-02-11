# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "allocator-api2-0_2_21-bd3713078dfee01f";
    meta.cargo_crate_info = {
      name = "allocator-api2";
      version = "0.2.21";
      crate_hash = "bd3713078dfee01f";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/allocator-api2/0.2.21/download";
      sha256 = "683d7910e743518b0e34f1186f92494becacb047c7b6bf616c96772180fef923";
    };
    unpackPhase = ''
      tar xf $src
      cd allocator-api2-0.2.21
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "allocator_api2";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Zakarum <zaq.dev@icloud.com>";
    CARGO_PKG_DESCRIPTION = "Mirror of Rust's allocator API";
    CARGO_PKG_HOMEPAGE = "https://github.com/zakarumych/allocator-api2";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "allocator-api2";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/zakarumych/allocator-api2";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "0.2.21";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "21";
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
              --crate-name allocator_api2 \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --warn=unexpected_cfgs \
              --check-cfg 'cfg(no_global_oom_handling)' \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "default", "fresh-rust", "nightly", "serde", "std"))' \
              -C metadata=2f0dfb5a1472cf8e \
              -C extra-filename=-bd3713078dfee01f \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
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
