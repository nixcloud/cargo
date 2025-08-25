# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "curl-sys-0_4_80_plus_curl-8_12_1-script_build-b7ded91cd9455987";
    meta.cargo_crate_info = {
      name = "curl-sys";
      version = "0.4.80+curl-8.12.1";
      crate_hash = "b7ded91cd9455987";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cc-1_2_16-aaebd3b60c7751f8 pkg-config-0_3_31-74aa6e3930289a4b];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
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

    CARGO_CRATE_NAME = "build_script_build";
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

      echo -e "\e[92mCompiling\e[0m curl-sys-0_4_80_plus_curl-8_12_1-script_build-b7ded91cd9455987"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2018 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="http2"' \
        --cfg 'feature="libnghttp2-sys"' \
        --cfg 'feature="openssl-sys"' \
        --cfg 'feature="ssl"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "force-system-lib-on-osx", "http2", "libnghttp2-sys", "mesalink", "ntlm", "openssl-sys", "poll_7_68_0", "protocol-ftp", "rustls", "rustls-ffi", "spnego", "ssl", "static-curl", "static-ssl", "upkeep_7_62_0", "windows-static-ssl", "zlib-ng-compat"))' \
        -C metadata=4653ca2e7c954e7c \
        -C extra-filename=-b7ded91cd9455987 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern cc=${cc-1_2_16-aaebd3b60c7751f8}/libcc-aaebd3b60c7751f8.rlib \
        --extern pkg_config=${pkg-config-0_3_31-74aa6e3930289a4b}/libpkg_config-74aa6e3930289a4b.rlib \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-b7ded91cd9455987 $OUT_DIR/build_script_build
      )
    '';
}
