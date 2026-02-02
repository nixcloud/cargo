# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "blake3-1_6_1-3250b34f7bcecb8a";
    meta.cargo_crate_info = {
      name = "blake3";
      version = "1.6.1";
      crate_hash = "3250b34f7bcecb8a";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [arrayref-0_3_9-70eb58486769037f arrayvec-0_7_6-0f41f30094bbac6c cfg-if-1_0_0-616d46354eebf850 constant_time_eq-0_3_1-52e5576b18736f3b];
    passthru.rust_crate_parent = [blake3-1_6_1-script_build_run-22b5db8b15d30a2c];
    passthru.rust_script_build_run = [blake3-1_6_1-script_build_run-22b5db8b15d30a2c];
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

    CARGO_CRATE_NAME = "blake3";
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

      echo -e "\e[92mCompiling\e[0m blake3-1_6_1-3250b34f7bcecb8a"
      echo "@cargo { \"type\":0, \"crate_name\":\"blake3\", \"id\":\"blake3-1_6_1-3250b34f7bcecb8a\" }"
      cp -r ${fn.get_rust_crate_parent passthru.rust_crate_parent}/* $OUT_DIR
      for file in $out/environment-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
          if [ -f "$file" ]; then
          sed -i "s|${fn.get_rust_crate_parent passthru.rust_crate_parent}|$out|g" "$file"
          fi
      done
      for file in ${fn.environment_variables passthru.rust_script_build_run}; do
        if [ -f $file ]; then
          set -a
            while read -r line; do
              echo -e "\033[38;5;208m$line\033[0m"
            done < "$file"
            source $file
            set +a
        fi
      done
      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name blake3 \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "digest", "mmap", "neon", "no_avx2", "no_avx512", "no_neon", "no_sse2", "no_sse41", "prefer_intrinsics", "pure", "rayon", "serde", "std", "traits-preview", "zeroize"))' \
              -C metadata=d6d363cd85b1fcf7 \
              -C extra-filename=-3250b34f7bcecb8a \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern arrayref=${arrayref-0_3_9-70eb58486769037f}/libarrayref-70eb58486769037f.rmeta \
              --extern arrayvec=${arrayvec-0_7_6-0f41f30094bbac6c}/libarrayvec-0f41f30094bbac6c.rmeta \
              --extern cfg_if=${cfg-if-1_0_0-616d46354eebf850}/libcfg_if-616d46354eebf850.rmeta \
              --extern constant_time_eq=${constant_time_eq-0_3_1-52e5576b18736f3b}/libconstant_time_eq-52e5576b18736f3b.rmeta \
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
          --arg fullname "blake3-1_6_1-3250b34f7bcecb8a" \
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
