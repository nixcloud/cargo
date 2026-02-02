# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "curl-sys-0_4_80_plus_curl-8_12_1-script_build-dc795e51d6e22aca";
    meta.cargo_crate_info = {
      name = "curl-sys";
      version = "0.4.80+curl-8.12.1";
      crate_hash = "dc795e51d6e22aca";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cc-1_2_16-76812c37260a1dd3 pkg-config-0_3_31-9f951027c189d1c8];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/curl-sys/0.4.80+curl-8.12.1/download";
      sha256 = "55f7df2eac63200c3ab25bde3b2268ef2ee56af3d238e76d61f01c3c49bff734";
    };
    unpackPhase = ''
      tar xf $src
      cd curl-sys-0.4.80+curl-8.12.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Native bindings to the libcurl library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "curl-sys";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/alexcrichton/curl-rust";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.4.80+curl-8.12.1";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "80";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m curl-sys-0_4_80_plus_curl-8_12_1-script_build-dc795e51d6e22aca"
      echo "@cargo { \"type\":0, \"crate_name\":\"curl-sys\", \"id\":\"curl-sys-0_4_80_plus_curl-8_12_1-script_build-dc795e51d6e22aca\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name build_script_build \
              --edition=2018 build.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type bin \
              --emit=dep-info,link \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="http2"' \
              --cfg 'feature="libnghttp2-sys"' \
              --cfg 'feature="openssl-sys"' \
              --cfg 'feature="ssl"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "force-system-lib-on-osx", "http2", "libnghttp2-sys", "mesalink", "ntlm", "openssl-sys", "poll_7_68_0", "protocol-ftp", "rustls", "rustls-ffi", "spnego", "ssl", "static-curl", "static-ssl", "upkeep_7_62_0", "windows-static-ssl", "zlib-ng-compat"))' \
              -C metadata=718fc8dc4af8790b \
              -C extra-filename=-dc795e51d6e22aca \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern cc=${cc-1_2_16-76812c37260a1dd3}/libcc-76812c37260a1dd3.rlib \
              --extern pkg_config=${pkg-config-0_3_31-9f951027c189d1c8}/libpkg_config-9f951027c189d1c8.rlib \
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
            ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-dc795e51d6e22aca $OUT_DIR/build_script_build
      
      # return structured formatted errors for later processing
      output=$(${pkgs.jq}/bin/jq -s -r -c \
          --arg fullname "curl-sys-0_4_80_plus_curl-8_12_1-script_build-dc795e51d6e22aca" \
          --arg crate_name "curl-sys" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
