# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "libgit2-sys-0_18_0_plus_1_9_0-86c4b3f8f5bf526a";
    meta.cargo_crate_info = {
      name = "libgit2-sys";
      version = "0.18.0+1.9.0";
      crate_hash = "86c4b3f8f5bf526a";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [libc-0_2_175-df0687d6868fdede libssh2-sys-0_3_1-7b0b3bce8fea88d8 libz-sys-1_1_21-69f52d4cc5a20a24 openssl-sys-0_9_106-adcaf6cb517a5566];
    passthru.rust_crate_parent = [libgit2-sys-0_18_0_plus_1_9_0-script_build_run-394f4058e10471ef];
    passthru.rust_script_build_run = [libgit2-sys-0_18_0_plus_1_9_0-script_build_run-394f4058e10471ef];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/libgit2-sys/0.18.0+1.9.0/download";
      sha256 = "e1a117465e7e1597e8febea8bb0c410f1c7fb93b1e1cddf34363f8390367ffec";
    };
    unpackPhase = ''
      tar xf $src
      cd libgit2-sys-0.18.0+1.9.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "libgit2_sys";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Josh Triplett <josh@joshtriplett.org>:Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Native bindings to the libgit2 library";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "libgit2-sys";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/git2-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.18.0+1.9.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "18";
    CARGO_PKG_VERSION_PATCH = "0";
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
              --crate-name libgit2_sys \
              --edition=2018 lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="https"' \
              --cfg 'feature="libssh2-sys"' \
              --cfg 'feature="openssl-sys"' \
              --cfg 'feature="ssh"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("https", "libssh2-sys", "openssl-sys", "ssh", "vendored", "vendored-openssl", "zlib-ng-compat"))' \
              -C metadata=30a33c06cb9da66f \
              -C extra-filename=-86c4b3f8f5bf526a \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern libssh2_sys=${libssh2-sys-0_3_1-7b0b3bce8fea88d8}/liblibssh2_sys-7b0b3bce8fea88d8.rmeta \
              --extern libz_sys=${libz-sys-1_1_21-69f52d4cc5a20a24}/liblibz_sys-69f52d4cc5a20a24.rmeta \
              --extern openssl_sys=${openssl-sys-0_9_106-adcaf6cb517a5566}/libopenssl_sys-adcaf6cb517a5566.rmeta \
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
