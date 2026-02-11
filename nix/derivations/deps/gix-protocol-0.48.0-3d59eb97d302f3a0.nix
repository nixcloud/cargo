# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-protocol-0_48_0-3d59eb97d302f3a0";
    meta.cargo_crate_info = {
      name = "gix-protocol";
      version = "0.48.0";
      crate_hash = "3d59eb97d302f3a0";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [bstr-1_11_3-14003bcd5b7b8103 gix-credentials-0_27_0-48aff77da2287bad gix-date-0_9_3-ef3873a712c7b7c9 gix-features-0_40_0-7b4fa941d491da9c gix-hash-0_16_0-2dd06b7faad8300b gix-lock-16_0_0-c0e4d3d42bd1d641 gix-negotiate-0_18_0-3bc90a63e768c830 gix-object-0_47_0-1feb494be43bf821 gix-ref-0_50_0-9c43a6c2d25dc4c1 gix-refspec-0_28_0-e29e1a847ad4941f gix-revwalk-0_18_0-58438d094712a949 gix-shallow-0_2_0-17cceba6b74ec6c7 gix-trace-0_1_12-6fa342b8ee63f664 gix-transport-0_45_0-6a2f0d56c387db84 gix-utils-0_1_14-4da59f2b8afebe0a maybe-async-0_2_10-3a2823bcacaa3374 thiserror-2_0_11-a57592ffa4ea41e0 winnow-0_6_26-83cf2fecf0abf70e];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/gix-protocol/0.48.0/download";
      sha256 = "6c61bd61afc6b67d213241e2100394c164be421e3f7228d3521b04f48ca5ba90";
    };
    unpackPhase = ''
      tar xf $src
      cd gix-protocol-0.48.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "gix_protocol";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Sebastian Thiel <sebastian.thiel@icloud.com>";
    CARGO_PKG_DESCRIPTION = "A crate of the gitoxide project for implementing git protocols";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "gix-protocol";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/GitoxideLabs/gitoxide";
    CARGO_PKG_RUST_VERSION = "1.70";
    CARGO_PKG_VERSION = "0.48.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "48";
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
              --crate-name gix_protocol \
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
              --cfg 'feature="blocking-client"' \
              --cfg 'feature="fetch"' \
              --cfg 'feature="handshake"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("async-client", "blocking-client", "document-features", "fetch", "handshake", "serde"))' \
              -C metadata=eb0cc38c18bef080 \
              -C extra-filename=-3d59eb97d302f3a0 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern bstr=${bstr-1_11_3-14003bcd5b7b8103}/libbstr-14003bcd5b7b8103.rmeta \
              --extern gix_credentials=${gix-credentials-0_27_0-48aff77da2287bad}/libgix_credentials-48aff77da2287bad.rmeta \
              --extern gix_date=${gix-date-0_9_3-ef3873a712c7b7c9}/libgix_date-ef3873a712c7b7c9.rmeta \
              --extern gix_features=${gix-features-0_40_0-7b4fa941d491da9c}/libgix_features-7b4fa941d491da9c.rmeta \
              --extern gix_hash=${gix-hash-0_16_0-2dd06b7faad8300b}/libgix_hash-2dd06b7faad8300b.rmeta \
              --extern gix_lock=${gix-lock-16_0_0-c0e4d3d42bd1d641}/libgix_lock-c0e4d3d42bd1d641.rmeta \
              --extern gix_negotiate=${gix-negotiate-0_18_0-3bc90a63e768c830}/libgix_negotiate-3bc90a63e768c830.rmeta \
              --extern gix_object=${gix-object-0_47_0-1feb494be43bf821}/libgix_object-1feb494be43bf821.rmeta \
              --extern gix_ref=${gix-ref-0_50_0-9c43a6c2d25dc4c1}/libgix_ref-9c43a6c2d25dc4c1.rmeta \
              --extern gix_refspec=${gix-refspec-0_28_0-e29e1a847ad4941f}/libgix_refspec-e29e1a847ad4941f.rmeta \
              --extern gix_revwalk=${gix-revwalk-0_18_0-58438d094712a949}/libgix_revwalk-58438d094712a949.rmeta \
              --extern gix_shallow=${gix-shallow-0_2_0-17cceba6b74ec6c7}/libgix_shallow-17cceba6b74ec6c7.rmeta \
              --extern gix_trace=${gix-trace-0_1_12-6fa342b8ee63f664}/libgix_trace-6fa342b8ee63f664.rmeta \
              --extern gix_transport=${gix-transport-0_45_0-6a2f0d56c387db84}/libgix_transport-6a2f0d56c387db84.rmeta \
              --extern gix_utils=${gix-utils-0_1_14-4da59f2b8afebe0a}/libgix_utils-4da59f2b8afebe0a.rmeta \
              --extern maybe_async=${maybe-async-0_2_10-3a2823bcacaa3374}/libmaybe_async-3a2823bcacaa3374.so \
              --extern thiserror=${thiserror-2_0_11-a57592ffa4ea41e0}/libthiserror-a57592ffa4ea41e0.rmeta \
              --extern winnow=${winnow-0_6_26-83cf2fecf0abf70e}/libwinnow-83cf2fecf0abf70e.rmeta \
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
