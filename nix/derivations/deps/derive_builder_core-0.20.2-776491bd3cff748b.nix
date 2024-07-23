# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "derive_builder_core-0_20_2-776491bd3cff748b";
    meta.cargo_crate_info = {
      name = "derive_builder_core";
      version = "0.20.2";
      crate_hash = "776491bd3cff748b";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [darling-0_20_10-8fd75665fdb6cbf2 proc-macro2-1_0_93-8972bce74b99a2b8 quote-1_0_38-69fc837ab5040c10 syn-2_0_98-cf14ab7ccae9dbe8];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/derive_builder_core/0.20.2/download";
      sha256 = "2d5bcf7b024d6835cfb3d473887cd966994907effbe9227e8c8219824d06c4e8";
    };

    unpackPhase = ''
      tar xf $src
      cd derive_builder_core-0.20.2
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "derive_builder_core";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Colin Kiegel <kiegel@gmx.de>:Pascal Hertleif <killercup@gmail.com>:Jan-Erik Rediger <janerik@fnordig.de>:Ted Driggs <ted.driggs@outlook.com>";
    CARGO_PKG_DESCRIPTION = "Internal helper library for the derive_builder crate.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "derive_builder_core";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/colin-kiegel/rust-derive-builder";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.20.2";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "20";
    CARGO_PKG_VERSION_PATCH = "2";
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
              --crate-name derive_builder_core \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debug-assertions=off \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="lib_has_std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "clippy", "lib_has_std"))' \
              -C metadata=d59dfeb2f56ffb40 \
              -C extra-filename=-776491bd3cff748b \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern darling=${darling-0_20_10-8fd75665fdb6cbf2}/libdarling-8fd75665fdb6cbf2.rmeta \
              --extern proc_macro2=${proc-macro2-1_0_93-8972bce74b99a2b8}/libproc_macro2-8972bce74b99a2b8.rmeta \
              --extern quote=${quote-1_0_38-69fc837ab5040c10}/libquote-69fc837ab5040c10.rmeta \
              --extern syn=${syn-2_0_98-cf14ab7ccae9dbe8}/libsyn-cf14ab7ccae9dbe8.rmeta \
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
