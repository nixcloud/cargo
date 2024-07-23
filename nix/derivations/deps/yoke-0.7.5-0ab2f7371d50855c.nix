# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "yoke-0_7_5-0ab2f7371d50855c";
    meta.cargo_crate_info = {
      name = "yoke";
      version = "0.7.5";
      crate_hash = "0ab2f7371d50855c";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [stable_deref_trait-1_2_0-232ca7c28cd47370 yoke-derive-0_7_5-7f7cc48008852617 zerofrom-0_1_5-ea748ae3ec88a0de];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/yoke/0.7.5/download";
      sha256 = "120e6aef9aa629e3d4f52dc8cc43a015c7724194c97dfaf45180d2daf2b77f40";
    };

    unpackPhase = ''
      tar xf $src
      cd yoke-0.7.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "yoke";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Manish Goregaokar <manishsmail@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Abstraction allowing borrowed data to be carried along with the backing data it borrows from";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Unicode-3.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "yoke";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/unicode-org/icu4x";
    CARGO_PKG_RUST_VERSION = "1.71.1";
    CARGO_PKG_VERSION = "0.7.5";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
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
              --crate-name yoke \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --cfg 'feature="default"' \
              --cfg 'feature="derive"' \
              --cfg 'feature="zerofrom"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "default", "derive", "serde", "zerofrom"))' \
              -C metadata=651cc53f4811a76a \
              -C extra-filename=-0ab2f7371d50855c \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern stable_deref_trait=${stable_deref_trait-1_2_0-232ca7c28cd47370}/libstable_deref_trait-232ca7c28cd47370.rmeta \
              --extern yoke_derive=${yoke-derive-0_7_5-7f7cc48008852617}/libyoke_derive-7f7cc48008852617.so \
              --extern zerofrom=${zerofrom-0_1_5-ea748ae3ec88a0de}/libzerofrom-ea748ae3ec88a0de.rmeta \
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
