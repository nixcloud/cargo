# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-0_70_0-6ef08fee72b6f2df";
    meta.cargo_crate_info = {
      name = "gix";
      version = "0.70.0";
      crate_hash = "6ef08fee72b6f2df";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [gix-actor-0_33_2-6ed8c81e826ceba4 gix-attributes-0_24_0-64ee21b308ccf8d6 gix-command-0_4_1-74abf2bf82b71c94 gix-commitgraph-0_26_0-3f98563c5c8a6311 gix-config-0_43_0-258b91159c7a0459 gix-credentials-0_27_0-31b7bfc0f35b5458 gix-date-0_9_3-6d0773e8f7ea4157 gix-diff-0_50_0-56281f41a2cabff3 gix-dir-0_12_0-e3e998ab3cb08ee6 gix-discover-0_38_0-243df1ed30f8cacf gix-features-0_40_0-786b5f2993cbc7d3 gix-filter-0_17_0-47e02cbbb6050e2a gix-fs-0_13_0-82d23dce92bde1cf gix-glob-0_18_0-cfb0a22bd88ebc1a gix-hash-0_16_0-d473f2b9165b7ac8 gix-hashtable-0_7_0-318054c20e5fbfa6 gix-ignore-0_13_0-feb550e0a5cf7f17 gix-index-0_38_0-d1d71768249da153 gix-lock-16_0_0-8d2d91e093879452 gix-negotiate-0_18_0-398a8b405acd631e gix-object-0_47_0-d81adbd40609c58b gix-odb-0_67_0-e43f597d8647a021 gix-pack-0_57_0-012506e91304f7af gix-path-0_10_14-fac4f7c597a0c8bd gix-pathspec-0_9_0-dc7b452ba4237f55 gix-prompt-0_9_1-af9ba06f0c392615 gix-protocol-0_48_0-5fdd06620e19fa94 gix-ref-0_50_0-118027e5bbad2abb gix-refspec-0_28_0-d51836ae4e2212f2 gix-revision-0_32_0-897144e6bad2e45b gix-revwalk-0_18_0-e12966047159e740 gix-sec-0_10_11-c1812e93e0aabb9f gix-shallow-0_2_0-080d1f139f023928 gix-submodule-0_17_0-06f8f708b9f867fa gix-tempfile-16_0_0-741f0a837b503fa9 gix-trace-0_1_12-718f68523d5ac749 gix-transport-0_45_0-1ea8ae6992c380fb gix-traverse-0_44_0-0ef1034feb6f2559 gix-url-0_29_0-3f47ae4bf8a5f462 gix-utils-0_1_14-1374b61d28fc65a7 gix-validate-0_9_3-216a7de78dd3073f gix-worktree-0_39_0-d4920c30021559e3 once_cell-1_20_3-65600a49c06310f1 prodash-29_0_0-d9f2709fb236f900 smallvec-1_13_2-0ef9b24879be6fdc thiserror-2_0_11-c6c4ee382aacde15];
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
              -C metadata=5b690d1c10d9b35a \
              -C extra-filename=-6ef08fee72b6f2df \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern gix_actor=${gix-actor-0_33_2-6ed8c81e826ceba4}/libgix_actor-6ed8c81e826ceba4.rmeta \
              --extern gix_attributes=${gix-attributes-0_24_0-64ee21b308ccf8d6}/libgix_attributes-64ee21b308ccf8d6.rmeta \
              --extern gix_command=${gix-command-0_4_1-74abf2bf82b71c94}/libgix_command-74abf2bf82b71c94.rmeta \
              --extern gix_commitgraph=${gix-commitgraph-0_26_0-3f98563c5c8a6311}/libgix_commitgraph-3f98563c5c8a6311.rmeta \
              --extern gix_config=${gix-config-0_43_0-258b91159c7a0459}/libgix_config-258b91159c7a0459.rmeta \
              --extern gix_credentials=${gix-credentials-0_27_0-31b7bfc0f35b5458}/libgix_credentials-31b7bfc0f35b5458.rmeta \
              --extern gix_date=${gix-date-0_9_3-6d0773e8f7ea4157}/libgix_date-6d0773e8f7ea4157.rmeta \
              --extern gix_diff=${gix-diff-0_50_0-56281f41a2cabff3}/libgix_diff-56281f41a2cabff3.rmeta \
              --extern gix_dir=${gix-dir-0_12_0-e3e998ab3cb08ee6}/libgix_dir-e3e998ab3cb08ee6.rmeta \
              --extern gix_discover=${gix-discover-0_38_0-243df1ed30f8cacf}/libgix_discover-243df1ed30f8cacf.rmeta \
              --extern gix_features=${gix-features-0_40_0-786b5f2993cbc7d3}/libgix_features-786b5f2993cbc7d3.rmeta \
              --extern gix_filter=${gix-filter-0_17_0-47e02cbbb6050e2a}/libgix_filter-47e02cbbb6050e2a.rmeta \
              --extern gix_fs=${gix-fs-0_13_0-82d23dce92bde1cf}/libgix_fs-82d23dce92bde1cf.rmeta \
              --extern gix_glob=${gix-glob-0_18_0-cfb0a22bd88ebc1a}/libgix_glob-cfb0a22bd88ebc1a.rmeta \
              --extern gix_hash=${gix-hash-0_16_0-d473f2b9165b7ac8}/libgix_hash-d473f2b9165b7ac8.rmeta \
              --extern gix_hashtable=${gix-hashtable-0_7_0-318054c20e5fbfa6}/libgix_hashtable-318054c20e5fbfa6.rmeta \
              --extern gix_ignore=${gix-ignore-0_13_0-feb550e0a5cf7f17}/libgix_ignore-feb550e0a5cf7f17.rmeta \
              --extern gix_index=${gix-index-0_38_0-d1d71768249da153}/libgix_index-d1d71768249da153.rmeta \
              --extern gix_lock=${gix-lock-16_0_0-8d2d91e093879452}/libgix_lock-8d2d91e093879452.rmeta \
              --extern gix_negotiate=${gix-negotiate-0_18_0-398a8b405acd631e}/libgix_negotiate-398a8b405acd631e.rmeta \
              --extern gix_object=${gix-object-0_47_0-d81adbd40609c58b}/libgix_object-d81adbd40609c58b.rmeta \
              --extern gix_odb=${gix-odb-0_67_0-e43f597d8647a021}/libgix_odb-e43f597d8647a021.rmeta \
              --extern gix_pack=${gix-pack-0_57_0-012506e91304f7af}/libgix_pack-012506e91304f7af.rmeta \
              --extern gix_path=${gix-path-0_10_14-fac4f7c597a0c8bd}/libgix_path-fac4f7c597a0c8bd.rmeta \
              --extern gix_pathspec=${gix-pathspec-0_9_0-dc7b452ba4237f55}/libgix_pathspec-dc7b452ba4237f55.rmeta \
              --extern gix_prompt=${gix-prompt-0_9_1-af9ba06f0c392615}/libgix_prompt-af9ba06f0c392615.rmeta \
              --extern gix_protocol=${gix-protocol-0_48_0-5fdd06620e19fa94}/libgix_protocol-5fdd06620e19fa94.rmeta \
              --extern gix_ref=${gix-ref-0_50_0-118027e5bbad2abb}/libgix_ref-118027e5bbad2abb.rmeta \
              --extern gix_refspec=${gix-refspec-0_28_0-d51836ae4e2212f2}/libgix_refspec-d51836ae4e2212f2.rmeta \
              --extern gix_revision=${gix-revision-0_32_0-897144e6bad2e45b}/libgix_revision-897144e6bad2e45b.rmeta \
              --extern gix_revwalk=${gix-revwalk-0_18_0-e12966047159e740}/libgix_revwalk-e12966047159e740.rmeta \
              --extern gix_sec=${gix-sec-0_10_11-c1812e93e0aabb9f}/libgix_sec-c1812e93e0aabb9f.rmeta \
              --extern gix_shallow=${gix-shallow-0_2_0-080d1f139f023928}/libgix_shallow-080d1f139f023928.rmeta \
              --extern gix_submodule=${gix-submodule-0_17_0-06f8f708b9f867fa}/libgix_submodule-06f8f708b9f867fa.rmeta \
              --extern gix_tempfile=${gix-tempfile-16_0_0-741f0a837b503fa9}/libgix_tempfile-741f0a837b503fa9.rmeta \
              --extern gix_trace=${gix-trace-0_1_12-718f68523d5ac749}/libgix_trace-718f68523d5ac749.rmeta \
              --extern gix_transport=${gix-transport-0_45_0-1ea8ae6992c380fb}/libgix_transport-1ea8ae6992c380fb.rmeta \
              --extern gix_traverse=${gix-traverse-0_44_0-0ef1034feb6f2559}/libgix_traverse-0ef1034feb6f2559.rmeta \
              --extern gix_url=${gix-url-0_29_0-3f47ae4bf8a5f462}/libgix_url-3f47ae4bf8a5f462.rmeta \
              --extern gix_utils=${gix-utils-0_1_14-1374b61d28fc65a7}/libgix_utils-1374b61d28fc65a7.rmeta \
              --extern gix_validate=${gix-validate-0_9_3-216a7de78dd3073f}/libgix_validate-216a7de78dd3073f.rmeta \
              --extern gix_worktree=${gix-worktree-0_39_0-d4920c30021559e3}/libgix_worktree-d4920c30021559e3.rmeta \
              --extern once_cell=${once_cell-1_20_3-65600a49c06310f1}/libonce_cell-65600a49c06310f1.rmeta \
              --extern prodash=${prodash-29_0_0-d9f2709fb236f900}/libprodash-d9f2709fb236f900.rmeta \
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
