# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-filter-0_17_0-c80d6bb81ef5aa53";
    meta.cargo_crate_info = {
      name = "gix-filter";
      version = "0.17.0";
      crate_hash = "c80d6bb81ef5aa53";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [bstr-1_11_3-29be561fe10b8eeb encoding_rs-0_8_35-7a2b03048b6d91ec gix-attributes-0_24_0-839dd8a3503d8e44 gix-command-0_4_1-d7db7f609223402c gix-hash-0_16_0-c47a8c0103fbbf5d gix-object-0_47_0-d62e7b541181e72a gix-packetline-blocking-0_18_2-468024ca91f06cff gix-path-0_10_14-2414f38f73019524 gix-quote-0_4_15-052d0b90d2515f5d gix-trace-0_1_12-e7c79603b3e36d61 gix-utils-0_1_14-286091b3d3e35677 smallvec-1_13_2-453c588ad74a5894 thiserror-2_0_11-266d93aab4cee78a];
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
    CARGO = "${rustc}/bin/rustc";

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
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m gix-filter-0_17_0-c80d6bb81ef5aa53"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name gix_filter \
        --edition=2021 src/lib.rs \
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
        -C metadata=2c0e6d6d54bb31dd \
        -C extra-filename=-c80d6bb81ef5aa53 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern bstr=${bstr-1_11_3-29be561fe10b8eeb}/libbstr-29be561fe10b8eeb.rmeta \
        --extern encoding_rs=${encoding_rs-0_8_35-7a2b03048b6d91ec}/libencoding_rs-7a2b03048b6d91ec.rmeta \
        --extern gix_attributes=${gix-attributes-0_24_0-839dd8a3503d8e44}/libgix_attributes-839dd8a3503d8e44.rmeta \
        --extern gix_command=${gix-command-0_4_1-d7db7f609223402c}/libgix_command-d7db7f609223402c.rmeta \
        --extern gix_hash=${gix-hash-0_16_0-c47a8c0103fbbf5d}/libgix_hash-c47a8c0103fbbf5d.rmeta \
        --extern gix_object=${gix-object-0_47_0-d62e7b541181e72a}/libgix_object-d62e7b541181e72a.rmeta \
        --extern gix_packetline=${gix-packetline-blocking-0_18_2-468024ca91f06cff}/libgix_packetline_blocking-468024ca91f06cff.rmeta \
        --extern gix_path=${gix-path-0_10_14-2414f38f73019524}/libgix_path-2414f38f73019524.rmeta \
        --extern gix_quote=${gix-quote-0_4_15-052d0b90d2515f5d}/libgix_quote-052d0b90d2515f5d.rmeta \
        --extern gix_trace=${gix-trace-0_1_12-e7c79603b3e36d61}/libgix_trace-e7c79603b3e36d61.rmeta \
        --extern gix_utils=${gix-utils-0_1_14-286091b3d3e35677}/libgix_utils-286091b3d3e35677.rmeta \
        --extern smallvec=${smallvec-1_13_2-453c588ad74a5894}/libsmallvec-453c588ad74a5894.rmeta \
        --extern thiserror=${thiserror-2_0_11-266d93aab4cee78a}/libthiserror-266d93aab4cee78a.rmeta \
        --cap-lints allow
      )
    '';
}
