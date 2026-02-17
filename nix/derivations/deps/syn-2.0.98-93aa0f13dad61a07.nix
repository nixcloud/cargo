# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "syn-2_0_98-93aa0f13dad61a07";
    meta.cargo_crate_info = {
      name = "syn";
      version = "2.0.98";
      crate_hash = "93aa0f13dad61a07";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [proc-macro2-1_0_93-cfe81a59cf98819f quote-1_0_38-12b99e3192e30e82 unicode-ident-1_0_17-19b9bf45cc26c223];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/syn/2.0.98/download";
      sha256 = "36147f1a48ae0ec2b5b3bc5b537d267457555a10dc06f3dbc8cb11ba3006d3b1";
    };
    unpackPhase = ''
      tar xf $src
      cd syn-2.0.98
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "syn";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "David Tolnay <dtolnay@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Parser for Rust source code";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "syn";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/dtolnay/syn";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "2.0.98";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "98";
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
              --crate-name syn \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="clone-impls"' \
              --cfg 'feature="default"' \
              --cfg 'feature="derive"' \
              --cfg 'feature="extra-traits"' \
              --cfg 'feature="fold"' \
              --cfg 'feature="full"' \
              --cfg 'feature="parsing"' \
              --cfg 'feature="printing"' \
              --cfg 'feature="proc-macro"' \
              --cfg 'feature="visit"' \
              --cfg 'feature="visit-mut"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("clone-impls", "default", "derive", "extra-traits", "fold", "full", "parsing", "printing", "proc-macro", "test", "visit", "visit-mut"))' \
              -C metadata=5afe03310e452fa9 \
              -C extra-filename=-93aa0f13dad61a07 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern proc_macro2=${proc-macro2-1_0_93-cfe81a59cf98819f}/libproc_macro2-cfe81a59cf98819f.rmeta \
              --extern quote=${quote-1_0_38-12b99e3192e30e82}/libquote-12b99e3192e30e82.rmeta \
              --extern unicode_ident=${unicode-ident-1_0_17-19b9bf45cc26c223}/libunicode_ident-19b9bf45cc26c223.rmeta \
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
