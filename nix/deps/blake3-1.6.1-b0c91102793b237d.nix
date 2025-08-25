# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "blake3-1_6_1-b0c91102793b237d";
    meta.cargo_crate_info = {
      name = "blake3";
      version = "1.6.1";
      crate_hash = "b0c91102793b237d";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [arrayref-0_3_9-a83a2890b6f0ead7 arrayvec-0_7_6-5f3280febbd4aa59 cfg-if-1_0_0-f52ed1292e79c10c constant_time_eq-0_3_1-361d71284e43752f];
    passthru.rust_crate_parent = [blake3-1_6_1-script_build_run-3d8deedcb782e943];
    passthru.rust_script_build_run = [blake3-1_6_1-script_build_run-3d8deedcb782e943];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/blake3/1.6.1/download";
      sha256 = "675f87afced0413c9bb02843499dbbd3882a237645883f71a2b59644a6d2f753";
    };
    unpackPhase = ''
      tar xf $src
      cd blake3-1.6.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "blake3";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Jack O'Connor <oconnor663@gmail.com>:Samuel Neves";
    CARGO_PKG_DESCRIPTION = "the BLAKE3 hash function";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "CC0-1.0 OR Apache-2.0 OR Apache-2.0 WITH LLVM-exception";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "blake3";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/BLAKE3-team/BLAKE3";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "1.6.1";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "6";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m blake3-1_6_1-b0c91102793b237d"
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
        --crate-name blake3 \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --cfg 'feature="std"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "digest", "mmap", "neon", "no_avx2", "no_avx512", "no_neon", "no_sse2", "no_sse41", "prefer_intrinsics", "pure", "rayon", "serde", "std", "traits-preview", "zeroize"))' \
        -C metadata=dc3e3ec076a7be75 \
        -C extra-filename=-b0c91102793b237d \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern arrayref=${arrayref-0_3_9-a83a2890b6f0ead7}/libarrayref-a83a2890b6f0ead7.rmeta \
        --extern arrayvec=${arrayvec-0_7_6-5f3280febbd4aa59}/libarrayvec-5f3280febbd4aa59.rmeta \
        --extern cfg_if=${cfg-if-1_0_0-f52ed1292e79c10c}/libcfg_if-f52ed1292e79c10c.rmeta \
        --extern constant_time_eq=${constant_time_eq-0_3_1-361d71284e43752f}/libconstant_time_eq-361d71284e43752f.rmeta \
        --cap-lints allow
      )
    '';
}
