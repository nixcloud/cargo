# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "im-rc-15_1_0-c80c253ce789d440";
    meta.cargo_crate_info = {
      name = "im-rc";
      version = "15.1.0";
      crate_hash = "c80c253ce789d440";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [bitmaps-2_1_0-51933aba5ef55341 rand_core-0_6_4-fe99bd26a150a053 rand_xoshiro-0_6_0-f04981dd311ba238 sized-chunks-0_6_5-046f699445e99791 typenum-1_17_0-218683b74ca28981];
    passthru.rust_crate_parent = [im-rc-15_1_0-script_build_run-723454c6ae50b5e6];
    passthru.rust_script_build_run = [im-rc-15_1_0-script_build_run-723454c6ae50b5e6];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/im-rc/15.1.0/download";
      sha256 = "af1955a75fa080c677d3972822ec4bad316169ab1cfc6c257a942c2265dbe5fe";
    };
    unpackPhase = ''
      tar xf $src
      cd im-rc-15.1.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "im_rc";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Bodil Stokke <bodil@bodil.org>";
    CARGO_PKG_DESCRIPTION = "Immutable collection datatypes (the fast but not thread safe version)";
    CARGO_PKG_HOMEPAGE = "http://immutable.rs/";
    CARGO_PKG_LICENSE = "MPL-2.0+";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "im-rc";
    CARGO_PKG_README = "../../README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/bodil/im-rs";
    CARGO_PKG_RUST_VERSION = "1.46.0";
    CARGO_PKG_VERSION = "15.1.0";
    CARGO_PKG_VERSION_MAJOR = "15";
    CARGO_PKG_VERSION_MINOR = "1";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m im-rc-15_1_0-c80c253ce789d440"
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
        --crate-name im_rc \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("arbitrary", "debug", "pool", "proptest", "quickcheck", "rayon", "refpool", "serde"))' \
        -C metadata=317f930cf89b773b \
        -C extra-filename=-c80c253ce789d440 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern bitmaps=${bitmaps-2_1_0-51933aba5ef55341}/libbitmaps-51933aba5ef55341.rmeta \
        --extern rand_core=${rand_core-0_6_4-fe99bd26a150a053}/librand_core-fe99bd26a150a053.rmeta \
        --extern rand_xoshiro=${rand_xoshiro-0_6_0-f04981dd311ba238}/librand_xoshiro-f04981dd311ba238.rmeta \
        --extern sized_chunks=${sized-chunks-0_6_5-046f699445e99791}/libsized_chunks-046f699445e99791.rmeta \
        --extern typenum=${typenum-1_17_0-218683b74ca28981}/libtypenum-218683b74ca28981.rmeta \
        --cap-lints allow
      )
    '';
}
