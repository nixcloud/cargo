# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "generic-array-0_14_7-a73c62568a2134d9";
    meta.cargo_crate_info = {
      name = "generic-array";
      version = "0.14.7";
      crate_hash = "a73c62568a2134d9";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [typenum-1_17_0-218683b74ca28981 zeroize-1_8_1-aaf7cdda91519e7c];
    passthru.rust_crate_parent = [generic-array-0_14_7-script_build_run-39173d8ec8bd3f99];
    passthru.rust_script_build_run = [generic-array-0_14_7-script_build_run-39173d8ec8bd3f99];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/generic-array/0.14.7/download";
      sha256 = "85649ca51fd72272d7821adaf274ad91c288277713d9c18820d8499a7ff69e9a";
    };
    unpackPhase = ''
      tar xf $src
      cd generic-array-0.14.7
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "generic_array";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Bartłomiej Kamiński <fizyk20@gmail.com>:Aaron Trent <novacrazy@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Generic types implementing functionality of arrays";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "generic-array";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/fizyk20/generic-array.git";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.14.7";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "14";
    CARGO_PKG_VERSION_PATCH = "7";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m generic-array-0_14_7-a73c62568a2134d9"
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
        --crate-name generic_array \
        --edition=2015 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="more_lengths"' \
        --cfg 'feature="zeroize"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("more_lengths", "serde", "zeroize"))' \
        -C metadata=f3966a0403dd28fd \
        -C extra-filename=-a73c62568a2134d9 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern typenum=${typenum-1_17_0-218683b74ca28981}/libtypenum-218683b74ca28981.rmeta \
        --extern zeroize=${zeroize-1_8_1-aaf7cdda91519e7c}/libzeroize-aaf7cdda91519e7c.rmeta \
        --cap-lints allow
      )
    '';
}
