# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "git2-0_20_0-73cd3d9b5537d1b3";
    meta.cargo_crate_info = {
      name = "git2";
      version = "0.20.0";
      crate_hash = "73cd3d9b5537d1b3";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [bitflags-2_8_0-27b6a5758605f436 libc-0_2_170-d46a143b0470970d libgit2-sys-0_18_0_plus_1_9_0-f11a39420c489c62 log-0_4_25-f053b1d34dfd0749 openssl-probe-0_1_6-d94d2fd3bc8350c1 openssl-sys-0_9_106-f58fbd59ff8ffe86 url-2_5_4-f84eb31ea66b0c06];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/git2/0.20.0/download";
      sha256 = "3fda788993cc341f69012feba8bf45c0ba4f3291fcc08e214b4d5a7332d88aff";
    };
    unpackPhase = ''
      tar xf $src
      cd git2-0.20.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "git2";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Josh Triplett <josh@joshtriplett.org>:Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Bindings to libgit2 for interoperating with git repositories. This library is
both threadsafe and memory safe and allows both reading and writing git
repositories.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "git2";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/git2-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.20.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "20";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m git2-0_20_0-73cd3d9b5537d1b3"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name git2 \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="https"' \
        --cfg 'feature="openssl-probe"' \
        --cfg 'feature="openssl-sys"' \
        --cfg 'feature="ssh"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "https", "openssl-probe", "openssl-sys", "ssh", "unstable", "vendored-libgit2", "vendored-openssl", "zlib-ng-compat"))' \
        -C metadata=abd0c8e2533a4434 \
        -C extra-filename=-73cd3d9b5537d1b3 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern bitflags=${bitflags-2_8_0-27b6a5758605f436}/libbitflags-27b6a5758605f436.rmeta \
        --extern libc=${libc-0_2_170-d46a143b0470970d}/liblibc-d46a143b0470970d.rmeta \
        --extern libgit2_sys=${libgit2-sys-0_18_0_plus_1_9_0-f11a39420c489c62}/liblibgit2_sys-f11a39420c489c62.rmeta \
        --extern log=${log-0_4_25-f053b1d34dfd0749}/liblog-f053b1d34dfd0749.rmeta \
        --extern openssl_probe=${openssl-probe-0_1_6-d94d2fd3bc8350c1}/libopenssl_probe-d94d2fd3bc8350c1.rmeta \
        --extern openssl_sys=${openssl-sys-0_9_106-f58fbd59ff8ffe86}/libopenssl_sys-f58fbd59ff8ffe86.rmeta \
        --extern url=${url-2_5_4-f84eb31ea66b0c06}/liburl-f84eb31ea66b0c06.rmeta \
        --cap-lints allow
      )
    '';
}
