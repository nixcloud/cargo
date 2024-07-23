# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libsqlite3-sys-0_31_0-16ed399da4d69400";
    meta.cargo_crate_info = {
      name = "libsqlite3-sys";
      version = "0.31.0";
      crate_hash = "16ed399da4d69400";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [libsqlite3-sys-0_31_0-script_build_run-c31a64d006305f9c];
    passthru.rust_script_build_run = [libsqlite3-sys-0_31_0-script_build_run-c31a64d006305f9c];
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
    CARGO_CRATE_NAME = "libsqlite3_sys";
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
      copy_build_script_run_results_over_with_nix "${fn.get_rust_crate_parent passthru.rust_crate_parent}"
      for file in $out/environment-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
          if [ -f "$file" ]; then
          sed -i "s|${fn.get_rust_crate_parent passthru.rust_crate_parent}|$out|g" "$file"
          fi
      done
      load_environment_variables_from_files "${fn.environment_variables passthru.rust_script_build_run}"
      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name libsqlite3_sys \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
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
              -C metadata=da5f9cb4e4116ed4 \
              -C extra-filename=-16ed399da4d69400 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
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
