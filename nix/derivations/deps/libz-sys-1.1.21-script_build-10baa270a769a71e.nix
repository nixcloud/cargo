# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libz-sys-1_1_21-script_build-10baa270a769a71e";
    meta.cargo_crate_info = {
      name = "libz-sys";
      version = "1.1.21";
      crate_hash = "10baa270a769a71e";
      type = "(build.rs build)";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [cc-1_2_16-76812c37260a1dd3 pkg-config-0_3_31-9f951027c189d1c8 vcpkg-0_2_15-586bd5fdef1a0fde];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libz-sys/1.1.21/download";
      sha256 = "df9b68e50e6e0b26f672573834882eb57759f6db9b3be2ea3c35c91188bb4eaa";
    };
    unpackPhase = ''
      tar xf $src
      cd libz-sys-1.1.21
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>:Josh Triplett <josh@joshtriplett.org>:Sebastian Thiel <sebastian.thiel@icloud.com>";
    CARGO_PKG_DESCRIPTION = "Low-level bindings to the system libz library (also known as zlib).";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libz-sys";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/libz-sys";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "1.1.21";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "21";
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
              --edition=2018 build.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type bin \
              --emit=dep-info,link \
              -C embed-bitcode=no \
              --warn=unexpected_cfgs \
              --check-cfg 'cfg(zng)' \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("asm", "cmake", "default", "libc", "static", "stock-zlib", "zlib-ng", "zlib-ng-no-cmake-experimental-community-maintained"))' \
              -C metadata=807c4cb535122b63 \
              -C extra-filename=-10baa270a769a71e \
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
            ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-10baa270a769a71e $OUT_DIR/build_script_build
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
