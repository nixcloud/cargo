# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-index-0_38_0-fd774084d6371cea";
    meta.cargo_crate_info = {
      name = "gix-index";
      version = "0.38.0";
      crate_hash = "fd774084d6371cea";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [bitflags-2_8_0-d8308ebf07e22afd bstr-1_11_3-14003bcd5b7b8103 filetime-0_2_25-36b58a90b887714e fnv-1_0_7-e86d9923dc926ea6 gix-bitmap-0_2_14-f354064ea405ef42 gix-features-0_40_0-7b4fa941d491da9c gix-fs-0_13_0-32f209ecf862a862 gix-hash-0_16_0-2dd06b7faad8300b gix-lock-16_0_0-c0e4d3d42bd1d641 gix-object-0_47_0-1feb494be43bf821 gix-traverse-0_44_0-2765cfa05e8b8e89 gix-utils-0_1_14-4da59f2b8afebe0a gix-validate-0_9_3-5cd523d9060c9684 hashbrown-0_14_5-0902b9e9c2cf4ed1 itoa-1_0_14-6ae7bc765ab6d9fa libc-0_2_175-df0687d6868fdede memmap2-0_9_5-74a37f7611502dc0 rustix-0_38_44-83758b3e1a43a320 smallvec-1_13_2-e5874423828ed52b thiserror-2_0_11-a57592ffa4ea41e0];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/gix-index/0.38.0/download";
      sha256 = "acd12e3626879369310fffe2ac61acc828613ef656b50c4ea984dd59d7dc85d8";
    };
    unpackPhase = ''
      tar xf $src
      cd gix-index-0.38.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "gix_index";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Sebastian Thiel <sebastian.thiel@icloud.com>";
    CARGO_PKG_DESCRIPTION = "A work-in-progress crate of the gitoxide project dedicated implementing the git index file";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "gix-index";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/GitoxideLabs/gitoxide";
    CARGO_PKG_RUST_VERSION = "1.70";
    CARGO_PKG_VERSION = "0.38.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "38";
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
              --crate-name gix_index \
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
              --check-cfg 'cfg(feature, values("document-features", "serde"))' \
              -C metadata=3a993bcbc7a69e75 \
              -C extra-filename=-fd774084d6371cea \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern bitflags=${bitflags-2_8_0-d8308ebf07e22afd}/libbitflags-d8308ebf07e22afd.rmeta \
              --extern bstr=${bstr-1_11_3-14003bcd5b7b8103}/libbstr-14003bcd5b7b8103.rmeta \
              --extern filetime=${filetime-0_2_25-36b58a90b887714e}/libfiletime-36b58a90b887714e.rmeta \
              --extern fnv=${fnv-1_0_7-e86d9923dc926ea6}/libfnv-e86d9923dc926ea6.rmeta \
              --extern gix_bitmap=${gix-bitmap-0_2_14-f354064ea405ef42}/libgix_bitmap-f354064ea405ef42.rmeta \
              --extern gix_features=${gix-features-0_40_0-7b4fa941d491da9c}/libgix_features-7b4fa941d491da9c.rmeta \
              --extern gix_fs=${gix-fs-0_13_0-32f209ecf862a862}/libgix_fs-32f209ecf862a862.rmeta \
              --extern gix_hash=${gix-hash-0_16_0-2dd06b7faad8300b}/libgix_hash-2dd06b7faad8300b.rmeta \
              --extern gix_lock=${gix-lock-16_0_0-c0e4d3d42bd1d641}/libgix_lock-c0e4d3d42bd1d641.rmeta \
              --extern gix_object=${gix-object-0_47_0-1feb494be43bf821}/libgix_object-1feb494be43bf821.rmeta \
              --extern gix_traverse=${gix-traverse-0_44_0-2765cfa05e8b8e89}/libgix_traverse-2765cfa05e8b8e89.rmeta \
              --extern gix_utils=${gix-utils-0_1_14-4da59f2b8afebe0a}/libgix_utils-4da59f2b8afebe0a.rmeta \
              --extern gix_validate=${gix-validate-0_9_3-5cd523d9060c9684}/libgix_validate-5cd523d9060c9684.rmeta \
              --extern hashbrown=${hashbrown-0_14_5-0902b9e9c2cf4ed1}/libhashbrown-0902b9e9c2cf4ed1.rmeta \
              --extern itoa=${itoa-1_0_14-6ae7bc765ab6d9fa}/libitoa-6ae7bc765ab6d9fa.rmeta \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern memmap2=${memmap2-0_9_5-74a37f7611502dc0}/libmemmap2-74a37f7611502dc0.rmeta \
              --extern rustix=${rustix-0_38_44-83758b3e1a43a320}/librustix-83758b3e1a43a320.rmeta \
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
