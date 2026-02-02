# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "crossbeam-utils-0_8_21-script_build-12f6a43a9fc01710";
    meta.cargo_crate_info = {
      name = "crossbeam-utils";
      version = "0.8.21";
      crate_hash = "12f6a43a9fc01710";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/crossbeam-utils/0.8.21/download";
      sha256 = "d0a5c400df2834b80a4c3327b3aad3a4c4cd4de0629063962b03235697506a28";
    };
    unpackPhase = ''
      tar xf $src
      cd crossbeam-utils-0.8.21
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Utilities for concurrent programming";
    CARGO_PKG_HOMEPAGE = "https://github.com/crossbeam-rs/crossbeam/tree/master/crossbeam-utils";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "crossbeam-utils";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/crossbeam-rs/crossbeam";
    CARGO_PKG_RUST_VERSION = "1.60";
    CARGO_PKG_VERSION = "0.8.21";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "21";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m crossbeam-utils-0_8_21-script_build-12f6a43a9fc01710"
      echo "@cargo { \"type\":0, \"crate_name\":\"crossbeam-utils\", \"id\":\"crossbeam-utils-0_8_21-script_build-12f6a43a9fc01710\" }"

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
              --warn=unexpected_cfgs \
              --allow=clippy::lint_groups_priority \
              --allow=clippy::declare_interior_mutable_const \
              --check-cfg 'cfg(crossbeam_loom)' \
              --check-cfg 'cfg(crossbeam_sanitize)' \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "loom", "nightly", "std"))' \
              -C metadata=8b87ea39c6a46f43 \
              -C extra-filename=-12f6a43a9fc01710 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
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
            ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-12f6a43a9fc01710 $OUT_DIR/build_script_build
      
      # return structured formatted errors for later processing
      output=$(${pkgs.jq}/bin/jq -s -r -c \
          --arg fullname "crossbeam-utils-0_8_21-script_build-12f6a43a9fc01710" \
          --arg crate_name "crossbeam-utils" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
