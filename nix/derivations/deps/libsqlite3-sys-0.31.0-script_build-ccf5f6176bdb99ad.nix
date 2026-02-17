# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libsqlite3-sys-0_31_0-script_build-ccf5f6176bdb99ad";
    meta.cargo_crate_info = {
      name = "libsqlite3-sys";
      version = "0.31.0";
      crate_hash = "ccf5f6176bdb99ad";
      type = "(build.rs build)";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [cc-1_2_16-76812c37260a1dd3 pkg-config-0_3_31-9f951027c189d1c8 vcpkg-0_2_15-586bd5fdef1a0fde];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libsqlite3-sys/0.31.0/download";
      sha256 = "ad8935b44e7c13394a179a438e0cebba0fe08fe01b54f152e29a93b5cf993fd4";
    };
    unpackPhase = ''
      tar xf $src
      cd libsqlite3-sys-0.31.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The rusqlite developers";
    CARGO_PKG_DESCRIPTION = "Native bindings to the libsqlite3 library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libsqlite3-sys";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rusqlite/rusqlite";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.31.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "31";
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
              --crate-name build_script_build \
              --edition=2021 build.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type bin \
              --emit=dep-info,link \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="bundled"' \
              --cfg 'feature="bundled_bindings"' \
              --cfg 'feature="cc"' \
              --cfg 'feature="default"' \
              --cfg 'feature="min_sqlite_version_3_14_0"' \
              --cfg 'feature="pkg-config"' \
              --cfg 'feature="vcpkg"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("bindgen", "buildtime_bindgen", "bundled", "bundled-sqlcipher", "bundled-sqlcipher-vendored-openssl", "bundled-windows", "bundled_bindings", "cc", "default", "in_gecko", "loadable_extension", "min_sqlite_version_3_14_0", "openssl-sys", "pkg-config", "prettyplease", "preupdate_hook", "quote", "session", "sqlcipher", "syn", "unlock_notify", "vcpkg", "wasm32-wasi-vfs", "with-asan"))' \
              -C metadata=f0a50a66f1b19d21 \
              -C extra-filename=-ccf5f6176bdb99ad \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern cc=${cc-1_2_16-76812c37260a1dd3}/libcc-76812c37260a1dd3.rlib \
              --extern pkg_config=${pkg-config-0_3_31-9f951027c189d1c8}/libpkg_config-9f951027c189d1c8.rlib \
              --extern vcpkg=${vcpkg-0_2_15-586bd5fdef1a0fde}/libvcpkg-586bd5fdef1a0fde.rlib \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
         ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-ccf5f6176bdb99ad $OUT_DIR/build_script_build
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
