# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "rusqlite-0_33_0-482fe49309905af7";
    meta.cargo_crate_info = {
      name = "rusqlite";
      version = "0.33.0";
      crate_hash = "482fe49309905af7";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [bitflags-2_8_0-27b6a5758605f436 fallible-iterator-0_3_0-a78d5d88288e14db fallible-streaming-iterator-0_1_9-c0b7b971c74187c5 hashlink-0_10_0-11400bf95c4b5dec libsqlite3-sys-0_31_0-da22452ba9e7ce15 smallvec-1_13_2-453c588ad74a5894];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/rusqlite/0.33.0/download";
      sha256 = "1c6d5e5acb6f6129fe3f7ba0a7fc77bca1942cb568535e18e7bc40262baf3110";
    };
    unpackPhase = ''
      tar xf $src
      cd rusqlite-0.33.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "rusqlite";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The rusqlite developers";
    CARGO_PKG_DESCRIPTION = "Ergonomic wrapper for SQLite";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "rusqlite";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rusqlite/rusqlite";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.33.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "33";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m rusqlite-0_33_0-482fe49309905af7"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name rusqlite \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="bundled"' \
        --cfg 'feature="modern_sqlite"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("array", "backup", "blob", "buildtime_bindgen", "bundled", "bundled-full", "bundled-sqlcipher", "bundled-sqlcipher-vendored-openssl", "bundled-windows", "chrono", "collation", "column_decltype", "csv", "csvtab", "extra_check", "functions", "hooks", "i128_blob", "in_gecko", "jiff", "limits", "load_extension", "loadable_extension", "modern-full", "modern_sqlite", "preupdate_hook", "rusqlite-macros", "serde_json", "serialize", "series", "session", "sqlcipher", "time", "trace", "unlock_notify", "url", "uuid", "vtab", "wasm32-wasi-vfs", "window", "with-asan"))' \
        -C metadata=4a305374a7ce7276 \
        -C extra-filename=-482fe49309905af7 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern bitflags=${bitflags-2_8_0-27b6a5758605f436}/libbitflags-27b6a5758605f436.rmeta \
        --extern fallible_iterator=${fallible-iterator-0_3_0-a78d5d88288e14db}/libfallible_iterator-a78d5d88288e14db.rmeta \
        --extern fallible_streaming_iterator=${fallible-streaming-iterator-0_1_9-c0b7b971c74187c5}/libfallible_streaming_iterator-c0b7b971c74187c5.rmeta \
        --extern hashlink=${hashlink-0_10_0-11400bf95c4b5dec}/libhashlink-11400bf95c4b5dec.rmeta \
        --extern libsqlite3_sys=${libsqlite3-sys-0_31_0-da22452ba9e7ce15}/liblibsqlite3_sys-da22452ba9e7ce15.rmeta \
        --extern smallvec=${smallvec-1_13_2-453c588ad74a5894}/libsmallvec-453c588ad74a5894.rmeta \
        --cap-lints allow
      )
    '';
}
