# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "colorchoice-1_0_3-9667677c83bfc624";
    meta.cargo_crate_info = {
      name = "colorchoice";
      version = "1.0.3";
      crate_hash = "9667677c83bfc624";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/colorchoice/1.0.3/download";
      sha256 = "5b63caa9aa9397e2d9480a9b13673856c78d8ac123288526c37d7839f2a86990";
    };

    unpackPhase = ''
      tar xf $src
      cd colorchoice-1.0.3
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "colorchoice";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Global override of color control";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "colorchoice";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-cli/anstyle.git";
    CARGO_PKG_RUST_VERSION = "1.66.0";
    CARGO_PKG_VERSION = "1.0.3";
    CARGO_PKG_VERSION_MAJOR = "1";
    CARGO_PKG_VERSION_MINOR = "0";
    CARGO_PKG_VERSION_PATCH = "3";
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
              --crate-name colorchoice \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
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
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values())' \
              -C metadata=b897840df5c1b2bf \
              -C extra-filename=-9667677c83bfc624 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
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
