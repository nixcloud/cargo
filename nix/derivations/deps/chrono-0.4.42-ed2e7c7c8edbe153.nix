# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "chrono-0_4_42-ed2e7c7c8edbe153";
    meta.cargo_crate_info = {
      name = "chrono";
      version = "0.4.42";
      crate_hash = "ed2e7c7c8edbe153";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [iana-time-zone-0_1_64-a8b027aa07cfe667 num-traits-0_2_19-e470ad1dd03fa99a serde-1_0_218-ed8707ff8dc168e7];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/chrono/0.4.42/download";
      sha256 = "145052bdd345b87320e369255277e3fb5152762ad123a901ef5c262dd38fe8d2";
    };

    unpackPhase = ''
      tar xf $src
      cd chrono-0.4.42
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "chrono";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Date and time library for Rust";
    CARGO_PKG_HOMEPAGE = "https://github.com/chronotope/chrono";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "chrono";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/chronotope/chrono";
    CARGO_PKG_RUST_VERSION = "1.62.0";
    CARGO_PKG_VERSION = "0.4.42";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "42";
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
              --crate-name chrono \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --cfg 'feature="clock"' \
              --cfg 'feature="default"' \
              --cfg 'feature="iana-time-zone"' \
              --cfg 'feature="js-sys"' \
              --cfg 'feature="now"' \
              --cfg 'feature="oldtime"' \
              --cfg 'feature="serde"' \
              --cfg 'feature="std"' \
              --cfg 'feature="wasm-bindgen"' \
              --cfg 'feature="wasmbind"' \
              --cfg 'feature="winapi"' \
              --cfg 'feature="windows-link"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("__internal_bench", "alloc", "arbitrary", "clock", "core-error", "default", "iana-time-zone", "js-sys", "libc", "now", "oldtime", "pure-rust-locales", "rkyv", "rkyv-16", "rkyv-32", "rkyv-64", "rkyv-validation", "serde", "std", "unstable-locales", "wasm-bindgen", "wasmbind", "winapi", "windows-link"))' \
              -C metadata=299f2d5c92a741c8 \
              -C extra-filename=-ed2e7c7c8edbe153 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern iana_time_zone=${iana-time-zone-0_1_64-a8b027aa07cfe667}/libiana_time_zone-a8b027aa07cfe667.rmeta \
              --extern num_traits=${num-traits-0_2_19-e470ad1dd03fa99a}/libnum_traits-e470ad1dd03fa99a.rmeta \
              --extern serde=${serde-1_0_218-ed8707ff8dc168e7}/libserde-ed8707ff8dc168e7.rmeta \
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
