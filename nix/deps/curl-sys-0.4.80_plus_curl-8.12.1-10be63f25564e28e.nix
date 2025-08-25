# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "curl-sys-0_4_80_plus_curl-8_12_1-10be63f25564e28e";
    meta.cargo_crate_info = {
      name = "curl-sys";
      version = "0.4.80+curl-8.12.1";
      crate_hash = "10be63f25564e28e";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [libc-0_2_170-d46a143b0470970d libnghttp2-sys-0_1_11_plus_1_64_0-030ecdf52d88149a libz-sys-1_1_21-dca0372fd8ac9ea4 openssl-sys-0_9_106-f58fbd59ff8ffe86];
    passthru.rust_crate_parent = [curl-sys-0_4_80_plus_curl-8_12_1-script_build_run-2bd25bf7f874b161];
    passthru.rust_script_build_run = [curl-sys-0_4_80_plus_curl-8_12_1-script_build_run-2bd25bf7f874b161];
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
    CARGO = "${rustc}/bin/rustc";

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
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m curl-sys-0_4_80_plus_curl-8_12_1-10be63f25564e28e"
      cp -r ${fn.get_rust_crate_parent passthru.rust_crate_parent}/* $OUT_DIR
      for file in $out/environment-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
          if [ -f "$file" ]; then
          sed -i "s|${fn.get_rust_crate_parent passthru.rust_crate_parent}|$out|g" "$file"
          fi
      done
      for file in ${fn.environment_variables passthru.rust_script_build_run}; do
        if [ -f $file ]; then
          set -a
            while read -r line; do
              echo -e "\033[38;5;208m$line\033[0m"
            done < "$file"
            source $file
            set +a
        fi
      done
      (set -x 
      ${rustc}/bin/rustc \
        --crate-name curl_sys \
        --edition=2018 lib.rs \
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
        -C metadata=fcda6e451f16c0e9 \
        -C extra-filename=-10be63f25564e28e \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern libc=${libc-0_2_170-d46a143b0470970d}/liblibc-d46a143b0470970d.rmeta \
        --extern libnghttp2_sys=${libnghttp2-sys-0_1_11_plus_1_64_0-030ecdf52d88149a}/liblibnghttp2_sys-030ecdf52d88149a.rmeta \
        --extern libz_sys=${libz-sys-1_1_21-dca0372fd8ac9ea4}/liblibz_sys-dca0372fd8ac9ea4.rmeta \
        --extern openssl_sys=${openssl-sys-0_9_106-f58fbd59ff8ffe86}/libopenssl_sys-f58fbd59ff8ffe86.rmeta \
        --cap-lints allow
      )
    '';
}
