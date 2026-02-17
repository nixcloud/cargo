# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "globset-0_4_15-2a50c1c4f3461932";
    meta.cargo_crate_info = {
      name = "globset";
      version = "0.4.15";
      crate_hash = "2a50c1c4f3461932";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [aho-corasick-1_1_3-4faf1ab2f37c32c1 bstr-1_11_3-14003bcd5b7b8103 log-0_4_25-7616f5eb69eb8f7e regex-automata-0_4_9-5e0d341bfc5bf703 regex-syntax-0_8_5-26304aacfbc68086];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/globset/0.4.15/download";
      sha256 = "15f1ce686646e7f1e19bf7d5533fe443a45dbfb990e00629110797578b42fb19";
    };
    unpackPhase = ''
      tar xf $src
      cd globset-0.4.15
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "globset";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Cross platform single glob and glob set matching. Glob set matching is the
process of matching one or more glob patterns against a single candidate path
simultaneously, and returning all of the globs that matched.";
    CARGO_PKG_HOMEPAGE = "https://github.com/BurntSushi/ripgrep/tree/master/crates/globset";
    CARGO_PKG_LICENSE = "Unlicense OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "globset";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/BurntSushi/ripgrep/tree/master/crates/globset";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.4.15";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "15";
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
              --crate-name globset \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="log"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "log", "serde", "serde1", "simd-accel"))' \
              -C metadata=580e93ebb0b5700d \
              -C extra-filename=-2a50c1c4f3461932 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern aho_corasick=${aho-corasick-1_1_3-4faf1ab2f37c32c1}/libaho_corasick-4faf1ab2f37c32c1.rmeta \
              --extern bstr=${bstr-1_11_3-14003bcd5b7b8103}/libbstr-14003bcd5b7b8103.rmeta \
              --extern log=${log-0_4_25-7616f5eb69eb8f7e}/liblog-7616f5eb69eb8f7e.rmeta \
              --extern regex_automata=${regex-automata-0_4_9-5e0d341bfc5bf703}/libregex_automata-5e0d341bfc5bf703.rmeta \
              --extern regex_syntax=${regex-syntax-0_8_5-26304aacfbc68086}/libregex_syntax-26304aacfbc68086.rmeta \
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
