# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "gix-features-0_40_0-7b4fa941d491da9c";
    meta.cargo_crate_info = {
      name = "gix-features";
      version = "0.40.0";
      crate_hash = "7b4fa941d491da9c";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [bytes-1_10_0-64a68773187e68cf crc32fast-1_4_2-3d7fbbab345759e0 crossbeam-channel-0_5_14-302e921e2a8d4ce6 flate2-1_1_0-8e647ae5b177ac6d gix-hash-0_16_0-2dd06b7faad8300b gix-trace-0_1_12-6fa342b8ee63f664 gix-utils-0_1_14-4da59f2b8afebe0a libc-0_2_175-df0687d6868fdede once_cell-1_20_3-60992a3834e62ae0 parking_lot-0_12_3-4fd4df098a55c376 prodash-29_0_0-a503f1586841c872 sha1_smol-1_0_1-44d22cb8cb02d9b3 thiserror-2_0_11-a57592ffa4ea41e0 walkdir-2_5_0-742d7f303f7cfcda];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/gix-features/0.40.0/download";
      sha256 = "8bfdd4838a8d42bd482c9f0cb526411d003ee94cc7c7b08afe5007329c71d554";
    };
    unpackPhase = ''
      tar xf $src
      cd gix-features-0.40.0
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "gix_features";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Sebastian Thiel <sebastian.thiel@icloud.com>";
    CARGO_PKG_DESCRIPTION = "A crate to integrate various capabilities using compile-time feature flags";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "gix-features";
    CARGO_PKG_README = "";
    CARGO_PKG_REPOSITORY = "https://github.com/GitoxideLabs/gitoxide";
    CARGO_PKG_RUST_VERSION = "1.70";
    CARGO_PKG_VERSION = "0.40.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "40";
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
              --crate-name gix_features \
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
              --cfg 'feature="crc32"' \
              --cfg 'feature="default"' \
              --cfg 'feature="fs-read-dir"' \
              --cfg 'feature="io-pipe"' \
              --cfg 'feature="once_cell"' \
              --cfg 'feature="parallel"' \
              --cfg 'feature="prodash"' \
              --cfg 'feature="progress"' \
              --cfg 'feature="rustsha1"' \
              --cfg 'feature="walkdir"' \
              --cfg 'feature="zlib"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("cache-efficiency-debug", "crc32", "default", "document-features", "fast-sha1", "fs-read-dir", "fs-walkdir-parallel", "io-pipe", "once_cell", "parallel", "prodash", "progress", "progress-unit-bytes", "progress-unit-human-numbers", "rustsha1", "tracing", "tracing-detail", "walkdir", "zlib", "zlib-ng", "zlib-ng-compat", "zlib-rust-backend", "zlib-stock"))' \
              -C metadata=64d7e8d361a58d2f \
              -C extra-filename=-7b4fa941d491da9c \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern bytes=${bytes-1_10_0-64a68773187e68cf}/libbytes-64a68773187e68cf.rmeta \
              --extern crc32fast=${crc32fast-1_4_2-3d7fbbab345759e0}/libcrc32fast-3d7fbbab345759e0.rmeta \
              --extern crossbeam_channel=${crossbeam-channel-0_5_14-302e921e2a8d4ce6}/libcrossbeam_channel-302e921e2a8d4ce6.rmeta \
              --extern flate2=${flate2-1_1_0-8e647ae5b177ac6d}/libflate2-8e647ae5b177ac6d.rmeta \
              --extern gix_hash=${gix-hash-0_16_0-2dd06b7faad8300b}/libgix_hash-2dd06b7faad8300b.rmeta \
              --extern gix_trace=${gix-trace-0_1_12-6fa342b8ee63f664}/libgix_trace-6fa342b8ee63f664.rmeta \
              --extern gix_utils=${gix-utils-0_1_14-4da59f2b8afebe0a}/libgix_utils-4da59f2b8afebe0a.rmeta \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rmeta \
              --extern once_cell=${once_cell-1_20_3-60992a3834e62ae0}/libonce_cell-60992a3834e62ae0.rmeta \
              --extern parking_lot=${parking_lot-0_12_3-4fd4df098a55c376}/libparking_lot-4fd4df098a55c376.rmeta \
              --extern prodash=${prodash-29_0_0-a503f1586841c872}/libprodash-a503f1586841c872.rmeta \
              --extern sha1_smol=${sha1_smol-1_0_1-44d22cb8cb02d9b3}/libsha1_smol-44d22cb8cb02d9b3.rmeta \
              --extern thiserror=${thiserror-2_0_11-a57592ffa4ea41e0}/libthiserror-a57592ffa4ea41e0.rmeta \
              --extern walkdir=${walkdir-2_5_0-742d7f303f7cfcda}/libwalkdir-742d7f303f7cfcda.rmeta \
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
