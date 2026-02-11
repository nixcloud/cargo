# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "utf16_iter-1_0_5-e2c4d90fc6d42e47";
    meta.cargo_crate_info = {
      name = "utf16_iter";
      version = "1.0.5";
      crate_hash = "e2c4d90fc6d42e47";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/utf16_iter/1.0.5/download";
      sha256 = "c8232dd3cdaed5356e0f716d285e4b40b932ac434100fe9b7e0e8e935b9e6246";
    };
    unpackPhase = ''
      tar xf $src
      cd utf16_iter-1.0.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "utf16_iter";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Henri Sivonen <hsivonen@hsivonen.fi>";
    CARGO_PKG_DESCRIPTION = "Iterator by char over potentially-invalid UTF-16 in &[u16]";
    CARGO_PKG_HOMEPAGE = "https://docs.rs/utf16_iter/";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "utf16_iter";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/hsivonen/utf16_iter";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "1.0.5";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "0";
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
              --crate-name utf16_iter \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values())' \
              -C metadata=9bc334bcab4e0170 \
              -C extra-filename=-e2c4d90fc6d42e47 \
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
