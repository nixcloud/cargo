# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "build-rs-libnix-0_1_11-24a8729adbae7212";
    meta.cargo_crate_info = {
      name = "build-rs-libnix";
      version = "0.1.11";
      crate_hash = "24a8729adbae7212";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [anyhow-1_0_96-61bbc4e08b05614c colored-3_1_1-86c9fae7f303dfbf regex-1_11_1-78f28ee524c2cf84];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/build-rs-libnix/0.1.11/download";
      sha256 = "26e2aeb7ef73805c80667abab8382f9ebdf6de81dc842a18eac0d880d3b43eab";
    };

    unpackPhase = ''
      tar xf $src
      cd build-rs-libnix-0.1.11
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "build_rs_libnix";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "A command-line utility that extracts `--cfg` and `--check-cfg` flags from `cargo:` build.rs outputs";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "LICENSE-THIRD-PARTY";
    CARGO_PKG_NAME = "build-rs-libnix";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.1.11";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
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
              --crate-name build_rs_libnix \
              --edition=2024 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values())' \
              -C metadata=fdf51184ca54963b \
              -C extra-filename=-24a8729adbae7212 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern anyhow=${anyhow-1_0_96-61bbc4e08b05614c}/libanyhow-61bbc4e08b05614c.rmeta \
              --extern colored=${colored-3_1_1-86c9fae7f303dfbf}/libcolored-86c9fae7f303dfbf.rmeta \
              --extern regex=${regex-1_11_1-78f28ee524c2cf84}/libregex-78f28ee524c2cf84.rmeta \
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
