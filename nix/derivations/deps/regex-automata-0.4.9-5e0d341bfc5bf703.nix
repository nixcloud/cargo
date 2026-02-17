# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "regex-automata-0_4_9-5e0d341bfc5bf703";
    meta.cargo_crate_info = {
      name = "regex-automata";
      version = "0.4.9";
      crate_hash = "5e0d341bfc5bf703";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [aho-corasick-1_1_3-4faf1ab2f37c32c1 memchr-2_7_4-3cee6db17bbe0dde regex-syntax-0_8_5-26304aacfbc68086];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/regex-automata/0.4.9/download";
      sha256 = "809e8dc61f6de73b46c85f4c96486310fe304c434cfa43669d7b40f711150908";
    };
    unpackPhase = ''
      tar xf $src
      cd regex-automata-0.4.9
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "regex_automata";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "The Rust Project Developers:Andrew Gallant <jamslam@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Automata construction and matching using regular expressions.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "regex-automata";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/regex/tree/master/regex-automata";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.4.9";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "9";
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
              --crate-name regex_automata \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --cfg 'feature="dfa-onepass"' \
              --cfg 'feature="dfa-search"' \
              --cfg 'feature="hybrid"' \
              --cfg 'feature="meta"' \
              --cfg 'feature="nfa"' \
              --cfg 'feature="nfa-backtrack"' \
              --cfg 'feature="nfa-pikevm"' \
              --cfg 'feature="nfa-thompson"' \
              --cfg 'feature="perf"' \
              --cfg 'feature="perf-inline"' \
              --cfg 'feature="perf-literal"' \
              --cfg 'feature="perf-literal-multisubstring"' \
              --cfg 'feature="perf-literal-substring"' \
              --cfg 'feature="std"' \
              --cfg 'feature="syntax"' \
              --cfg 'feature="unicode"' \
              --cfg 'feature="unicode-age"' \
              --cfg 'feature="unicode-bool"' \
              --cfg 'feature="unicode-case"' \
              --cfg 'feature="unicode-gencat"' \
              --cfg 'feature="unicode-perl"' \
              --cfg 'feature="unicode-script"' \
              --cfg 'feature="unicode-segment"' \
              --cfg 'feature="unicode-word-boundary"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "default", "dfa", "dfa-build", "dfa-onepass", "dfa-search", "hybrid", "internal-instrument", "internal-instrument-pikevm", "logging", "meta", "nfa", "nfa-backtrack", "nfa-pikevm", "nfa-thompson", "perf", "perf-inline", "perf-literal", "perf-literal-multisubstring", "perf-literal-substring", "std", "syntax", "unicode", "unicode-age", "unicode-bool", "unicode-case", "unicode-gencat", "unicode-perl", "unicode-script", "unicode-segment", "unicode-word-boundary"))' \
              -C metadata=0fa165fdbd4715ae \
              -C extra-filename=-5e0d341bfc5bf703 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern aho_corasick=${aho-corasick-1_1_3-4faf1ab2f37c32c1}/libaho_corasick-4faf1ab2f37c32c1.rmeta \
              --extern memchr=${memchr-2_7_4-3cee6db17bbe0dde}/libmemchr-3cee6db17bbe0dde.rmeta \
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
