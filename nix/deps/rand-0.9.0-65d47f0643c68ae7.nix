# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "rand-0_9_0-65d47f0643c68ae7";
    meta.cargo_crate_info = {
      name = "rand";
      version = "0.9.0";
      crate_hash = "65d47f0643c68ae7";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [rand_chacha-0_9_0-36af3c9bdf592709 rand_core-0_9_0-56c10e419464a859 zerocopy-0_8_17-fbe6072789cd833a];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/rand/0.9.0/download";
      sha256 = "3779b94aeb87e8bd4e834cee3650289ee9e0d5677f976ecdb6d219e5f4f6cd94";
    };
    unpackPhase = ''
      tar xf $src
      cd rand-0.9.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "rand";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Rand Project Developers:The Rust Project Developers";
    CARGO_PKG_DESCRIPTION = "Random number generators and other randomness functionality.
";
    CARGO_PKG_HOMEPAGE = "https://rust-random.github.io/book";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "rand";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-random/rand";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "0.9.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "9";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m rand-0_9_0-65d47f0643c68ae7"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name rand \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="default"' \
        --cfg 'feature="os_rng"' \
        --cfg 'feature="small_rng"' \
        --cfg 'feature="std"' \
        --cfg 'feature="std_rng"' \
        --cfg 'feature="thread_rng"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "default", "log", "nightly", "os_rng", "serde", "simd_support", "small_rng", "std", "std_rng", "thread_rng", "unbiased"))' \
        -C metadata=4e338d12df7b0d8f \
        -C extra-filename=-65d47f0643c68ae7 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern rand_chacha=${rand_chacha-0_9_0-36af3c9bdf592709}/librand_chacha-36af3c9bdf592709.rmeta \
        --extern rand_core=${rand_core-0_9_0-56c10e419464a859}/librand_core-56c10e419464a859.rmeta \
        --extern zerocopy=${zerocopy-0_8_17-fbe6072789cd833a}/libzerocopy-fbe6072789cd833a.rmeta \
        --cap-lints allow
      )
    '';
}
