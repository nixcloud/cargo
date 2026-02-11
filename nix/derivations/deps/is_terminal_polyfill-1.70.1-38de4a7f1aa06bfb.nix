# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "is_terminal_polyfill-1_70_1-38de4a7f1aa06bfb";
    meta.cargo_crate_info = {
      name = "is_terminal_polyfill";
      version = "1.70.1";
      crate_hash = "38de4a7f1aa06bfb";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/is_terminal_polyfill/1.70.1/download";
      sha256 = "7943c866cc5cd64cbc25b2e01621d07fa8eb2a1a23160ee81ce38704e97b8ecf";
    };
    unpackPhase = ''
      tar xf $src
      cd is_terminal_polyfill-1.70.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "is_terminal_polyfill";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Polyfill for `is_terminal` stdlib feature for use with older MSRVs";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "is_terminal_polyfill";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/polyfill-rs/is_terminal_polyfill";
    CARGO_PKG_RUST_VERSION = "1.70.0";
    CARGO_PKG_VERSION = "1.70.1";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "70";
    CARGO_PKG_VERSION_PATCH = "1";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      ${fn.import_bash_function_helpers}
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)
      
      mkdir -p $out/nix
      export OUT_DIR=$out

      print_compiling_message "${name}"
      print_cargo_message_type_0 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name is_terminal_polyfill \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --warn=clippy::zero_sized_map_values \
              --warn=clippy::wildcard_imports \
              --warn=clippy::verbose_file_reads \
              --warn=unused_qualifications \
              --warn=unused_macro_rules \
              --warn=unused_lifetimes \
              --warn=unsafe_op_in_unsafe_fn \
              --warn=unreachable_pub \
              --warn=clippy::trait_duplication_in_bounds \
              --warn=clippy::todo \
              --warn=clippy::string_to_string \
              --warn=clippy::string_lit_as_bytes \
              --warn=clippy::string_add_assign \
              --warn=clippy::string_add \
              --warn=clippy::str_to_string \
              --warn=clippy::single_match_else \
              --warn=clippy::semicolon_if_nothing_returned \
              --warn=clippy::self_named_module_files \
              --warn=clippy::same_functions_in_if_condition \
              --warn=rust_2018_idioms \
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
              --warn=clippy::match_wildcard_for_single_variants \
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
              --check-cfg 'cfg(feature, values("default"))' \
              -C metadata=0f2e2d30dc54563e \
              -C extra-filename=-38de4a7f1aa06bfb \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
