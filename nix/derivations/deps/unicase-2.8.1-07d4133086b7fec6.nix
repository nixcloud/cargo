# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "unicase-2_8_1-07d4133086b7fec6";
    meta.cargo_crate_info = {
      name = "unicase";
      version = "2.8.1";
      crate_hash = "07d4133086b7fec6";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/unicase/2.8.1/download";
      sha256 = "75b844d17643ee918803943289730bec8aac480150456169e647ed0b576ba539";
    };
    unpackPhase = ''
      tar xf $src
      cd unicase-2.8.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "unicase";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Sean McArthur <sean@seanmonstar.com>";
    CARGO_PKG_DESCRIPTION = "A case-insensitive wrapper around strings.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "unicase";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/seanmonstar/unicase";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "2.8.1";
    CARGO_PKG_VERSION_MAJOR = "2";
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
              --crate-name unicase \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("nightly"))' \
              -C metadata=81581191a9b10b4d \
              -C extra-filename=-07d4133086b7fec6 \
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
