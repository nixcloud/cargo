# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-util-schemas-0_8_1-bce7b79eff35b46a";
    meta.cargo_crate_info = {
      name = "cargo-util-schemas";
      version = "0.8.1";
      crate_hash = "bce7b79eff35b46a";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [semver-1_0_25-44d2ac63fb520e42 serde-1_0_218-472e28b9f131b02c serde-untagged-0_1_6-6d07b1ee988da762 serde-value-0_7_0-7784867bacba5e84 thiserror-2_0_11-a57592ffa4ea41e0 toml-0_8_20-7a483d12a9e19406 unicode-xid-0_2_6-2091b14caaa2c4d2 url-2_5_4-7b68be8bb56d0713];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "crates/cargo-util-schemas/src/lib.rs"
        "crates/cargo-util-schemas/src/core/mod.rs"
        "crates/cargo-util-schemas/src/core/package_id_spec.rs"
        "crates/cargo-util-schemas/src/core/partial_version.rs"
        "crates/cargo-util-schemas/src/core/source_kind.rs"
        "crates/cargo-util-schemas/src/manifest/mod.rs"
        "crates/cargo-util-schemas/src/manifest/rust_version.rs"
        "crates/cargo-util-schemas/src/messages.rs"
        "crates/cargo-util-schemas/src/restricted_names.rs"
      ];
    };
    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "cargo_util_schemas";
    CARGO_MANIFEST_DIR = "./crates/cargo-util-schemas";
    CARGO_MANIFEST_PATH = "./crates/cargo-util-schemas/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Deserialization schemas for Cargo";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo-util-schemas";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.8.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
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
              --crate-name cargo_util_schemas \
              --edition=2021 crates/cargo-util-schemas/src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --allow=clippy::all \
              --warn=clippy::correctness \
              --warn=clippy::self_named_module_files \
              --warn=rust_2018_idioms \
              --allow=rustdoc::private_intra_doc_links \
              --warn=clippy::print_stdout \
              --warn=clippy::print_stderr \
              --warn=clippy::disallowed_methods \
              --warn=clippy::dbg_macro \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("unstable-schema"))' \
              -C metadata=60210e7b150047d4 \
              -C extra-filename=-bce7b79eff35b46a \
              --out-dir $OUT_DIR \
              -C incremental=$INC_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern semver=${semver-1_0_25-44d2ac63fb520e42}/libsemver-44d2ac63fb520e42.rmeta \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
              --extern serde_untagged=${serde-untagged-0_1_6-6d07b1ee988da762}/libserde_untagged-6d07b1ee988da762.rmeta \
              --extern serde_value=${serde-value-0_7_0-7784867bacba5e84}/libserde_value-7784867bacba5e84.rmeta \
              --extern thiserror=${thiserror-2_0_11-a57592ffa4ea41e0}/libthiserror-a57592ffa4ea41e0.rmeta \
              --extern toml=${toml-0_8_20-7a483d12a9e19406}/libtoml-7a483d12a9e19406.rmeta \
              --extern unicode_xid=${unicode-xid-0_2_6-2091b14caaa2c4d2}/libunicode_xid-2091b14caaa2c4d2.rmeta \
              --extern url=${url-2_5_4-7b68be8bb56d0713}/liburl-7b68be8bb56d0713.rmeta 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
