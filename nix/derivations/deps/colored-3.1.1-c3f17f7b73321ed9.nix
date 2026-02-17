# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "colored-3_1_1-c3f17f7b73321ed9";
    meta.cargo_crate_info = {
      name = "colored";
      version = "3.1.1";
      crate_hash = "c3f17f7b73321ed9";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/colored/3.1.1/download";
      sha256 = "faf9468729b8cbcea668e36183cb69d317348c2e08e994829fb56ebfdfbaac34";
    };
    unpackPhase = ''
      tar xf $src
      cd colored-3.1.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "colored";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Thomas Wickham <mackwic@gmail.com>";
    CARGO_PKG_DESCRIPTION = "The most simple way to add colors in your terminal";
    CARGO_PKG_HOMEPAGE = "https://github.com/mackwic/colored";
    CARGO_PKG_LICENSE = "MPL-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "colored";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/mackwic/colored";
    CARGO_PKG_RUST_VERSION = "1.80";
    CARGO_PKG_VERSION = "3.1.1";
    CARGO_PKG_VERSION_MAJOR = "3";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "1";
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
              --crate-name colored \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --warn=unsafe_code \
              --warn=clippy::suspicious \
              --warn=clippy::style \
              --warn=clippy::perf \
              --warn=clippy::pedantic \
              --warn=clippy::nursery \
              --warn=deprecated \
              --warn=clippy::correctness \
              --warn=clippy::complexity \
              --allow=clippy::wildcard_imports \
              --allow=clippy::unwrap_used \
              --allow=clippy::too_many_lines \
              --allow=clippy::module_name_repetitions \
              --allow=clippy::missing_const_for_fn \
              --allow=clippy::expect_used \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("no-color"))' \
              -C metadata=ed8cc1904f92a50e \
              -C extra-filename=-c3f17f7b73321ed9 \
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
