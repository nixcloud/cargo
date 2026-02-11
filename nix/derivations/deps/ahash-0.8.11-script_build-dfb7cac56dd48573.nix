# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "ahash-0_8_11-script_build-dfb7cac56dd48573";
    meta.cargo_crate_info = {
      name = "ahash";
      version = "0.8.11";
      crate_hash = "dfb7cac56dd48573";
      type = "(build.rs build)";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [version_check-0_9_5-0f6ab564ae9887d4];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/ahash/0.8.11/download";
      sha256 = "e89da841a80418a9b391ebaea17f5c112ffaaa96f621d2c285b5174da76b9011";
    };
    unpackPhase = ''
      tar xf $src
      cd ahash-0.8.11
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Tom Kaitchuck <Tom.Kaitchuck@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A non-cryptographic hash function using AES-NI for high performance";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "ahash";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/tkaitchuck/ahash";
    CARGO_PKG_RUST_VERSION = "1.60.0";
    CARGO_PKG_VERSION = "0.8.11";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
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
              --crate-name build_script_build \
              --edition=2018 build.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type bin \
              --emit=dep-info,link \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("atomic-polyfill", "compile-time-rng", "const-random", "default", "getrandom", "nightly-arm-aes", "no-rng", "runtime-rng", "serde", "std"))' \
              -C metadata=ad5ed8b832bffe2d \
              -C extra-filename=-dfb7cac56dd48573 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern version_check=${version_check-0_9_5-0f6ab564ae9887d4}/libversion_check-0f6ab564ae9887d4.rlib \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
            ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-dfb7cac56dd48573 $OUT_DIR/build_script_build
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
