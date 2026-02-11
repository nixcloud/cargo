# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-util-0_2_20-7087e4a73afc7b23";
    meta.cargo_crate_info = {
      name = "cargo-util";
      version = "0.2.20";
      crate_hash = "7087e4a73afc7b23";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [anyhow-1_0_96-139173be5e005a44 filetime-0_2_25-36b58a90b887714e hex-0_4_3-ccbbd905e94f34bd ignore-0_4_23-dab7af6f0867647c jobserver-0_1_32-04274db7c36dbe6c libc-0_2_175-df0687d6868fdede same-file-1_0_6-82920d733726b0a3 sha2-0_10_8-bdde0649695b7ac6 shell-escape-0_1_5-fc06a701b65fbe9d tempfile-3_17_1-94ecc3046797cc75 tracing-0_1_41-7b5284fa1d5dcd0d walkdir-2_5_0-742d7f303f7cfcda];
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
              --check-cfg 'cfg(feature, values())' \
              -C metadata=649d42290d04e621 \
              -C extra-filename=-7087e4a73afc7b23 \
              --out-dir $OUT_DIR \
              -C incremental=$INC_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern anyhow=${anyhow-1_0_96-139173be5e005a44}/libanyhow-139173be5e005a44.rmeta \
              --extern filetime=${filetime-0_2_25-36b58a90b887714e}/libfiletime-36b58a90b887714e.rmeta \
              --extern hex=${hex-0_4_3-ccbbd905e94f34bd}/libhex-ccbbd905e94f34bd.rmeta \
              --extern ignore=${ignore-0_4_23-dab7af6f0867647c}/libignore-dab7af6f0867647c.rmeta \
              --extern jobserver=${jobserver-0_1_32-04274db7c36dbe6c}/libjobserver-04274db7c36dbe6c.rmeta \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern same_file=${same-file-1_0_6-82920d733726b0a3}/libsame_file-82920d733726b0a3.rmeta \
              --extern sha2=${sha2-0_10_8-bdde0649695b7ac6}/libsha2-bdde0649695b7ac6.rmeta \
              --extern shell_escape=${shell-escape-0_1_5-fc06a701b65fbe9d}/libshell_escape-fc06a701b65fbe9d.rmeta \
              --extern tempfile=${tempfile-3_17_1-94ecc3046797cc75}/libtempfile-94ecc3046797cc75.rmeta \
              --extern tracing=${tracing-0_1_41-7b5284fa1d5dcd0d}/libtracing-7b5284fa1d5dcd0d.rmeta \
              --extern walkdir=${walkdir-2_5_0-742d7f303f7cfcda}/libwalkdir-742d7f303f7cfcda.rmeta 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
