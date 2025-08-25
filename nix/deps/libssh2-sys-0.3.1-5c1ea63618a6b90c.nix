# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libssh2-sys-0_3_1-5c1ea63618a6b90c";
    meta.cargo_crate_info = {
      name = "libssh2-sys";
      version = "0.3.1";
      crate_hash = "5c1ea63618a6b90c";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [libc-0_2_170-d46a143b0470970d libz-sys-1_1_21-dca0372fd8ac9ea4 openssl-sys-0_9_106-f58fbd59ff8ffe86];
    passthru.rust_crate_parent = [libssh2-sys-0_3_1-script_build_run-1a392f869e3961cc];
    passthru.rust_script_build_run = [libssh2-sys-0_3_1-script_build_run-1a392f869e3961cc];
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
    CARGO = "${rustc}/bin/rustc";

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
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m libssh2-sys-0_3_1-5c1ea63618a6b90c"
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
        --crate-name libssh2_sys \
        --edition=2015 lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("openssl-on-win32", "openssl-sys", "vendored-openssl", "zlib-ng-compat"))' \
        -C metadata=9db1fdd50fdf3232 \
        -C extra-filename=-5c1ea63618a6b90c \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern libc=${libc-0_2_170-d46a143b0470970d}/liblibc-d46a143b0470970d.rmeta \
        --extern libz_sys=${libz-sys-1_1_21-dca0372fd8ac9ea4}/liblibz_sys-dca0372fd8ac9ea4.rmeta \
        --extern openssl_sys=${openssl-sys-0_9_106-f58fbd59ff8ffe86}/libopenssl_sys-f58fbd59ff8ffe86.rmeta \
        --cap-lints allow
      )
    '';
}
