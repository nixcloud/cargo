# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "curl-0_4_47-f684c2bd7b0f950d";
    meta.cargo_crate_info = {
      name = "curl";
      version = "0.4.47";
      crate_hash = "f684c2bd7b0f950d";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [curl-sys-0_4_80_plus_curl-8_12_1-db5fbe1d9680c71f libc-0_2_175-df0687d6868fdede openssl-probe-0_1_6-6d5d5ac82de655f5 openssl-sys-0_9_106-adcaf6cb517a5566 socket2-0_5_8-5c7e1d07a2b2a7e8];
    passthru.rust_crate_parent = [curl-0_4_47-script_build_run-ba10f3f61d2b9233];
    passthru.rust_script_build_run = [curl-0_4_47-script_build_run-ba10f3f61d2b9233];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/curl/0.4.47/download";
      sha256 = "d9fb4d13a1be2b58f14d60adba57c9834b78c62fd86c3e76a148f732686e9265";
    };
    unpackPhase = ''
      tar xf $src
      cd curl-0.4.47
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "curl";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Rust bindings to libcurl for making HTTP requests";
    CARGO_PKG_HOMEPAGE = "https://github.com/alexcrichton/curl-rust";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "curl";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/alexcrichton/curl-rust";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.4.47";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "47";
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
              --crate-name curl \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="http2"' \
              --cfg 'feature="openssl-probe"' \
              --cfg 'feature="openssl-sys"' \
              --cfg 'feature="ssl"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "force-system-lib-on-osx", "http2", "mesalink", "ntlm", "openssl-probe", "openssl-sys", "poll_7_68_0", "protocol-ftp", "rustls", "spnego", "ssl", "static-curl", "static-ssl", "upkeep_7_62_0", "windows-static-ssl", "zlib-ng-compat"))' \
              -C metadata=18bc58057af97ccc \
              -C extra-filename=-f684c2bd7b0f950d \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern curl_sys=${curl-sys-0_4_80_plus_curl-8_12_1-db5fbe1d9680c71f}/libcurl_sys-db5fbe1d9680c71f.rmeta \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern openssl_probe=${openssl-probe-0_1_6-6d5d5ac82de655f5}/libopenssl_probe-6d5d5ac82de655f5.rmeta \
              --extern openssl_sys=${openssl-sys-0_9_106-adcaf6cb517a5566}/libopenssl_sys-adcaf6cb517a5566.rmeta \
              --extern socket2=${socket2-0_5_8-5c7e1d07a2b2a7e8}/libsocket2-5c7e1d07a2b2a7e8.rmeta \
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
