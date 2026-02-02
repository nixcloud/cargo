# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "tracing-0_1_41-7b5284fa1d5dcd0d";
    meta.cargo_crate_info = {
      name = "tracing";
      version = "0.1.41";
      crate_hash = "7b5284fa1d5dcd0d";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [pin-project-lite-0_2_16-dbb7ad05ebc1034f tracing-attributes-0_1_28-056492cde3f32925 tracing-core-0_1_33-a96acb2d986ff9b2];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/tracing/0.1.41/download";
      sha256 = "784e0ac535deb450455cbfa28a6f0df145ea1bb7ae51b821cf5e7927fdcfbdd0";
    };
    unpackPhase = ''
      tar xf $src
      cd tracing-0.1.41
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "tracing";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Eliza Weisman <eliza@buoyant.io>:Tokio Contributors <team@tokio.rs>";
    CARGO_PKG_DESCRIPTION = "Application-level tracing for Rust.
";
    CARGO_PKG_HOMEPAGE = "https://tokio.rs";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "tracing";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/tokio-rs/tracing";
    CARGO_PKG_RUST_VERSION = "1.63.0";
    CARGO_PKG_VERSION = "0.1.41";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "41";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m tracing-0_1_41-7b5284fa1d5dcd0d"
      echo "@cargo { \"type\":0, \"crate_name\":\"tracing\", \"id\":\"tracing-0_1_41-7b5284fa1d5dcd0d\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name tracing \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --warn=unexpected_cfgs \
              --check-cfg 'cfg(flaky_tests)' \
              --check-cfg 'cfg(tracing_unstable)' \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="attributes"' \
              --cfg 'feature="std"' \
              --cfg 'feature="tracing-attributes"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("async-await", "attributes", "default", "log", "log-always", "max_level_debug", "max_level_error", "max_level_info", "max_level_off", "max_level_trace", "max_level_warn", "release_max_level_debug", "release_max_level_error", "release_max_level_info", "release_max_level_off", "release_max_level_trace", "release_max_level_warn", "std", "tracing-attributes", "valuable"))' \
              -C metadata=e665b7154cc1d6c8 \
              -C extra-filename=-7b5284fa1d5dcd0d \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern pin_project_lite=${pin-project-lite-0_2_16-dbb7ad05ebc1034f}/libpin_project_lite-dbb7ad05ebc1034f.rmeta \
              --extern tracing_attributes=${tracing-attributes-0_1_28-056492cde3f32925}/libtracing_attributes-056492cde3f32925.so \
              --extern tracing_core=${tracing-core-0_1_33-a96acb2d986ff9b2}/libtracing_core-a96acb2d986ff9b2.rmeta \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      # print errors
      while IFS= read -r line
      do
          tmpFile=$(${pkgs.mktemp}/bin/mktemp)
          echo "$line" > $tmpFile
          ${pkgs.jq}/bin/jq -r -c 'select(."$message_type"=="diagnostic") | .rendered' $tmpFile
      done < $rustc_json_output_lines
      
      
      # return structured formatted errors for later processing
      output=$(${pkgs.jq}/bin/jq -s -r -c \
          --arg fullname "tracing-0_1_41-7b5284fa1d5dcd0d" \
          --arg crate_name "tracing" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
