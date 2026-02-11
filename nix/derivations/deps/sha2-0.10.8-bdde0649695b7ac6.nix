# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "sha2-0_10_8-bdde0649695b7ac6";
    meta.cargo_crate_info = {
      name = "sha2";
      version = "0.10.8";
      crate_hash = "bdde0649695b7ac6";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [cfg-if-1_0_0-616d46354eebf850 cpufeatures-0_2_17-e2bead5fbcbc1f9e digest-0_10_7-d61413dd55c3b709];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/sha2/0.10.8/download";
      sha256 = "793db75ad2bcafc3ffa7c68b215fee268f537982cd901d132f89c6343f3a3dc8";
    };
    unpackPhase = ''
      tar xf $src
      cd sha2-0.10.8
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "sha2";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "RustCrypto Developers";
    CARGO_PKG_DESCRIPTION = "Pure Rust implementation of the SHA-2 hash function family
including SHA-224, SHA-256, SHA-384, and SHA-512.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "sha2";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/RustCrypto/hashes";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.10.8";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "10";
    CARGO_PKG_VERSION_PATCH = "8";
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
              --crate-name sha2 \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("asm", "asm-aarch64", "compress", "default", "force-soft", "loongarch64_asm", "oid", "sha2-asm", "std"))' \
              -C metadata=c6e31da321cc098b \
              -C extra-filename=-bdde0649695b7ac6 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern cfg_if=${cfg-if-1_0_0-616d46354eebf850}/libcfg_if-616d46354eebf850.rmeta \
              --extern cpufeatures=${cpufeatures-0_2_17-e2bead5fbcbc1f9e}/libcpufeatures-e2bead5fbcbc1f9e.rmeta \
              --extern digest=${digest-0_10_7-d61413dd55c3b709}/libdigest-d61413dd55c3b709.rmeta \
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
