# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-index-0_38_0-d1d71768249da153";
    meta.cargo_crate_info = {
      name = "gix-index";
      version = "0.38.0";
      crate_hash = "d1d71768249da153";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [bitflags-2_8_0-25bacb8b683e4264 bstr-1_11_3-46100c463ffaaa37 filetime-0_2_25-4a8c5a239dda911b fnv-1_0_7-4fc187120cbe28dc gix-bitmap-0_2_14-ccd068f2125b37ac gix-features-0_40_0-786b5f2993cbc7d3 gix-fs-0_13_0-82d23dce92bde1cf gix-hash-0_16_0-d473f2b9165b7ac8 gix-lock-16_0_0-8d2d91e093879452 gix-object-0_47_0-d81adbd40609c58b gix-traverse-0_44_0-0ef1034feb6f2559 gix-utils-0_1_14-1374b61d28fc65a7 gix-validate-0_9_3-216a7de78dd3073f hashbrown-0_14_5-5a3923327447427c itoa-1_0_14-f807d60e93b08a94 libc-0_2_175-b265bb513a0388f3 memmap2-0_9_5-ad06fecf20fe7317 rustix-0_38_44-bb44290fdf9a9b11 smallvec-1_13_2-0ef9b24879be6fdc thiserror-2_0_11-c6c4ee382aacde15];
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
              --check-cfg 'cfg(feature, values("document-features", "serde"))' \
              -C metadata=15201c258a7b86c5 \
              -C extra-filename=-d1d71768249da153 \
              --out-dir $OUT_DIR \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern bitflags=${bitflags-2_8_0-25bacb8b683e4264}/libbitflags-25bacb8b683e4264.rmeta \
              --extern bstr=${bstr-1_11_3-46100c463ffaaa37}/libbstr-46100c463ffaaa37.rmeta \
              --extern filetime=${filetime-0_2_25-4a8c5a239dda911b}/libfiletime-4a8c5a239dda911b.rmeta \
              --extern fnv=${fnv-1_0_7-4fc187120cbe28dc}/libfnv-4fc187120cbe28dc.rmeta \
              --extern gix_bitmap=${gix-bitmap-0_2_14-ccd068f2125b37ac}/libgix_bitmap-ccd068f2125b37ac.rmeta \
              --extern gix_features=${gix-features-0_40_0-786b5f2993cbc7d3}/libgix_features-786b5f2993cbc7d3.rmeta \
              --extern gix_fs=${gix-fs-0_13_0-82d23dce92bde1cf}/libgix_fs-82d23dce92bde1cf.rmeta \
              --extern gix_hash=${gix-hash-0_16_0-d473f2b9165b7ac8}/libgix_hash-d473f2b9165b7ac8.rmeta \
              --extern gix_lock=${gix-lock-16_0_0-8d2d91e093879452}/libgix_lock-8d2d91e093879452.rmeta \
              --extern gix_object=${gix-object-0_47_0-d81adbd40609c58b}/libgix_object-d81adbd40609c58b.rmeta \
              --extern gix_traverse=${gix-traverse-0_44_0-0ef1034feb6f2559}/libgix_traverse-0ef1034feb6f2559.rmeta \
              --extern gix_utils=${gix-utils-0_1_14-1374b61d28fc65a7}/libgix_utils-1374b61d28fc65a7.rmeta \
              --extern gix_validate=${gix-validate-0_9_3-216a7de78dd3073f}/libgix_validate-216a7de78dd3073f.rmeta \
              --extern hashbrown=${hashbrown-0_14_5-5a3923327447427c}/libhashbrown-5a3923327447427c.rmeta \
              --extern itoa=${itoa-1_0_14-f807d60e93b08a94}/libitoa-f807d60e93b08a94.rmeta \
              --extern libc=${libc-0_2_175-b265bb513a0388f3}/liblibc-b265bb513a0388f3.rmeta \
              --extern memmap2=${memmap2-0_9_5-ad06fecf20fe7317}/libmemmap2-ad06fecf20fe7317.rmeta \
              --extern rustix=${rustix-0_38_44-bb44290fdf9a9b11}/librustix-bb44290fdf9a9b11.rmeta \
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
