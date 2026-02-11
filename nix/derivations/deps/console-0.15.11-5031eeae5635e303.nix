# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "console-0_15_11-5031eeae5635e303";
    meta.cargo_crate_info = {
      name = "console";
      version = "0.15.11";
      crate_hash = "5031eeae5635e303";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [libc-0_2_175-df0687d6868fdede once_cell-1_20_3-60992a3834e62ae0 unicode-width-0_2_0-0c384aa902aa0aa2];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/console/0.15.11/download";
      sha256 = "054ccb5b10f9f2cbf51eb355ca1d05c2d279ce1804688d0db74b4733a5aeafd8";
    };
    unpackPhase = ''
      tar xf $src
      cd console-0.15.11
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "console";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Armin Ronacher <armin.ronacher@active-4.com>";
    CARGO_PKG_DESCRIPTION = "A terminal and console abstraction for Rust";
    CARGO_PKG_HOMEPAGE = "https://github.com/console-rs/console";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "console";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/console-rs/console";
    CARGO_PKG_RUST_VERSION = "1.66";
    CARGO_PKG_VERSION = "0.15.11";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "15";
    CARGO_PKG_VERSION_PATCH = "11";
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
              --crate-name console \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="ansi-parsing"' \
              --cfg 'feature="default"' \
              --cfg 'feature="unicode-width"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("ansi-parsing", "default", "unicode-width", "windows-console-colors"))' \
              -C metadata=aa207624105dd354 \
              -C extra-filename=-5031eeae5635e303 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern once_cell=${once_cell-1_20_3-60992a3834e62ae0}/libonce_cell-60992a3834e62ae0.rmeta \
              --extern unicode_width=${unicode-width-0_2_0-0c384aa902aa0aa2}/libunicode_width-0c384aa902aa0aa2.rmeta \
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
