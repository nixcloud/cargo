# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-filter-0_17_0-47e02cbbb6050e2a";
    meta.cargo_crate_info = {
      name = "gix-filter";
      version = "0.17.0";
      crate_hash = "47e02cbbb6050e2a";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [bstr-1_11_3-46100c463ffaaa37 encoding_rs-0_8_35-f759af49395e7c1b gix-attributes-0_24_0-64ee21b308ccf8d6 gix-command-0_4_1-74abf2bf82b71c94 gix-hash-0_16_0-d473f2b9165b7ac8 gix-object-0_47_0-d81adbd40609c58b gix-packetline-blocking-0_18_2-2d4b2659c8d16ebe gix-path-0_10_14-fac4f7c597a0c8bd gix-quote-0_4_15-761e55887e5c1d17 gix-trace-0_1_12-718f68523d5ac749 gix-utils-0_1_14-1374b61d28fc65a7 smallvec-1_13_2-0ef9b24879be6fdc thiserror-2_0_11-c6c4ee382aacde15];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/gix-filter/0.17.0/download";
      sha256 = "bdcc36cd7dbc63ed0ec3558645886553d1afd3cd09daa5efb9cba9cceb942bbb";
    };

    unpackPhase = ''
      tar xf $src
      cd gix-filter-0.17.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "gix_filter";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Sebastian Thiel <sebastian.thiel@icloud.com>";
    CARGO_PKG_DESCRIPTION = "A crate of the gitoxide project implementing git filters";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "gix-filter";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/GitoxideLabs/gitoxide";
    CARGO_PKG_RUST_VERSION = "1.70";
    CARGO_PKG_VERSION = "0.17.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "17";
    CARGO_PKG_VERSION_PATCH = "0";
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
              --crate-name gix_filter \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              --warn=clippy::pedantic \
              --allow=clippy::wildcard_imports \
              --allow=clippy::used_underscore_binding \
              --allow=clippy::unused_self \
              --allow=clippy::unreadable_literal \
              --allow=clippy::unnecessary_wraps \
              --allow=clippy::unnecessary_join \
              --allow=clippy::trivially_copy_pass_by_ref \
              --allow=clippy::transmute_ptr_to_ptr \
              --allow=clippy::too_many_lines \
              --allow=clippy::too_long_first_doc_paragraph \
              --allow=clippy::struct_field_names \
              --allow=clippy::struct_excessive_bools \
              --allow=clippy::stable_sort_primitive \
              --allow=clippy::single_match_else \
              --allow=clippy::similar_names \
              --allow=clippy::should_panic_without_expect \
              --allow=clippy::return_self_not_must_use \
              --allow=clippy::redundant_else \
              --allow=clippy::range_plus_one \
              --allow=clippy::option_option \
              --allow=clippy::no_effect_underscore_binding \
              --allow=clippy::needless_raw_string_hashes \
              --allow=clippy::needless_pass_by_value \
              --allow=clippy::needless_for_each \
              --allow=clippy::naive_bytecount \
              --allow=clippy::mut_mut \
              --allow=clippy::must_use_candidate \
              --allow=clippy::module_name_repetitions \
              --allow=clippy::missing_panics_doc \
              --allow=clippy::missing_errors_doc \
              --allow=clippy::match_wildcard_for_single_variants \
              --allow=clippy::match_wild_err_arm \
              --allow=clippy::match_same_arms \
              --allow=clippy::match_bool \
              --allow=clippy::many_single_char_names \
              --allow=clippy::manual_string_new \
              --allow=clippy::manual_let_else \
              --allow=clippy::manual_is_variant_and \
              --allow=clippy::manual_assert \
              --allow=clippy::large_stack_arrays \
              --allow=clippy::iter_without_into_iter \
              --allow=clippy::iter_not_returning_iterator \
              --allow=clippy::items_after_statements \
              --allow=clippy::inline_always \
              --allow=clippy::inefficient_to_string \
              --allow=clippy::inconsistent_struct_constructor \
              --allow=clippy::implicit_clone \
              --allow=clippy::ignored_unit_patterns \
              --allow=clippy::if_not_else \
              --allow=clippy::from_iter_instead_of_collect \
              --allow=clippy::fn_params_excessive_bools \
              --allow=clippy::filter_map_next \
              --allow=clippy::explicit_iter_loop \
              --allow=clippy::explicit_into_iter_loop \
              --allow=clippy::explicit_deref_methods \
              --allow=clippy::enum_glob_use \
              --allow=clippy::empty_docs \
              --allow=clippy::doc_markdown \
              --allow=clippy::default_trait_access \
              --allow=clippy::copy_iterator \
              --allow=clippy::checked_conversions \
              --allow=clippy::cast_sign_loss \
              --allow=clippy::cast_precision_loss \
              --allow=clippy::cast_possible_wrap \
              --allow=clippy::cast_possible_truncation \
              --allow=clippy::cast_lossless \
              --allow=clippy::borrow_as_ptr \
              --allow=clippy::bool_to_int_with_if \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values())' \
              -C metadata=d2a84ea716b99e9c \
              -C extra-filename=-47e02cbbb6050e2a \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern bstr=${bstr-1_11_3-46100c463ffaaa37}/libbstr-46100c463ffaaa37.rmeta \
              --extern encoding_rs=${encoding_rs-0_8_35-f759af49395e7c1b}/libencoding_rs-f759af49395e7c1b.rmeta \
              --extern gix_attributes=${gix-attributes-0_24_0-64ee21b308ccf8d6}/libgix_attributes-64ee21b308ccf8d6.rmeta \
              --extern gix_command=${gix-command-0_4_1-74abf2bf82b71c94}/libgix_command-74abf2bf82b71c94.rmeta \
              --extern gix_hash=${gix-hash-0_16_0-d473f2b9165b7ac8}/libgix_hash-d473f2b9165b7ac8.rmeta \
              --extern gix_object=${gix-object-0_47_0-d81adbd40609c58b}/libgix_object-d81adbd40609c58b.rmeta \
              --extern gix_packetline=${gix-packetline-blocking-0_18_2-2d4b2659c8d16ebe}/libgix_packetline_blocking-2d4b2659c8d16ebe.rmeta \
              --extern gix_path=${gix-path-0_10_14-fac4f7c597a0c8bd}/libgix_path-fac4f7c597a0c8bd.rmeta \
              --extern gix_quote=${gix-quote-0_4_15-761e55887e5c1d17}/libgix_quote-761e55887e5c1d17.rmeta \
              --extern gix_trace=${gix-trace-0_1_12-718f68523d5ac749}/libgix_trace-718f68523d5ac749.rmeta \
              --extern gix_utils=${gix-utils-0_1_14-1374b61d28fc65a7}/libgix_utils-1374b61d28fc65a7.rmeta \
              --extern smallvec=${smallvec-1_13_2-0ef9b24879be6fdc}/libsmallvec-0ef9b24879be6fdc.rmeta \
              --extern thiserror=${thiserror-2_0_11-c6c4ee382aacde15}/libthiserror-c6c4ee382aacde15.rmeta \
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
