# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "hashbrown-0_14_5-0902b9e9c2cf4ed1";
    meta.cargo_crate_info = {
      name = "hashbrown";
      version = "0.14.5";
      crate_hash = "0902b9e9c2cf4ed1";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [ahash-0_8_11-8f60023f209663c7 allocator-api2-0_2_21-bd3713078dfee01f];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/hashbrown/0.14.5/download";
      sha256 = "e5274423e17b7c9fc20b6e7e208532f9b19825d82dfd615708b70edd83df41f1";
    };
    unpackPhase = ''
      tar xf $src
      cd hashbrown-0.14.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "hashbrown";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Amanieu d'Antras <amanieu@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A Rust port of Google's SwissTable hash map";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "hashbrown";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/hashbrown";
    CARGO_PKG_RUST_VERSION = "1.63.0";
    CARGO_PKG_VERSION = "0.14.5";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "14";
    CARGO_PKG_VERSION_PATCH = "5";
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
              --crate-name hashbrown \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="ahash"' \
              --cfg 'feature="allocator-api2"' \
              --cfg 'feature="default"' \
              --cfg 'feature="inline-more"' \
              --cfg 'feature="raw"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("ahash", "alloc", "allocator-api2", "compiler_builtins", "core", "default", "equivalent", "inline-more", "nightly", "raw", "rayon", "rkyv", "rustc-dep-of-std", "rustc-internal-api", "serde"))' \
              -C metadata=3b2984debef64e2f \
              -C extra-filename=-0902b9e9c2cf4ed1 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern ahash=${ahash-0_8_11-8f60023f209663c7}/libahash-8f60023f209663c7.rmeta \
              --extern allocator_api2=${allocator-api2-0_2_21-bd3713078dfee01f}/liballocator_api2-bd3713078dfee01f.rmeta \
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
