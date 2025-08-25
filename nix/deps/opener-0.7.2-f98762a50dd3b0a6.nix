# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "opener-0_7_2-f98762a50dd3b0a6";
    meta.cargo_crate_info = {
      name = "opener";
      version = "0.7.2";
      crate_hash = "f98762a50dd3b0a6";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [bstr-1_11_3-29be561fe10b8eeb];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/opener/0.7.2/download";
      sha256 = "d0812e5e4df08da354c851a3376fead46db31c2214f849d3de356d774d057681";
    };
    unpackPhase = ''
      tar xf $src
      cd opener-0.7.2
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "opener";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Brian Bowman <seeker14491@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Open a file or link using the system default program.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "opener";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/Seeker14491/opener";
    CARGO_PKG_RUST_VERSION = "";
    CARGO_PKG_VERSION = "0.7.2";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "7";
    CARGO_PKG_VERSION_PATCH = "2";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m opener-0_7_2-f98762a50dd3b0a6"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name opener \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="dbus-vendored"' \
        --cfg 'feature="default"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("dbus-vendored", "default", "reveal"))' \
        -C metadata=48d4bd55557886cc \
        -C extra-filename=-f98762a50dd3b0a6 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern bstr=${bstr-1_11_3-29be561fe10b8eeb}/libbstr-29be561fe10b8eeb.rmeta \
        --cap-lints allow
      )
    '';
}
