# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-0_70_0-833dfa597e0c3507";
    meta.cargo_crate_info = {
      name = "gix";
      version = "0.70.0";
      crate_hash = "833dfa597e0c3507";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [gix-actor-0_33_2-1bdbe24e757b6722 gix-attributes-0_24_0-839dd8a3503d8e44 gix-command-0_4_1-d7db7f609223402c gix-commitgraph-0_26_0-e8ba9bafb35a5a77 gix-config-0_43_0-88776c32f6471efa gix-credentials-0_27_0-9f10d05e8cae30a6 gix-date-0_9_3-96d774acc5665b01 gix-diff-0_50_0-24f3e9953824e3ec gix-dir-0_12_0-88f377819e323035 gix-discover-0_38_0-c4fdb0dac6ff4581 gix-features-0_40_0-28fa590012f22da9 gix-filter-0_17_0-c80d6bb81ef5aa53 gix-fs-0_13_0-255b0b7de5a5da06 gix-glob-0_18_0-0d0d6365a30d9fb0 gix-hash-0_16_0-c47a8c0103fbbf5d gix-hashtable-0_7_0-f73f6779ef0c35fc gix-ignore-0_13_0-dc210cd523cd3a5f gix-index-0_38_0-fb8cb1f325d808d3 gix-lock-16_0_0-a67cc35e3a71cede gix-negotiate-0_18_0-62875ad27fc869c7 gix-object-0_47_0-d62e7b541181e72a gix-odb-0_67_0-c6661a6daf8eece9 gix-pack-0_57_0-e8c0e5e82661a842 gix-path-0_10_14-2414f38f73019524 gix-pathspec-0_9_0-cf015e1a3d247d1e gix-prompt-0_9_1-f87bf7f21c0d716e gix-protocol-0_48_0-9fa92f0b281ee0e2 gix-ref-0_50_0-757b0625f98d7554 gix-refspec-0_28_0-e1911f8b47334f93 gix-revision-0_32_0-460caf71d05c47ac gix-revwalk-0_18_0-2b6b72b2592b7eff gix-sec-0_10_11-ab0eb6daa79e8d04 gix-shallow-0_2_0-b72e00f79521cb69 gix-submodule-0_17_0-b3809ac1037d0844 gix-tempfile-16_0_0-82af46aa830dfb66 gix-trace-0_1_12-e7c79603b3e36d61 gix-transport-0_45_0-afa9908215953e1e gix-traverse-0_44_0-e79be577d449ae93 gix-url-0_29_0-75b9f18fc4d5606d gix-utils-0_1_14-286091b3d3e35677 gix-validate-0_9_3-d0731c820afa7a2d gix-worktree-0_39_0-8783032da3fa15b5 once_cell-1_20_3-5c63a4de5995f261 prodash-29_0_0-1d60e4a983dec2b3 smallvec-1_13_2-453c588ad74a5894 thiserror-2_0_11-266d93aab4cee78a];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/gix/0.70.0/download";
      sha256 = "736f14636705f3a56ea52b553e67282519418d9a35bb1e90b3a9637a00296b68";
    };
    unpackPhase = ''
      tar xf $src
      cd gix-0.70.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "gix";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Sebastian Thiel <sebastian.thiel@icloud.com>";
    CARGO_PKG_DESCRIPTION = "Interact with git repositories just like git would";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "gix";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/GitoxideLabs/gitoxide";
    CARGO_PKG_RUST_VERSION = "1.70";
    CARGO_PKG_VERSION = "0.70.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "70";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m gix-0_70_0-833dfa597e0c3507"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name gix \
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
        --cfg 'feature="attributes"' \
        --cfg 'feature="blocking-http-transport-curl"' \
        --cfg 'feature="blocking-network-client"' \
        --cfg 'feature="command"' \
        --cfg 'feature="credentials"' \
        --cfg 'feature="dirwalk"' \
        --cfg 'feature="excludes"' \
        --cfg 'feature="index"' \
        --cfg 'feature="parallel"' \
        --cfg 'feature="prodash"' \
        --cfg 'feature="progress-tree"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("async-network-client", "async-network-client-async-std", "async-std", "attributes", "basic", "blame", "blob-diff", "blocking-http-transport-curl", "blocking-http-transport-curl-rustls", "blocking-http-transport-reqwest", "blocking-http-transport-reqwest-native-tls", "blocking-http-transport-reqwest-rust-tls", "blocking-http-transport-reqwest-rust-tls-trust-dns", "blocking-network-client", "cache-efficiency-debug", "comfort", "command", "credentials", "default", "dirwalk", "document-features", "excludes", "extras", "fast-sha1", "gix-archive", "gix-status", "gix-worktree-stream", "hp-tempfile-registry", "index", "interrupt", "mailmap", "max-control", "max-performance", "max-performance-safe", "merge", "need-more-recent-msrv", "pack-cache-lru-dynamic", "pack-cache-lru-static", "parallel", "parallel-walkdir", "prodash", "progress-tree", "regex", "revision", "revparse-regex", "serde", "status", "tracing", "tracing-detail", "tree-editor", "verbose-object-parsing-errors", "worktree-archive", "worktree-mutation", "worktree-stream", "zlib-ng", "zlib-ng-compat", "zlib-stock"))' \
        -C metadata=40a2e6004fc2c9b3 \
        -C extra-filename=-833dfa597e0c3507 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern gix_actor=${gix-actor-0_33_2-1bdbe24e757b6722}/libgix_actor-1bdbe24e757b6722.rmeta \
        --extern gix_attributes=${gix-attributes-0_24_0-839dd8a3503d8e44}/libgix_attributes-839dd8a3503d8e44.rmeta \
        --extern gix_command=${gix-command-0_4_1-d7db7f609223402c}/libgix_command-d7db7f609223402c.rmeta \
        --extern gix_commitgraph=${gix-commitgraph-0_26_0-e8ba9bafb35a5a77}/libgix_commitgraph-e8ba9bafb35a5a77.rmeta \
        --extern gix_config=${gix-config-0_43_0-88776c32f6471efa}/libgix_config-88776c32f6471efa.rmeta \
        --extern gix_credentials=${gix-credentials-0_27_0-9f10d05e8cae30a6}/libgix_credentials-9f10d05e8cae30a6.rmeta \
        --extern gix_date=${gix-date-0_9_3-96d774acc5665b01}/libgix_date-96d774acc5665b01.rmeta \
        --extern gix_diff=${gix-diff-0_50_0-24f3e9953824e3ec}/libgix_diff-24f3e9953824e3ec.rmeta \
        --extern gix_dir=${gix-dir-0_12_0-88f377819e323035}/libgix_dir-88f377819e323035.rmeta \
        --extern gix_discover=${gix-discover-0_38_0-c4fdb0dac6ff4581}/libgix_discover-c4fdb0dac6ff4581.rmeta \
        --extern gix_features=${gix-features-0_40_0-28fa590012f22da9}/libgix_features-28fa590012f22da9.rmeta \
        --extern gix_filter=${gix-filter-0_17_0-c80d6bb81ef5aa53}/libgix_filter-c80d6bb81ef5aa53.rmeta \
        --extern gix_fs=${gix-fs-0_13_0-255b0b7de5a5da06}/libgix_fs-255b0b7de5a5da06.rmeta \
        --extern gix_glob=${gix-glob-0_18_0-0d0d6365a30d9fb0}/libgix_glob-0d0d6365a30d9fb0.rmeta \
        --extern gix_hash=${gix-hash-0_16_0-c47a8c0103fbbf5d}/libgix_hash-c47a8c0103fbbf5d.rmeta \
        --extern gix_hashtable=${gix-hashtable-0_7_0-f73f6779ef0c35fc}/libgix_hashtable-f73f6779ef0c35fc.rmeta \
        --extern gix_ignore=${gix-ignore-0_13_0-dc210cd523cd3a5f}/libgix_ignore-dc210cd523cd3a5f.rmeta \
        --extern gix_index=${gix-index-0_38_0-fb8cb1f325d808d3}/libgix_index-fb8cb1f325d808d3.rmeta \
        --extern gix_lock=${gix-lock-16_0_0-a67cc35e3a71cede}/libgix_lock-a67cc35e3a71cede.rmeta \
        --extern gix_negotiate=${gix-negotiate-0_18_0-62875ad27fc869c7}/libgix_negotiate-62875ad27fc869c7.rmeta \
        --extern gix_object=${gix-object-0_47_0-d62e7b541181e72a}/libgix_object-d62e7b541181e72a.rmeta \
        --extern gix_odb=${gix-odb-0_67_0-c6661a6daf8eece9}/libgix_odb-c6661a6daf8eece9.rmeta \
        --extern gix_pack=${gix-pack-0_57_0-e8c0e5e82661a842}/libgix_pack-e8c0e5e82661a842.rmeta \
        --extern gix_path=${gix-path-0_10_14-2414f38f73019524}/libgix_path-2414f38f73019524.rmeta \
        --extern gix_pathspec=${gix-pathspec-0_9_0-cf015e1a3d247d1e}/libgix_pathspec-cf015e1a3d247d1e.rmeta \
        --extern gix_prompt=${gix-prompt-0_9_1-f87bf7f21c0d716e}/libgix_prompt-f87bf7f21c0d716e.rmeta \
        --extern gix_protocol=${gix-protocol-0_48_0-9fa92f0b281ee0e2}/libgix_protocol-9fa92f0b281ee0e2.rmeta \
        --extern gix_ref=${gix-ref-0_50_0-757b0625f98d7554}/libgix_ref-757b0625f98d7554.rmeta \
        --extern gix_refspec=${gix-refspec-0_28_0-e1911f8b47334f93}/libgix_refspec-e1911f8b47334f93.rmeta \
        --extern gix_revision=${gix-revision-0_32_0-460caf71d05c47ac}/libgix_revision-460caf71d05c47ac.rmeta \
        --extern gix_revwalk=${gix-revwalk-0_18_0-2b6b72b2592b7eff}/libgix_revwalk-2b6b72b2592b7eff.rmeta \
        --extern gix_sec=${gix-sec-0_10_11-ab0eb6daa79e8d04}/libgix_sec-ab0eb6daa79e8d04.rmeta \
        --extern gix_shallow=${gix-shallow-0_2_0-b72e00f79521cb69}/libgix_shallow-b72e00f79521cb69.rmeta \
        --extern gix_submodule=${gix-submodule-0_17_0-b3809ac1037d0844}/libgix_submodule-b3809ac1037d0844.rmeta \
        --extern gix_tempfile=${gix-tempfile-16_0_0-82af46aa830dfb66}/libgix_tempfile-82af46aa830dfb66.rmeta \
        --extern gix_trace=${gix-trace-0_1_12-e7c79603b3e36d61}/libgix_trace-e7c79603b3e36d61.rmeta \
        --extern gix_transport=${gix-transport-0_45_0-afa9908215953e1e}/libgix_transport-afa9908215953e1e.rmeta \
        --extern gix_traverse=${gix-traverse-0_44_0-e79be577d449ae93}/libgix_traverse-e79be577d449ae93.rmeta \
        --extern gix_url=${gix-url-0_29_0-75b9f18fc4d5606d}/libgix_url-75b9f18fc4d5606d.rmeta \
        --extern gix_utils=${gix-utils-0_1_14-286091b3d3e35677}/libgix_utils-286091b3d3e35677.rmeta \
        --extern gix_validate=${gix-validate-0_9_3-d0731c820afa7a2d}/libgix_validate-d0731c820afa7a2d.rmeta \
        --extern gix_worktree=${gix-worktree-0_39_0-8783032da3fa15b5}/libgix_worktree-8783032da3fa15b5.rmeta \
        --extern once_cell=${once_cell-1_20_3-5c63a4de5995f261}/libonce_cell-5c63a4de5995f261.rmeta \
        --extern prodash=${prodash-29_0_0-1d60e4a983dec2b3}/libprodash-1d60e4a983dec2b3.rmeta \
        --extern smallvec=${smallvec-1_13_2-453c588ad74a5894}/libsmallvec-453c588ad74a5894.rmeta \
        --extern thiserror=${thiserror-2_0_11-266d93aab4cee78a}/libthiserror-266d93aab4cee78a.rmeta \
        --cap-lints allow
      )
    '';
}
