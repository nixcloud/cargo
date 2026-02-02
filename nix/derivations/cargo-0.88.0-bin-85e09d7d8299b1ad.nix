# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root, cargo-0_88_0-27e7993d9cf32df7, cargo-0_88_0-script_build_run-f5d51778f22880c0, cargo-credential-0_4_8-a5adc6ab9fe103b0, cargo-credential-libsecret-0_4_13-4e698a0b35f72d06, cargo-platform-0_2_0-c5f768769f22a333, cargo-util-0_2_20-7087e4a73afc7b23, cargo-util-schemas-0_8_1-bce7b79eff35b46a, crates-io-0_40_10-cb0425982b906266, rustfix-0_9_0-9f1c66820d29e14a }: with deps;

# let
#   incremental = stdenv.mkDerivation {
#   name = "crate-foo-incremental";
#   __impure = true;

#   buildCommand = ''
#     mkdir -p $out
#     echo "/tmp/inc" > $out/path
#     exit 1
#   '';
# };

#   in
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-0_88_0-bin-85e09d7d8299b1ad";
    meta.cargo_crate_info = {
      name = "cargo (bin)";
      version = "0.88.0";
      crate_hash = "85e09d7d8299b1ad";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [annotate-snippets-0_11_5-4d47bac9cbcd3256 anstream-0_6_18-3af54164fe68ad61 anstyle-1_0_10-bf6d032cb7d79be1 
      anyhow-1_0_96-139173be5e005a44 base64-0_22_1-169e80cc244b88d1 blake3-1_6_1-3250b34f7bcecb8a cargo-0_88_0-27e7993d9cf32df7 
      cargo-credential-0_4_8-a5adc6ab9fe103b0 cargo-credential-libsecret-0_4_13-4e698a0b35f72d06 cargo-platform-0_2_0-c5f768769f22a333 
      cargo-util-0_2_20-7087e4a73afc7b23 cargo-util-schemas-0_8_1-bce7b79eff35b46a clap-4_5_31-a6f5f68162f5c661 clap_complete-4_5_46-aac8805c5395ded9 
      color-print-0_3_7-4ae3eda36d442220 crates-io-0_40_10-cb0425982b906266 curl-0_4_47-f684c2bd7b0f950d curl-sys-0_4_80_plus_curl-8_12_1-db5fbe1d9680c71f 
      filetime-0_2_25-36b58a90b887714e flate2-1_1_0-8e647ae5b177ac6d git2-0_20_0-a5a6e57aa11f1a77 git2-curl-0_21_0-d43c11566cc114b0 gix-0_70_0-992c380a7e61bb6a 
      glob-0_3_2-544549cd000b48bc handlebars-6_3_1-1d5c39ccada6570e hex-0_4_3-ccbbd905e94f34bd hmac-0_12_1-84aacd8a0108f7c5 home-0_5_11-43ef4c896a7488bc 
      http-auth-0_1_10-b3940f62a0eee11f ignore-0_4_23-dab7af6f0867647c im-rc-15_1_0-6db31ca18b586012 indexmap-2_7_1-dcbfc0f8f5b442a0 
      indoc-2_0_6-3e36bbc9b09ee6b1 itertools-0_14_0-27edccb8d0332424 jiff-0_2_3-16345f2ab32d9b14 jobserver-0_1_32-04274db7c36dbe6c 
      lazycell-1_3_0-5468cb6502e4542b libc-0_2_175-df0687d6868fdede libgit2-sys-0_18_0_plus_1_9_0-86c4b3f8f5bf526a logone-0_2_7-1eb55177eedd2e91 
      memchr-2_7_4-3cee6db17bbe0dde opener-0_7_2-e60a19764aabfbee os_info-3_10_0-1475caac7a528f34 pasetors-0_7_2-0e3e06d4cbb54d3a 
      pathdiff-0_2_3-4adfc518be1c04af rand-0_9_0-6c716ea579f406d5 regex-1_11_1-c278e9a7e455d20f rusqlite-0_33_0-0e7a13217d933375 
      rustc-hash-2_1_1-eecec28cc151ccd3 rustc-stable-hash-0_1_2-5e3739f6900f7bdf rustfix-0_9_0-9f1c66820d29e14a same-file-1_0_6-82920d733726b0a3 
      semver-1_0_25-44d2ac63fb520e42 serde-1_0_218-472e28b9f131b02c serde-untagged-0_1_6-6d07b1ee988da762 serde_ignored-0_1_10-dc3c1b953dc9ba97 
      serde_json-1_0_139-ae78ec5bae97c420 sha1-0_10_6-7f98ce853a3fd8dc shell-escape-0_1_5-fc06a701b65fbe9d supports-hyperlinks-3_1_0-d01c256720ea7038 
      supports-unicode-3_0_0-bf24266a6bf9ea5d tar-0_4_44-1da5ced4b8e7e118 tempfile-3_17_1-94ecc3046797cc75 thiserror-2_0_11-a57592ffa4ea41e0 
      time-0_3_37-b73d8cae561973b7 toml-0_8_20-7a483d12a9e19406 toml_edit-0_22_24-24142c1671b8cfdf tracing-0_1_41-7b5284fa1d5dcd0d tracing-chrome-0_7_2-5b548189b83dd8d2 
      tracing-subscriber-0_3_19-8f98042188b2d3ba unicase-2_8_1-07d4133086b7fec6 unicode-width-0_2_0-0c384aa902aa0aa2 url-2_5_4-7b68be8bb56d0713 walkdir-2_5_0-742d7f303f7cfcda];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [cargo-0_88_0-27e7993d9cf32df7];
    phases = "unpackPhase buildPhase installPhase";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "src/bin/cargo/main.rs"
        "src/bin/cargo/cli.rs"
        "src/bin/cargo/commands/mod.rs"
        "src/bin/cargo/commands/add.rs"
        "src/bin/cargo/commands/bench.rs"
        "src/bin/cargo/commands/build.rs"
        "src/bin/cargo/commands/check.rs"
        "src/bin/cargo/commands/clean.rs"
        "src/bin/cargo/commands/config.rs"
        "src/bin/cargo/commands/doc.rs"
        "src/bin/cargo/commands/fetch.rs"
        "src/bin/cargo/commands/fix.rs"
        "src/bin/cargo/commands/nix.rs"
        "src/bin/cargo/commands/generate_lockfile.rs"
        "src/bin/cargo/commands/git_checkout.rs"
        "src/bin/cargo/commands/help.rs"
        "src/bin/cargo/commands/info.rs"
        "src/bin/cargo/commands/init.rs"
        "src/bin/cargo/commands/install.rs"
        "src/bin/cargo/commands/locate_project.rs"
        "src/bin/cargo/commands/login.rs"
        "src/bin/cargo/commands/logout.rs"
        "src/bin/cargo/commands/metadata.rs"
        "src/bin/cargo/commands/new.rs"
        "src/bin/cargo/commands/owner.rs"
        "src/bin/cargo/commands/package.rs"
        "src/bin/cargo/commands/pkgid.rs"
        "src/bin/cargo/commands/publish.rs"
        "src/bin/cargo/commands/read_manifest.rs"
        "src/bin/cargo/commands/remove.rs"
        "src/bin/cargo/commands/report.rs"
        "src/bin/cargo/commands/run.rs"
        "src/bin/cargo/commands/rustc.rs"
        "src/bin/cargo/commands/rustdoc.rs"
        "src/bin/cargo/commands/search.rs"
        "src/bin/cargo/commands/test.rs"
        "src/bin/cargo/commands/tree.rs"
        "src/bin/cargo/commands/uninstall.rs"
        "src/bin/cargo/commands/update.rs"
        "src/bin/cargo/commands/vendor.rs"
        "src/bin/cargo/commands/verify_project.rs"
        "src/bin/cargo/commands/version.rs"
        "src/bin/cargo/commands/yank.rs"
      ];
    };

    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_BIN_NAME = "cargo";
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

      date +%s
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m cargo-0_88_0-bin-85e09d7d8299b1ad"
      echo "@cargo { \"type\":0, \"crate_name\":\"cargo\", \"id\":\"cargo-0_88_0-bin-85e09d7d8299b1ad\" }"
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
      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)



      start_time=$(date +%s%3N)
      set -x +e


  #     start_time=$(date +%s%3N)
  #     set -x +e
  #  ${RUSTC} \
  #             --crate-name cargo \
  #             --edition=2021 src/bin/cargo/main.rs \
  #             --crate-type bin \
  #             --emit=dep-info \
  #             --check-cfg 'cfg(docsrs,test)' \
  #             --check-cfg 'cfg(feature, values("all-static", "openssl", "vendored-libgit2", "vendored-openssl"))' \
  #             -C metadata=41d126c5eb1acf4c \
  #             -C extra-filename=-85e09d7d8299b1ad \
  #             --out-dir $OUT_DIR 2>/dev/null
  #     end_time=$(date +%s%3N)
  #     elapsed=$(( end_time - start_time ))
  #     echo "Elapsed time between XXX and YYY: $elapsed ms"
  #     cat $out/*.d | grep -e "README.md"
  #     cat $out/*.d | grep -e ":$" | wc -l
  #     exit 1



      #dependency=fn.rustc_linker_arguments passthru.rust_crate_libraries}
              #-L dependency=magic} \


#  -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
# ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \

      date +%s

      mkdir -p /tmp/out
      
 


      ${RUSTC} \
              --crate-name cargo \
              --edition=2021 src/bin/cargo/main.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              $(if [ -d /incremental-target ]; then echo "-C incremental=/incremental-target"; fi) \
              --crate-type bin \
              --emit=link \
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
              -C metadata=41d126c5eb1acf4c \
              -C extra-filename=-85e09d7d8299b1ad \
              --out-dir /tmp/out \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              --extern annotate_snippets=${annotate-snippets-0_11_5-4d47bac9cbcd3256}/libannotate_snippets-4d47bac9cbcd3256.rlib \
              --extern anstream=${anstream-0_6_18-3af54164fe68ad61}/libanstream-3af54164fe68ad61.rlib \
              --extern anstyle=${anstyle-1_0_10-bf6d032cb7d79be1}/libanstyle-bf6d032cb7d79be1.rlib \
              --extern anyhow=${anyhow-1_0_96-139173be5e005a44}/libanyhow-139173be5e005a44.rlib \
              --extern base64=${base64-0_22_1-169e80cc244b88d1}/libbase64-169e80cc244b88d1.rlib \
              --extern blake3=${blake3-1_6_1-3250b34f7bcecb8a}/libblake3-3250b34f7bcecb8a.rlib \
              --extern cargo=${cargo-0_88_0-27e7993d9cf32df7}/libcargo-27e7993d9cf32df7.rlib \
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
              --extern walkdir=${walkdir-2_5_0-742d7f303f7cfcda}/libwalkdir-742d7f303f7cfcda.rlib 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e

      

      end_time=$(date +%s%3N)
      elapsed=$(( end_time - start_time ))
      echo "Elapsed time between XXX and YYY: $elapsed seconds"
           
      # print errors
      while IFS= read -r line
      do
          tmpFile=$(${pkgs.mktemp}/bin/mktemp)
          echo "$line" > $tmpFile
          ${pkgs.jq}/bin/jq -r -c 'select(."$message_type"=="diagnostic") | .rendered' $tmpFile
      done < $rustc_json_output_lines
      
      mkdir -p $out/
      time cp -R /tmp/out/* $out/
      
      # return structured formatted errors for later processing
      output=$(${pkgs.jq}/bin/jq -s -r -c \
          --arg fullname "cargo-0_88_0-bin-85e09d7d8299b1ad" \
          --arg crate_name "cargo" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
      date +%s

    '';
    installPhase = ''
      mkdir $out/bin
      ln -s $out/cargo-85e09d7d8299b1ad $out/bin/cargo
      date +%s
    '';
}
