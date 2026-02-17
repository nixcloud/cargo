# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "toml_edit-0_22_24-24142c1671b8cfdf";
    meta.cargo_crate_info = {
      name = "toml_edit";
      version = "0.22.24";
      crate_hash = "24142c1671b8cfdf";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [indexmap-2_7_1-dcbfc0f8f5b442a0 serde-1_0_218-472e28b9f131b02c serde_spanned-0_6_8-b8b72c3377341dbf toml_datetime-0_6_8-c22a379486cde223 winnow-0_7_1-a5873bca62debc35];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/toml_edit/0.22.24/download";
      sha256 = "17b4795ff5edd201c7cd6dca065ae59972ce77d1b80fa0a84d94950ece7d1474";
    };
    unpackPhase = ''
      tar xf $src
      cd toml_edit-0.22.24
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "toml_edit";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Andronik Ordian <write@reusable.software>:Ed Page <eopage@gmail.com>";
    CARGO_PKG_DESCRIPTION = "Yet another format-preserving TOML parser.";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "toml_edit";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/toml-rs/toml";
    CARGO_PKG_RUST_VERSION = "1.65";
    CARGO_PKG_VERSION = "0.22.24";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "22";
    CARGO_PKG_VERSION_PATCH = "24";
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
              --crate-name toml_edit \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
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
              --cfg 'feature="display"' \
              --cfg 'feature="parse"' \
              --cfg 'feature="serde"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "display", "parse", "perf", "serde", "unbounded"))' \
              -C metadata=e2b4297c098ff199 \
              -C extra-filename=-24142c1671b8cfdf \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern indexmap=${indexmap-2_7_1-dcbfc0f8f5b442a0}/libindexmap-dcbfc0f8f5b442a0.rmeta \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
              --extern serde_spanned=${serde_spanned-0_6_8-b8b72c3377341dbf}/libserde_spanned-b8b72c3377341dbf.rmeta \
              --extern toml_datetime=${toml_datetime-0_6_8-c22a379486cde223}/libtoml_datetime-c22a379486cde223.rmeta \
              --extern winnow=${winnow-0_7_1-a5873bca62debc35}/libwinnow-a5873bca62debc35.rmeta \
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
