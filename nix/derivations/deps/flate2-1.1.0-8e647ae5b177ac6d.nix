# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "flate2-1_1_0-8e647ae5b177ac6d";
    meta.cargo_crate_info = {
      name = "flate2";
      version = "1.1.0";
      crate_hash = "8e647ae5b177ac6d";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [crc32fast-1_4_2-3d7fbbab345759e0 libz-sys-1_1_21-69f52d4cc5a20a24 miniz_oxide-0_8_5-a4a0cc7b24b565c3];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/flate2/1.1.0/download";
      sha256 = "11faaf5a5236997af9848be0bef4db95824b1d534ebc64d0f0c6cf3e67bd38dc";
    };
    unpackPhase = ''
      tar xf $src
      cd flate2-1.1.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "flate2";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>:Josh Triplett <josh@joshtriplett.org>";
    CARGO_PKG_DESCRIPTION = "DEFLATE compression and decompression exposed as Read/BufRead/Write streams.
Supports miniz_oxide and multiple zlib implementations. Supports zlib, gzip,
and raw deflate streams.
";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-lang/flate2-rs";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "flate2";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/flate2-rs";
    CARGO_PKG_RUST_VERSION = "1.67.0";
    CARGO_PKG_VERSION = "1.1.0";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m flate2-1_1_0-8e647ae5b177ac6d"
      echo "@cargo { \"type\":0, \"crate_name\":\"flate2\", \"id\":\"flate2-1_1_0-8e647ae5b177ac6d\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name flate2 \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="any_impl"' \
              --cfg 'feature="any_zlib"' \
              --cfg 'feature="libz-sys"' \
              --cfg 'feature="miniz_oxide"' \
              --cfg 'feature="rust_backend"' \
              --cfg 'feature="zlib"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("any_impl", "any_zlib", "cloudflare-zlib-sys", "cloudflare_zlib", "default", "libz-ng-sys", "libz-rs-sys", "libz-sys", "miniz-sys", "miniz_oxide", "rust_backend", "zlib", "zlib-default", "zlib-ng", "zlib-ng-compat", "zlib-rs"))' \
              -C metadata=28c47e034bc36352 \
              -C extra-filename=-8e647ae5b177ac6d \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern crc32fast=${crc32fast-1_4_2-3d7fbbab345759e0}/libcrc32fast-3d7fbbab345759e0.rmeta \
              --extern libz_sys=${libz-sys-1_1_21-69f52d4cc5a20a24}/liblibz_sys-69f52d4cc5a20a24.rmeta \
              --extern miniz_oxide=${miniz_oxide-0_8_5-a4a0cc7b24b565c3}/libminiz_oxide-a4a0cc7b24b565c3.rmeta \
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
          --arg fullname "flate2-1_1_0-8e647ae5b177ac6d" \
          --arg crate_name "flate2" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
