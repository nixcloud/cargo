# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "pin-project-lite-0_2_16-12250a02a17ca230";
    meta.cargo_crate_info = {
      name = "pin-project-lite";
      version = "0.2.16";
      crate_hash = "12250a02a17ca230";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/pin-project-lite/0.2.16/download";
      sha256 = "3b3cff922bd51709b605d9ead9aa71031d81447142d828eb4a6eba76fe619f9b";
    };
    unpackPhase = ''
      tar xf $src
      cd pin-project-lite-0.2.16
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "pin_project_lite";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "A lightweight version of pin-project written with declarative macros.
";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "pin-project-lite";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/taiki-e/pin-project-lite";
    CARGO_PKG_RUST_VERSION = "1.37";
    CARGO_PKG_VERSION = "0.2.16";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "2";
    CARGO_PKG_VERSION_PATCH = "16";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m pin-project-lite-0_2_16-12250a02a17ca230"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name pin_project_lite \
        --edition=2018 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        --warn=unreachable_pub \
        --warn=unexpected_cfgs \
        --warn=clippy::undocumented_unsafe_blocks \
        --warn=clippy::transmute_undefined_repr \
        --warn=clippy::trailing_empty_array \
        --warn=single_use_lifetimes \
        --warn=rust_2018_idioms \
        --warn=clippy::pedantic \
        --warn=non_ascii_idents \
        --warn=clippy::inline_asm_x86_att_syntax \
        --warn=improper_ctypes_definitions \
        --warn=improper_ctypes \
        --warn=deprecated_safe \
        --warn=clippy::default_union_representation \
        --warn=clippy::as_underscore \
        --warn=clippy::as_ptr_cast_mut \
        --warn=clippy::all \
        --allow=clippy::unreadable_literal \
        --allow=clippy::type_complexity \
        --allow=clippy::too_many_lines \
        --allow=clippy::too_many_arguments \
        --allow=clippy::struct_field_names \
        --allow=clippy::struct_excessive_bools \
        --allow=clippy::single_match_else \
        --allow=clippy::single_match \
        --allow=clippy::similar_names \
        --allow=clippy::range_plus_one \
        --allow=clippy::nonminimal_bool \
        --allow=clippy::naive_bytecount \
        --allow=clippy::module_name_repetitions \
        --allow=clippy::missing_errors_doc \
        --allow=clippy::manual_range_contains \
        --allow=clippy::manual_assert \
        --allow=clippy::lint_groups_priority \
        --allow=clippy::incompatible_msrv \
        --allow=clippy::float_cmp \
        --allow=clippy::doc_markdown \
        --allow=clippy::declare_interior_mutable_const \
        --allow=clippy::cast_lossless \
        --allow=clippy::borrow_as_ptr \
        --allow=clippy::bool_assert_comparison \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values())' \
        -C metadata=993972bacc6798ae \
        -C extra-filename=-12250a02a17ca230 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      )
    '';
}
