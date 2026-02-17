# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "signal-hook-mio-0_2_4-cd56e28dfd710f50";
    meta.cargo_crate_info = {
      name = "signal-hook-mio";
      version = "0.2.4";
      crate_hash = "cd56e28dfd710f50";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [libc-0_2_175-df0687d6868fdede mio-0_8_11-6d022cfdfb03dec5 signal-hook-0_3_18-1abb298067a85eda];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/signal-hook-mio/0.2.4/download";
      sha256 = "34db1a06d485c9142248b7a054f034b349b212551f3dfd19c94d45a754a217cd";
    };
    unpackPhase = ''
      tar xf $src
      cd signal-hook-mio-0.2.4
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "signal_hook_mio";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Michal 'vorner' Vaner <vorner@vorner.cz>:Thomas Himmelstoss <thimm@posteo.de>";
    CARGO_PKG_DESCRIPTION = "MIO support for signal-hook";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0/MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "signal-hook-mio";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/vorner/signal-hook";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.2.4";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "4";
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
              --crate-name signal_hook_mio \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="mio-0_8"' \
              --cfg 'feature="support-v0_8"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("mio-0_6", "mio-0_7", "mio-0_8", "mio-1_0", "mio-uds", "support-v0_6", "support-v0_7", "support-v0_8", "support-v1_0"))' \
              -C metadata=d09d761df3219cf9 \
              -C extra-filename=-cd56e28dfd710f50 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern mio_0_8=${mio-0_8_11-6d022cfdfb03dec5}/libmio-6d022cfdfb03dec5.rmeta \
              --extern signal_hook=${signal-hook-0_3_18-1abb298067a85eda}/libsignal_hook-1abb298067a85eda.rmeta \
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
