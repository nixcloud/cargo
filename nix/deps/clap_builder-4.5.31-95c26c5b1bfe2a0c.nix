# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "clap_builder-4_5_31-95c26c5b1bfe2a0c";
    meta.cargo_crate_info = {
      name = "clap_builder";
      version = "4.5.31";
      crate_hash = "95c26c5b1bfe2a0c";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [anstream-0_6_18-37605a02f0fac906 anstyle-1_0_10-894b0e78f8d7fc16 clap_lex-0_7_4-ad85b797eb91717f strsim-0_11_1-cd89ec10c58c8c9e terminal_size-0_4_1-912c14073d80036b];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/clap_builder/4.5.31/download";
      sha256 = "5589e0cba072e0f3d23791efac0fd8627b49c829c196a492e88168e6a669d863";
    };
    unpackPhase = ''
      tar xf $src
      cd clap_builder-4.5.31
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "clap_builder";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "A simple to use, efficient, and full-featured Command Line Argument Parser";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "clap_builder";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/clap-rs/clap";
    CARGO_PKG_RUST_VERSION = "1.74";
    CARGO_PKG_VERSION = "4.5.31";
    CARGO_PKG_VERSION_MAJOR = "4";
    CARGO_PKG_VERSION_MINOR = "5";
    CARGO_PKG_VERSION_PATCH = "31";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m clap_builder-4_5_31-95c26c5b1bfe2a0c"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name clap_builder \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
        --warn=rust_2018_idioms \
        --warn=clippy::zero_sized_map_values \
        --warn=clippy::verbose_file_reads \
        --warn=unused_qualifications \
        --warn=unused_macro_rules \
        --warn=unused_lifetimes \
        --warn=unsafe_op_in_unsafe_fn \
        --warn=unreachable_pub \
        --warn=clippy::uninlined_format_args \
        --warn=clippy::trait_duplication_in_bounds \
        --warn=clippy::todo \
        --warn=clippy::string_lit_as_bytes \
        --warn=clippy::string_add_assign \
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
        --allow=clippy::multiple_bound_locations \
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
        --allow=clippy::blocks_in_conditions \
        --allow=clippy::assigning_clones \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="color"' \
        --cfg 'feature="error-context"' \
        --cfg 'feature="help"' \
        --cfg 'feature="std"' \
        --cfg 'feature="suggestions"' \
        --cfg 'feature="unstable-ext"' \
        --cfg 'feature="usage"' \
        --cfg 'feature="wrap_help"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("cargo", "color", "debug", "default", "deprecated", "env", "error-context", "help", "std", "string", "suggestions", "unicode", "unstable-doc", "unstable-ext", "unstable-styles", "unstable-v5", "usage", "wrap_help"))' \
        -C metadata=5543bdc7a96892e8 \
        -C extra-filename=-95c26c5b1bfe2a0c \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern anstream=${anstream-0_6_18-37605a02f0fac906}/libanstream-37605a02f0fac906.rmeta \
        --extern anstyle=${anstyle-1_0_10-894b0e78f8d7fc16}/libanstyle-894b0e78f8d7fc16.rmeta \
        --extern clap_lex=${clap_lex-0_7_4-ad85b797eb91717f}/libclap_lex-ad85b797eb91717f.rmeta \
        --extern strsim=${strsim-0_11_1-cd89ec10c58c8c9e}/libstrsim-cd89ec10c58c8c9e.rmeta \
        --extern terminal_size=${terminal_size-0_4_1-912c14073d80036b}/libterminal_size-912c14073d80036b.rmeta \
        --cap-lints allow
      )
    '';
}
