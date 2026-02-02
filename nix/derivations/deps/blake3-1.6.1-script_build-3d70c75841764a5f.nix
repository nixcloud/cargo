# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "blake3-1_6_1-script_build-3d70c75841764a5f";
    meta.cargo_crate_info = {
      name = "blake3";
      version = "1.6.1";
      crate_hash = "3d70c75841764a5f";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cc-1_2_16-76812c37260a1dd3];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/blake3/1.6.1/download";
      sha256 = "675f87afced0413c9bb02843499dbbd3882a237645883f71a2b59644a6d2f753";
    };
    unpackPhase = ''
      tar xf $src
      cd blake3-1.6.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Jack O'Connor <oconnor663@gmail.com>:Samuel Neves";
    CARGO_PKG_DESCRIPTION = "the BLAKE3 hash function";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "CC0-1.0 OR Apache-2.0 OR Apache-2.0 WITH LLVM-exception";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "blake3";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/BLAKE3-team/BLAKE3";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "1.6.1";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "6";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m blake3-1_6_1-script_build-3d70c75841764a5f"
      echo "@cargo { \"type\":0, \"crate_name\":\"blake3\", \"id\":\"blake3-1_6_1-script_build-3d70c75841764a5f\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name build_script_build \
              --edition=2021 build.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type bin \
              --emit=dep-info,link \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "digest", "mmap", "neon", "no_avx2", "no_avx512", "no_neon", "no_sse2", "no_sse41", "prefer_intrinsics", "pure", "rayon", "serde", "std", "traits-preview", "zeroize"))' \
              -C metadata=bf8c0c0002745150 \
              -C extra-filename=-3d70c75841764a5f \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern cc=${cc-1_2_16-76812c37260a1dd3}/libcc-76812c37260a1dd3.rlib \
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
            ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-3d70c75841764a5f $OUT_DIR/build_script_build
      
      # return structured formatted errors for later processing
      output=$(${pkgs.jq}/bin/jq -s -r -c \
          --arg fullname "blake3-1_6_1-script_build-3d70c75841764a5f" \
          --arg crate_name "blake3" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
