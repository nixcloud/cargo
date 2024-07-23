# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "displaydoc-0_2_5-ff04277df12d4cce";
    meta.cargo_crate_info = {
      name = "displaydoc";
      version = "0.2.5";
      crate_hash = "ff04277df12d4cce";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [proc-macro2-1_0_93-8972bce74b99a2b8 quote-1_0_38-69fc837ab5040c10 syn-2_0_98-cf14ab7ccae9dbe8];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/displaydoc/0.2.5/download";
      sha256 = "97369cbbc041bc366949bc74d34658d6cda5621039731c6310521892a3a20ae0";
    };

    unpackPhase = ''
      tar xf $src
      cd displaydoc-0.2.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "displaydoc";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Jane Lusby <jlusby@yaah.dev>";
    CARGO_PKG_DESCRIPTION = "A derive macro for implementing the display Trait via a doc comment and string interpolation";
    CARGO_PKG_HOMEPAGE = "https://github.com/yaahc/displaydoc";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "displaydoc";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/yaahc/displaydoc";
    CARGO_PKG_RUST_VERSION = "1.56.0";
    CARGO_PKG_VERSION = "0.2.5";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
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
              --crate-name displaydoc \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type proc-macro \
              --emit=dep-info,link \
              -C prefer-dynamic \
              -C embed-bitcode=no \
              -C debug-assertions=off \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "std"))' \
              -C metadata=9ba184393ed319e4 \
              -C extra-filename=-ff04277df12d4cce \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern proc_macro2=${proc-macro2-1_0_93-8972bce74b99a2b8}/libproc_macro2-8972bce74b99a2b8.rlib \
              --extern quote=${quote-1_0_38-69fc837ab5040c10}/libquote-69fc837ab5040c10.rlib \
              --extern syn=${syn-2_0_98-cf14ab7ccae9dbe8}/libsyn-cf14ab7ccae9dbe8.rlib \
              --extern proc_macro \
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
