# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "ignore-0_4_23-dab7af6f0867647c";
    meta.cargo_crate_info = {
      name = "ignore";
      version = "0.4.23";
      crate_hash = "dab7af6f0867647c";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [crossbeam-deque-0_8_6-33404d844ef9489b globset-0_4_15-2a50c1c4f3461932 log-0_4_25-7616f5eb69eb8f7e memchr-2_7_4-3cee6db17bbe0dde regex-automata-0_4_9-5e0d341bfc5bf703 same-file-1_0_6-82920d733726b0a3 walkdir-2_5_0-742d7f303f7cfcda];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/ignore/0.4.23/download";
      sha256 = "6d89fd380afde86567dfba715db065673989d6253f42b88179abd3eae47bda4b";
    };
    unpackPhase = ''
      tar xf $src
      cd ignore-0.4.23
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "ignore";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "A fast library for efficiently matching ignore files such as `.gitignore`
against file paths.";
    CARGO_PKG_HOMEPAGE = "https://github.com/BurntSushi/ripgrep/tree/master/crates/ignore";
    CARGO_PKG_LICENSE = "Unlicense OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "ignore";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/BurntSushi/ripgrep/tree/master/crates/ignore";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.4.23";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "23";
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
              --crate-name ignore \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("simd-accel"))' \
              -C metadata=0911765fa7e35a67 \
              -C extra-filename=-dab7af6f0867647c \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern crossbeam_deque=${crossbeam-deque-0_8_6-33404d844ef9489b}/libcrossbeam_deque-33404d844ef9489b.rmeta \
              --extern globset=${globset-0_4_15-2a50c1c4f3461932}/libglobset-2a50c1c4f3461932.rmeta \
              --extern log=${log-0_4_25-7616f5eb69eb8f7e}/liblog-7616f5eb69eb8f7e.rmeta \
              --extern memchr=${memchr-2_7_4-3cee6db17bbe0dde}/libmemchr-3cee6db17bbe0dde.rmeta \
              --extern regex_automata=${regex-automata-0_4_9-5e0d341bfc5bf703}/libregex_automata-5e0d341bfc5bf703.rmeta \
              --extern same_file=${same-file-1_0_6-82920d733726b0a3}/libsame_file-82920d733726b0a3.rmeta \
              --extern walkdir=${walkdir-2_5_0-742d7f303f7cfcda}/libwalkdir-742d7f303f7cfcda.rmeta \
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
