# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "git2-curl-0_21_0-d43c11566cc114b0";
    meta.cargo_crate_info = {
      name = "git2-curl";
      version = "0.21.0";
      crate_hash = "d43c11566cc114b0";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [curl-0_4_47-f684c2bd7b0f950d git2-0_20_0-a5a6e57aa11f1a77 log-0_4_25-7616f5eb69eb8f7e url-2_5_4-7b68be8bb56d0713];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/git2-curl/0.21.0/download";
      sha256 = "be8dcabbc09ece4d30a9aa983d5804203b7e2f8054a171f792deff59b56d31fa";
    };
    unpackPhase = ''
      tar xf $src
      cd git2-curl-0.21.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "git2_curl";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Josh Triplett <josh@joshtriplett.org>:Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Backend for an HTTP transport in libgit2 powered by libcurl.

Intended to be used with the git2 crate.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "git2-curl";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/git2-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.21.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "21";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m git2-curl-0_21_0-d43c11566cc114b0"
      echo "@cargo { \"type\":0, \"crate_name\":\"git2-curl\", \"id\":\"git2-curl-0_21_0-d43c11566cc114b0\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name git2_curl \
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
              --check-cfg 'cfg(feature, values("zlib-ng-compat"))' \
              -C metadata=80ed707a8575c645 \
              -C extra-filename=-d43c11566cc114b0 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern curl=${curl-0_4_47-f684c2bd7b0f950d}/libcurl-f684c2bd7b0f950d.rmeta \
              --extern git2=${git2-0_20_0-a5a6e57aa11f1a77}/libgit2-a5a6e57aa11f1a77.rmeta \
              --extern log=${log-0_4_25-7616f5eb69eb8f7e}/liblog-7616f5eb69eb8f7e.rmeta \
              --extern url=${url-2_5_4-7b68be8bb56d0713}/liburl-7b68be8bb56d0713.rmeta \
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
          --arg fullname "git2-curl-0_21_0-d43c11566cc114b0" \
          --arg crate_name "git2-curl" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
