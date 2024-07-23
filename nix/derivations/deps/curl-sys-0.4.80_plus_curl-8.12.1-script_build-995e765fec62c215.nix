# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "curl-sys-0_4_80_plus_curl-8_12_1-script_build-995e765fec62c215";
    meta.cargo_crate_info = {
      name = "curl-sys";
      version = "0.4.80+curl-8.12.1";
      crate_hash = "995e765fec62c215";
      type = "(build.rs build)";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [cc-1_2_16-e1e43c4b4d22a16b pkg-config-0_3_31-ff42e244d259eb1a];
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
      ${fn.import_bash_function_helpers}
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)
      
      mkdir -p $out/nix
      export OUT_DIR=$out

      print_compiling_message "${name}"
      print_cargo_message_type_0 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name build_script_build \
              --edition=2018 build.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type bin \
              --emit=dep-info,link \
              -C embed-bitcode=no \
              -C debug-assertions=off \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="http2"' \
              --cfg 'feature="libnghttp2-sys"' \
              --cfg 'feature="openssl-sys"' \
              --cfg 'feature="ssl"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "force-system-lib-on-osx", "http2", "libnghttp2-sys", "mesalink", "ntlm", "openssl-sys", "poll_7_68_0", "protocol-ftp", "rustls", "rustls-ffi", "spnego", "ssl", "static-curl", "static-ssl", "upkeep_7_62_0", "windows-static-ssl", "zlib-ng-compat"))' \
              -C metadata=b2a562256c258363 \
              -C extra-filename=-995e765fec62c215 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern cc=${cc-1_2_16-e1e43c4b4d22a16b}/libcc-e1e43c4b4d22a16b.rlib \
              --extern pkg_config=${pkg-config-0_3_31-ff42e244d259eb1a}/libpkg_config-ff42e244d259eb1a.rlib \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
         ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-995e765fec62c215 $OUT_DIR/build_script_build
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
