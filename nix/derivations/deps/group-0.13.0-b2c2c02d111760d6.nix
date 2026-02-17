# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "group-0_13_0-b2c2c02d111760d6";
    meta.cargo_crate_info = {
      name = "group";
      version = "0.13.0";
      crate_hash = "b2c2c02d111760d6";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [ff-0_13_0-c7a3e6a3c0308f8f rand_core-0_6_4-5078be04f75dc0b2 subtle-2_6_1-61dbca2d742edabc];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/group/0.13.0/download";
      sha256 = "f0f9ef7462f7c099f518d754361858f86d8a07af53ba9af0fe635bbccb151a63";
    };
    unpackPhase = ''
      tar xf $src
      cd group-0.13.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "group";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Sean Bowe <ewillbefull@gmail.com>:Jack Grigg <jack@z.cash>";
    CARGO_PKG_DESCRIPTION = "Elliptic curve group traits and utilities";
    CARGO_PKG_HOMEPAGE = "https://github.com/zkcrypto/group";
    CARGO_PKG_LICENSE = "MIT/Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "group";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/zkcrypto/group";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.13.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "13";
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
              --crate-name group \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "default", "memuse", "rand", "rand_xorshift", "tests", "wnaf-memuse"))' \
              -C metadata=9710a499938ee9b7 \
              -C extra-filename=-b2c2c02d111760d6 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern ff=${ff-0_13_0-c7a3e6a3c0308f8f}/libff-c7a3e6a3c0308f8f.rmeta \
              --extern rand_core=${rand_core-0_6_4-5078be04f75dc0b2}/librand_core-5078be04f75dc0b2.rmeta \
              --extern subtle=${subtle-2_6_1-61dbca2d742edabc}/libsubtle-61dbca2d742edabc.rmeta \
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
