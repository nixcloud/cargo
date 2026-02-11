# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "regex-1_11_1-c278e9a7e455d20f";
    meta.cargo_crate_info = {
      name = "regex";
      version = "1.11.1";
      crate_hash = "c278e9a7e455d20f";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [aho-corasick-1_1_3-4faf1ab2f37c32c1 memchr-2_7_4-3cee6db17bbe0dde regex-automata-0_4_9-5e0d341bfc5bf703 regex-syntax-0_8_5-26304aacfbc68086];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/regex/1.11.1/download";
      sha256 = "b544ef1b4eac5dc2db33ea63606ae9ffcfac26c1416a2806ae0bf5f56b201191";
    };
    unpackPhase = ''
      tar xf $src
      cd regex-1.11.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "regex";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Rust Project Developers:Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "An implementation of regular expressions for Rust. This implementation uses
finite automata and guarantees linear time matching on all inputs.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/regex";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "regex";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/regex";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "1.11.1";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "11";
    CARGO_PKG_VERSION_PATCH = "1";
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
              --crate-name regex \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="perf"' \
              --cfg 'feature="perf-backtrack"' \
              --cfg 'feature="perf-cache"' \
              --cfg 'feature="perf-dfa"' \
              --cfg 'feature="perf-inline"' \
              --cfg 'feature="perf-literal"' \
              --cfg 'feature="perf-onepass"' \
              --cfg 'feature="std"' \
              --cfg 'feature="unicode"' \
              --cfg 'feature="unicode-age"' \
              --cfg 'feature="unicode-bool"' \
              --cfg 'feature="unicode-case"' \
              --cfg 'feature="unicode-gencat"' \
              --cfg 'feature="unicode-perl"' \
              --cfg 'feature="unicode-script"' \
              --cfg 'feature="unicode-segment"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "logging", "pattern", "perf", "perf-backtrack", "perf-cache", "perf-dfa", "perf-dfa-full", "perf-inline", "perf-literal", "perf-onepass", "std", "unicode", "unicode-age", "unicode-bool", "unicode-case", "unicode-gencat", "unicode-perl", "unicode-script", "unicode-segment", "unstable", "use_std"))' \
              -C metadata=c86c6a8eea07d5ce \
              -C extra-filename=-c278e9a7e455d20f \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern aho_corasick=${aho-corasick-1_1_3-4faf1ab2f37c32c1}/libaho_corasick-4faf1ab2f37c32c1.rmeta \
              --extern memchr=${memchr-2_7_4-3cee6db17bbe0dde}/libmemchr-3cee6db17bbe0dde.rmeta \
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
