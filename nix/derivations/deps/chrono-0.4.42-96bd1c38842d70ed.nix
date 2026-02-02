# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "chrono-0_4_42-96bd1c38842d70ed";
    meta.cargo_crate_info = {
      name = "chrono";
      version = "0.4.42";
      crate_hash = "96bd1c38842d70ed";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [iana-time-zone-0_1_64-e266c5c8a338d056 num-traits-0_2_19-8946f1ffa19e3055 serde-1_0_218-472e28b9f131b02c];
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
    CARGO = "${cargo}/bin/cargo";

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
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m chrono-0_4_42-96bd1c38842d70ed"
      echo "@cargo { \"type\":0, \"crate_name\":\"chrono\", \"id\":\"chrono-0_4_42-96bd1c38842d70ed\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name chrono \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
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
              -C metadata=5393b233a1dcdd0c \
              -C extra-filename=-96bd1c38842d70ed \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern iana_time_zone=${iana-time-zone-0_1_64-e266c5c8a338d056}/libiana_time_zone-e266c5c8a338d056.rmeta \
              --extern num_traits=${num-traits-0_2_19-8946f1ffa19e3055}/libnum_traits-8946f1ffa19e3055.rmeta \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
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
          --arg fullname "chrono-0_4_42-96bd1c38842d70ed" \
          --arg crate_name "chrono" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
