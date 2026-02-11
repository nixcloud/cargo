# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-dir-0_12_0-5131791182ccf5a3";
    meta.cargo_crate_info = {
      name = "gix-dir";
      version = "0.12.0";
      crate_hash = "5131791182ccf5a3";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [bstr-1_11_3-14003bcd5b7b8103 gix-discover-0_38_0-3541dc1bd7f8a291 gix-fs-0_13_0-32f209ecf862a862 gix-ignore-0_13_0-a762477646d7d9f7 gix-index-0_38_0-fd774084d6371cea gix-object-0_47_0-1feb494be43bf821 gix-path-0_10_14-6bb928c9998da5a8 gix-pathspec-0_9_0-8c1afc1e63b302a6 gix-trace-0_1_12-6fa342b8ee63f664 gix-utils-0_1_14-4da59f2b8afebe0a gix-worktree-0_39_0-441c8c8134035536 thiserror-2_0_11-a57592ffa4ea41e0];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/gix-dir/0.12.0/download";
      sha256 = "c1d78db3927a12f7d1b788047b84efacaab03ef25738bd1c77856ad8966bd57b";
    };
    unpackPhase = ''
      tar xf $src
      cd gix-dir-0.12.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "gix_dir";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Sebastian Thiel <sebastian.thiel@icloud.com>";
    CARGO_PKG_DESCRIPTION = "A crate of the gitoxide project dealing with directory walks";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "gix-dir";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/GitoxideLabs/gitoxide";
    CARGO_PKG_RUST_VERSION = "1.70";
    CARGO_PKG_VERSION = "0.12.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "12";
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
              --crate-name gix_dir \
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
              -C metadata=f23361362776bf91 \
              -C extra-filename=-5131791182ccf5a3 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern bstr=${bstr-1_11_3-14003bcd5b7b8103}/libbstr-14003bcd5b7b8103.rmeta \
              --extern gix_discover=${gix-discover-0_38_0-3541dc1bd7f8a291}/libgix_discover-3541dc1bd7f8a291.rmeta \
              --extern gix_fs=${gix-fs-0_13_0-32f209ecf862a862}/libgix_fs-32f209ecf862a862.rmeta \
              --extern gix_ignore=${gix-ignore-0_13_0-a762477646d7d9f7}/libgix_ignore-a762477646d7d9f7.rmeta \
              --extern gix_index=${gix-index-0_38_0-fd774084d6371cea}/libgix_index-fd774084d6371cea.rmeta \
              --extern gix_object=${gix-object-0_47_0-1feb494be43bf821}/libgix_object-1feb494be43bf821.rmeta \
              --extern gix_path=${gix-path-0_10_14-6bb928c9998da5a8}/libgix_path-6bb928c9998da5a8.rmeta \
              --extern gix_pathspec=${gix-pathspec-0_9_0-8c1afc1e63b302a6}/libgix_pathspec-8c1afc1e63b302a6.rmeta \
              --extern gix_trace=${gix-trace-0_1_12-6fa342b8ee63f664}/libgix_trace-6fa342b8ee63f664.rmeta \
              --extern gix_utils=${gix-utils-0_1_14-4da59f2b8afebe0a}/libgix_utils-4da59f2b8afebe0a.rmeta \
              --extern gix_worktree=${gix-worktree-0_39_0-441c8c8134035536}/libgix_worktree-441c8c8134035536.rmeta \
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
