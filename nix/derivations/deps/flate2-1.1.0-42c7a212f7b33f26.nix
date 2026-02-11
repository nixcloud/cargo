# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "flate2-1_1_0-42c7a212f7b33f26";
    meta.cargo_crate_info = {
      name = "flate2";
      version = "1.1.0";
      crate_hash = "42c7a212f7b33f26";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [crc32fast-1_4_2-3d7fbbab345759e0 libz-sys-1_1_21-2665ee861d863bc2];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/flate2/1.1.0/download";
      sha256 = "11faaf5a5236997af9848be0bef4db95824b1d534ebc64d0f0c6cf3e67bd38dc";
    };
    unpackPhase = ''
      tar xf $src
      cd flate2-1.1.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "flate2";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>:Josh Triplett <josh@joshtriplett.org>";
    CARGO_PKG_DESCRIPTION = "DEFLATE compression and decompression exposed as Read/BufRead/Write streams.
Supports miniz_oxide and multiple zlib implementations. Supports zlib, gzip,
and raw deflate streams.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/flate2-rs";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "flate2";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/flate2-rs";
    CARGO_PKG_RUST_VERSION = "1.67.0";
    CARGO_PKG_VERSION = "1.1.0";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "1";
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
              --crate-name flate2 \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="any_impl"' \
              --cfg 'feature="any_zlib"' \
              --cfg 'feature="libz-sys"' \
              --cfg 'feature="zlib"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("any_impl", "any_zlib", "cloudflare-zlib-sys", "cloudflare_zlib", "default", "libz-ng-sys", "libz-rs-sys", "libz-sys", "miniz-sys", "miniz_oxide", "rust_backend", "zlib", "zlib-default", "zlib-ng", "zlib-ng-compat", "zlib-rs"))' \
              -C metadata=664d3a5b6ac78123 \
              -C extra-filename=-42c7a212f7b33f26 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern crc32fast=${crc32fast-1_4_2-3d7fbbab345759e0}/libcrc32fast-3d7fbbab345759e0.rmeta \
              --extern libz_sys=${libz-sys-1_1_21-2665ee861d863bc2}/liblibz_sys-2665ee861d863bc2.rmeta \
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
