# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libssh2-sys-0_3_1-7b0b3bce8fea88d8";
    meta.cargo_crate_info = {
      name = "libssh2-sys";
      version = "0.3.1";
      crate_hash = "7b0b3bce8fea88d8";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [libc-0_2_175-df0687d6868fdede libz-sys-1_1_21-69f52d4cc5a20a24 openssl-sys-0_9_106-adcaf6cb517a5566];
    passthru.rust_crate_parent = [libssh2-sys-0_3_1-script_build_run-1fb24ef6763538ce];
    passthru.rust_script_build_run = [libssh2-sys-0_3_1-script_build_run-1fb24ef6763538ce];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libssh2-sys/0.3.1/download";
      sha256 = "220e4f05ad4a218192533b300327f5150e809b54c4ec83b5a1d91833601811b9";
    };
    unpackPhase = ''
      tar xf $src
      cd libssh2-sys-0.3.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "libssh2_sys";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>:Wez Furlong <wez@wezfurlong.org>:Matteo Bigoi <bigo@crisidev.org>";
    CARGO_PKG_DESCRIPTION = "Native bindings to the libssh2 library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libssh2-sys";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/alexcrichton/ssh2-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.3.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
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
              --crate-name libssh2_sys \
              --edition=2015 lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("openssl-on-win32", "openssl-sys", "vendored-openssl", "zlib-ng-compat"))' \
              -C metadata=3d729c9c9b8e4179 \
              -C extra-filename=-7b0b3bce8fea88d8 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern libz_sys=${libz-sys-1_1_21-69f52d4cc5a20a24}/liblibz_sys-69f52d4cc5a20a24.rmeta \
              --extern openssl_sys=${openssl-sys-0_9_106-adcaf6cb517a5566}/libopenssl_sys-adcaf6cb517a5566.rmeta \
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
