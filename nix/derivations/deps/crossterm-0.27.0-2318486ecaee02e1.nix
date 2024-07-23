# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "crossterm-0_27_0-2318486ecaee02e1";
    meta.cargo_crate_info = {
      name = "crossterm";
      version = "0.27.0";
      crate_hash = "2318486ecaee02e1";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [bitflags-2_8_0-25bacb8b683e4264 libc-0_2_175-b265bb513a0388f3 mio-0_8_11-4f2afca5af8b8fd0 parking_lot-0_12_3-bd00df7ddce28121 signal-hook-0_3_18-e8d16b5f96fe21a7 signal-hook-mio-0_2_4-1832b50a039b9f0e];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/crossterm/0.27.0/download";
      sha256 = "f476fe445d41c9e991fd07515a6f463074b782242ccf4a5b7b1d1012e70824df";
    };

    unpackPhase = ''
      tar xf $src
      cd crossterm-0.27.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "crossterm";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "T. Post";
    CARGO_PKG_DESCRIPTION = "A crossplatform terminal library for manipulating terminals.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "crossterm";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/crossterm-rs/crossterm";
    CARGO_PKG_RUST_VERSION = "1.58.0";
    CARGO_PKG_VERSION = "0.27.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "27";
    CARGO_PKG_VERSION_PATCH = "0";
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
              --crate-name crossterm \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="bracketed-paste"' \
              --cfg 'feature="default"' \
              --cfg 'feature="events"' \
              --cfg 'feature="windows"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("bracketed-paste", "default", "event-stream", "events", "filedescriptor", "serde", "use-dev-tty", "windows"))' \
              -C metadata=dcf5a3e2edf7e324 \
              -C extra-filename=-2318486ecaee02e1 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern bitflags=${bitflags-2_8_0-25bacb8b683e4264}/libbitflags-25bacb8b683e4264.rmeta \
              --extern libc=${libc-0_2_175-b265bb513a0388f3}/liblibc-b265bb513a0388f3.rmeta \
              --extern mio=${mio-0_8_11-4f2afca5af8b8fd0}/libmio-4f2afca5af8b8fd0.rmeta \
              --extern parking_lot=${parking_lot-0_12_3-bd00df7ddce28121}/libparking_lot-bd00df7ddce28121.rmeta \
              --extern signal_hook=${signal-hook-0_3_18-e8d16b5f96fe21a7}/libsignal_hook-e8d16b5f96fe21a7.rmeta \
              --extern signal_hook_mio=${signal-hook-mio-0_2_4-1832b50a039b9f0e}/libsignal_hook_mio-1832b50a039b9f0e.rmeta \
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
