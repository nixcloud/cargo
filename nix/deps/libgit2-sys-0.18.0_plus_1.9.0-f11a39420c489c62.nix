# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libgit2-sys-0_18_0_plus_1_9_0-f11a39420c489c62";
    meta.cargo_crate_info = {
      name = "libgit2-sys";
      version = "0.18.0+1.9.0";
      crate_hash = "f11a39420c489c62";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [libc-0_2_170-d46a143b0470970d libssh2-sys-0_3_1-5c1ea63618a6b90c libz-sys-1_1_21-dca0372fd8ac9ea4 openssl-sys-0_9_106-f58fbd59ff8ffe86];
    passthru.rust_crate_parent = [libgit2-sys-0_18_0_plus_1_9_0-script_build_run-f9c81e389c530995];
    passthru.rust_script_build_run = [libgit2-sys-0_18_0_plus_1_9_0-script_build_run-f9c81e389c530995];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libgit2-sys/0.18.0+1.9.0/download";
      sha256 = "e1a117465e7e1597e8febea8bb0c410f1c7fb93b1e1cddf34363f8390367ffec";
    };
    unpackPhase = ''
      tar xf $src
      cd libgit2-sys-0.18.0+1.9.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "libgit2_sys";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Josh Triplett <josh@joshtriplett.org>:Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Native bindings to the libgit2 library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libgit2-sys";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/git2-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.18.0+1.9.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "18";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m libgit2-sys-0_18_0_plus_1_9_0-f11a39420c489c62"
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
        --crate-name libgit2_sys \
        --edition=2018 lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="https"' \
        --cfg 'feature="libssh2-sys"' \
        --cfg 'feature="openssl-sys"' \
        --cfg 'feature="ssh"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("https", "libssh2-sys", "openssl-sys", "ssh", "vendored", "vendored-openssl", "zlib-ng-compat"))' \
        -C metadata=de6972c508869e9f \
        -C extra-filename=-f11a39420c489c62 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern libc=${libc-0_2_170-d46a143b0470970d}/liblibc-d46a143b0470970d.rmeta \
        --extern libssh2_sys=${libssh2-sys-0_3_1-5c1ea63618a6b90c}/liblibssh2_sys-5c1ea63618a6b90c.rmeta \
        --extern libz_sys=${libz-sys-1_1_21-dca0372fd8ac9ea4}/liblibz_sys-dca0372fd8ac9ea4.rmeta \
        --extern openssl_sys=${openssl-sys-0_9_106-f58fbd59ff8ffe86}/libopenssl_sys-f58fbd59ff8ffe86.rmeta \
        --cap-lints allow
      )
    '';
}
