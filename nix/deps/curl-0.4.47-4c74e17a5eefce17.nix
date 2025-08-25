# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "curl-0_4_47-4c74e17a5eefce17";
    meta.cargo_crate_info = {
      name = "curl";
      version = "0.4.47";
      crate_hash = "4c74e17a5eefce17";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [curl-sys-0_4_80_plus_curl-8_12_1-10be63f25564e28e libc-0_2_170-d46a143b0470970d openssl-probe-0_1_6-d94d2fd3bc8350c1 openssl-sys-0_9_106-f58fbd59ff8ffe86 socket2-0_5_8-9466d5a2d1b3ea8d];
    passthru.rust_crate_parent = [curl-0_4_47-script_build_run-7162e6f0e51e3a28];
    passthru.rust_script_build_run = [curl-0_4_47-script_build_run-7162e6f0e51e3a28];
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
    CARGO = "${rustc}/bin/rustc";

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
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m curl-0_4_47-4c74e17a5eefce17"
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
        --crate-name curl \
        --edition=2018 src/lib.rs \
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
        -C metadata=adbb70ee3fd2a202 \
        -C extra-filename=-4c74e17a5eefce17 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern curl_sys=${curl-sys-0_4_80_plus_curl-8_12_1-10be63f25564e28e}/libcurl_sys-10be63f25564e28e.rmeta \
        --extern libc=${libc-0_2_170-d46a143b0470970d}/liblibc-d46a143b0470970d.rmeta \
        --extern openssl_probe=${openssl-probe-0_1_6-d94d2fd3bc8350c1}/libopenssl_probe-d94d2fd3bc8350c1.rmeta \
        --extern openssl_sys=${openssl-sys-0_9_106-f58fbd59ff8ffe86}/libopenssl_sys-f58fbd59ff8ffe86.rmeta \
        --extern socket2=${socket2-0_5_8-9466d5a2d1b3ea8d}/libsocket2-9466d5a2d1b3ea8d.rmeta \
        --cap-lints allow
      )
    '';
}
