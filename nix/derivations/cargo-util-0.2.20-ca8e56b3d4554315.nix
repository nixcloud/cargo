# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-util-0_2_20-ca8e56b3d4554315";
    meta.cargo_crate_info = {
      name = "cargo-util";
      version = "0.2.20";
      crate_hash = "ca8e56b3d4554315";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [anyhow-1_0_96-61bbc4e08b05614c filetime-0_2_25-4a8c5a239dda911b hex-0_4_3-d9f97d45c228789e ignore-0_4_23-d7082c3c0c554a79 jobserver-0_1_32-bf749e6aa2009df5 libc-0_2_175-b265bb513a0388f3 same-file-1_0_6-c702782bc8f9cf83 sha2-0_10_8-259709e389f530eb shell-escape-0_1_5-2dddd153d3f4fa85 tempfile-3_17_1-b08d0e8469fdeafa tracing-0_1_41-f95fa3c0b6430cd1 walkdir-2_5_0-1df263e29c1f7c83];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "crates/cargo-util/src/lib.rs"
        "crates/cargo-util/src/du.rs"
        "crates/cargo-util/src/paths.rs"
        "crates/cargo-util/src/process_builder.rs"
        "crates/cargo-util/src/process_error.rs"
        "crates/cargo-util/src/read2.rs"
        "crates/cargo-util/src/registry.rs"
        "crates/cargo-util/src/sha256.rs"
      ];
    };

    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "cargo_util";
    CARGO_MANIFEST_DIR = "./crates/cargo-util";
    CARGO_MANIFEST_PATH = "./crates/cargo-util/Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Miscellaneous support code used by Cargo.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/cargo";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo-util";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.2.20";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "20";
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
              --crate-name cargo_util \
              --edition=2021 crates/cargo-util/src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
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
              --check-cfg 'cfg(feature, values())' \
              -C metadata=de96df6dfabf3deb \
              -C extra-filename=-ca8e56b3d4554315 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern anyhow=${anyhow-1_0_96-61bbc4e08b05614c}/libanyhow-61bbc4e08b05614c.rmeta \
              --extern filetime=${filetime-0_2_25-4a8c5a239dda911b}/libfiletime-4a8c5a239dda911b.rmeta \
              --extern hex=${hex-0_4_3-d9f97d45c228789e}/libhex-d9f97d45c228789e.rmeta \
              --extern ignore=${ignore-0_4_23-d7082c3c0c554a79}/libignore-d7082c3c0c554a79.rmeta \
              --extern jobserver=${jobserver-0_1_32-bf749e6aa2009df5}/libjobserver-bf749e6aa2009df5.rmeta \
              --extern libc=${libc-0_2_175-b265bb513a0388f3}/liblibc-b265bb513a0388f3.rmeta \
              --extern same_file=${same-file-1_0_6-c702782bc8f9cf83}/libsame_file-c702782bc8f9cf83.rmeta \
              --extern sha2=${sha2-0_10_8-259709e389f530eb}/libsha2-259709e389f530eb.rmeta \
              --extern shell_escape=${shell-escape-0_1_5-2dddd153d3f4fa85}/libshell_escape-2dddd153d3f4fa85.rmeta \
              --extern tempfile=${tempfile-3_17_1-b08d0e8469fdeafa}/libtempfile-b08d0e8469fdeafa.rmeta \
              --extern tracing=${tracing-0_1_41-f95fa3c0b6430cd1}/libtracing-f95fa3c0b6430cd1.rmeta \
              --extern walkdir=${walkdir-2_5_0-1df263e29c1f7c83}/libwalkdir-1df263e29c1f7c83.rmeta 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
