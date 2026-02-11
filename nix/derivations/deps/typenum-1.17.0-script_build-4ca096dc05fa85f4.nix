# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "typenum-1_17_0-script_build-4ca096dc05fa85f4";
    meta.cargo_crate_info = {
      name = "typenum";
      version = "1.17.0";
      crate_hash = "4ca096dc05fa85f4";
      type = "(build.rs build)";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/typenum/1.17.0/download";
      sha256 = "42ff0bf0c66b8238c6f3b578df37d0b7848e55df8577b3f74f92a69acceeb825";
    };
    unpackPhase = ''
      tar xf $src
      cd typenum-1.17.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "build_script_main";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Paho Lurie-Gregg <paho@paholg.com>:Andre Bogus <bogusandre@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Typenum is a Rust library for type-level numbers evaluated at
    compile time. It currently supports bits, unsigned integers, and signed
    integers. It also provides a type-level array of type-level numbers, but its
    implementation is incomplete.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "typenum";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/paholg/typenum";
    CARGO_PKG_RUST_VERSION = "1.37.0";
    CARGO_PKG_VERSION = "1.17.0";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "17";
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

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name build_script_main \
              --edition=2018 build/main.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type bin \
              --emit=dep-info,link \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("const-generics", "force_unix_path_separator", "i128", "no_std", "scale-info", "scale_info", "strict"))' \
              -C metadata=399d043ad9f9cd30 \
              -C extra-filename=-4ca096dc05fa85f4 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
            ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-4ca096dc05fa85f4 $OUT_DIR/build_script_build
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
