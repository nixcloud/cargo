# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-protocol-0_48_0-9fa92f0b281ee0e2";
    meta.cargo_crate_info = {
      name = "gix-protocol";
      version = "0.48.0";
      crate_hash = "9fa92f0b281ee0e2";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [bstr-1_11_3-29be561fe10b8eeb gix-credentials-0_27_0-9f10d05e8cae30a6 gix-date-0_9_3-96d774acc5665b01 gix-features-0_40_0-28fa590012f22da9 gix-hash-0_16_0-c47a8c0103fbbf5d gix-lock-16_0_0-a67cc35e3a71cede gix-negotiate-0_18_0-62875ad27fc869c7 gix-object-0_47_0-d62e7b541181e72a gix-ref-0_50_0-757b0625f98d7554 gix-refspec-0_28_0-e1911f8b47334f93 gix-revwalk-0_18_0-2b6b72b2592b7eff gix-shallow-0_2_0-b72e00f79521cb69 gix-trace-0_1_12-e7c79603b3e36d61 gix-transport-0_45_0-afa9908215953e1e gix-utils-0_1_14-286091b3d3e35677 maybe-async-0_2_10-f37bc9f105f3b8fd thiserror-2_0_11-266d93aab4cee78a winnow-0_6_26-baf69e6936c03756];
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
    CARGO = "${rustc}/bin/rustc";

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
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m gix-protocol-0_48_0-9fa92f0b281ee0e2"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name gix_protocol \
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
        --cfg 'feature="blocking-client"' \
        --cfg 'feature="fetch"' \
        --cfg 'feature="handshake"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("async-client", "blocking-client", "document-features", "fetch", "handshake", "serde"))' \
        -C metadata=b9bd9920a0bba36f \
        -C extra-filename=-9fa92f0b281ee0e2 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern bstr=${bstr-1_11_3-29be561fe10b8eeb}/libbstr-29be561fe10b8eeb.rmeta \
        --extern gix_credentials=${gix-credentials-0_27_0-9f10d05e8cae30a6}/libgix_credentials-9f10d05e8cae30a6.rmeta \
        --extern gix_date=${gix-date-0_9_3-96d774acc5665b01}/libgix_date-96d774acc5665b01.rmeta \
        --extern gix_features=${gix-features-0_40_0-28fa590012f22da9}/libgix_features-28fa590012f22da9.rmeta \
        --extern gix_hash=${gix-hash-0_16_0-c47a8c0103fbbf5d}/libgix_hash-c47a8c0103fbbf5d.rmeta \
        --extern gix_lock=${gix-lock-16_0_0-a67cc35e3a71cede}/libgix_lock-a67cc35e3a71cede.rmeta \
        --extern gix_negotiate=${gix-negotiate-0_18_0-62875ad27fc869c7}/libgix_negotiate-62875ad27fc869c7.rmeta \
        --extern gix_object=${gix-object-0_47_0-d62e7b541181e72a}/libgix_object-d62e7b541181e72a.rmeta \
        --extern gix_ref=${gix-ref-0_50_0-757b0625f98d7554}/libgix_ref-757b0625f98d7554.rmeta \
        --extern gix_refspec=${gix-refspec-0_28_0-e1911f8b47334f93}/libgix_refspec-e1911f8b47334f93.rmeta \
        --extern gix_revwalk=${gix-revwalk-0_18_0-2b6b72b2592b7eff}/libgix_revwalk-2b6b72b2592b7eff.rmeta \
        --extern gix_shallow=${gix-shallow-0_2_0-b72e00f79521cb69}/libgix_shallow-b72e00f79521cb69.rmeta \
        --extern gix_trace=${gix-trace-0_1_12-e7c79603b3e36d61}/libgix_trace-e7c79603b3e36d61.rmeta \
        --extern gix_transport=${gix-transport-0_45_0-afa9908215953e1e}/libgix_transport-afa9908215953e1e.rmeta \
        --extern gix_utils=${gix-utils-0_1_14-286091b3d3e35677}/libgix_utils-286091b3d3e35677.rmeta \
        --extern maybe_async=${maybe-async-0_2_10-f37bc9f105f3b8fd}/libmaybe_async-f37bc9f105f3b8fd.so \
        --extern thiserror=${thiserror-2_0_11-266d93aab4cee78a}/libthiserror-266d93aab4cee78a.rmeta \
        --extern winnow=${winnow-0_6_26-baf69e6936c03756}/libwinnow-baf69e6936c03756.rmeta \
        --cap-lints allow
      )
    '';
}
