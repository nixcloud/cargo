# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-filter-0_17_0-e2f5328c169aa835";
    meta.cargo_crate_info = {
      name = "gix-filter";
      version = "0.17.0";
      crate_hash = "e2f5328c169aa835";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [bstr-1_11_3-14003bcd5b7b8103 encoding_rs-0_8_35-92f62b88e615318e gix-attributes-0_24_0-b71cf5283dcbf9ad gix-command-0_4_1-e29484d4d4e346e8 gix-hash-0_16_0-2dd06b7faad8300b gix-object-0_47_0-1feb494be43bf821 gix-packetline-blocking-0_18_2-638c01d5b51657b1 gix-path-0_10_14-6bb928c9998da5a8 gix-quote-0_4_15-8a0f189e1c6e7301 gix-trace-0_1_12-6fa342b8ee63f664 gix-utils-0_1_14-4da59f2b8afebe0a smallvec-1_13_2-e5874423828ed52b thiserror-2_0_11-a57592ffa4ea41e0];
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
              -C embed-bitcode=no \
              -C debuginfo=2 \
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
              -C metadata=705a0bd84620e109 \
              -C extra-filename=-e2f5328c169aa835 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern bstr=${bstr-1_11_3-14003bcd5b7b8103}/libbstr-14003bcd5b7b8103.rmeta \
              --extern encoding_rs=${encoding_rs-0_8_35-92f62b88e615318e}/libencoding_rs-92f62b88e615318e.rmeta \
              --extern gix_attributes=${gix-attributes-0_24_0-b71cf5283dcbf9ad}/libgix_attributes-b71cf5283dcbf9ad.rmeta \
              --extern gix_command=${gix-command-0_4_1-e29484d4d4e346e8}/libgix_command-e29484d4d4e346e8.rmeta \
              --extern gix_hash=${gix-hash-0_16_0-2dd06b7faad8300b}/libgix_hash-2dd06b7faad8300b.rmeta \
              --extern gix_object=${gix-object-0_47_0-1feb494be43bf821}/libgix_object-1feb494be43bf821.rmeta \
              --extern gix_packetline=${gix-packetline-blocking-0_18_2-638c01d5b51657b1}/libgix_packetline_blocking-638c01d5b51657b1.rmeta \
              --extern gix_path=${gix-path-0_10_14-6bb928c9998da5a8}/libgix_path-6bb928c9998da5a8.rmeta \
              --extern gix_quote=${gix-quote-0_4_15-8a0f189e1c6e7301}/libgix_quote-8a0f189e1c6e7301.rmeta \
              --extern gix_trace=${gix-trace-0_1_12-6fa342b8ee63f664}/libgix_trace-6fa342b8ee63f664.rmeta \
              --extern gix_utils=${gix-utils-0_1_14-4da59f2b8afebe0a}/libgix_utils-4da59f2b8afebe0a.rmeta \
              --extern smallvec=${smallvec-1_13_2-e5874423828ed52b}/libsmallvec-e5874423828ed52b.rmeta \
              --extern thiserror=${thiserror-2_0_11-a57592ffa4ea41e0}/libthiserror-a57592ffa4ea41e0.rmeta \
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
