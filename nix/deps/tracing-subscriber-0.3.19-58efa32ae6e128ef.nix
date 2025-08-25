# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tracing-subscriber-0_3_19-58efa32ae6e128ef";
    meta.cargo_crate_info = {
      name = "tracing-subscriber";
      version = "0.3.19";
      crate_hash = "58efa32ae6e128ef";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [matchers-0_1_0-7609a5f40b73546f nu-ansi-term-0_46_0-6e21f79c22ab38a6 once_cell-1_20_3-5c63a4de5995f261 regex-1_11_1-81271cb7b4167e0c sharded-slab-0_1_7-d6c2afa47dbbbf49 smallvec-1_13_2-453c588ad74a5894 thread_local-1_1_8-381cd2e4639c2948 tracing-0_1_41-4ef8fb354e141157 tracing-core-0_1_33-f06771044d6f65f3 tracing-log-0_2_0-f6dbe86a8725a3f6];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tracing-subscriber/0.3.19/download";
      sha256 = "e8189decb5ac0fa7bc8b96b7cb9b2701d60d48805aca84a238004d665fcc4008";
    };
    unpackPhase = ''
      tar xf $src
      cd tracing-subscriber-0.3.19
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "tracing_subscriber";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Eliza Weisman <eliza@buoyant.io>:David Barsky <me@davidbarsky.com>:Tokio Contributors <team@tokio.rs>";
    CARGO_PKG_DESCRIPTION = "Utilities for implementing and composing `tracing` subscribers.
";
    CARGO_PKG_HOMEPAGE = "https://tokio.rs";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tracing-subscriber";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/tokio-rs/tracing";
    CARGO_PKG_RUST_VERSION = "1.63.0";
    CARGO_PKG_VERSION = "0.3.19";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "19";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m tracing-subscriber-0_3_19-58efa32ae6e128ef"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name tracing_subscriber \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        --warn=unexpected_cfgs \
        --check-cfg 'cfg(flaky_tests)' \
        --check-cfg 'cfg(tracing_unstable)' \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="ansi"' \
        --cfg 'feature="default"' \
        --cfg 'feature="env-filter"' \
        --cfg 'feature="fmt"' \
        --cfg 'feature="matchers"' \
        --cfg 'feature="nu-ansi-term"' \
        --cfg 'feature="once_cell"' \
        --cfg 'feature="regex"' \
        --cfg 'feature="registry"' \
        --cfg 'feature="sharded-slab"' \
        --cfg 'feature="smallvec"' \
        --cfg 'feature="std"' \
        --cfg 'feature="thread_local"' \
        --cfg 'feature="tracing"' \
        --cfg 'feature="tracing-log"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("alloc", "ansi", "chrono", "default", "env-filter", "fmt", "json", "local-time", "matchers", "nu-ansi-term", "once_cell", "parking_lot", "regex", "registry", "serde", "serde_json", "sharded-slab", "smallvec", "std", "thread_local", "time", "tracing", "tracing-log", "tracing-serde", "valuable", "valuable-serde", "valuable_crate"))' \
        -C metadata=c578566deb00492d \
        -C extra-filename=-58efa32ae6e128ef \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern matchers=${matchers-0_1_0-7609a5f40b73546f}/libmatchers-7609a5f40b73546f.rmeta \
        --extern nu_ansi_term=${nu-ansi-term-0_46_0-6e21f79c22ab38a6}/libnu_ansi_term-6e21f79c22ab38a6.rmeta \
        --extern once_cell=${once_cell-1_20_3-5c63a4de5995f261}/libonce_cell-5c63a4de5995f261.rmeta \
        --extern regex=${regex-1_11_1-81271cb7b4167e0c}/libregex-81271cb7b4167e0c.rmeta \
        --extern sharded_slab=${sharded-slab-0_1_7-d6c2afa47dbbbf49}/libsharded_slab-d6c2afa47dbbbf49.rmeta \
        --extern smallvec=${smallvec-1_13_2-453c588ad74a5894}/libsmallvec-453c588ad74a5894.rmeta \
        --extern thread_local=${thread_local-1_1_8-381cd2e4639c2948}/libthread_local-381cd2e4639c2948.rmeta \
        --extern tracing=${tracing-0_1_41-4ef8fb354e141157}/libtracing-4ef8fb354e141157.rmeta \
        --extern tracing_core=${tracing-core-0_1_33-f06771044d6f65f3}/libtracing_core-f06771044d6f65f3.rmeta \
        --extern tracing_log=${tracing-log-0_2_0-f6dbe86a8725a3f6}/libtracing_log-f6dbe86a8725a3f6.rmeta \
        --cap-lints allow
      )
    '';
}
