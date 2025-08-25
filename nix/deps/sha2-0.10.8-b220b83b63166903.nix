# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "sha2-0_10_8-b220b83b63166903";
    meta.cargo_crate_info = {
      name = "sha2";
      version = "0.10.8";
      crate_hash = "b220b83b63166903";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cfg-if-1_0_0-f52ed1292e79c10c cpufeatures-0_2_17-1ff49c4245bd0b82 digest-0_10_7-fb3b4a12386762cc];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/sha2/0.10.8/download";
      sha256 = "793db75ad2bcafc3ffa7c68b215fee268f537982cd901d132f89c6343f3a3dc8";
    };
    unpackPhase = ''
      tar xf $src
      cd sha2-0.10.8
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "sha2";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of the SHA-2 hash function family
including SHA-224, SHA-256, SHA-384, and SHA-512.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "sha2";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/hashes";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.10.8";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "10";
    CARGO_PKG_VERSION_PATCH = "8";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m sha2-0_10_8-b220b83b63166903"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name sha2 \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("asm", "asm-aarch64", "compress", "default", "force-soft", "loongarch64_asm", "oid", "sha2-asm", "std"))' \
        -C metadata=3796619fd9117a80 \
        -C extra-filename=-b220b83b63166903 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern cfg_if=${cfg-if-1_0_0-f52ed1292e79c10c}/libcfg_if-f52ed1292e79c10c.rmeta \
        --extern cpufeatures=${cpufeatures-0_2_17-1ff49c4245bd0b82}/libcpufeatures-1ff49c4245bd0b82.rmeta \
        --extern digest=${digest-0_10_7-fb3b4a12386762cc}/libdigest-fb3b4a12386762cc.rmeta \
        --cap-lints allow
      )
    '';
}
