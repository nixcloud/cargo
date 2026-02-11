# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "git2-0_20_0-a5a6e57aa11f1a77";
    meta.cargo_crate_info = {
      name = "git2";
      version = "0.20.0";
      crate_hash = "a5a6e57aa11f1a77";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [bitflags-2_8_0-d8308ebf07e22afd libc-0_2_175-df0687d6868fdede libgit2-sys-0_18_0_plus_1_9_0-86c4b3f8f5bf526a log-0_4_25-7616f5eb69eb8f7e openssl-probe-0_1_6-6d5d5ac82de655f5 openssl-sys-0_9_106-adcaf6cb517a5566 url-2_5_4-7b68be8bb56d0713];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/git2/0.20.0/download";
      sha256 = "3fda788993cc341f69012feba8bf45c0ba4f3291fcc08e214b4d5a7332d88aff";
    };
    unpackPhase = ''
      tar xf $src
      cd git2-0.20.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "git2";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Josh Triplett <josh@joshtriplett.org>:Alex Crichton <alex@alexcrichton.com>";
    CARGO_PKG_DESCRIPTION = "Bindings to libgit2 for interoperating with git repositories. This library is
both threadsafe and memory safe and allows both reading and writing git
repositories.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "git2";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/git2-rs";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.20.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "20";
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

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name git2 \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="https"' \
              --cfg 'feature="openssl-probe"' \
              --cfg 'feature="openssl-sys"' \
              --cfg 'feature="ssh"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "https", "openssl-probe", "openssl-sys", "ssh", "unstable", "vendored-libgit2", "vendored-openssl", "zlib-ng-compat"))' \
              -C metadata=b786ce4447e04f3d \
              -C extra-filename=-a5a6e57aa11f1a77 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern bitflags=${bitflags-2_8_0-d8308ebf07e22afd}/libbitflags-d8308ebf07e22afd.rmeta \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern libgit2_sys=${libgit2-sys-0_18_0_plus_1_9_0-86c4b3f8f5bf526a}/liblibgit2_sys-86c4b3f8f5bf526a.rmeta \
              --extern log=${log-0_4_25-7616f5eb69eb8f7e}/liblog-7616f5eb69eb8f7e.rmeta \
              --extern openssl_probe=${openssl-probe-0_1_6-6d5d5ac82de655f5}/libopenssl_probe-6d5d5ac82de655f5.rmeta \
              --extern openssl_sys=${openssl-sys-0_9_106-adcaf6cb517a5566}/libopenssl_sys-adcaf6cb517a5566.rmeta \
              --extern url=${url-2_5_4-7b68be8bb56d0713}/liburl-7b68be8bb56d0713.rmeta \
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
