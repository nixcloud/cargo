# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "annotate-snippets-0_11_5-a7212a9a74faaa3f";
    meta.cargo_crate_info = {
      name = "annotate-snippets";
      version = "0.11.5";
      crate_hash = "a7212a9a74faaa3f";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [anstyle-1_0_10-894b0e78f8d7fc16 unicode-width-0_2_0-26c2c85f3e92cc69];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/annotate-snippets/0.11.5/download";
      sha256 = "710e8eae58854cdc1790fcb56cca04d712a17be849eeb81da2a724bf4bae2bc4";
    };
    unpackPhase = ''
      tar xf $src
      cd annotate-snippets-0.11.5
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "annotate_snippets";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Library for building code annotations";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "annotate-snippets";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/annotate-snippets-rs";
    CARGO_PKG_RUST_VERSION = "1.66.0";
    CARGO_PKG_VERSION = "0.11.5";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "11";
    CARGO_PKG_VERSION_PATCH = "5";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m annotate-snippets-0_11_5-a7212a9a74faaa3f"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name annotate_snippets \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        --warn=rust_2018_idioms \
        --warn=clippy::zero_sized_map_values \
        --warn=clippy::wildcard_imports \
        --warn=clippy::verbose_file_reads \
        --warn=unused_qualifications \
        --warn=unused_macro_rules \
        --warn=unused_lifetimes \
        --warn=unsafe_op_in_unsafe_fn \
        --warn=unreachable_pub \
        --warn=clippy::uninlined_format_args \
        --warn=clippy::trait_duplication_in_bounds \
        --warn=clippy::todo \
        --warn=clippy::string_to_string \
        --warn=clippy::string_lit_as_bytes \
        --warn=clippy::string_add_assign \
        --warn=clippy::string_add \
        --warn=clippy::str_to_string \
        --warn=clippy::semicolon_if_nothing_returned \
        --warn=clippy::self_named_module_files \
        --warn=clippy::same_functions_in_if_condition \
        --allow=clippy::result_large_err \
        --warn=clippy::rest_pat_in_fully_bound_structs \
        --warn=clippy::ref_option_ref \
        --warn=clippy::redundant_feature_names \
        --warn=clippy::rc_mutex \
        --warn=clippy::ptr_as_ptr \
        --warn=clippy::path_buf_push_overwrite \
        --warn=clippy::negative_feature_names \
        --warn=clippy::needless_for_each \
        --warn=clippy::needless_continue \
        --warn=clippy::mutex_integer \
        --warn=clippy::mem_forget \
        --warn=clippy::macro_use_imports \
        --warn=clippy::lossy_float_literal \
        --warn=clippy::linkedlist \
        --allow=clippy::let_and_return \
        --warn=clippy::large_types_passed_by_value \
        --warn=clippy::large_stack_arrays \
        --warn=clippy::large_digit_groups \
        --warn=clippy::invalid_upcast_comparisons \
        --warn=clippy::infinite_loop \
        --warn=clippy::inefficient_to_string \
        --warn=clippy::inconsistent_struct_constructor \
        --warn=clippy::imprecise_flops \
        --warn=clippy::implicit_clone \
        --allow=clippy::if_same_then_else \
        --warn=clippy::from_iter_instead_of_collect \
        --warn=clippy::fn_params_excessive_bools \
        --warn=clippy::float_cmp_const \
        --warn=clippy::flat_map_option \
        --warn=clippy::filter_map_next \
        --warn=clippy::fallible_impl_from \
        --warn=clippy::explicit_into_iter_loop \
        --warn=clippy::explicit_deref_methods \
        --warn=clippy::expl_impl_clone_on_copy \
        --warn=clippy::enum_glob_use \
        --warn=clippy::empty_enum \
        --warn=clippy::doc_markdown \
        --warn=clippy::debug_assert_with_mut_call \
        --warn=clippy::dbg_macro \
        --warn=clippy::create_dir \
        --allow=clippy::collapsible_else_if \
        --warn=clippy::checked_conversions \
        --allow=clippy::branches_sharing_code \
        --allow=clippy::bool_assert_comparison \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="default"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("default", "memchr", "simd", "testing-colors"))' \
        -C metadata=00e9f9a9d7ead317 \
        -C extra-filename=-a7212a9a74faaa3f \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern anstyle=${anstyle-1_0_10-894b0e78f8d7fc16}/libanstyle-894b0e78f8d7fc16.rmeta \
        --extern unicode_width=${unicode-width-0_2_0-26c2c85f3e92cc69}/libunicode_width-26c2c85f3e92cc69.rmeta \
        --cap-lints allow
      )
    '';
}
