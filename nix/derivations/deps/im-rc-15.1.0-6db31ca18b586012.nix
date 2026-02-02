# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "im-rc-15_1_0-6db31ca18b586012";
    meta.cargo_crate_info = {
      name = "im-rc";
      version = "15.1.0";
      crate_hash = "6db31ca18b586012";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [bitmaps-2_1_0-f1176e47abd2310d rand_core-0_6_4-5078be04f75dc0b2 rand_xoshiro-0_6_0-9966516d1098f296 sized-chunks-0_6_5-e757fe722119bf9b typenum-1_17_0-34b9dff24cc50896];
    passthru.rust_crate_parent = [im-rc-15_1_0-script_build_run-7f18a1872a44f952];
    passthru.rust_script_build_run = [im-rc-15_1_0-script_build_run-7f18a1872a44f952];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/im-rc/15.1.0/download";
      sha256 = "af1955a75fa080c677d3972822ec4bad316169ab1cfc6c257a942c2265dbe5fe";
    };
    unpackPhase = ''
      tar xf $src
      cd im-rc-15.1.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "im_rc";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Bodil Stokke <bodil@bodil.org>";
    CARGO_PKG_DESCRIPTION = "Immutable collection datatypes (the fast but not thread safe version)";
    CARGO_PKG_HOMEPAGE = "http://immutable.rs/";
    CARGO_PKG_LICENSE = "MPL-2.0+";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "im-rc";
    CARGO_PKG_README = "../../README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/bodil/im-rs";
    CARGO_PKG_RUST_VERSION = "1.46.0";
    CARGO_PKG_VERSION = "15.1.0";
    CARGO_PKG_VERSION_MAJOR = "15";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m im-rc-15_1_0-6db31ca18b586012"
      echo "@cargo { \"type\":0, \"crate_name\":\"im-rc\", \"id\":\"im-rc-15_1_0-6db31ca18b586012\" }"
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
              --crate-name im_rc \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("arbitrary", "debug", "pool", "proptest", "quickcheck", "rayon", "refpool", "serde"))' \
              -C metadata=218594a063b83a5a \
              -C extra-filename=-6db31ca18b586012 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern bitmaps=${bitmaps-2_1_0-f1176e47abd2310d}/libbitmaps-f1176e47abd2310d.rmeta \
              --extern rand_core=${rand_core-0_6_4-5078be04f75dc0b2}/librand_core-5078be04f75dc0b2.rmeta \
              --extern rand_xoshiro=${rand_xoshiro-0_6_0-9966516d1098f296}/librand_xoshiro-9966516d1098f296.rmeta \
              --extern sized_chunks=${sized-chunks-0_6_5-e757fe722119bf9b}/libsized_chunks-e757fe722119bf9b.rmeta \
              --extern typenum=${typenum-1_17_0-34b9dff24cc50896}/libtypenum-34b9dff24cc50896.rmeta \
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
          --arg fullname "im-rc-15_1_0-6db31ca18b586012" \
          --arg crate_name "im-rc" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
