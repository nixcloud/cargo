# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "curl-sys-0_4_80_plus_curl-8_12_1-db5fbe1d9680c71f";
    meta.cargo_crate_info = {
      name = "curl-sys";
      version = "0.4.80+curl-8.12.1";
      crate_hash = "db5fbe1d9680c71f";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [libc-0_2_175-df0687d6868fdede libnghttp2-sys-0_1_11_plus_1_64_0-d8f3869573ff8422 libz-sys-1_1_21-69f52d4cc5a20a24 openssl-sys-0_9_106-adcaf6cb517a5566];
    passthru.rust_crate_parent = [curl-sys-0_4_80_plus_curl-8_12_1-script_build_run-5dbbf84b2b7464b9];
    passthru.rust_script_build_run = [curl-sys-0_4_80_plus_curl-8_12_1-script_build_run-5dbbf84b2b7464b9];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/curl-sys/0.4.80+curl-8.12.1/download";
      sha256 = "55f7df2eac63200c3ab25bde3b2268ef2ee56af3d238e76d61f01c3c49bff734";
    };
    unpackPhase = ''
      tar xf $src
      cd curl-sys-0.4.80+curl-8.12.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "curl_sys";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Native bindings to the libcurl library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "curl-sys";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/alexcrichton/curl-rust";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.4.80+curl-8.12.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "80";
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
              --crate-name curl_sys \
              --edition=2018 lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="http2"' \
              --cfg 'feature="libnghttp2-sys"' \
              --cfg 'feature="openssl-sys"' \
              --cfg 'feature="ssl"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "force-system-lib-on-osx", "http2", "libnghttp2-sys", "mesalink", "ntlm", "openssl-sys", "poll_7_68_0", "protocol-ftp", "rustls", "rustls-ffi", "spnego", "ssl", "static-curl", "static-ssl", "upkeep_7_62_0", "windows-static-ssl", "zlib-ng-compat"))' \
              -C metadata=1f74d4b2b389025c \
              -C extra-filename=-db5fbe1d9680c71f \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern libnghttp2_sys=${libnghttp2-sys-0_1_11_plus_1_64_0-d8f3869573ff8422}/liblibnghttp2_sys-d8f3869573ff8422.rmeta \
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
