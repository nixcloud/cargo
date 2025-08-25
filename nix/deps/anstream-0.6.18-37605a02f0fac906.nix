# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "anstream-0_6_18-37605a02f0fac906";
    meta.cargo_crate_info = {
      name = "anstream";
      version = "0.6.18";
      crate_hash = "37605a02f0fac906";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [anstyle-1_0_10-894b0e78f8d7fc16 anstyle-parse-0_2_6-4881a1eda670a37e anstyle-query-1_1_2-5f4bd87459b20ad6 colorchoice-1_0_3-ba17308800d88ed6 is_terminal_polyfill-1_70_1-0ec8cf20a8fd5a04 utf8parse-0_2_2-ed0f948dddfa5152];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/anstream/0.6.18/download";
      sha256 = "8acc5369981196006228e28809f761875c0327210a891e941f4c683b3a99529b";
    };
    unpackPhase = ''
      tar xf $src
      cd anstream-0.6.18
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "anstream";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "A simple cross platform library for writing colored text to a terminal.";
    CARGO_PKG_HOMEPAGE = "https://github.com/rust-cli/anstyle";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "anstream";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-cli/anstyle.git";
    CARGO_PKG_RUST_VERSION = "1.66.0";
    CARGO_PKG_VERSION = "0.6.18";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "6";
    CARGO_PKG_VERSION_PATCH = "18";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m anstream-0_6_18-37605a02f0fac906"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name anstream \
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
        --cfg 'feature="auto"' \
        --cfg 'feature="default"' \
        --cfg 'feature="wincon"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("auto", "default", "test", "wincon"))' \
        -C metadata=c919dd1102c06a19 \
        -C extra-filename=-37605a02f0fac906 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern anstyle=${anstyle-1_0_10-894b0e78f8d7fc16}/libanstyle-894b0e78f8d7fc16.rmeta \
        --extern anstyle_parse=${anstyle-parse-0_2_6-4881a1eda670a37e}/libanstyle_parse-4881a1eda670a37e.rmeta \
        --extern anstyle_query=${anstyle-query-1_1_2-5f4bd87459b20ad6}/libanstyle_query-5f4bd87459b20ad6.rmeta \
        --extern colorchoice=${colorchoice-1_0_3-ba17308800d88ed6}/libcolorchoice-ba17308800d88ed6.rmeta \
        --extern is_terminal_polyfill=${is_terminal_polyfill-1_70_1-0ec8cf20a8fd5a04}/libis_terminal_polyfill-0ec8cf20a8fd5a04.rmeta \
        --extern utf8parse=${utf8parse-0_2_2-ed0f948dddfa5152}/libutf8parse-ed0f948dddfa5152.rmeta \
        --cap-lints allow
      )
    '';
}
