# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root, cargo-0_88_0-script_build_run-f5d51778f22880c0, cargo-credential-0_4_8-a5adc6ab9fe103b0, cargo-credential-libsecret-0_4_13-4e698a0b35f72d06, cargo-platform-0_2_0-c5f768769f22a333, cargo-util-0_2_20-7087e4a73afc7b23, cargo-util-schemas-0_8_1-bce7b79eff35b46a, crates-io-0_40_10-cb0425982b906266, rustfix-0_9_0-9f1c66820d29e14a }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-0_88_0-27e7993d9cf32df7";
    meta.cargo_crate_info = {
      name = "cargo";
      version = "0.88.0";
      crate_hash = "27e7993d9cf32df7";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [annotate-snippets-0_11_5-4d47bac9cbcd3256 anstream-0_6_18-3af54164fe68ad61 anstyle-1_0_10-bf6d032cb7d79be1 anyhow-1_0_96-139173be5e005a44 base64-0_22_1-169e80cc244b88d1 blake3-1_6_1-3250b34f7bcecb8a cargo-credential-0_4_8-a5adc6ab9fe103b0 cargo-credential-libsecret-0_4_13-4e698a0b35f72d06 cargo-platform-0_2_0-c5f768769f22a333 cargo-util-0_2_20-7087e4a73afc7b23 cargo-util-schemas-0_8_1-bce7b79eff35b46a clap-4_5_31-a6f5f68162f5c661 clap_complete-4_5_46-aac8805c5395ded9 color-print-0_3_7-4ae3eda36d442220 crates-io-0_40_10-cb0425982b906266 curl-0_4_47-f684c2bd7b0f950d curl-sys-0_4_80_plus_curl-8_12_1-db5fbe1d9680c71f filetime-0_2_25-36b58a90b887714e flate2-1_1_0-8e647ae5b177ac6d git2-0_20_0-a5a6e57aa11f1a77 git2-curl-0_21_0-d43c11566cc114b0 gix-0_70_0-992c380a7e61bb6a glob-0_3_2-544549cd000b48bc handlebars-6_3_1-1d5c39ccada6570e hex-0_4_3-ccbbd905e94f34bd hmac-0_12_1-84aacd8a0108f7c5 home-0_5_11-43ef4c896a7488bc http-auth-0_1_10-b3940f62a0eee11f ignore-0_4_23-dab7af6f0867647c im-rc-15_1_0-6db31ca18b586012 indexmap-2_7_1-dcbfc0f8f5b442a0 indoc-2_0_6-3e36bbc9b09ee6b1 itertools-0_14_0-27edccb8d0332424 jiff-0_2_3-16345f2ab32d9b14 jobserver-0_1_32-04274db7c36dbe6c lazycell-1_3_0-5468cb6502e4542b libc-0_2_175-df0687d6868fdede libgit2-sys-0_18_0_plus_1_9_0-86c4b3f8f5bf526a logone-0_2_7-1eb55177eedd2e91 memchr-2_7_4-3cee6db17bbe0dde opener-0_7_2-e60a19764aabfbee os_info-3_10_0-1475caac7a528f34 pasetors-0_7_2-0e3e06d4cbb54d3a pathdiff-0_2_3-4adfc518be1c04af rand-0_9_0-6c716ea579f406d5 regex-1_11_1-c278e9a7e455d20f rusqlite-0_33_0-0e7a13217d933375 rustc-hash-2_1_1-eecec28cc151ccd3 rustc-stable-hash-0_1_2-5e3739f6900f7bdf rustfix-0_9_0-9f1c66820d29e14a same-file-1_0_6-82920d733726b0a3 semver-1_0_25-44d2ac63fb520e42 serde-1_0_218-472e28b9f131b02c serde-untagged-0_1_6-6d07b1ee988da762 serde_ignored-0_1_10-dc3c1b953dc9ba97 serde_json-1_0_139-ae78ec5bae97c420 sha1-0_10_6-7f98ce853a3fd8dc shell-escape-0_1_5-fc06a701b65fbe9d supports-hyperlinks-3_1_0-d01c256720ea7038 supports-unicode-3_0_0-bf24266a6bf9ea5d tar-0_4_44-1da5ced4b8e7e118 tempfile-3_17_1-94ecc3046797cc75 thiserror-2_0_11-a57592ffa4ea41e0 time-0_3_37-b73d8cae561973b7 toml-0_8_20-7a483d12a9e19406 toml_edit-0_22_24-24142c1671b8cfdf tracing-0_1_41-7b5284fa1d5dcd0d tracing-chrome-0_7_2-5b548189b83dd8d2 tracing-subscriber-0_3_19-8f98042188b2d3ba unicase-2_8_1-07d4133086b7fec6 unicode-width-0_2_0-0c384aa902aa0aa2 url-2_5_4-7b68be8bb56d0713 walkdir-2_5_0-742d7f303f7cfcda];
    passthru.rust_crate_parent = [cargo-0_88_0-script_build_run-f5d51778f22880c0];
    passthru.rust_script_build_run = [cargo-0_88_0-script_build_run-f5d51778f22880c0];
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
        "src/cargo/core/compiler/nix_build/templates/default.nix.handlebars"
        "src/cargo/core/compiler/nix_build/templates/target.nix.handlebars"
        "src/cargo/core/compiler/nix_build/templates/rustc-call.nix.handlebars"
        "src/cargo/core/compiler/timings.js"
      ];
    };

    # src = builtins.filterSource
    #   (path: type:
    #     let base = baseNameOf path;
    #     in !(base == "target" || base == "result" || builtins.match "result-*" base != null)
    #   ) /home/nixos/cargo;
    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

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
    #RUSTC_LOG="rustc_incremental=info";
    #RUSTC_LOG="rustc_incremental=trace";
    #RUSTFLAGS="-Z incremental-verbose";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m cargo-0_88_0-27e7993d9cf32df7"
      echo "@cargo { \"type\":0, \"crate_name\":\"cargo\", \"id\":\"cargo-0_88_0-27e7993d9cf32df7\" }"
      cp -r ${fn.get_rust_crate_parent passthru.rust_crate_parent}/* $OUT_DIR
      
      for file in $out/environment-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
          if [ -f "$file" ]; then
          sed -i "s|${fn.get_rust_crate_parent passthru.rust_crate_parent}|$out|g" "$file"
          fi
      done
      for file in ${fn.environment_variables passthru.rust_script_build_run}; do
        if [ -f $file ]; then
          set -a
            while read -r line; do
              echo -e "\033[38;5;208m$line\033[0m"
            done < "$file"
            source $file
            set +a
        fi
      done


#env
#pwd
#exit 1





# for file in src/cargo/lib.rs src/cargo/macros.rs src/cargo/core/mod.rs src/cargo/core/compiler/mod.rs src/cargo/core/compiler/artifact.rs src/cargo/core/compiler/build_config.rs src/cargo/core/compiler/build_context/mod.rs src/cargo/core/compiler/build_context/target_info.rs src/cargo/core/compiler/build_plan.rs src/cargo/core/compiler/build_runner/mod.rs src/cargo/core/compiler/build_runner/compilation_files.rs src/cargo/core/compiler/compilation.rs src/cargo/core/compiler/compile_kind.rs src/cargo/core/compiler/crate_type.rs src/cargo/core/compiler/custom_build.rs src/cargo/core/compiler/fingerprint/mod.rs src/cargo/core/compiler/fingerprint/dep_info.rs src/cargo/core/compiler/fingerprint/dirty_reason.rs src/cargo/core/compiler/future_incompat.rs src/cargo/core/compiler/job_queue/mod.rs src/cargo/core/compiler/job_queue/job.rs src/cargo/core/compiler/job_queue/job_state.rs src/cargo/core/compiler/layout.rs src/cargo/core/compiler/links.rs src/cargo/core/compiler/lto.rs src/cargo/core/compiler/nix_build/mod.rs src/cargo/core/compiler/nix_build/asserts.rs src/cargo/core/compiler/nix_build/download.rs src/cargo/core/compiler/nix_build/nix_build_runner/mod.rs src/cargo/core/compiler/nix_build/nix_build_runner/build_result_parser.rs src/cargo/core/compiler/nix_build/nix_build_runner/build_runner.rs src/cargo/core/compiler/output_depinfo.rs src/cargo/core/compiler/output_sbom.rs src/cargo/core/compiler/rustdoc.rs src/cargo/core/compiler/standard_lib.rs src/cargo/core/compiler/timings.rs src/cargo/core/compiler/unit.rs src/cargo/core/compiler/unit_dependencies.rs src/cargo/core/compiler/unit_graph.rs src/cargo/core/dependency.rs src/cargo/core/features.rs; do start_time=$(date +%s%3N)
#       start_time=$(date +%s%3N)
#       set +x +e

#       ${RUSTC} \
#               --crate-name cargo \
#               --edition=2021 $file \
#               --error-format=json \
#               --json=diagnostic-rendered-ansi,artifacts,future-incompat \
#               --crate-type lib \
#               --emit=dep-info,metadata,link \
#               -C embed-bitcode=no \
#               -C debuginfo=2 \
#               --allow=clippy::all \
#               --warn=clippy::correctness \
#               --warn=clippy::self_named_module_files \
#               --warn=rust_2018_idioms \
#               --allow=rustdoc::private_intra_doc_links \
#               --warn=clippy::print_stdout \
#               --warn=clippy::print_stderr \
#               --warn=clippy::disallowed_methods \
#               --warn=clippy::dbg_macro \
#               ${fn.rustc_arguments passthru.rust_crate_parent} \
#               --check-cfg 'cfg(docsrs,test)' \
#               --check-cfg 'cfg(feature, values("all-static", "openssl", "vendored-libgit2", "vendored-openssl"))' \
#               -C metadata=8abf83ef020a3059 \
#               -C extra-filename=-27e7993d9cf32df7 \
#               --out-dir $OUT_DIR  2>/dev/null
#       end_time=$(date +%s%3N)
#       elapsed=$(( end_time - start_time ))
#       echo "--------------- $file ------------------"
#       echo "Elapsed time for $file : $elapsed ms"
#       cat $out/cargo-27e7993d9cf32df7.d
#       echo "--------------- / $file ------------------"
# done
#       exit 1


  #     start_time=$(date +%s%3N)
  #     set -x +e
  #  ${RUSTC} \
  #             --crate-name cargo \
  #             --edition=2021 src/cargo/lib.rs \
  #             --crate-type lib \
  #             --emit=dep-info \
  #             ${fn.rustc_arguments passthru.rust_crate_parent} \
  #             --check-cfg 'cfg(docsrs,test)' \
  #             --check-cfg 'cfg(feature, values("all-static", "openssl", "vendored-libgit2", "vendored-openssl"))' \
  #             -C metadata=8abf83ef020a3059 \
  #             -C extra-filename=-8abf83ef020a3059 \
  #             --out-dir $OUT_DIR 2>/dev/null
  #     end_time=$(date +%s%3N)
  #     elapsed=$(( end_time - start_time ))
  #     echo "Elapsed time between XXX and YYY: $elapsed ms"
  #     cat $out/*.d | grep -e ":$" | wc -l
  #     exit 1



  #   Running `rustc --crate-name build_script_build --edition=2018 /home/nixos/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/curl-sys-0.4.80+curl-8.12.1/build.rs --error-format=json --json=diagnostic-rendered-ansi,artifacts,future-incompat --diagnostic-width=181 --crate-type bin --emit=dep-info,link -C embed-bitcode=no --cfg 'feature="default"' --cfg 'feature="http2"' --cfg 'feature="libnghttp2-sys"' --cfg 'feature="openssl-sys"' --cfg 'feature="ssl"' --check-cfg 'cfg(docsrs,test)' --check-cfg 'cfg(feature, values("default", "force-system-lib-on-osx", "http2", "libnghttp2-sys", "mesalink", "ntlm", "openssl-sys", "poll_7_68_0", "protocol-ftp", "rustls", "rustls-ffi", "spnego", "ssl", "static-curl", "static-ssl", "upkeep_7_62_0", "windows-static-ssl", "zlib-ng-compat"))' -C metadata=59af2ac95a07b57a -C extra-filename=-8f2a8f1c538d4492 --out-dir /home/nixos/cargo/target/debug/build/curl-sys-8f2a8f1c538d4492 -L dependency=/home/nixos/cargo/target/debug/deps --extern cc=/home/nixos/cargo/target/debug/deps/libcc-af64f1102f40881f.rlib --extern pkg_config=/home/nixos/cargo/target/debug/deps/libpkg_config-9f951027c189d1c8.rlib --cap-lints allow`
  #    Running `/home/nixos/cargo/target/debug/build/libnghttp2-sys-bd4b61ea3dbf0aa0/build-script-build`
  #      Dirty serde_derive v1.0.218: the dependency proc_macro2 was rebuilt
  #  Compiling serde_derive v1.0.218
  #    Running `rustc --crate-name serde_derive --edition=2015 /home/nixos/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_derive-1.0.218/src/lib.rs --error-format=json --json=diagnostic-rendered-ansi,artifacts,future-incompat --diagnostic-width=181 --crate-type proc-macro --emit=dep-info,link -C prefer-dynamic -C embed-bitcode=no --cfg 'feature="default"' --check-cfg 'cfg(docsrs,test)' --check-cfg 'cfg(feature, values("default", "deserialize_in_place"))' -C metadata=5a0b817ec9dbb616 -C extra-filename=-9c5dc85d8202c295 --out-dir /home/nixos/cargo/target/debug/deps -L dependency=/home/nixos/cargo/target/debug/deps --extern proc_macro2=/home/nixos/cargo/target/debug/deps/libproc_macro2-e21101aa04a927ed.rlib --extern quote=/home/nixos/cargo/target/debug/deps/libquote-c701a81a3cabe41c.rlib --extern syn=/home/nixos/cargo/target/debug/deps/libsyn-fba6ed2458f875ca.rlib --extern proc_macro --cap-lints allow`

#ls -la ${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps
#exit 1

#ls -la /incremental-target
#du -a  /incremental-target
#exit 1
              # --error-format=json \
              # --json=diagnostic-rendered-ansi,artifacts,future-incompat \

    #          ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
     #        
 #mkdir -p $out/inc
      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      
      #set RUSTC_LOG=rustc_incremental=info 
      #export 
      #RUSTC_LOG=rustc_incremental=info 

      mkdir -p $out/
      mkdir -p /tmp/out

#              -Z incremental-info \

      ${RUSTC} -v \
              --crate-name cargo \
              $(if [ -d /incremental-target ]; then echo "-C incremental=/incremental-target"; fi) \
              --edition=2021 src/cargo/lib.rs \
              --crate-type lib \
              --emit=metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              -C split-debuginfo=unpacked \
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
              -C metadata=8abf83ef020a3059 \
              -C extra-filename=-27e7993d9cf32df7 \
              --out-dir /tmp/out \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              --extern annotate_snippets=${annotate-snippets-0_11_5-4d47bac9cbcd3256}/libannotate_snippets-4d47bac9cbcd3256.rlib \
              --extern anstream=${anstream-0_6_18-3af54164fe68ad61}/libanstream-3af54164fe68ad61.rlib \
              --extern anstyle=${anstyle-1_0_10-bf6d032cb7d79be1}/libanstyle-bf6d032cb7d79be1.rlib \
              --extern anyhow=${anyhow-1_0_96-139173be5e005a44}/libanyhow-139173be5e005a44.rlib \
              --extern base64=${base64-0_22_1-169e80cc244b88d1}/libbase64-169e80cc244b88d1.rlib \
              --extern blake3=${blake3-1_6_1-3250b34f7bcecb8a}/libblake3-3250b34f7bcecb8a.rlib \
              --extern cargo_credential=${cargo-credential-0_4_8-a5adc6ab9fe103b0}/libcargo_credential-a5adc6ab9fe103b0.rlib \
              --extern cargo_credential_libsecret=${cargo-credential-libsecret-0_4_13-4e698a0b35f72d06}/libcargo_credential_libsecret-4e698a0b35f72d06.rlib \
              --extern cargo_platform=${cargo-platform-0_2_0-c5f768769f22a333}/libcargo_platform-c5f768769f22a333.rlib \
              --extern cargo_util=${cargo-util-0_2_20-7087e4a73afc7b23}/libcargo_util-7087e4a73afc7b23.rlib \
              --extern cargo_util_schemas=${cargo-util-schemas-0_8_1-bce7b79eff35b46a}/libcargo_util_schemas-bce7b79eff35b46a.rlib \
              --extern clap=${clap-4_5_31-a6f5f68162f5c661}/libclap-a6f5f68162f5c661.rlib \
              --extern clap_complete=${clap_complete-4_5_46-aac8805c5395ded9}/libclap_complete-aac8805c5395ded9.rlib \
              --extern color_print=${color-print-0_3_7-4ae3eda36d442220}/libcolor_print-4ae3eda36d442220.rlib \
              --extern crates_io=${crates-io-0_40_10-cb0425982b906266}/libcrates_io-cb0425982b906266.rlib \
              --extern curl=${curl-0_4_47-f684c2bd7b0f950d}/libcurl-f684c2bd7b0f950d.rlib \
              --extern curl_sys=${curl-sys-0_4_80_plus_curl-8_12_1-db5fbe1d9680c71f}/libcurl_sys-db5fbe1d9680c71f.rlib \
              --extern filetime=${filetime-0_2_25-36b58a90b887714e}/libfiletime-36b58a90b887714e.rlib \
              --extern flate2=${flate2-1_1_0-8e647ae5b177ac6d}/libflate2-8e647ae5b177ac6d.rlib \
              --extern git2=${git2-0_20_0-a5a6e57aa11f1a77}/libgit2-a5a6e57aa11f1a77.rlib \
              --extern git2_curl=${git2-curl-0_21_0-d43c11566cc114b0}/libgit2_curl-d43c11566cc114b0.rlib \
              --extern gix=${gix-0_70_0-992c380a7e61bb6a}/libgix-992c380a7e61bb6a.rlib \
              --extern glob=${glob-0_3_2-544549cd000b48bc}/libglob-544549cd000b48bc.rlib \
              --extern handlebars=${handlebars-6_3_1-1d5c39ccada6570e}/libhandlebars-1d5c39ccada6570e.rlib \
              --extern hex=${hex-0_4_3-ccbbd905e94f34bd}/libhex-ccbbd905e94f34bd.rlib \
              --extern hmac=${hmac-0_12_1-84aacd8a0108f7c5}/libhmac-84aacd8a0108f7c5.rlib \
              --extern home=${home-0_5_11-43ef4c896a7488bc}/libhome-43ef4c896a7488bc.rlib \
              --extern http_auth=${http-auth-0_1_10-b3940f62a0eee11f}/libhttp_auth-b3940f62a0eee11f.rlib \
              --extern ignore=${ignore-0_4_23-dab7af6f0867647c}/libignore-dab7af6f0867647c.rlib \
              --extern im_rc=${im-rc-15_1_0-6db31ca18b586012}/libim_rc-6db31ca18b586012.rlib \
              --extern indexmap=${indexmap-2_7_1-dcbfc0f8f5b442a0}/libindexmap-dcbfc0f8f5b442a0.rlib \
              --extern indoc=${indoc-2_0_6-3e36bbc9b09ee6b1}/libindoc-3e36bbc9b09ee6b1.so \
              --extern itertools=${itertools-0_14_0-27edccb8d0332424}/libitertools-27edccb8d0332424.rlib \
              --extern jiff=${jiff-0_2_3-16345f2ab32d9b14}/libjiff-16345f2ab32d9b14.rlib \
              --extern jobserver=${jobserver-0_1_32-04274db7c36dbe6c}/libjobserver-04274db7c36dbe6c.rlib \
              --extern lazycell=${lazycell-1_3_0-5468cb6502e4542b}/liblazycell-5468cb6502e4542b.rlib \
              --extern libc=${libc-0_2_175-df0687d6868fdede}/liblibc-df0687d6868fdede.rlib \
              --extern libgit2_sys=${libgit2-sys-0_18_0_plus_1_9_0-86c4b3f8f5bf526a}/liblibgit2_sys-86c4b3f8f5bf526a.rlib \
              --extern logone=${logone-0_2_7-1eb55177eedd2e91}/liblogone-1eb55177eedd2e91.rlib \
              --extern memchr=${memchr-2_7_4-3cee6db17bbe0dde}/libmemchr-3cee6db17bbe0dde.rlib \
              --extern opener=${opener-0_7_2-e60a19764aabfbee}/libopener-e60a19764aabfbee.rlib \
              --extern os_info=${os_info-3_10_0-1475caac7a528f34}/libos_info-1475caac7a528f34.rlib \
              --extern pasetors=${pasetors-0_7_2-0e3e06d4cbb54d3a}/libpasetors-0e3e06d4cbb54d3a.rlib \
              --extern pathdiff=${pathdiff-0_2_3-4adfc518be1c04af}/libpathdiff-4adfc518be1c04af.rlib \
              --extern rand=${rand-0_9_0-6c716ea579f406d5}/librand-6c716ea579f406d5.rlib \
              --extern regex=${regex-1_11_1-c278e9a7e455d20f}/libregex-c278e9a7e455d20f.rlib \
              --extern rusqlite=${rusqlite-0_33_0-0e7a13217d933375}/librusqlite-0e7a13217d933375.rlib \
              --extern rustc_hash=${rustc-hash-2_1_1-eecec28cc151ccd3}/librustc_hash-eecec28cc151ccd3.rlib \
              --extern rustc_stable_hash=${rustc-stable-hash-0_1_2-5e3739f6900f7bdf}/librustc_stable_hash-5e3739f6900f7bdf.rlib \
              --extern rustfix=${rustfix-0_9_0-9f1c66820d29e14a}/librustfix-9f1c66820d29e14a.rlib \
              --extern same_file=${same-file-1_0_6-82920d733726b0a3}/libsame_file-82920d733726b0a3.rlib \
              --extern semver=${semver-1_0_25-44d2ac63fb520e42}/libsemver-44d2ac63fb520e42.rlib \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rlib \
              --extern serde_untagged=${serde-untagged-0_1_6-6d07b1ee988da762}/libserde_untagged-6d07b1ee988da762.rlib \
              --extern serde_ignored=${serde_ignored-0_1_10-dc3c1b953dc9ba97}/libserde_ignored-dc3c1b953dc9ba97.rlib \
              --extern serde_json=${serde_json-1_0_139-ae78ec5bae97c420}/libserde_json-ae78ec5bae97c420.rlib \
              --extern sha1=${sha1-0_10_6-7f98ce853a3fd8dc}/libsha1-7f98ce853a3fd8dc.rlib \
              --extern shell_escape=${shell-escape-0_1_5-fc06a701b65fbe9d}/libshell_escape-fc06a701b65fbe9d.rlib \
              --extern supports_hyperlinks=${supports-hyperlinks-3_1_0-d01c256720ea7038}/libsupports_hyperlinks-d01c256720ea7038.rlib \
              --extern supports_unicode=${supports-unicode-3_0_0-bf24266a6bf9ea5d}/libsupports_unicode-bf24266a6bf9ea5d.rlib \
              --extern tar=${tar-0_4_44-1da5ced4b8e7e118}/libtar-1da5ced4b8e7e118.rlib \
              --extern tempfile=${tempfile-3_17_1-94ecc3046797cc75}/libtempfile-94ecc3046797cc75.rlib \
              --extern thiserror=${thiserror-2_0_11-a57592ffa4ea41e0}/libthiserror-a57592ffa4ea41e0.rlib \
              --extern time=${time-0_3_37-b73d8cae561973b7}/libtime-b73d8cae561973b7.rlib \
              --extern toml=${toml-0_8_20-7a483d12a9e19406}/libtoml-7a483d12a9e19406.rlib \
              --extern toml_edit=${toml_edit-0_22_24-24142c1671b8cfdf}/libtoml_edit-24142c1671b8cfdf.rlib \
              --extern tracing=${tracing-0_1_41-7b5284fa1d5dcd0d}/libtracing-7b5284fa1d5dcd0d.rlib \
              --extern tracing_chrome=${tracing-chrome-0_7_2-5b548189b83dd8d2}/libtracing_chrome-5b548189b83dd8d2.rlib \
              --extern tracing_subscriber=${tracing-subscriber-0_3_19-8f98042188b2d3ba}/libtracing_subscriber-8f98042188b2d3ba.rlib \
              --extern unicase=${unicase-2_8_1-07d4133086b7fec6}/libunicase-07d4133086b7fec6.rlib \
              --extern unicode_width=${unicode-width-0_2_0-0c384aa902aa0aa2}/libunicode_width-0c384aa902aa0aa2.rlib \
              --extern url=${url-2_5_4-7b68be8bb56d0713}/liburl-7b68be8bb56d0713.rlib \
              --extern walkdir=${walkdir-2_5_0-742d7f303f7cfcda}/libwalkdir-742d7f303f7cfcda.rlib 
      rustc_exit_value=$?
      set +x -e

      cp -R /tmp/out/* $out/

      #cat $rustc_json_output_lines
           
      # print errors
      # while IFS= read -r line
      # do
      #     tmpFile=$(${pkgs.mktemp}/bin/mktemp)
      #     echo "$line" > $tmpFile
      #     ${pkgs.jq}/bin/jq -r -c 'select(."$message_type"=="diagnostic") | .rendered' $tmpFile
      # done < $rustc_json_output_lines
      
      
      # return structured formatted errors for later processing
      # output=$(${pkgs.jq}/bin/jq -s -r -c \
      #     --arg fullname "cargo-0_88_0-27e7993d9cf32df7" \
      #     --arg crate_name "cargo" \
      #     --arg exit_code "$rustc_exit_value" \
      #     '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
      #     "$rustc_json_output_lines")
      # printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
