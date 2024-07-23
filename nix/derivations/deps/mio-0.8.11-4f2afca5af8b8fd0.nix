# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "mio-0_8_11-4f2afca5af8b8fd0";
    meta.cargo_crate_info = {
      name = "mio";
      version = "0.8.11";
      crate_hash = "4f2afca5af8b8fd0";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [libc-0_2_175-b265bb513a0388f3 log-0_4_25-fde7ab722b325b0e];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/mio/0.8.11/download";
      sha256 = "a4a650543ca06a924e8b371db273b2756685faae30f8487da1b56505a8f78b0c";
    };

    unpackPhase = ''
      tar xf $src
      cd mio-0.8.11
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "mio";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Carl Lerche <me@carllerche.com>:Thomas de Zeeuw <thomasdezeeuw@gmail.com>:Tokio Contributors <team@tokio.rs>";
    CARGO_PKG_DESCRIPTION = "Lightweight non-blocking I/O.";
    CARGO_PKG_HOMEPAGE = "https://github.com/tokio-rs/mio";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "mio";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/tokio-rs/mio";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.8.11";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "8";
    CARGO_PKG_VERSION_PATCH = "11";
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
              --crate-name mio \
              --edition=2018 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="log"' \
              --cfg 'feature="net"' \
              --cfg 'feature="os-ext"' \
              --cfg 'feature="os-poll"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "log", "net", "os-ext", "os-poll"))' \
              -C metadata=a148b1664da080ef \
              -C extra-filename=-4f2afca5af8b8fd0 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern libc=${libc-0_2_175-b265bb513a0388f3}/liblibc-b265bb513a0388f3.rmeta \
              --extern log=${log-0_4_25-fde7ab722b325b0e}/liblog-fde7ab722b325b0e.rmeta \
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
