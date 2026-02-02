# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "miniz_oxide-0_8_5-a4a0cc7b24b565c3";
    meta.cargo_crate_info = {
      name = "miniz_oxide";
      version = "0.8.5";
      crate_hash = "a4a0cc7b24b565c3";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [adler2-2_0_0-115180b36279fc7c];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/miniz_oxide/0.8.5/download";
      sha256 = "8e3e04debbb59698c15bacbb6d93584a8c0ca9cc3213cb423d31f760d8843ce5";
    };
    unpackPhase = ''
      tar xf $src
      cd miniz_oxide-0.8.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "miniz_oxide";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Frommi <daniil.liferenko@gmail.com>:oyvindln <oyvindln@users.noreply.github.com>:Rich Geldreich richgel99@gmail.com";
    CARGO_PKG_DESCRIPTION = "DEFLATE compression and decompression library rewritten in Rust based on miniz";
    CARGO_PKG_HOMEPAGE = "https://github.com/Frommi/miniz_oxide/tree/master/miniz_oxide";
    CARGO_PKG_LICENSE = "MIT OR Zlib OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "miniz_oxide";
    CARGO_PKG_README = "Readme.md";
    CARGO_PKG_REPOSITORY = "https://github.com/Frommi/miniz_oxide/tree/master/miniz_oxide";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.8.5";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "5";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m miniz_oxide-0_8_5-a4a0cc7b24b565c3"
      echo "@cargo { \"type\":0, \"crate_name\":\"miniz_oxide\", \"id\":\"miniz_oxide-0_8_5-a4a0cc7b24b565c3\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name miniz_oxide \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --warn=unexpected_cfgs \
              --check-cfg 'cfg(fuzzing)' \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="with-alloc"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "compiler_builtins", "core", "default", "rustc-dep-of-std", "simd", "simd-adler32", "std", "with-alloc"))' \
              -C metadata=44690975a3af3118 \
              -C extra-filename=-a4a0cc7b24b565c3 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern adler2=${adler2-2_0_0-115180b36279fc7c}/libadler2-115180b36279fc7c.rmeta \
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
          --arg fullname "miniz_oxide-0_8_5-a4a0cc7b24b565c3" \
          --arg crate_name "miniz_oxide" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
