# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "pest_derive-2_7_15-d16fa3e9d28681c6";
    meta.cargo_crate_info = {
      name = "pest_derive";
      version = "2.7.15";
      crate_hash = "d16fa3e9d28681c6";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [pest-2_7_15-a8485b5b1580dc17 pest_generator-2_7_15-c669ba2a5e7aeb38];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/pest_derive/2.7.15/download";
      sha256 = "816518421cfc6887a0d62bf441b6ffb4536fcc926395a69e1a85852d4363f57e";
    };
    unpackPhase = ''
      tar xf $src
      cd pest_derive-2.7.15
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "pest_derive";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Dragoș Tiselice <dragostiselice@gmail.com>";
    CARGO_PKG_DESCRIPTION = "pest's derive macro";
    CARGO_PKG_HOMEPAGE = "https://pest.rs/";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "pest_derive";
    CARGO_PKG_README = "_README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/pest-parser/pest";
    CARGO_PKG_RUST_VERSION = "1.61";
    CARGO_PKG_VERSION = "2.7.15";
    CARGO_PKG_VERSION_MAJOR = "2";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "15";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m pest_derive-2_7_15-d16fa3e9d28681c6"
      echo "@cargo { \"type\":0, \"crate_name\":\"pest_derive\", \"id\":\"pest_derive-2_7_15-d16fa3e9d28681c6\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name pest_derive \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type proc-macro \
              --emit=dep-info,link \
              -C prefer-dynamic \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "grammar-extras", "not-bootstrap-in-src", "std"))' \
              -C metadata=4028d9fe615261e1 \
              -C extra-filename=-d16fa3e9d28681c6 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern pest=${pest-2_7_15-a8485b5b1580dc17}/libpest-a8485b5b1580dc17.rlib \
              --extern pest_generator=${pest_generator-2_7_15-c669ba2a5e7aeb38}/libpest_generator-c669ba2a5e7aeb38.rlib \
              --extern proc_macro \
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
          --arg fullname "pest_derive-2_7_15-d16fa3e9d28681c6" \
          --arg crate_name "pest_derive" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
