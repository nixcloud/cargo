# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "rusqlite-0_33_0-0e7a13217d933375";
    meta.cargo_crate_info = {
      name = "rusqlite";
      version = "0.33.0";
      crate_hash = "0e7a13217d933375";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [bitflags-2_8_0-d8308ebf07e22afd fallible-iterator-0_3_0-2494fdfb0552e808 fallible-streaming-iterator-0_1_9-6db7f5334e34a8b5 hashlink-0_10_0-39cf9e95ebd42033 libsqlite3-sys-0_31_0-8e2c6f3f6c420058 smallvec-1_13_2-e5874423828ed52b];
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
      ${fn.import_bash_function_helpers}
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)
      
      mkdir -p $out/nix
      export OUT_DIR=$out

      print_compiling_message "${name}"
      print_cargo_message_type_0 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name rusqlite \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="bundled"' \
              --cfg 'feature="modern_sqlite"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("array", "backup", "blob", "buildtime_bindgen", "bundled", "bundled-full", "bundled-sqlcipher", "bundled-sqlcipher-vendored-openssl", "bundled-windows", "chrono", "collation", "column_decltype", "csv", "csvtab", "extra_check", "functions", "hooks", "i128_blob", "in_gecko", "jiff", "limits", "load_extension", "loadable_extension", "modern-full", "modern_sqlite", "preupdate_hook", "rusqlite-macros", "serde_json", "serialize", "series", "session", "sqlcipher", "time", "trace", "unlock_notify", "url", "uuid", "vtab", "wasm32-wasi-vfs", "window", "with-asan"))' \
              -C metadata=3fc24bd542911e8d \
              -C extra-filename=-0e7a13217d933375 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern bitflags=${bitflags-2_8_0-d8308ebf07e22afd}/libbitflags-d8308ebf07e22afd.rmeta \
              --extern fallible_iterator=${fallible-iterator-0_3_0-2494fdfb0552e808}/libfallible_iterator-2494fdfb0552e808.rmeta \
              --extern fallible_streaming_iterator=${fallible-streaming-iterator-0_1_9-6db7f5334e34a8b5}/libfallible_streaming_iterator-6db7f5334e34a8b5.rmeta \
              --extern hashlink=${hashlink-0_10_0-39cf9e95ebd42033}/libhashlink-39cf9e95ebd42033.rmeta \
              --extern libsqlite3_sys=${libsqlite3-sys-0_31_0-8e2c6f3f6c420058}/liblibsqlite3_sys-8e2c6f3f6c420058.rmeta \
              --extern smallvec=${smallvec-1_13_2-e5874423828ed52b}/libsmallvec-e5874423828ed52b.rmeta \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
