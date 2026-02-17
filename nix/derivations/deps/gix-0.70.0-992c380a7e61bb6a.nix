# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-0_70_0-992c380a7e61bb6a";
    meta.cargo_crate_info = {
      name = "gix";
      version = "0.70.0";
      crate_hash = "992c380a7e61bb6a";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [gix-actor-0_33_2-6f4ab7bcb15a2392 gix-attributes-0_24_0-b71cf5283dcbf9ad gix-command-0_4_1-e29484d4d4e346e8 gix-commitgraph-0_26_0-f831d83001ac5121 gix-config-0_43_0-c2a2493ddeeda786 gix-credentials-0_27_0-48aff77da2287bad gix-date-0_9_3-ef3873a712c7b7c9 gix-diff-0_50_0-fed3014ae47894e9 gix-dir-0_12_0-5131791182ccf5a3 gix-discover-0_38_0-3541dc1bd7f8a291 gix-features-0_40_0-7b4fa941d491da9c gix-filter-0_17_0-e2f5328c169aa835 gix-fs-0_13_0-32f209ecf862a862 gix-glob-0_18_0-7b254994b5e9c6fa gix-hash-0_16_0-2dd06b7faad8300b gix-hashtable-0_7_0-cf7f65c45ebb5acb gix-ignore-0_13_0-a762477646d7d9f7 gix-index-0_38_0-fd774084d6371cea gix-lock-16_0_0-c0e4d3d42bd1d641 gix-negotiate-0_18_0-3bc90a63e768c830 gix-object-0_47_0-1feb494be43bf821 gix-odb-0_67_0-75c8e2fcff23733b gix-pack-0_57_0-86d1b37081390307 gix-path-0_10_14-6bb928c9998da5a8 gix-pathspec-0_9_0-8c1afc1e63b302a6 gix-prompt-0_9_1-fa757bef7affaabd gix-protocol-0_48_0-3d59eb97d302f3a0 gix-ref-0_50_0-9c43a6c2d25dc4c1 gix-refspec-0_28_0-e29e1a847ad4941f gix-revision-0_32_0-e2b81ece8deb27a8 gix-revwalk-0_18_0-58438d094712a949 gix-sec-0_10_11-a898e4a50340a006 gix-shallow-0_2_0-17cceba6b74ec6c7 gix-submodule-0_17_0-3e55b4fc27cc42ec gix-tempfile-16_0_0-83660278b0f5c0f2 gix-trace-0_1_12-6fa342b8ee63f664 gix-transport-0_45_0-6a2f0d56c387db84 gix-traverse-0_44_0-2765cfa05e8b8e89 gix-url-0_29_0-74b20df333b8da83 gix-utils-0_1_14-4da59f2b8afebe0a gix-validate-0_9_3-5cd523d9060c9684 gix-worktree-0_39_0-441c8c8134035536 once_cell-1_20_3-60992a3834e62ae0 prodash-29_0_0-a503f1586841c872 smallvec-1_13_2-e5874423828ed52b thiserror-2_0_11-a57592ffa4ea41e0];
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
              --crate-name gix \
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
              -C metadata=8025c8df1e3eed1c \
              -C extra-filename=-992c380a7e61bb6a \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern gix_actor=${gix-actor-0_33_2-6f4ab7bcb15a2392}/libgix_actor-6f4ab7bcb15a2392.rmeta \
              --extern gix_attributes=${gix-attributes-0_24_0-b71cf5283dcbf9ad}/libgix_attributes-b71cf5283dcbf9ad.rmeta \
              --extern gix_command=${gix-command-0_4_1-e29484d4d4e346e8}/libgix_command-e29484d4d4e346e8.rmeta \
              --extern gix_commitgraph=${gix-commitgraph-0_26_0-f831d83001ac5121}/libgix_commitgraph-f831d83001ac5121.rmeta \
              --extern gix_config=${gix-config-0_43_0-c2a2493ddeeda786}/libgix_config-c2a2493ddeeda786.rmeta \
              --extern gix_credentials=${gix-credentials-0_27_0-48aff77da2287bad}/libgix_credentials-48aff77da2287bad.rmeta \
              --extern gix_date=${gix-date-0_9_3-ef3873a712c7b7c9}/libgix_date-ef3873a712c7b7c9.rmeta \
              --extern gix_diff=${gix-diff-0_50_0-fed3014ae47894e9}/libgix_diff-fed3014ae47894e9.rmeta \
              --extern gix_dir=${gix-dir-0_12_0-5131791182ccf5a3}/libgix_dir-5131791182ccf5a3.rmeta \
              --extern gix_discover=${gix-discover-0_38_0-3541dc1bd7f8a291}/libgix_discover-3541dc1bd7f8a291.rmeta \
              --extern gix_features=${gix-features-0_40_0-7b4fa941d491da9c}/libgix_features-7b4fa941d491da9c.rmeta \
              --extern gix_filter=${gix-filter-0_17_0-e2f5328c169aa835}/libgix_filter-e2f5328c169aa835.rmeta \
              --extern gix_fs=${gix-fs-0_13_0-32f209ecf862a862}/libgix_fs-32f209ecf862a862.rmeta \
              --extern gix_glob=${gix-glob-0_18_0-7b254994b5e9c6fa}/libgix_glob-7b254994b5e9c6fa.rmeta \
              --extern gix_hash=${gix-hash-0_16_0-2dd06b7faad8300b}/libgix_hash-2dd06b7faad8300b.rmeta \
              --extern gix_hashtable=${gix-hashtable-0_7_0-cf7f65c45ebb5acb}/libgix_hashtable-cf7f65c45ebb5acb.rmeta \
              --extern gix_ignore=${gix-ignore-0_13_0-a762477646d7d9f7}/libgix_ignore-a762477646d7d9f7.rmeta \
              --extern gix_index=${gix-index-0_38_0-fd774084d6371cea}/libgix_index-fd774084d6371cea.rmeta \
              --extern gix_lock=${gix-lock-16_0_0-c0e4d3d42bd1d641}/libgix_lock-c0e4d3d42bd1d641.rmeta \
              --extern gix_negotiate=${gix-negotiate-0_18_0-3bc90a63e768c830}/libgix_negotiate-3bc90a63e768c830.rmeta \
              --extern gix_object=${gix-object-0_47_0-1feb494be43bf821}/libgix_object-1feb494be43bf821.rmeta \
              --extern gix_odb=${gix-odb-0_67_0-75c8e2fcff23733b}/libgix_odb-75c8e2fcff23733b.rmeta \
              --extern gix_pack=${gix-pack-0_57_0-86d1b37081390307}/libgix_pack-86d1b37081390307.rmeta \
              --extern gix_path=${gix-path-0_10_14-6bb928c9998da5a8}/libgix_path-6bb928c9998da5a8.rmeta \
              --extern gix_pathspec=${gix-pathspec-0_9_0-8c1afc1e63b302a6}/libgix_pathspec-8c1afc1e63b302a6.rmeta \
              --extern gix_prompt=${gix-prompt-0_9_1-fa757bef7affaabd}/libgix_prompt-fa757bef7affaabd.rmeta \
              --extern gix_protocol=${gix-protocol-0_48_0-3d59eb97d302f3a0}/libgix_protocol-3d59eb97d302f3a0.rmeta \
              --extern gix_ref=${gix-ref-0_50_0-9c43a6c2d25dc4c1}/libgix_ref-9c43a6c2d25dc4c1.rmeta \
              --extern gix_refspec=${gix-refspec-0_28_0-e29e1a847ad4941f}/libgix_refspec-e29e1a847ad4941f.rmeta \
              --extern gix_revision=${gix-revision-0_32_0-e2b81ece8deb27a8}/libgix_revision-e2b81ece8deb27a8.rmeta \
              --extern gix_revwalk=${gix-revwalk-0_18_0-58438d094712a949}/libgix_revwalk-58438d094712a949.rmeta \
              --extern gix_sec=${gix-sec-0_10_11-a898e4a50340a006}/libgix_sec-a898e4a50340a006.rmeta \
              --extern gix_shallow=${gix-shallow-0_2_0-17cceba6b74ec6c7}/libgix_shallow-17cceba6b74ec6c7.rmeta \
              --extern gix_submodule=${gix-submodule-0_17_0-3e55b4fc27cc42ec}/libgix_submodule-3e55b4fc27cc42ec.rmeta \
              --extern gix_tempfile=${gix-tempfile-16_0_0-83660278b0f5c0f2}/libgix_tempfile-83660278b0f5c0f2.rmeta \
              --extern gix_trace=${gix-trace-0_1_12-6fa342b8ee63f664}/libgix_trace-6fa342b8ee63f664.rmeta \
              --extern gix_transport=${gix-transport-0_45_0-6a2f0d56c387db84}/libgix_transport-6a2f0d56c387db84.rmeta \
              --extern gix_traverse=${gix-traverse-0_44_0-2765cfa05e8b8e89}/libgix_traverse-2765cfa05e8b8e89.rmeta \
              --extern gix_url=${gix-url-0_29_0-74b20df333b8da83}/libgix_url-74b20df333b8da83.rmeta \
              --extern gix_utils=${gix-utils-0_1_14-4da59f2b8afebe0a}/libgix_utils-4da59f2b8afebe0a.rmeta \
              --extern gix_validate=${gix-validate-0_9_3-5cd523d9060c9684}/libgix_validate-5cd523d9060c9684.rmeta \
              --extern gix_worktree=${gix-worktree-0_39_0-441c8c8134035536}/libgix_worktree-441c8c8134035536.rmeta \
              --extern once_cell=${once_cell-1_20_3-60992a3834e62ae0}/libonce_cell-60992a3834e62ae0.rmeta \
              --extern prodash=${prodash-29_0_0-a503f1586841c872}/libprodash-a503f1586841c872.rmeta \
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
