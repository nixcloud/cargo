# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "parking_lot_core-0_9_10-9a59bd9bd3fe342c";
    meta.cargo_crate_info = {
      name = "parking_lot_core";
      version = "0.9.10";
      crate_hash = "9a59bd9bd3fe342c";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [cfg-if-1_0_0-f52ed1292e79c10c libc-0_2_170-d46a143b0470970d smallvec-1_13_2-453c588ad74a5894];
    passthru.rust_crate_parent = [parking_lot_core-0_9_10-script_build_run-7bae69a33df63e20];
    passthru.rust_script_build_run = [parking_lot_core-0_9_10-script_build_run-7bae69a33df63e20];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/parking_lot_core/0.9.10/download";
      sha256 = "1e401f977ab385c9e4e3ab30627d6f26d00e2c73eef317493c4ec6d468726cf8";
    };
    unpackPhase = ''
      tar xf $src
      cd parking_lot_core-0.9.10
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "parking_lot_core";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Amanieu d'Antras <amanieu@gmail.com>";
    CARGO_PKG_DESCRIPTION = "An advanced API for creating custom synchronization primitives.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "parking_lot_core";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/Amanieu/parking_lot";
    CARGO_PKG_RUST_VERSION = "1.56.0";
    CARGO_PKG_VERSION = "0.9.10";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "9";
    CARGO_PKG_VERSION_PATCH = "10";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m parking_lot_core-0_9_10-9a59bd9bd3fe342c"
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
      (set -x 
      ${rustc}/bin/rustc \
        --crate-name parking_lot_core \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("backtrace", "deadlock_detection", "nightly", "petgraph", "thread-id"))' \
        -C metadata=4e6e00cdec0ff6fa \
        -C extra-filename=-9a59bd9bd3fe342c \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern cfg_if=${cfg-if-1_0_0-f52ed1292e79c10c}/libcfg_if-f52ed1292e79c10c.rmeta \
        --extern libc=${libc-0_2_170-d46a143b0470970d}/liblibc-d46a143b0470970d.rmeta \
        --extern smallvec=${smallvec-1_13_2-453c588ad74a5894}/libsmallvec-453c588ad74a5894.rmeta \
        --cap-lints allow
      )
    '';
}
