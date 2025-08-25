# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps, cargo-0_88_0-script_build_run-dc81d07243ae70b8, cargo-credential-0_4_8-b614317587c5a56a, cargo-credential-libsecret-0_4_13-29580c6ca7639f8c, cargo-platform-0_2_0-bd48cbd44bf645fb, cargo-util-0_2_20-e1e52a96aad3a2c8, cargo-util-schemas-0_8_1-46ed49ab1cd04c33, crates-io-0_40_10-42ca41081e6e1fa6, rustfix-0_9_0-3994058f2b66a27c }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-0_88_0-d76731b471aa2da9";
    meta.cargo_crate_info = {
      name = "cargo";
      version = "0.88.0";
      crate_hash = "d76731b471aa2da9";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [annotate-snippets-0_11_5-a7212a9a74faaa3f anstream-0_6_18-37605a02f0fac906 anstyle-1_0_10-894b0e78f8d7fc16 anyhow-1_0_96-08accda0b9ade607 base64-0_22_1-b113dbe7721f305b blake3-1_6_1-b0c91102793b237d cargo-credential-0_4_8-b614317587c5a56a cargo-credential-libsecret-0_4_13-29580c6ca7639f8c cargo-platform-0_2_0-bd48cbd44bf645fb cargo-util-0_2_20-e1e52a96aad3a2c8 cargo-util-schemas-0_8_1-46ed49ab1cd04c33 clap-4_5_31-a895b6c8d0e21ec4 clap_complete-4_5_46-5f1dfb943e043129 color-print-0_3_7-93904ff317cf4c47 crates-io-0_40_10-42ca41081e6e1fa6 curl-0_4_47-4c74e17a5eefce17 curl-sys-0_4_80_plus_curl-8_12_1-10be63f25564e28e filetime-0_2_25-862af764b19c0992 flate2-1_1_0-38509094c93956ab git2-0_20_0-73cd3d9b5537d1b3 git2-curl-0_21_0-6b25165e10b2c3e8 gix-0_70_0-833dfa597e0c3507 glob-0_3_2-d15d76c0231059af handlebars-6_3_1-5c73ade78aa41eb5 hex-0_4_3-dd0d71cb863a3089 hmac-0_12_1-fd2e0dad2a9c7cc4 home-0_5_11-aaab8970bcca687f http-auth-0_1_10-5a8a3e7f7c6b8cf6 ignore-0_4_23-853f4c5fbe46d77c im-rc-15_1_0-c80c253ce789d440 indexmap-2_7_1-578007b5dcfb0e2f indoc-2_0_6-13909eb38cbcdb1a itertools-0_14_0-21d508070d3c88fa jiff-0_2_3-324a8733dc2072b7 jobserver-0_1_32-11f288c905f4bb8b lazycell-1_3_0-ac2e73bc4c6a0582 libc-0_2_170-d46a143b0470970d libgit2-sys-0_18_0_plus_1_9_0-f11a39420c489c62 memchr-2_7_4-df7138072aead54d opener-0_7_2-f98762a50dd3b0a6 os_info-3_10_0-65200209af10267c pasetors-0_7_2-58098e8bbd680953 pathdiff-0_2_3-db5f2acff7ea901e rand-0_9_0-65d47f0643c68ae7 regex-1_11_1-81271cb7b4167e0c rusqlite-0_33_0-482fe49309905af7 rustc-hash-2_1_1-be14e71c30fcb538 rustc-stable-hash-0_1_2-f58afbf2a98ba869 rustfix-0_9_0-3994058f2b66a27c same-file-1_0_6-fa3759c6ae4b4446 semver-1_0_25-da00f457d140fad0 serde-1_0_218-c4e47f01a1cedfa0 serde-untagged-0_1_6-6b39be11e9642e68 serde_ignored-0_1_10-d53ad3a476cabeba serde_json-1_0_139-578ab230a253fef1 sha1-0_10_6-67f712219a142979 shell-escape-0_1_5-3e2e155bbe040858 supports-hyperlinks-3_1_0-456eae7aa61f6d0f supports-unicode-3_0_0-3d239df88dbd39bf tar-0_4_44-6f385aa67f40a316 tempfile-3_17_1-54a70dc79c182b90 thiserror-2_0_11-266d93aab4cee78a time-0_3_37-913b3e2f5fba81ad toml-0_8_20-50efb42ce9e83b37 toml_edit-0_22_24-1991cc4beab81340 tracing-0_1_41-4ef8fb354e141157 tracing-chrome-0_7_2-ac9a4cc9edeed658 tracing-subscriber-0_3_19-58efa32ae6e128ef unicase-2_8_1-1d2f15b5b2c0a78e unicode-width-0_2_0-26c2c85f3e92cc69 url-2_5_4-f84eb31ea66b0c06 walkdir-2_5_0-edbfc6d2b455f0bf];
    passthru.rust_crate_parent = [cargo-0_88_0-script_build_run-dc81d07243ae70b8];
    passthru.rust_script_build_run = [cargo-0_88_0-script_build_run-dc81d07243ae70b8];
    phases = "unpackPhase buildPhase";

    src = builtins.filterSource
      (path: type:
        let base = baseNameOf path;
        in !(base == "target" || base == "result" || builtins.match "result-*" base != null)
      ) /home/nixos/cargo;
    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "cargo";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Cargo, a package manager for Rust.
";
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
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m cargo-0_88_0-d76731b471aa2da9"
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
      (set -x 
      ${rustc}/bin/rustc \
        --crate-name cargo \
        --edition=2021 src/cargo/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
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
        -C metadata=c20cde2e67a901d7 \
        -C extra-filename=-d76731b471aa2da9 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern annotate_snippets=${annotate-snippets-0_11_5-a7212a9a74faaa3f}/libannotate_snippets-a7212a9a74faaa3f.rmeta \
        --extern anstream=${anstream-0_6_18-37605a02f0fac906}/libanstream-37605a02f0fac906.rmeta \
        --extern anstyle=${anstyle-1_0_10-894b0e78f8d7fc16}/libanstyle-894b0e78f8d7fc16.rmeta \
        --extern anyhow=${anyhow-1_0_96-08accda0b9ade607}/libanyhow-08accda0b9ade607.rmeta \
        --extern base64=${base64-0_22_1-b113dbe7721f305b}/libbase64-b113dbe7721f305b.rmeta \
        --extern blake3=${blake3-1_6_1-b0c91102793b237d}/libblake3-b0c91102793b237d.rmeta \
        --extern cargo_credential=${cargo-credential-0_4_8-b614317587c5a56a}/libcargo_credential-b614317587c5a56a.rmeta \
        --extern cargo_credential_libsecret=${cargo-credential-libsecret-0_4_13-29580c6ca7639f8c}/libcargo_credential_libsecret-29580c6ca7639f8c.rmeta \
        --extern cargo_platform=${cargo-platform-0_2_0-bd48cbd44bf645fb}/libcargo_platform-bd48cbd44bf645fb.rmeta \
        --extern cargo_util=${cargo-util-0_2_20-e1e52a96aad3a2c8}/libcargo_util-e1e52a96aad3a2c8.rmeta \
        --extern cargo_util_schemas=${cargo-util-schemas-0_8_1-46ed49ab1cd04c33}/libcargo_util_schemas-46ed49ab1cd04c33.rmeta \
        --extern clap=${clap-4_5_31-a895b6c8d0e21ec4}/libclap-a895b6c8d0e21ec4.rmeta \
        --extern clap_complete=${clap_complete-4_5_46-5f1dfb943e043129}/libclap_complete-5f1dfb943e043129.rmeta \
        --extern color_print=${color-print-0_3_7-93904ff317cf4c47}/libcolor_print-93904ff317cf4c47.rmeta \
        --extern crates_io=${crates-io-0_40_10-42ca41081e6e1fa6}/libcrates_io-42ca41081e6e1fa6.rmeta \
        --extern curl=${curl-0_4_47-4c74e17a5eefce17}/libcurl-4c74e17a5eefce17.rmeta \
        --extern curl_sys=${curl-sys-0_4_80_plus_curl-8_12_1-10be63f25564e28e}/libcurl_sys-10be63f25564e28e.rmeta \
        --extern filetime=${filetime-0_2_25-862af764b19c0992}/libfiletime-862af764b19c0992.rmeta \
        --extern flate2=${flate2-1_1_0-38509094c93956ab}/libflate2-38509094c93956ab.rmeta \
        --extern git2=${git2-0_20_0-73cd3d9b5537d1b3}/libgit2-73cd3d9b5537d1b3.rmeta \
        --extern git2_curl=${git2-curl-0_21_0-6b25165e10b2c3e8}/libgit2_curl-6b25165e10b2c3e8.rmeta \
        --extern gix=${gix-0_70_0-833dfa597e0c3507}/libgix-833dfa597e0c3507.rmeta \
        --extern glob=${glob-0_3_2-d15d76c0231059af}/libglob-d15d76c0231059af.rmeta \
        --extern handlebars=${handlebars-6_3_1-5c73ade78aa41eb5}/libhandlebars-5c73ade78aa41eb5.rmeta \
        --extern hex=${hex-0_4_3-dd0d71cb863a3089}/libhex-dd0d71cb863a3089.rmeta \
        --extern hmac=${hmac-0_12_1-fd2e0dad2a9c7cc4}/libhmac-fd2e0dad2a9c7cc4.rmeta \
        --extern home=${home-0_5_11-aaab8970bcca687f}/libhome-aaab8970bcca687f.rmeta \
        --extern http_auth=${http-auth-0_1_10-5a8a3e7f7c6b8cf6}/libhttp_auth-5a8a3e7f7c6b8cf6.rmeta \
        --extern ignore=${ignore-0_4_23-853f4c5fbe46d77c}/libignore-853f4c5fbe46d77c.rmeta \
        --extern im_rc=${im-rc-15_1_0-c80c253ce789d440}/libim_rc-c80c253ce789d440.rmeta \
        --extern indexmap=${indexmap-2_7_1-578007b5dcfb0e2f}/libindexmap-578007b5dcfb0e2f.rmeta \
        --extern indoc=${indoc-2_0_6-13909eb38cbcdb1a}/libindoc-13909eb38cbcdb1a.so \
        --extern itertools=${itertools-0_14_0-21d508070d3c88fa}/libitertools-21d508070d3c88fa.rmeta \
        --extern jiff=${jiff-0_2_3-324a8733dc2072b7}/libjiff-324a8733dc2072b7.rmeta \
        --extern jobserver=${jobserver-0_1_32-11f288c905f4bb8b}/libjobserver-11f288c905f4bb8b.rmeta \
        --extern lazycell=${lazycell-1_3_0-ac2e73bc4c6a0582}/liblazycell-ac2e73bc4c6a0582.rmeta \
        --extern libc=${libc-0_2_170-d46a143b0470970d}/liblibc-d46a143b0470970d.rmeta \
        --extern libgit2_sys=${libgit2-sys-0_18_0_plus_1_9_0-f11a39420c489c62}/liblibgit2_sys-f11a39420c489c62.rmeta \
        --extern memchr=${memchr-2_7_4-df7138072aead54d}/libmemchr-df7138072aead54d.rmeta \
        --extern opener=${opener-0_7_2-f98762a50dd3b0a6}/libopener-f98762a50dd3b0a6.rmeta \
        --extern os_info=${os_info-3_10_0-65200209af10267c}/libos_info-65200209af10267c.rmeta \
        --extern pasetors=${pasetors-0_7_2-58098e8bbd680953}/libpasetors-58098e8bbd680953.rmeta \
        --extern pathdiff=${pathdiff-0_2_3-db5f2acff7ea901e}/libpathdiff-db5f2acff7ea901e.rmeta \
        --extern rand=${rand-0_9_0-65d47f0643c68ae7}/librand-65d47f0643c68ae7.rmeta \
        --extern regex=${regex-1_11_1-81271cb7b4167e0c}/libregex-81271cb7b4167e0c.rmeta \
        --extern rusqlite=${rusqlite-0_33_0-482fe49309905af7}/librusqlite-482fe49309905af7.rmeta \
        --extern rustc_hash=${rustc-hash-2_1_1-be14e71c30fcb538}/librustc_hash-be14e71c30fcb538.rmeta \
        --extern rustc_stable_hash=${rustc-stable-hash-0_1_2-f58afbf2a98ba869}/librustc_stable_hash-f58afbf2a98ba869.rmeta \
        --extern rustfix=${rustfix-0_9_0-3994058f2b66a27c}/librustfix-3994058f2b66a27c.rmeta \
        --extern same_file=${same-file-1_0_6-fa3759c6ae4b4446}/libsame_file-fa3759c6ae4b4446.rmeta \
        --extern semver=${semver-1_0_25-da00f457d140fad0}/libsemver-da00f457d140fad0.rmeta \
        --extern serde=${serde-1_0_218-c4e47f01a1cedfa0}/libserde-c4e47f01a1cedfa0.rmeta \
        --extern serde_untagged=${serde-untagged-0_1_6-6b39be11e9642e68}/libserde_untagged-6b39be11e9642e68.rmeta \
        --extern serde_ignored=${serde_ignored-0_1_10-d53ad3a476cabeba}/libserde_ignored-d53ad3a476cabeba.rmeta \
        --extern serde_json=${serde_json-1_0_139-578ab230a253fef1}/libserde_json-578ab230a253fef1.rmeta \
        --extern sha1=${sha1-0_10_6-67f712219a142979}/libsha1-67f712219a142979.rmeta \
        --extern shell_escape=${shell-escape-0_1_5-3e2e155bbe040858}/libshell_escape-3e2e155bbe040858.rmeta \
        --extern supports_hyperlinks=${supports-hyperlinks-3_1_0-456eae7aa61f6d0f}/libsupports_hyperlinks-456eae7aa61f6d0f.rmeta \
        --extern supports_unicode=${supports-unicode-3_0_0-3d239df88dbd39bf}/libsupports_unicode-3d239df88dbd39bf.rmeta \
        --extern tar=${tar-0_4_44-6f385aa67f40a316}/libtar-6f385aa67f40a316.rmeta \
        --extern tempfile=${tempfile-3_17_1-54a70dc79c182b90}/libtempfile-54a70dc79c182b90.rmeta \
        --extern thiserror=${thiserror-2_0_11-266d93aab4cee78a}/libthiserror-266d93aab4cee78a.rmeta \
        --extern time=${time-0_3_37-913b3e2f5fba81ad}/libtime-913b3e2f5fba81ad.rmeta \
        --extern toml=${toml-0_8_20-50efb42ce9e83b37}/libtoml-50efb42ce9e83b37.rmeta \
        --extern toml_edit=${toml_edit-0_22_24-1991cc4beab81340}/libtoml_edit-1991cc4beab81340.rmeta \
        --extern tracing=${tracing-0_1_41-4ef8fb354e141157}/libtracing-4ef8fb354e141157.rmeta \
        --extern tracing_chrome=${tracing-chrome-0_7_2-ac9a4cc9edeed658}/libtracing_chrome-ac9a4cc9edeed658.rmeta \
        --extern tracing_subscriber=${tracing-subscriber-0_3_19-58efa32ae6e128ef}/libtracing_subscriber-58efa32ae6e128ef.rmeta \
        --extern unicase=${unicase-2_8_1-1d2f15b5b2c0a78e}/libunicase-1d2f15b5b2c0a78e.rmeta \
        --extern unicode_width=${unicode-width-0_2_0-26c2c85f3e92cc69}/libunicode_width-26c2c85f3e92cc69.rmeta \
        --extern url=${url-2_5_4-f84eb31ea66b0c06}/liburl-f84eb31ea66b0c06.rmeta \
        --extern walkdir=${walkdir-2_5_0-edbfc6d2b455f0bf}/libwalkdir-edbfc6d2b455f0bf.rmeta
      )
    '';
}
