# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "signal-hook-0_3_18-1abb298067a85eda";
    meta.cargo_crate_info = {
      name = "signal-hook";
      version = "0.3.18";
      crate_hash = "1abb298067a85eda";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [libc-0_2_175-df0687d6868fdede signal-hook-registry-1_4_6-e6450daef8f1b40e];
    passthru.rust_crate_parent = [signal-hook-0_3_18-script_build_run-40557db598ae01b9];
    passthru.rust_script_build_run = [signal-hook-0_3_18-script_build_run-40557db598ae01b9];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/signal-hook/0.3.18/download";
      sha256 = "d881a16cf4426aa584979d30bd82cb33429027e42122b169753d6ef1085ed6e2";
    };
    unpackPhase = ''
      tar xf $src
      cd signal-hook-0.3.18
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "signal_hook";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Michal 'vorner' Vaner <vorner@vorner.cz>:Thomas Himmelstoss <thimm@posteo.de>";
    CARGO_PKG_DESCRIPTION = "Unix signal handling";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0/MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "signal-hook";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/vorner/signal-hook";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.3.18";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "18";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      ${fn.import_bash_function_helpers}
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)
      
      mkdir -p $out/nix
      export OUT_DIR=$out

      print_compiling_message "${name}"
      print_cargo_message_type_0 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}"
      copy_build_script_run_results_over_with_nix "${fn.get_rust_crate_parent passthru.rust_crate_parent}"
      for file in $out/environment-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
          if [ -f "$file" ]; then
          sed -i "s|${fn.get_rust_crate_parent passthru.rust_crate_parent}|$out|g" "$file"
          fi
      done
      load_environment_variables_from_files "${fn.environment_variables passthru.rust_script_build_run}"
      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name signal_hook \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="channel"' \
              --cfg 'feature="default"' \
              --cfg 'feature="iterator"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("cc", "channel", "default", "extended-siginfo", "extended-siginfo-raw", "iterator"))' \
              -C metadata=51143356dc7dc37d \
              -C extra-filename=-1abb298067a85eda \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern signal_hook_registry=${signal-hook-registry-1_4_6-e6450daef8f1b40e}/libsignal_hook_registry-e6450daef8f1b40e.rmeta \
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
