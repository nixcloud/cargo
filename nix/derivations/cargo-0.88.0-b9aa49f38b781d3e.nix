# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root, cargo-0_88_0-script_build_run-c582da2c854a7f93, cargo-credential-0_4_8-04d496e2b8c4b2ba, cargo-credential-libsecret-0_4_13-9f8a917365498280, cargo-platform-0_2_0-9528fcbd58f1490b, cargo-util-0_2_20-ca8e56b3d4554315, cargo-util-schemas-0_8_1-a76d1978f9d187be, crates-io-0_40_10-114ba05d6d48e004, rustfix-0_9_0-f92d91d9c29999cf }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-0_88_0-b9aa49f38b781d3e";
    meta.cargo_crate_info = {
      name = "cargo";
      version = "0.88.0";
      crate_hash = "b9aa49f38b781d3e";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [annotate-snippets-0_11_5-c27a2250c0f48ef5 anstream-0_6_18-59aa35a61b4ca0e8 anstyle-1_0_10-051477b24e08c8d1 anyhow-1_0_96-61bbc4e08b05614c base64-0_22_1-a69787aa05970cd3 blake3-1_6_1-ceb9e2c2787b1280 build-rs-libnix-0_1_11-24a8729adbae7212 cargo-credential-0_4_8-04d496e2b8c4b2ba cargo-credential-libsecret-0_4_13-9f8a917365498280 cargo-platform-0_2_0-9528fcbd58f1490b cargo-util-0_2_20-ca8e56b3d4554315 cargo-util-schemas-0_8_1-a76d1978f9d187be clap-4_5_31-436756512d3af050 clap_complete-4_5_46-4dce9b58b32b4c7b color-print-0_3_7-9618017c447b538d colored-3_1_1-86c9fae7f303dfbf crates-io-0_40_10-114ba05d6d48e004 curl-0_4_47-8a5016373deb916e curl-sys-0_4_80_plus_curl-8_12_1-e26ceb4086d88aa5 filetime-0_2_25-4a8c5a239dda911b flate2-1_1_0-f05ad64f5d566c20 git2-0_20_0-50735b59c53beae1 git2-curl-0_21_0-aa8fb836bc90345d gix-0_70_0-6ef08fee72b6f2df glob-0_3_2-e53520df8dafaafd handlebars-6_3_1-576dd3883f721609 hex-0_4_3-d9f97d45c228789e hmac-0_12_1-bc3929f8e30dab3e home-0_5_11-918f819357cab881 http-auth-0_1_10-0efb6c0d40dfe9f2 ignore-0_4_23-d7082c3c0c554a79 im-rc-15_1_0-da56962fc462ba73 indexmap-2_7_1-6b5f2f48a7e1007e indoc-2_0_6-d096069012c7930c itertools-0_14_0-aa0fbdedc8514404 jiff-0_2_3-c3af8ddf56e85995 jobserver-0_1_32-bf749e6aa2009df5 lazycell-1_3_0-f94eeda76d97df1a libc-0_2_175-b265bb513a0388f3 libgit2-sys-0_18_0_plus_1_9_0-7c92f3a3d35092c8 logone-0_2_9-ae524b4cfa794eda memchr-2_7_4-a0e5828b48f06e07 opener-0_7_2-62099bf816df8f93 os_info-3_10_0-110090feb8887db7 pasetors-0_7_2-ec9d83f095443be2 pathdiff-0_2_3-1e0bf37cc5ac710a rand-0_9_0-9c1f064fb8df1dbe regex-1_11_1-78f28ee524c2cf84 rusqlite-0_33_0-8c318caee200e796 rustc-hash-2_1_1-56f40b181a89ccb3 rustc-stable-hash-0_1_2-b8337645b79370b8 rustfix-0_9_0-f92d91d9c29999cf same-file-1_0_6-c702782bc8f9cf83 semver-1_0_25-66c86f3f308501e7 serde-1_0_218-ed8707ff8dc168e7 serde-untagged-0_1_6-c26af987742396e6 serde_ignored-0_1_10-71b955e71e7f10ed serde_json-1_0_139-17182eb61f3853cc sha1-0_10_6-0cf4bfd2ea90fd1c shell-escape-0_1_5-2dddd153d3f4fa85 supports-hyperlinks-3_1_0-047db521a6002c93 supports-unicode-3_0_0-fe8b7a4d9f1dccb8 tar-0_4_44-ec5e86963dbd14f3 tempfile-3_17_1-b08d0e8469fdeafa thiserror-2_0_11-c6c4ee382aacde15 time-0_3_37-470f9c4ebcfb97a1 toml-0_8_20-b9f11c4f8c54e863 toml_edit-0_22_24-265a869043520f6a tracing-0_1_41-f95fa3c0b6430cd1 tracing-chrome-0_7_2-69c67e5ad43699de tracing-subscriber-0_3_19-5f4c4d18551b276c unicase-2_8_1-8a7dec03eccfaf46 unicode-width-0_2_0-76d8e9c15baf673e url-2_5_4-659fce6bf9b29cb7 walkdir-2_5_0-1df263e29c1f7c83];
    passthru.rust_crate_parent = [cargo-0_88_0-script_build_run-c582da2c854a7f93];
    passthru.rust_script_build_run = [cargo-0_88_0-script_build_run-c582da2c854a7f93];
    phases = "unpackPhase buildPhase";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "src/cargo/lib.rs"
        "src/cargo/macros.rs"
        "src/cargo/core/mod.rs"
        "src/cargo/core/compiler/mod.rs"
        "src/cargo/core/compiler/artifact.rs"
        "src/cargo/core/compiler/build_config.rs"
        "src/cargo/core/compiler/build_context/mod.rs"
        "src/cargo/core/compiler/build_context/target_info.rs"
        "src/cargo/core/compiler/build_plan.rs"
        "src/cargo/core/compiler/build_runner/mod.rs"
        "src/cargo/core/compiler/build_runner/compilation_files.rs"
        "src/cargo/core/compiler/compilation.rs"
        "src/cargo/core/compiler/compile_kind.rs"
        "src/cargo/core/compiler/crate_type.rs"
        "src/cargo/core/compiler/custom_build.rs"
        "src/cargo/core/compiler/fingerprint/mod.rs"
        "src/cargo/core/compiler/fingerprint/dep_info.rs"
        "src/cargo/core/compiler/fingerprint/dirty_reason.rs"
        "src/cargo/core/compiler/future_incompat.rs"
        "src/cargo/core/compiler/job_queue/mod.rs"
        "src/cargo/core/compiler/job_queue/job.rs"
        "src/cargo/core/compiler/job_queue/job_state.rs"
        "src/cargo/core/compiler/layout.rs"
        "src/cargo/core/compiler/links.rs"
        "src/cargo/core/compiler/lto.rs"
        "src/cargo/core/compiler/nix_build/mod.rs"
        "src/cargo/core/compiler/nix_build/asserts.rs"
        "src/cargo/core/compiler/nix_build/deps.rs"
        "src/cargo/core/compiler/nix_build/nix_code.rs"
        "src/cargo/core/compiler/nix_build/nix_files.rs"
        "src/cargo/core/compiler/nix_build/tests.rs"
        "src/cargo/core/compiler/nix_build/download.rs"
        "src/cargo/core/compiler/nix_build/nix_build_runner/mod.rs"
        "src/cargo/core/compiler/nix_build/nix_build_runner/build_result_parser.rs"
        "src/cargo/core/compiler/nix_build/nix_build_runner/build_runner.rs"
        "src/cargo/core/compiler/output_depinfo.rs"
        "src/cargo/core/compiler/output_sbom.rs"
        "src/cargo/core/compiler/rustdoc.rs"
        "src/cargo/core/compiler/standard_lib.rs"
        "src/cargo/core/compiler/timings.rs"
        "src/cargo/core/compiler/unit.rs"
        "src/cargo/core/compiler/unit_dependencies.rs"
        "src/cargo/core/compiler/unit_graph.rs"
        "src/cargo/core/dependency.rs"
        "src/cargo/core/features.rs"
        "src/cargo/core/gc.rs"
        "src/cargo/core/global_cache_tracker.rs"
        "src/cargo/core/manifest.rs"
        "src/cargo/core/package.rs"
        "src/cargo/core/package_id.rs"
        "src/cargo/core/package_id_spec.rs"
        "src/cargo/core/profiles.rs"
        "src/cargo/core/registry.rs"
        "src/cargo/core/resolver/mod.rs"
        "src/cargo/core/resolver/conflict_cache.rs"
        "src/cargo/core/resolver/context.rs"
        "src/cargo/core/resolver/dep_cache.rs"
        "src/cargo/core/resolver/encode.rs"
        "src/cargo/core/resolver/errors.rs"
        "src/cargo/core/resolver/features.rs"
        "src/cargo/core/resolver/resolve.rs"
        "src/cargo/core/resolver/types.rs"
        "src/cargo/core/resolver/version_prefs.rs"
        "src/cargo/core/shell.rs"
        "src/cargo/core/source_id.rs"
        "src/cargo/core/summary.rs"
        "src/cargo/core/workspace.rs"
        "src/cargo/ops/mod.rs"
        "src/cargo/ops/cargo_add/mod.rs"
        "src/cargo/ops/cargo_add/crate_spec.rs"
        "src/cargo/ops/cargo_clean.rs"
        "src/cargo/ops/cargo_compile/mod.rs"
        "src/cargo/ops/cargo_compile/compile_filter.rs"
        "src/cargo/ops/cargo_compile/unit_generator.rs"
        "src/cargo/ops/cargo_compile/packages.rs"
        "src/cargo/ops/cargo_config.rs"
        "src/cargo/ops/cargo_doc.rs"
        "src/cargo/ops/cargo_fetch.rs"
        "src/cargo/ops/cargo_install.rs"
        "src/cargo/ops/cargo_new.rs"
        "src/cargo/ops/cargo_output_metadata.rs"
        "src/cargo/ops/cargo_package/mod.rs"
        "src/cargo/ops/cargo_package/vcs.rs"
        "src/cargo/ops/cargo_package/verify.rs"
        "src/cargo/ops/cargo_pkgid.rs"
        "src/cargo/ops/cargo_read_manifest.rs"
        "src/cargo/ops/cargo_remove.rs"
        "src/cargo/ops/cargo_run.rs"
        "src/cargo/ops/cargo_test.rs"
        "src/cargo/ops/cargo_uninstall.rs"
        "src/cargo/ops/cargo_update.rs"
        "src/cargo/ops/common_for_install_and_uninstall.rs"
        "src/cargo/ops/fix.rs"
        "src/cargo/ops/lockfile.rs"
        "src/cargo/ops/registry/mod.rs"
        "src/cargo/ops/registry/info/mod.rs"
        "src/cargo/ops/registry/info/view.rs"
        "src/cargo/ops/registry/login.rs"
        "src/cargo/ops/registry/logout.rs"
        "src/cargo/ops/registry/owner.rs"
        "src/cargo/ops/registry/publish.rs"
        "src/cargo/ops/registry/search.rs"
        "src/cargo/ops/registry/yank.rs"
        "src/cargo/ops/resolve.rs"
        "src/cargo/ops/tree/mod.rs"
        "src/cargo/ops/tree/format/mod.rs"
        "src/cargo/ops/tree/format/parse.rs"
        "src/cargo/ops/tree/graph.rs"
        "src/cargo/ops/vendor.rs"
        "src/cargo/sources/mod.rs"
        "src/cargo/sources/config.rs"
        "src/cargo/sources/directory.rs"
        "src/cargo/sources/git/mod.rs"
        "src/cargo/sources/git/known_hosts.rs"
        "src/cargo/sources/git/oxide.rs"
        "src/cargo/sources/git/source.rs"
        "src/cargo/sources/git/utils.rs"
        "src/cargo/sources/overlay.rs"
        "src/cargo/sources/path.rs"
        "src/cargo/sources/registry/mod.rs"
        "src/cargo/sources/registry/download.rs"
        "src/cargo/sources/registry/http_remote.rs"
        "src/cargo/sources/registry/index/mod.rs"
        "src/cargo/sources/registry/index/cache.rs"
        "src/cargo/sources/registry/local.rs"
        "src/cargo/sources/registry/remote.rs"
        "src/cargo/sources/replaced.rs"
        "src/cargo/sources/source.rs"
        "src/cargo/util/mod.rs"
        "src/cargo/util/auth/mod.rs"
        "src/cargo/util/cache_lock.rs"
        "src/cargo/util/canonical_url.rs"
        "src/cargo/util/command_prelude.rs"
        "src/cargo/util/context/mod.rs"
        "src/cargo/util/context/de.rs"
        "src/cargo/util/context/value.rs"
        "src/cargo/util/context/key.rs"
        "src/cargo/util/context/path.rs"
        "src/cargo/util/context/target.rs"
        "src/cargo/util/context/environment.rs"
        "src/cargo/util/counter.rs"
        "src/cargo/util/cpu.rs"
        "src/cargo/util/credential/mod.rs"
        "src/cargo/util/credential/adaptor.rs"
        "src/cargo/util/credential/paseto.rs"
        "src/cargo/util/credential/process.rs"
        "src/cargo/util/credential/token.rs"
        "src/cargo/util/dependency_queue.rs"
        "src/cargo/util/diagnostic_server.rs"
        "src/cargo/util/edit_distance.rs"
        "src/cargo/util/errors.rs"
        "src/cargo/util/flock.rs"
        "src/cargo/util/graph.rs"
        "src/cargo/util/hasher.rs"
        "src/cargo/util/hex.rs"
        "src/cargo/util/hostname.rs"
        "src/cargo/util/important_paths.rs"
        "src/cargo/util/interning.rs"
        "src/cargo/util/into_url.rs"
        "src/cargo/util/into_url_with_base.rs"
        "src/cargo/util/io.rs"
        "src/cargo/util/job.rs"
        "src/cargo/util/lints.rs"
        "src/cargo/util/lockserver.rs"
        "src/cargo/util/machine_message.rs"
        "src/cargo/util/network/mod.rs"
        "src/cargo/util/network/http.rs"
        "src/cargo/util/network/proxy.rs"
        "src/cargo/util/network/retry.rs"
        "src/cargo/util/network/sleep.rs"
        "src/cargo/util/progress.rs"
        "src/cargo/util/queue.rs"
        "src/cargo/util/restricted_names.rs"
        "src/cargo/util/rustc.rs"
        "src/cargo/util/semver_eval_ext.rs"
        "src/cargo/util/semver_ext.rs"
        "src/cargo/util/sqlite.rs"
        "src/cargo/util/style.rs"
        "src/cargo/util/toml/mod.rs"
        "src/cargo/util/toml/embedded.rs"
        "src/cargo/util/toml/targets.rs"
        "src/cargo/util/toml_mut/mod.rs"
        "src/cargo/util/toml_mut/dependency.rs"
        "src/cargo/util/toml_mut/manifest.rs"
        "src/cargo/util/toml_mut/upgrade.rs"
        "src/cargo/util/vcs.rs"
        "src/cargo/util/workspace.rs"
        "src/cargo/version.rs"
        "src/cargo/core/compiler/nix_build/templates/cargo_build_caller.nix.handlebars"
        "src/cargo/core/compiler/nix_build/templates/build_rs_libnix.nix.handlebars"
        "src/cargo/core/compiler/nix_build/templates/default.nix.handlebars"
        "src/cargo/core/compiler/nix_build/templates/target.nix.handlebars"
        "src/cargo/core/compiler/nix_build/templates/rustc-call.nix.handlebars"
        "src/cargo/core/compiler/timings.js"
      ];
    };

    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "cargo";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Cargo, a package manager for Rust.";
    CARGO_PKG_HOMEPAGE = "https://doc.rust-lang.org/cargo/index.html";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.88.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "88";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";
    CARGO_PRIMARY_PACKAGE = "1";
    CARGO_SBOM_PATH = "";

    buildPhase = ''
      ${fn.import_bash_function_helpers}
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)
      
      mkdir -p $out/nix
      export OUT_DIR=$out

      print_compiling_message "${name}"
      print_cargo_message_type_0 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}"
      copy_build_script_run_results_over_with_nix "${fn.get_rust_crate_parent passthru.rust_crate_parent}"
      for file in $out/environment-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
          if [ -f "$file" ]; then
          sed -i "s|${fn.get_rust_crate_parent passthru.rust_crate_parent}|$out|g" "$file"
          fi
      done
      load_environment_variables_from_files "${fn.environment_variables passthru.rust_script_build_run}"
      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      mkdir -p /tmp/out
      set -x +e

      ${RUSTC} \
              --crate-name cargo \
              $(if [ -d /incremental-target ]; then echo "-C incremental=/incremental-target"; fi) \
              --edition=2021 src/cargo/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=metadata,link \
              -C opt-level=3 \
              -C embed-bitcode=no \
              --allow=clippy::all \
              --warn=clippy::correctness \
              --warn=clippy::self_named_module_files \
              --warn=rust_2018_idioms \
              --allow=rustdoc::private_intra_doc_links \
              --warn=clippy::print_stdout \
              --warn=clippy::print_stderr \
              --warn=clippy::disallowed_methods \
              --warn=clippy::dbg_macro \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("all-static", "openssl", "vendored-libgit2", "vendored-openssl"))' \
              -C metadata=444e069d1510cfb9 \
              -C extra-filename=-b9aa49f38b781d3e \
              --out-dir /tmp/out \
              -C strip=debuginfo \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern annotate_snippets=${annotate-snippets-0_11_5-c27a2250c0f48ef5}/libannotate_snippets-c27a2250c0f48ef5.rmeta \
              --extern anstream=${anstream-0_6_18-59aa35a61b4ca0e8}/libanstream-59aa35a61b4ca0e8.rmeta \
              --extern anstyle=${anstyle-1_0_10-051477b24e08c8d1}/libanstyle-051477b24e08c8d1.rmeta \
              --extern anyhow=${anyhow-1_0_96-61bbc4e08b05614c}/libanyhow-61bbc4e08b05614c.rmeta \
              --extern base64=${base64-0_22_1-a69787aa05970cd3}/libbase64-a69787aa05970cd3.rmeta \
              --extern blake3=${blake3-1_6_1-ceb9e2c2787b1280}/libblake3-ceb9e2c2787b1280.rmeta \
              --extern build_rs_libnix=${build-rs-libnix-0_1_11-24a8729adbae7212}/libbuild_rs_libnix-24a8729adbae7212.rmeta \
              --extern cargo_credential=${cargo-credential-0_4_8-04d496e2b8c4b2ba}/libcargo_credential-04d496e2b8c4b2ba.rmeta \
              --extern cargo_credential_libsecret=${cargo-credential-libsecret-0_4_13-9f8a917365498280}/libcargo_credential_libsecret-9f8a917365498280.rmeta \
              --extern cargo_platform=${cargo-platform-0_2_0-9528fcbd58f1490b}/libcargo_platform-9528fcbd58f1490b.rmeta \
              --extern cargo_util=${cargo-util-0_2_20-ca8e56b3d4554315}/libcargo_util-ca8e56b3d4554315.rmeta \
              --extern cargo_util_schemas=${cargo-util-schemas-0_8_1-a76d1978f9d187be}/libcargo_util_schemas-a76d1978f9d187be.rmeta \
              --extern clap=${clap-4_5_31-436756512d3af050}/libclap-436756512d3af050.rmeta \
              --extern clap_complete=${clap_complete-4_5_46-4dce9b58b32b4c7b}/libclap_complete-4dce9b58b32b4c7b.rmeta \
              --extern color_print=${color-print-0_3_7-9618017c447b538d}/libcolor_print-9618017c447b538d.rmeta \
              --extern colored=${colored-3_1_1-86c9fae7f303dfbf}/libcolored-86c9fae7f303dfbf.rmeta \
              --extern crates_io=${crates-io-0_40_10-114ba05d6d48e004}/libcrates_io-114ba05d6d48e004.rmeta \
              --extern curl=${curl-0_4_47-8a5016373deb916e}/libcurl-8a5016373deb916e.rmeta \
              --extern curl_sys=${curl-sys-0_4_80_plus_curl-8_12_1-e26ceb4086d88aa5}/libcurl_sys-e26ceb4086d88aa5.rmeta \
              --extern filetime=${filetime-0_2_25-4a8c5a239dda911b}/libfiletime-4a8c5a239dda911b.rmeta \
              --extern flate2=${flate2-1_1_0-f05ad64f5d566c20}/libflate2-f05ad64f5d566c20.rmeta \
              --extern git2=${git2-0_20_0-50735b59c53beae1}/libgit2-50735b59c53beae1.rmeta \
              --extern git2_curl=${git2-curl-0_21_0-aa8fb836bc90345d}/libgit2_curl-aa8fb836bc90345d.rmeta \
              --extern gix=${gix-0_70_0-6ef08fee72b6f2df}/libgix-6ef08fee72b6f2df.rmeta \
              --extern glob=${glob-0_3_2-e53520df8dafaafd}/libglob-e53520df8dafaafd.rmeta \
              --extern handlebars=${handlebars-6_3_1-576dd3883f721609}/libhandlebars-576dd3883f721609.rmeta \
              --extern hex=${hex-0_4_3-d9f97d45c228789e}/libhex-d9f97d45c228789e.rmeta \
              --extern hmac=${hmac-0_12_1-bc3929f8e30dab3e}/libhmac-bc3929f8e30dab3e.rmeta \
              --extern home=${home-0_5_11-918f819357cab881}/libhome-918f819357cab881.rmeta \
              --extern http_auth=${http-auth-0_1_10-0efb6c0d40dfe9f2}/libhttp_auth-0efb6c0d40dfe9f2.rmeta \
              --extern ignore=${ignore-0_4_23-d7082c3c0c554a79}/libignore-d7082c3c0c554a79.rmeta \
              --extern im_rc=${im-rc-15_1_0-da56962fc462ba73}/libim_rc-da56962fc462ba73.rmeta \
              --extern indexmap=${indexmap-2_7_1-6b5f2f48a7e1007e}/libindexmap-6b5f2f48a7e1007e.rmeta \
              --extern indoc=${indoc-2_0_6-d096069012c7930c}/libindoc-d096069012c7930c.so \
              --extern itertools=${itertools-0_14_0-aa0fbdedc8514404}/libitertools-aa0fbdedc8514404.rmeta \
              --extern jiff=${jiff-0_2_3-c3af8ddf56e85995}/libjiff-c3af8ddf56e85995.rmeta \
              --extern jobserver=${jobserver-0_1_32-bf749e6aa2009df5}/libjobserver-bf749e6aa2009df5.rmeta \
              --extern lazycell=${lazycell-1_3_0-f94eeda76d97df1a}/liblazycell-f94eeda76d97df1a.rmeta \
              --extern libc=${libc-0_2_175-b265bb513a0388f3}/liblibc-b265bb513a0388f3.rmeta \
              --extern libgit2_sys=${libgit2-sys-0_18_0_plus_1_9_0-7c92f3a3d35092c8}/liblibgit2_sys-7c92f3a3d35092c8.rmeta \
              --extern logone=${logone-0_2_9-ae524b4cfa794eda}/liblogone-ae524b4cfa794eda.rmeta \
              --extern memchr=${memchr-2_7_4-a0e5828b48f06e07}/libmemchr-a0e5828b48f06e07.rmeta \
              --extern opener=${opener-0_7_2-62099bf816df8f93}/libopener-62099bf816df8f93.rmeta \
              --extern os_info=${os_info-3_10_0-110090feb8887db7}/libos_info-110090feb8887db7.rmeta \
              --extern pasetors=${pasetors-0_7_2-ec9d83f095443be2}/libpasetors-ec9d83f095443be2.rmeta \
              --extern pathdiff=${pathdiff-0_2_3-1e0bf37cc5ac710a}/libpathdiff-1e0bf37cc5ac710a.rmeta \
              --extern rand=${rand-0_9_0-9c1f064fb8df1dbe}/librand-9c1f064fb8df1dbe.rmeta \
              --extern regex=${regex-1_11_1-78f28ee524c2cf84}/libregex-78f28ee524c2cf84.rmeta \
              --extern rusqlite=${rusqlite-0_33_0-8c318caee200e796}/librusqlite-8c318caee200e796.rmeta \
              --extern rustc_hash=${rustc-hash-2_1_1-56f40b181a89ccb3}/librustc_hash-56f40b181a89ccb3.rmeta \
              --extern rustc_stable_hash=${rustc-stable-hash-0_1_2-b8337645b79370b8}/librustc_stable_hash-b8337645b79370b8.rmeta \
              --extern rustfix=${rustfix-0_9_0-f92d91d9c29999cf}/librustfix-f92d91d9c29999cf.rmeta \
              --extern same_file=${same-file-1_0_6-c702782bc8f9cf83}/libsame_file-c702782bc8f9cf83.rmeta \
              --extern semver=${semver-1_0_25-66c86f3f308501e7}/libsemver-66c86f3f308501e7.rmeta \
              --extern serde=${serde-1_0_218-ed8707ff8dc168e7}/libserde-ed8707ff8dc168e7.rmeta \
              --extern serde_untagged=${serde-untagged-0_1_6-c26af987742396e6}/libserde_untagged-c26af987742396e6.rmeta \
              --extern serde_ignored=${serde_ignored-0_1_10-71b955e71e7f10ed}/libserde_ignored-71b955e71e7f10ed.rmeta \
              --extern serde_json=${serde_json-1_0_139-17182eb61f3853cc}/libserde_json-17182eb61f3853cc.rmeta \
              --extern sha1=${sha1-0_10_6-0cf4bfd2ea90fd1c}/libsha1-0cf4bfd2ea90fd1c.rmeta \
              --extern shell_escape=${shell-escape-0_1_5-2dddd153d3f4fa85}/libshell_escape-2dddd153d3f4fa85.rmeta \
              --extern supports_hyperlinks=${supports-hyperlinks-3_1_0-047db521a6002c93}/libsupports_hyperlinks-047db521a6002c93.rmeta \
              --extern supports_unicode=${supports-unicode-3_0_0-fe8b7a4d9f1dccb8}/libsupports_unicode-fe8b7a4d9f1dccb8.rmeta \
              --extern tar=${tar-0_4_44-ec5e86963dbd14f3}/libtar-ec5e86963dbd14f3.rmeta \
              --extern tempfile=${tempfile-3_17_1-b08d0e8469fdeafa}/libtempfile-b08d0e8469fdeafa.rmeta \
              --extern thiserror=${thiserror-2_0_11-c6c4ee382aacde15}/libthiserror-c6c4ee382aacde15.rmeta \
              --extern time=${time-0_3_37-470f9c4ebcfb97a1}/libtime-470f9c4ebcfb97a1.rmeta \
              --extern toml=${toml-0_8_20-b9f11c4f8c54e863}/libtoml-b9f11c4f8c54e863.rmeta \
              --extern toml_edit=${toml_edit-0_22_24-265a869043520f6a}/libtoml_edit-265a869043520f6a.rmeta \
              --extern tracing=${tracing-0_1_41-f95fa3c0b6430cd1}/libtracing-f95fa3c0b6430cd1.rmeta \
              --extern tracing_chrome=${tracing-chrome-0_7_2-69c67e5ad43699de}/libtracing_chrome-69c67e5ad43699de.rmeta \
              --extern tracing_subscriber=${tracing-subscriber-0_3_19-5f4c4d18551b276c}/libtracing_subscriber-5f4c4d18551b276c.rmeta \
              --extern unicase=${unicase-2_8_1-8a7dec03eccfaf46}/libunicase-8a7dec03eccfaf46.rmeta \
              --extern unicode_width=${unicode-width-0_2_0-76d8e9c15baf673e}/libunicode_width-76d8e9c15baf673e.rmeta \
              --extern url=${url-2_5_4-659fce6bf9b29cb7}/liburl-659fce6bf9b29cb7.rmeta \
              --extern walkdir=${walkdir-2_5_0-1df263e29c1f7c83}/libwalkdir-1df263e29c1f7c83.rmeta 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
                
      print_rustc_rendered_messages $rustc_json_output_lines
      
      print_cargo_message_type_2 "${name}" "${meta.cargo_crate_info.name}" "${meta.cargo_crate_info.type}" $rustc_exit_value $rustc_json_output_lines
      
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
      mkdir -p $out/
      cp -r /tmp/out/* $out
    '';

}
