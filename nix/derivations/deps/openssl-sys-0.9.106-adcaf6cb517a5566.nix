# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "openssl-sys-0_9_106-adcaf6cb517a5566";
    meta.cargo_crate_info = {
      name = "openssl-sys";
      version = "0.9.106";
      crate_hash = "adcaf6cb517a5566";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [libc-0_2_175-df0687d6868fdede];
    passthru.rust_crate_parent = [openssl-sys-0_9_106-script_build_run-c8c90d54d12f4385];
    passthru.rust_script_build_run = [openssl-sys-0_9_106-script_build_run-c8c90d54d12f4385];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/openssl-sys/0.9.106/download";
      sha256 = "8bb61ea9811cc39e3c2069f40b8b8e2e70d8569b361f879786cc7ed48b777cdd";
    };
    unpackPhase = ''
      tar xf $src
      cd openssl-sys-0.9.106
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "openssl_sys";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Alex Crichton <alex@alexcrichton.com>:Steven Fackler <sfackler@gmail.com>";
    CARGO_PKG_DESCRIPTION = "FFI bindings to OpenSSL";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "openssl-sys";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/sfackler/rust-openssl";
    CARGO_PKG_RUST_VERSION = "1.63.0";
    CARGO_PKG_VERSION = "0.9.106";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "9";
    CARGO_PKG_VERSION_PATCH = "106";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      ${fn.import_bash_function_helpers}
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)
      
      mkdir -p $out/nix
      export OUT_DIR=$out

      print_compiling_message "${name}"
      print_cargo_message_type_0 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}"
      copy_build_script_run_results_over_with_nix "${fn.get_rust_crate_parent passthru.rust_crate_parent}"
      for file in $out/environment-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
          if [ -f "$file" ]; then
          sed -i "s|${fn.get_rust_crate_parent passthru.rust_crate_parent}|$out|g" "$file"
          fi
      done
      load_environment_variables_from_files "${fn.environment_variables passthru.rust_script_build_run}"
      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name openssl_sys \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("bindgen", "bssl-sys", "openssl-src", "unstable_boringssl", "vendored"))' \
              -C metadata=65c44e179fa881e2 \
              -C extra-filename=-adcaf6cb517a5566 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
