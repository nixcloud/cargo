# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "clap_complete-4_5_46-5f1dfb943e043129";
    meta.cargo_crate_info = {
      name = "clap_complete";
      version = "4.5.46";
      crate_hash = "5f1dfb943e043129";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [clap-4_5_31-a895b6c8d0e21ec4 clap_lex-0_7_4-ad85b797eb91717f is_executable-1_0_4-99d2b134784a31f2 shlex-1_3_0-2bc6e0a0e5c36322];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/clap_complete/4.5.46/download";
      sha256 = "f5c5508ea23c5366f77e53f5a0070e5a84e51687ec3ef9e0464c86dc8d13ce98";
    };
    unpackPhase = ''
      tar xf $src
      cd clap_complete-4.5.46
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "clap_complete";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Generate shell completion scripts for your clap::Command";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "clap_complete";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/clap-rs/clap";
    CARGO_PKG_RUST_VERSION = "1.74";
    CARGO_PKG_VERSION = "4.5.46";
    CARGO_PKG_VERSION_MAJOR = "4";
    CARGO_PKG_VERSION_MINOR = "5";
    CARGO_PKG_VERSION_PATCH = "46";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m clap_complete-4_5_46-5f1dfb943e043129"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name clap_complete \
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
        --cfg 'feature="default"' \
        --cfg 'feature="unstable-dynamic"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("debug", "default", "unstable-doc", "unstable-dynamic", "unstable-shell-tests"))' \
        -C metadata=8a5e4f5a7fcc8531 \
        -C extra-filename=-5f1dfb943e043129 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern clap=${clap-4_5_31-a895b6c8d0e21ec4}/libclap-a895b6c8d0e21ec4.rmeta \
        --extern clap_lex=${clap_lex-0_7_4-ad85b797eb91717f}/libclap_lex-ad85b797eb91717f.rmeta \
        --extern is_executable=${is_executable-1_0_4-99d2b134784a31f2}/libis_executable-99d2b134784a31f2.rmeta \
        --extern shlex=${shlex-1_3_0-2bc6e0a0e5c36322}/libshlex-2bc6e0a0e5c36322.rmeta \
        --cap-lints allow
      )
    '';
}
