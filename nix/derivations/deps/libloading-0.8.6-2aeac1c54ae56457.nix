# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libloading-0_8_6-2aeac1c54ae56457";
    meta.cargo_crate_info = {
      name = "libloading";
      version = "0.8.6";
      crate_hash = "2aeac1c54ae56457";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cfg-if-1_0_0-616d46354eebf850];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libloading/0.8.6/download";
      sha256 = "fc2f4eb4bc735547cfed7c0a4922cbd04a4655978c09b54f1f7b228750664c34";
    };
    unpackPhase = ''
      tar xf $src
      cd libloading-0.8.6
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "libloading";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Simonas Kazlauskas <libloading@kazlauskas.me>";
    CARGO_PKG_DESCRIPTION = "Bindings around the platform's dynamic library loading primitives with greatly improved memory safety.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "ISC";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libloading";
    CARGO_PKG_README = "README.mkd";
    CARGO_PKG_REPOSITORY = "https://github.com/nagisa/rust_libloading/";
    CARGO_PKG_RUST_VERSION = "1.56.0";
    CARGO_PKG_VERSION = "0.8.6";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "6";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m libloading-0_8_6-2aeac1c54ae56457"
      echo "@cargo { \"type\":0, \"crate_name\":\"libloading\", \"id\":\"libloading-0_8_6-2aeac1c54ae56457\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name libloading \
              --edition=2015 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --warn=unexpected_cfgs \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values())' \
              -C metadata=cf749206c3100b86 \
              -C extra-filename=-2aeac1c54ae56457 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern cfg_if=${cfg-if-1_0_0-616d46354eebf850}/libcfg_if-616d46354eebf850.rmeta \
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
          --arg fullname "libloading-0_8_6-2aeac1c54ae56457" \
          --arg crate_name "libloading" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
