# generated from default.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, lib ? pkgs.lib, rustc, cargo, external_crate_dependencies, project_root }:
let
  build_rs_libnix' = pkgs.callPackage ./build_rs_libnix.nix {
    inherit pkgs;
  };
  callPackage' = lib.callPackageWith (pkgs // lib // self // { inherit fn rustc cargo project_root; });
  fn = rec {
    build_rs_libnix = "${build_rs_libnix'}/bin/build-rs-libnix";
    allCollectedInputs = a: lib.unique (
      builtins.foldl' (acc: el: acc ++ [el] ++ (allCollectedInputs el.rust_crate_libraries)) [] a
    );
    rustc_linker_arguments = rust_crate_libraries: builtins.concatStringsSep " " (map (lib: "-L ${lib}") (allCollectedInputs rust_crate_libraries));
    rustc_linker_arguments_dir = rust_crate_libraries: 
      pkgs.stdenv.mkDerivation {
        name = "rustc-linker-arguments-dir";
        # anyhow-139173be5e005a44.d  libanyhow-139173be5e005a44.rlib  libanyhow-139173be5e005a44.rmeta  nix
        buildCommand = ''
          mkdir -p $out/deps
          for lib in ${builtins.concatStringsSep " " (map (lib: "${lib}") (allCollectedInputs rust_crate_libraries))}; do
            if [ -d "$lib" ]; then
              for f in "$lib"/*.rlib "$lib"/*.rmeta "$lib"/*.so; do
                if [ -e "$f" ]; then
                  ln -s "$f" "$out/deps/" || true
                fi
              done
            fi
          done
          echo ${builtins.concatStringsSep " " (map (lib: "-L ${lib}") (allCollectedInputs rust_crate_libraries))} > $out/rustc-linker-arguments
        '';
      };
    rustc_arguments = rust_crate_parent: assert lib.assertMsg (builtins.length rust_crate_parent <= 1) "passthru.rust_crate_parent must have 0 or 1 element at maxium" ;
      lib.replaceStrings ["\n"] [""] (builtins.concatStringsSep " " (map (crate:
        if builtins.pathExists "${crate}/nix/rustc-arguments" then
          builtins.readFile "${crate}/nix/rustc-arguments"
        else
          ""
        ) rust_crate_parent));
    rustc_propagated_arguments = rust_crate_libraries: lib.replaceStrings ["\n"] [""] (builtins.concatStringsSep " " (map (crate:
      if builtins.pathExists "${crate}/nix/rustc-propagated-arguments" then
        builtins.readFile "${crate}/nix/rustc-propagated-arguments"
      else
        ""
      ) (allCollectedInputs rust_crate_libraries)));
    environment_variables = rust_script_build_run: builtins.concatStringsSep " " (map (d: "${d}/nix/environment-variables") rust_script_build_run);
    get_rust_crate_parent = parent_list:
      assert lib.assertMsg (builtins.length parent_list == 1) "item is supposed to have exactly one parent, while it has 0 or more than 1";
      builtins.head parent_list;
    import_bash_function_helpers = ''
      print_compiling_message() {
        local fullname="$1"
        printf '\033[0;32mCompiling\033[0m %s\n' "$fullname"
      }

      # to indicate that a crate build inside a mkDerivation has started of type
      print_cargo_message_type_0() {
        local fullname="$1"         # "serde-1_21_3-bfbc21afc6e0b538"
        local name="$2"             # "serde" 
        local type="$3"             # "(lib)"
        echo "@cargo { \"type\":0, \"crate_name\":\"$name\", \"crate_type\":\"$type\", \"id\":\"$fullname\" }"
      }

      # to indicate that a mkDerivation has finished compiling a crate of type rustc call counterpart: finishes a type 0 message
      print_cargo_message_type_2() {
        local fullname="$1"         # "serde-1_21_3-bfbc21afc6e0b538"
        local name="$2"             # "serde"
        local type="$3"             # "(lib)"
        local rustc_exit_code="$4"
        local rustc_json_output_lines="$5"
        output=$(${pkgs.jq}/bin/jq -s -r -c \
          --arg fullname "$fullname" \
          --arg name "$name" \
          --arg type "$type" \
          --arg exit_code "$rustc_exit_code" \
          '{type: 2, crate_name: $name, crate_type: $type, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
        printf '@cargo %s\n' "$output"
      }

      # "build.rs run" calls this
      print_cargo_message_type_3() {
        local name="$1"
        local type="$2"
        local notice="$3"
        local exit_code="$4"
        local build_script_build_output_lines="$5"
        output=$(${pkgs.jq}/bin/jq -c -n \
          --arg name "$name" \
          --arg type "$type" \
          --arg notice "$notice" \
          --arg exit_code "$exit_code" \
          --rawfile msg $build_script_build_output_lines \
          '{type: 3, crate_name: $name, crate_type: $type, exit_code: ($exit_code|tonumber), messages: [ $notice, $msg ] }')
        printf '@cargo %s\n' "$output"
      }

      # rustc outputs json, from that we extracted the .rendered part and print it to stdout 
      # (so we see useful messages during 'nix build')
      print_rustc_rendered_messages() {
        local rustc_json_output_lines="$1"
        while IFS= read -r line
        do
            tmpFile=$(${pkgs.mktemp}/bin/mktemp)
            echo "$line" > $tmpFile
            ${pkgs.jq}/bin/jq -r -c 'select(."$message_type"=="diagnostic") | .rendered' $tmpFile
        done < $rustc_json_output_lines
      }

      # set env variables from the passthru propagation, used for DEP_* and similar from build.rs
      load_environment_variables_from_files() {
        local files="$1"
        for file in $files; do
          if [ -f $file ]; then
            set -a
              while read -r line; do
                echo -e "\033[38;5;208m$line\033[0m"
              done < "$file"
              source $file
              set +a
          fi
        done
      }

      copy_build_script_run_results_over_with_nix() {
        local build_script_run_out_dir="$1"
        cp -r "$build_script_run_out_dir"/* $OUT_DIR
      }

      copy_build_script_run_results_over_without_nix() {
        local build_script_run_out_dir="$1"
        cp -r "$build_script_run_out_dir"/* $OUT_DIR
        rm -Rf $OUT_DIR/nix
      }
    '';
    inject_deps = cargo_crate_info:
      let
        deps = external_crate_dependencies.deps;
        name = cargo_crate_info.name;
        version = cargo_crate_info.version;
        crate_hash = cargo_crate_info.hash;
        entry = deps.${name} or null;
      in
        if builtins.isAttrs entry then
          let
            verEntry = entry.${version} or null;
          in
            if builtins.isAttrs verEntry then
              verEntry.${crate_hash} or (throw "No deps found for ${name} version ${version} hash ${crate_hash}")
            else if builtins.isList verEntry then
              verEntry
            else
              throw "No deps found for '${name}' version ${version}"
        else if builtins.isList entry then
          entry
        else
          [];
    inject_envs = cargo_crate_info:
      let
        envs = external_crate_dependencies.envs;
        name = cargo_crate_info.name;
        version = cargo_crate_info.version;
        crate_hash = cargo_crate_info.crate_hash;
        entry = envs.${name} or null;
      in
        if builtins.isAttrs entry then
          let
            verEntry = entry.${version} or null;
          in
            if builtins.isAttrs verEntry then
              if builtins.isAttrs verEntry then
                if verEntry ? "${crate_hash}" then verEntry.${crate_hash} else verEntry
              else
                {}
            else
              entry
        else
          {};
    relativeFileset = project_root: relPaths: lib.fileset.unions (map (p: project_root + "/${p}") relPaths);
  };
  self = {
    target = callPackage' ./target.nix {};
    cargo-0_88_0-b9aa49f38b781d3e = callPackage' ./cargo-0.88.0-b9aa49f38b781d3e.nix { };
    cargo-0_88_0-bin-b4cc6eeacb818d24 = callPackage' ./cargo-0.88.0-bin-b4cc6eeacb818d24.nix { };
    cargo-0_88_0-script_build-2f8a8657b7eefbe7 = callPackage' ./cargo-0.88.0-script_build-2f8a8657b7eefbe7.nix { };
    cargo-0_88_0-script_build_run-c582da2c854a7f93 = callPackage' ./cargo-0.88.0-script_build_run-c582da2c854a7f93.nix { };
    cargo-credential-0_4_8-04d496e2b8c4b2ba = callPackage' ./cargo-credential-0.4.8-04d496e2b8c4b2ba.nix { };
    cargo-credential-libsecret-0_4_13-9f8a917365498280 = callPackage' ./cargo-credential-libsecret-0.4.13-9f8a917365498280.nix { };
    cargo-platform-0_2_0-9528fcbd58f1490b = callPackage' ./cargo-platform-0.2.0-9528fcbd58f1490b.nix { };
    cargo-util-0_2_20-ca8e56b3d4554315 = callPackage' ./cargo-util-0.2.20-ca8e56b3d4554315.nix { };
    cargo-util-schemas-0_8_1-a76d1978f9d187be = callPackage' ./cargo-util-schemas-0.8.1-a76d1978f9d187be.nix { };
    crates-io-0_40_10-114ba05d6d48e004 = callPackage' ./crates-io-0.40.10-114ba05d6d48e004.nix { };
    rustfix-0_9_0-f92d91d9c29999cf = callPackage' ./rustfix-0.9.0-f92d91d9c29999cf.nix { };
    deps = {
      adler2-2_0_0-bb8b39862d26c331 = callPackage' ./deps/adler2-2.0.0-bb8b39862d26c331.nix { };
      ahash-0_8_11-d85bc5cef2391462 = callPackage' ./deps/ahash-0.8.11-d85bc5cef2391462.nix { };
      ahash-0_8_11-script_build-abac3b41dce7b5e7 = callPackage' ./deps/ahash-0.8.11-script_build-abac3b41dce7b5e7.nix { };
      ahash-0_8_11-script_build_run-eacbc68f79a20c26 = callPackage' ./deps/ahash-0.8.11-script_build_run-eacbc68f79a20c26.nix { };
      aho-corasick-1_1_3-511789a4780abe8b = callPackage' ./deps/aho-corasick-1.1.3-511789a4780abe8b.nix { };
      allocator-api2-0_2_21-fe10efef62e2f9d8 = callPackage' ./deps/allocator-api2-0.2.21-fe10efef62e2f9d8.nix { };
      annotate-snippets-0_11_5-c27a2250c0f48ef5 = callPackage' ./deps/annotate-snippets-0.11.5-c27a2250c0f48ef5.nix { };
      anstream-0_6_18-59aa35a61b4ca0e8 = callPackage' ./deps/anstream-0.6.18-59aa35a61b4ca0e8.nix { };
      anstyle-1_0_10-051477b24e08c8d1 = callPackage' ./deps/anstyle-1.0.10-051477b24e08c8d1.nix { };
      anstyle-parse-0_2_6-edba57480f1f6f73 = callPackage' ./deps/anstyle-parse-0.2.6-edba57480f1f6f73.nix { };
      anstyle-query-1_1_2-789edfa707211726 = callPackage' ./deps/anstyle-query-1.1.2-789edfa707211726.nix { };
      anyhow-1_0_96-61bbc4e08b05614c = callPackage' ./deps/anyhow-1.0.96-61bbc4e08b05614c.nix { };
      anyhow-1_0_96-script_build-22dc23ffd8131166 = callPackage' ./deps/anyhow-1.0.96-script_build-22dc23ffd8131166.nix { };
      anyhow-1_0_96-script_build_run-f080edeb228c5f3e = callPackage' ./deps/anyhow-1.0.96-script_build_run-f080edeb228c5f3e.nix { };
      arc-swap-1_7_1-edd6f861745ef398 = callPackage' ./deps/arc-swap-1.7.1-edd6f861745ef398.nix { };
      arrayref-0_3_9-b991aefb74018707 = callPackage' ./deps/arrayref-0.3.9-b991aefb74018707.nix { };
      arrayvec-0_7_6-6c3d4fac0079d5d1 = callPackage' ./deps/arrayvec-0.7.6-6c3d4fac0079d5d1.nix { };
      autocfg-1_4_0-c4c87cfc7a8a4820 = callPackage' ./deps/autocfg-1.4.0-c4c87cfc7a8a4820.nix { };
      base16ct-0_2_0-03a13dfc8db9d885 = callPackage' ./deps/base16ct-0.2.0-03a13dfc8db9d885.nix { };
      base64-0_22_1-a69787aa05970cd3 = callPackage' ./deps/base64-0.22.1-a69787aa05970cd3.nix { };
      base64ct-1_6_0-1ae6576b82f793d7 = callPackage' ./deps/base64ct-1.6.0-1ae6576b82f793d7.nix { };
      bitflags-2_8_0-25bacb8b683e4264 = callPackage' ./deps/bitflags-2.8.0-25bacb8b683e4264.nix { };
      bitmaps-2_1_0-2e9cf441e3de2772 = callPackage' ./deps/bitmaps-2.1.0-2e9cf441e3de2772.nix { };
      blake3-1_6_1-ceb9e2c2787b1280 = callPackage' ./deps/blake3-1.6.1-ceb9e2c2787b1280.nix { };
      blake3-1_6_1-script_build-be65d8b05892796a = callPackage' ./deps/blake3-1.6.1-script_build-be65d8b05892796a.nix { };
      blake3-1_6_1-script_build_run-ca3cbed55d4f6861 = callPackage' ./deps/blake3-1.6.1-script_build_run-ca3cbed55d4f6861.nix { };
      block-buffer-0_10_4-432b32a3941fb8c8 = callPackage' ./deps/block-buffer-0.10.4-432b32a3941fb8c8.nix { };
      bstr-1_11_3-46100c463ffaaa37 = callPackage' ./deps/bstr-1.11.3-46100c463ffaaa37.nix { };
      build-rs-libnix-0_1_11-24a8729adbae7212 = callPackage' ./deps/build-rs-libnix-0.1.11-24a8729adbae7212.nix { };
      byteorder-1_5_0-a28b656e45fc3f61 = callPackage' ./deps/byteorder-1.5.0-a28b656e45fc3f61.nix { };
      bytes-1_10_0-f994980fad6be9eb = callPackage' ./deps/bytes-1.10.0-f994980fad6be9eb.nix { };
      cc-1_2_16-e1e43c4b4d22a16b = callPackage' ./deps/cc-1.2.16-e1e43c4b4d22a16b.nix { };
      cfg-if-1_0_0-39db481b14499192 = callPackage' ./deps/cfg-if-1.0.0-39db481b14499192.nix { };
      cfg-if-1_0_0-424abd49c6d5f017 = callPackage' ./deps/cfg-if-1.0.0-424abd49c6d5f017.nix { };
      chrono-0_4_42-ed2e7c7c8edbe153 = callPackage' ./deps/chrono-0.4.42-ed2e7c7c8edbe153.nix { };
      clap-4_5_31-436756512d3af050 = callPackage' ./deps/clap-4.5.31-436756512d3af050.nix { };
      clap_builder-4_5_31-ce83770df656d62a = callPackage' ./deps/clap_builder-4.5.31-ce83770df656d62a.nix { };
      clap_complete-4_5_46-4dce9b58b32b4c7b = callPackage' ./deps/clap_complete-4.5.46-4dce9b58b32b4c7b.nix { };
      clap_derive-4_5_28-2dc16d361323aba6 = callPackage' ./deps/clap_derive-4.5.28-2dc16d361323aba6.nix { };
      clap_lex-0_7_4-ee15bee4b3047b45 = callPackage' ./deps/clap_lex-0.7.4-ee15bee4b3047b45.nix { };
      clru-0_6_2-c2f996648471f3fc = callPackage' ./deps/clru-0.6.2-c2f996648471f3fc.nix { };
      color-print-0_3_7-9618017c447b538d = callPackage' ./deps/color-print-0.3.7-9618017c447b538d.nix { };
      color-print-proc-macro-0_3_7-92102f3133fdb913 = callPackage' ./deps/color-print-proc-macro-0.3.7-92102f3133fdb913.nix { };
      colorchoice-1_0_3-9667677c83bfc624 = callPackage' ./deps/colorchoice-1.0.3-9667677c83bfc624.nix { };
      colored-3_1_1-86c9fae7f303dfbf = callPackage' ./deps/colored-3.1.1-86c9fae7f303dfbf.nix { };
      console-0_15_11-d380249dfaf73f99 = callPackage' ./deps/console-0.15.11-d380249dfaf73f99.nix { };
      const-oid-0_9_6-ad382a9997690729 = callPackage' ./deps/const-oid-0.9.6-ad382a9997690729.nix { };
      constant_time_eq-0_3_1-94020b1cb70f9a08 = callPackage' ./deps/constant_time_eq-0.3.1-94020b1cb70f9a08.nix { };
      cpufeatures-0_2_17-38122a3e7ee1c3f6 = callPackage' ./deps/cpufeatures-0.2.17-38122a3e7ee1c3f6.nix { };
      crc32fast-1_4_2-6198ec617f8ea4ed = callPackage' ./deps/crc32fast-1.4.2-6198ec617f8ea4ed.nix { };
      crc32fast-1_4_2-74097b32b99506ae = callPackage' ./deps/crc32fast-1.4.2-74097b32b99506ae.nix { };
      crossbeam-channel-0_5_14-bc627ba0c15ff4fd = callPackage' ./deps/crossbeam-channel-0.5.14-bc627ba0c15ff4fd.nix { };
      crossbeam-deque-0_8_6-71d6deff62d4a66b = callPackage' ./deps/crossbeam-deque-0.8.6-71d6deff62d4a66b.nix { };
      crossbeam-epoch-0_9_18-ddc627cd5d25a336 = callPackage' ./deps/crossbeam-epoch-0.9.18-ddc627cd5d25a336.nix { };
      crossbeam-utils-0_8_21-33005183671c1b28 = callPackage' ./deps/crossbeam-utils-0.8.21-33005183671c1b28.nix { };
      crossbeam-utils-0_8_21-script_build-de090a42333daf53 = callPackage' ./deps/crossbeam-utils-0.8.21-script_build-de090a42333daf53.nix { };
      crossbeam-utils-0_8_21-script_build_run-fdbe690e32d2fd05 = callPackage' ./deps/crossbeam-utils-0.8.21-script_build_run-fdbe690e32d2fd05.nix { };
      crossterm-0_27_0-2318486ecaee02e1 = callPackage' ./deps/crossterm-0.27.0-2318486ecaee02e1.nix { };
      crypto-bigint-0_5_5-0bcc8357eda397b9 = callPackage' ./deps/crypto-bigint-0.5.5-0bcc8357eda397b9.nix { };
      crypto-common-0_1_6-a7af26dbac30ba96 = callPackage' ./deps/crypto-common-0.1.6-a7af26dbac30ba96.nix { };
      ct-codecs-1_1_3-7a8152012b595d7e = callPackage' ./deps/ct-codecs-1.1.3-7a8152012b595d7e.nix { };
      curl-0_4_47-8a5016373deb916e = callPackage' ./deps/curl-0.4.47-8a5016373deb916e.nix { };
      curl-0_4_47-script_build-6927a4ffca2b77e3 = callPackage' ./deps/curl-0.4.47-script_build-6927a4ffca2b77e3.nix { };
      curl-0_4_47-script_build_run-aa150e1d87a83eeb = callPackage' ./deps/curl-0.4.47-script_build_run-aa150e1d87a83eeb.nix { };
      curl-sys-0_4_80_plus_curl-8_12_1-e26ceb4086d88aa5 = callPackage' ./deps/curl-sys-0.4.80_plus_curl-8.12.1-e26ceb4086d88aa5.nix { };
      curl-sys-0_4_80_plus_curl-8_12_1-script_build-995e765fec62c215 = callPackage' ./deps/curl-sys-0.4.80_plus_curl-8.12.1-script_build-995e765fec62c215.nix { };
      curl-sys-0_4_80_plus_curl-8_12_1-script_build_run-3b4d64c654555321 = callPackage' ./deps/curl-sys-0.4.80_plus_curl-8.12.1-script_build_run-3b4d64c654555321.nix { };
      darling-0_20_10-8fd75665fdb6cbf2 = callPackage' ./deps/darling-0.20.10-8fd75665fdb6cbf2.nix { };
      darling_core-0_20_10-33b904f525621e82 = callPackage' ./deps/darling_core-0.20.10-33b904f525621e82.nix { };
      darling_macro-0_20_10-af8d834bbc2463c3 = callPackage' ./deps/darling_macro-0.20.10-af8d834bbc2463c3.nix { };
      der-0_7_9-9223185c0fceb330 = callPackage' ./deps/der-0.7.9-9223185c0fceb330.nix { };
      deranged-0_3_11-091ab43039ab41fd = callPackage' ./deps/deranged-0.3.11-091ab43039ab41fd.nix { };
      derive_builder-0_20_2-55d9f78f8009441b = callPackage' ./deps/derive_builder-0.20.2-55d9f78f8009441b.nix { };
      derive_builder_core-0_20_2-776491bd3cff748b = callPackage' ./deps/derive_builder_core-0.20.2-776491bd3cff748b.nix { };
      derive_builder_macro-0_20_2-202d4187b36add0b = callPackage' ./deps/derive_builder_macro-0.20.2-202d4187b36add0b.nix { };
      digest-0_10_7-07ce6216f0c2d433 = callPackage' ./deps/digest-0.10.7-07ce6216f0c2d433.nix { };
      displaydoc-0_2_5-ff04277df12d4cce = callPackage' ./deps/displaydoc-0.2.5-ff04277df12d4cce.nix { };
      ecdsa-0_16_9-833b4c6c9b0d846b = callPackage' ./deps/ecdsa-0.16.9-833b4c6c9b0d846b.nix { };
      ed25519-compact-2_1_1-7a9cae9574606b40 = callPackage' ./deps/ed25519-compact-2.1.1-7a9cae9574606b40.nix { };
      either-1_13_0-0a3bb2ce8ec479b0 = callPackage' ./deps/either-1.13.0-0a3bb2ce8ec479b0.nix { };
      elliptic-curve-0_13_8-c56a877db253e598 = callPackage' ./deps/elliptic-curve-0.13.8-c56a877db253e598.nix { };
      encoding_rs-0_8_35-f759af49395e7c1b = callPackage' ./deps/encoding_rs-0.8.35-f759af49395e7c1b.nix { };
      equivalent-1_0_1-10c35e6cce698ddd = callPackage' ./deps/equivalent-1.0.1-10c35e6cce698ddd.nix { };
      erased-serde-0_4_5-8434fcc0adc8659a = callPackage' ./deps/erased-serde-0.4.5-8434fcc0adc8659a.nix { };
      fallible-iterator-0_3_0-2c14c8adfb18ad4f = callPackage' ./deps/fallible-iterator-0.3.0-2c14c8adfb18ad4f.nix { };
      fallible-streaming-iterator-0_1_9-1108f90d36611767 = callPackage' ./deps/fallible-streaming-iterator-0.1.9-1108f90d36611767.nix { };
      faster-hex-0_9_0-f6f594650c4ebeb1 = callPackage' ./deps/faster-hex-0.9.0-f6f594650c4ebeb1.nix { };
      fastrand-2_3_0-a6e21b8cf3724d00 = callPackage' ./deps/fastrand-2.3.0-a6e21b8cf3724d00.nix { };
      ff-0_13_0-9c81edae7543beed = callPackage' ./deps/ff-0.13.0-9c81edae7543beed.nix { };
      fiat-crypto-0_2_9-037e45f01d16bb63 = callPackage' ./deps/fiat-crypto-0.2.9-037e45f01d16bb63.nix { };
      filetime-0_2_25-4a8c5a239dda911b = callPackage' ./deps/filetime-0.2.25-4a8c5a239dda911b.nix { };
      filetime-0_2_25-ef94eb22f8d9650d = callPackage' ./deps/filetime-0.2.25-ef94eb22f8d9650d.nix { };
      flate2-1_1_0-1803cfc90dc9b44e = callPackage' ./deps/flate2-1.1.0-1803cfc90dc9b44e.nix { };
      flate2-1_1_0-f05ad64f5d566c20 = callPackage' ./deps/flate2-1.1.0-f05ad64f5d566c20.nix { };
      fnv-1_0_7-005fa565602fcd4e = callPackage' ./deps/fnv-1.0.7-005fa565602fcd4e.nix { };
      fnv-1_0_7-4fc187120cbe28dc = callPackage' ./deps/fnv-1.0.7-4fc187120cbe28dc.nix { };
      foldhash-0_1_4-121b51bda0a24351 = callPackage' ./deps/foldhash-0.1.4-121b51bda0a24351.nix { };
      form_urlencoded-1_2_1-617614f34ad1bf88 = callPackage' ./deps/form_urlencoded-1.2.1-617614f34ad1bf88.nix { };
      generic-array-0_14_7-28e5836782b73319 = callPackage' ./deps/generic-array-0.14.7-28e5836782b73319.nix { };
      generic-array-0_14_7-script_build-b95f81cf6da3b676 = callPackage' ./deps/generic-array-0.14.7-script_build-b95f81cf6da3b676.nix { };
      generic-array-0_14_7-script_build_run-40414111f0038cbd = callPackage' ./deps/generic-array-0.14.7-script_build_run-40414111f0038cbd.nix { };
      getrandom-0_2_15-888b1a2900229056 = callPackage' ./deps/getrandom-0.2.15-888b1a2900229056.nix { };
      getrandom-0_3_1-e63b8caed24af524 = callPackage' ./deps/getrandom-0.3.1-e63b8caed24af524.nix { };
      getrandom-0_3_1-script_build-394ed08c28b050f0 = callPackage' ./deps/getrandom-0.3.1-script_build-394ed08c28b050f0.nix { };
      getrandom-0_3_1-script_build_run-cb15c936ded7c8a6 = callPackage' ./deps/getrandom-0.3.1-script_build_run-cb15c936ded7c8a6.nix { };
      git2-0_20_0-50735b59c53beae1 = callPackage' ./deps/git2-0.20.0-50735b59c53beae1.nix { };
      git2-curl-0_21_0-aa8fb836bc90345d = callPackage' ./deps/git2-curl-0.21.0-aa8fb836bc90345d.nix { };
      gix-0_70_0-6ef08fee72b6f2df = callPackage' ./deps/gix-0.70.0-6ef08fee72b6f2df.nix { };
      gix-actor-0_33_2-6ed8c81e826ceba4 = callPackage' ./deps/gix-actor-0.33.2-6ed8c81e826ceba4.nix { };
      gix-attributes-0_24_0-64ee21b308ccf8d6 = callPackage' ./deps/gix-attributes-0.24.0-64ee21b308ccf8d6.nix { };
      gix-bitmap-0_2_14-ccd068f2125b37ac = callPackage' ./deps/gix-bitmap-0.2.14-ccd068f2125b37ac.nix { };
      gix-chunk-0_4_11-cba533d3bf84babe = callPackage' ./deps/gix-chunk-0.4.11-cba533d3bf84babe.nix { };
      gix-command-0_4_1-74abf2bf82b71c94 = callPackage' ./deps/gix-command-0.4.1-74abf2bf82b71c94.nix { };
      gix-commitgraph-0_26_0-3f98563c5c8a6311 = callPackage' ./deps/gix-commitgraph-0.26.0-3f98563c5c8a6311.nix { };
      gix-config-0_43_0-258b91159c7a0459 = callPackage' ./deps/gix-config-0.43.0-258b91159c7a0459.nix { };
      gix-config-value-0_14_11-75309d14f49a1fbd = callPackage' ./deps/gix-config-value-0.14.11-75309d14f49a1fbd.nix { };
      gix-credentials-0_27_0-31b7bfc0f35b5458 = callPackage' ./deps/gix-credentials-0.27.0-31b7bfc0f35b5458.nix { };
      gix-date-0_9_3-6d0773e8f7ea4157 = callPackage' ./deps/gix-date-0.9.3-6d0773e8f7ea4157.nix { };
      gix-diff-0_50_0-56281f41a2cabff3 = callPackage' ./deps/gix-diff-0.50.0-56281f41a2cabff3.nix { };
      gix-dir-0_12_0-e3e998ab3cb08ee6 = callPackage' ./deps/gix-dir-0.12.0-e3e998ab3cb08ee6.nix { };
      gix-discover-0_38_0-243df1ed30f8cacf = callPackage' ./deps/gix-discover-0.38.0-243df1ed30f8cacf.nix { };
      gix-features-0_40_0-786b5f2993cbc7d3 = callPackage' ./deps/gix-features-0.40.0-786b5f2993cbc7d3.nix { };
      gix-filter-0_17_0-47e02cbbb6050e2a = callPackage' ./deps/gix-filter-0.17.0-47e02cbbb6050e2a.nix { };
      gix-fs-0_13_0-82d23dce92bde1cf = callPackage' ./deps/gix-fs-0.13.0-82d23dce92bde1cf.nix { };
      gix-glob-0_18_0-cfb0a22bd88ebc1a = callPackage' ./deps/gix-glob-0.18.0-cfb0a22bd88ebc1a.nix { };
      gix-hash-0_16_0-d473f2b9165b7ac8 = callPackage' ./deps/gix-hash-0.16.0-d473f2b9165b7ac8.nix { };
      gix-hashtable-0_7_0-318054c20e5fbfa6 = callPackage' ./deps/gix-hashtable-0.7.0-318054c20e5fbfa6.nix { };
      gix-ignore-0_13_0-feb550e0a5cf7f17 = callPackage' ./deps/gix-ignore-0.13.0-feb550e0a5cf7f17.nix { };
      gix-index-0_38_0-d1d71768249da153 = callPackage' ./deps/gix-index-0.38.0-d1d71768249da153.nix { };
      gix-lock-16_0_0-8d2d91e093879452 = callPackage' ./deps/gix-lock-16.0.0-8d2d91e093879452.nix { };
      gix-negotiate-0_18_0-398a8b405acd631e = callPackage' ./deps/gix-negotiate-0.18.0-398a8b405acd631e.nix { };
      gix-object-0_47_0-d81adbd40609c58b = callPackage' ./deps/gix-object-0.47.0-d81adbd40609c58b.nix { };
      gix-odb-0_67_0-e43f597d8647a021 = callPackage' ./deps/gix-odb-0.67.0-e43f597d8647a021.nix { };
      gix-pack-0_57_0-012506e91304f7af = callPackage' ./deps/gix-pack-0.57.0-012506e91304f7af.nix { };
      gix-packetline-0_18_3-b816ddc0d55273d0 = callPackage' ./deps/gix-packetline-0.18.3-b816ddc0d55273d0.nix { };
      gix-packetline-blocking-0_18_2-2d4b2659c8d16ebe = callPackage' ./deps/gix-packetline-blocking-0.18.2-2d4b2659c8d16ebe.nix { };
      gix-path-0_10_14-fac4f7c597a0c8bd = callPackage' ./deps/gix-path-0.10.14-fac4f7c597a0c8bd.nix { };
      gix-pathspec-0_9_0-dc7b452ba4237f55 = callPackage' ./deps/gix-pathspec-0.9.0-dc7b452ba4237f55.nix { };
      gix-prompt-0_9_1-af9ba06f0c392615 = callPackage' ./deps/gix-prompt-0.9.1-af9ba06f0c392615.nix { };
      gix-protocol-0_48_0-5fdd06620e19fa94 = callPackage' ./deps/gix-protocol-0.48.0-5fdd06620e19fa94.nix { };
      gix-quote-0_4_15-761e55887e5c1d17 = callPackage' ./deps/gix-quote-0.4.15-761e55887e5c1d17.nix { };
      gix-ref-0_50_0-118027e5bbad2abb = callPackage' ./deps/gix-ref-0.50.0-118027e5bbad2abb.nix { };
      gix-refspec-0_28_0-d51836ae4e2212f2 = callPackage' ./deps/gix-refspec-0.28.0-d51836ae4e2212f2.nix { };
      gix-revision-0_32_0-897144e6bad2e45b = callPackage' ./deps/gix-revision-0.32.0-897144e6bad2e45b.nix { };
      gix-revwalk-0_18_0-e12966047159e740 = callPackage' ./deps/gix-revwalk-0.18.0-e12966047159e740.nix { };
      gix-sec-0_10_11-c1812e93e0aabb9f = callPackage' ./deps/gix-sec-0.10.11-c1812e93e0aabb9f.nix { };
      gix-shallow-0_2_0-080d1f139f023928 = callPackage' ./deps/gix-shallow-0.2.0-080d1f139f023928.nix { };
      gix-submodule-0_17_0-06f8f708b9f867fa = callPackage' ./deps/gix-submodule-0.17.0-06f8f708b9f867fa.nix { };
      gix-tempfile-16_0_0-741f0a837b503fa9 = callPackage' ./deps/gix-tempfile-16.0.0-741f0a837b503fa9.nix { };
      gix-trace-0_1_12-718f68523d5ac749 = callPackage' ./deps/gix-trace-0.1.12-718f68523d5ac749.nix { };
      gix-transport-0_45_0-1ea8ae6992c380fb = callPackage' ./deps/gix-transport-0.45.0-1ea8ae6992c380fb.nix { };
      gix-traverse-0_44_0-0ef1034feb6f2559 = callPackage' ./deps/gix-traverse-0.44.0-0ef1034feb6f2559.nix { };
      gix-url-0_29_0-3f47ae4bf8a5f462 = callPackage' ./deps/gix-url-0.29.0-3f47ae4bf8a5f462.nix { };
      gix-utils-0_1_14-1374b61d28fc65a7 = callPackage' ./deps/gix-utils-0.1.14-1374b61d28fc65a7.nix { };
      gix-validate-0_9_3-216a7de78dd3073f = callPackage' ./deps/gix-validate-0.9.3-216a7de78dd3073f.nix { };
      gix-worktree-0_39_0-d4920c30021559e3 = callPackage' ./deps/gix-worktree-0.39.0-d4920c30021559e3.nix { };
      glob-0_3_2-e53520df8dafaafd = callPackage' ./deps/glob-0.3.2-e53520df8dafaafd.nix { };
      globset-0_4_15-c204f6852854b3a1 = callPackage' ./deps/globset-0.4.15-c204f6852854b3a1.nix { };
      group-0_13_0-959c7bb78c337d72 = callPackage' ./deps/group-0.13.0-959c7bb78c337d72.nix { };
      handlebars-6_3_1-576dd3883f721609 = callPackage' ./deps/handlebars-6.3.1-576dd3883f721609.nix { };
      hashbrown-0_14_5-5a3923327447427c = callPackage' ./deps/hashbrown-0.14.5-5a3923327447427c.nix { };
      hashbrown-0_15_2-6ab6a36ed920f298 = callPackage' ./deps/hashbrown-0.15.2-6ab6a36ed920f298.nix { };
      hashlink-0_10_0-0e6ad142faf8aa5f = callPackage' ./deps/hashlink-0.10.0-0e6ad142faf8aa5f.nix { };
      heck-0_5_0-7cca0b380f9fed60 = callPackage' ./deps/heck-0.5.0-7cca0b380f9fed60.nix { };
      hex-0_4_3-d9f97d45c228789e = callPackage' ./deps/hex-0.4.3-d9f97d45c228789e.nix { };
      hkdf-0_12_4-5fa923505668b238 = callPackage' ./deps/hkdf-0.12.4-5fa923505668b238.nix { };
      hmac-0_12_1-bc3929f8e30dab3e = callPackage' ./deps/hmac-0.12.1-bc3929f8e30dab3e.nix { };
      home-0_5_11-918f819357cab881 = callPackage' ./deps/home-0.5.11-918f819357cab881.nix { };
      http-auth-0_1_10-0efb6c0d40dfe9f2 = callPackage' ./deps/http-auth-0.1.10-0efb6c0d40dfe9f2.nix { };
      iana-time-zone-0_1_64-a8b027aa07cfe667 = callPackage' ./deps/iana-time-zone-0.1.64-a8b027aa07cfe667.nix { };
      icu_collections-1_5_0-90410059e9afb9fa = callPackage' ./deps/icu_collections-1.5.0-90410059e9afb9fa.nix { };
      icu_locid-1_5_0-91abdeb33e173e23 = callPackage' ./deps/icu_locid-1.5.0-91abdeb33e173e23.nix { };
      icu_locid_transform-1_5_0-8381e4dfe84a3f83 = callPackage' ./deps/icu_locid_transform-1.5.0-8381e4dfe84a3f83.nix { };
      icu_locid_transform_data-1_5_0-5001d6ff6fb192db = callPackage' ./deps/icu_locid_transform_data-1.5.0-5001d6ff6fb192db.nix { };
      icu_normalizer-1_5_0-194359313be9d7ae = callPackage' ./deps/icu_normalizer-1.5.0-194359313be9d7ae.nix { };
      icu_normalizer_data-1_5_0-619ec124c50639c9 = callPackage' ./deps/icu_normalizer_data-1.5.0-619ec124c50639c9.nix { };
      icu_properties-1_5_1-6d849a19734066a4 = callPackage' ./deps/icu_properties-1.5.1-6d849a19734066a4.nix { };
      icu_properties_data-1_5_0-c313818f7216e2a4 = callPackage' ./deps/icu_properties_data-1.5.0-c313818f7216e2a4.nix { };
      icu_provider-1_5_0-a18007741f2feb04 = callPackage' ./deps/icu_provider-1.5.0-a18007741f2feb04.nix { };
      icu_provider_macros-1_5_0-2dc3f1777bf90bb8 = callPackage' ./deps/icu_provider_macros-1.5.0-2dc3f1777bf90bb8.nix { };
      ident_case-1_0_1-38883fcd263aba6b = callPackage' ./deps/ident_case-1.0.1-38883fcd263aba6b.nix { };
      idna-1_0_3-601f9940603462a3 = callPackage' ./deps/idna-1.0.3-601f9940603462a3.nix { };
      idna_adapter-1_2_0-f13f13d8106967c4 = callPackage' ./deps/idna_adapter-1.2.0-f13f13d8106967c4.nix { };
      ignore-0_4_23-d7082c3c0c554a79 = callPackage' ./deps/ignore-0.4.23-d7082c3c0c554a79.nix { };
      im-rc-15_1_0-da56962fc462ba73 = callPackage' ./deps/im-rc-15.1.0-da56962fc462ba73.nix { };
      im-rc-15_1_0-script_build-107ebc29aa288c61 = callPackage' ./deps/im-rc-15.1.0-script_build-107ebc29aa288c61.nix { };
      im-rc-15_1_0-script_build_run-d8792684cc68fdb8 = callPackage' ./deps/im-rc-15.1.0-script_build_run-d8792684cc68fdb8.nix { };
      indexmap-2_7_1-6b5f2f48a7e1007e = callPackage' ./deps/indexmap-2.7.1-6b5f2f48a7e1007e.nix { };
      indoc-2_0_6-d096069012c7930c = callPackage' ./deps/indoc-2.0.6-d096069012c7930c.nix { };
      is_executable-1_0_4-bee9f7c96c317349 = callPackage' ./deps/is_executable-1.0.4-bee9f7c96c317349.nix { };
      is_terminal_polyfill-1_70_1-b05df178f5b36030 = callPackage' ./deps/is_terminal_polyfill-1.70.1-b05df178f5b36030.nix { };
      itertools-0_14_0-aa0fbdedc8514404 = callPackage' ./deps/itertools-0.14.0-aa0fbdedc8514404.nix { };
      itoa-1_0_14-f807d60e93b08a94 = callPackage' ./deps/itoa-1.0.14-f807d60e93b08a94.nix { };
      jiff-0_1_29-41b3bef036432895 = callPackage' ./deps/jiff-0.1.29-41b3bef036432895.nix { };
      jiff-0_2_3-c3af8ddf56e85995 = callPackage' ./deps/jiff-0.2.3-c3af8ddf56e85995.nix { };
      jobserver-0_1_32-194ee6edd996dcfe = callPackage' ./deps/jobserver-0.1.32-194ee6edd996dcfe.nix { };
      jobserver-0_1_32-bf749e6aa2009df5 = callPackage' ./deps/jobserver-0.1.32-bf749e6aa2009df5.nix { };
      kstring-2_0_2-a79178d67703af0a = callPackage' ./deps/kstring-2.0.2-a79178d67703af0a.nix { };
      lazy_static-1_5_0-24e6a7dcc86d716c = callPackage' ./deps/lazy_static-1.5.0-24e6a7dcc86d716c.nix { };
      lazycell-1_3_0-f94eeda76d97df1a = callPackage' ./deps/lazycell-1.3.0-f94eeda76d97df1a.nix { };
      libc-0_2_175-b265bb513a0388f3 = callPackage' ./deps/libc-0.2.175-b265bb513a0388f3.nix { };
      libc-0_2_175-c1de36c6b4119d87 = callPackage' ./deps/libc-0.2.175-c1de36c6b4119d87.nix { };
      libc-0_2_175-script_build-3e7315495ba0d9cb = callPackage' ./deps/libc-0.2.175-script_build-3e7315495ba0d9cb.nix { };
      libc-0_2_175-script_build_run-b535b13a5bf2f5a2 = callPackage' ./deps/libc-0.2.175-script_build_run-b535b13a5bf2f5a2.nix { };
      libc-0_2_175-script_build_run-b778f13adc7035ee = callPackage' ./deps/libc-0.2.175-script_build_run-b778f13adc7035ee.nix { };
      libgit2-sys-0_18_0_plus_1_9_0-7c92f3a3d35092c8 = callPackage' ./deps/libgit2-sys-0.18.0_plus_1.9.0-7c92f3a3d35092c8.nix { };
      libgit2-sys-0_18_0_plus_1_9_0-script_build-7aac88d9d89789eb = callPackage' ./deps/libgit2-sys-0.18.0_plus_1.9.0-script_build-7aac88d9d89789eb.nix { };
      libgit2-sys-0_18_0_plus_1_9_0-script_build_run-5a9ff40869530baf = callPackage' ./deps/libgit2-sys-0.18.0_plus_1.9.0-script_build_run-5a9ff40869530baf.nix { };
      libloading-0_8_6-4059f906086e733b = callPackage' ./deps/libloading-0.8.6-4059f906086e733b.nix { };
      libnghttp2-sys-0_1_11_plus_1_64_0-fc24622a308fad5a = callPackage' ./deps/libnghttp2-sys-0.1.11_plus_1.64.0-fc24622a308fad5a.nix { };
      libnghttp2-sys-0_1_11_plus_1_64_0-script_build-b8955650ab97a961 = callPackage' ./deps/libnghttp2-sys-0.1.11_plus_1.64.0-script_build-b8955650ab97a961.nix { };
      libnghttp2-sys-0_1_11_plus_1_64_0-script_build_run-80246f34416f2ddc = callPackage' ./deps/libnghttp2-sys-0.1.11_plus_1.64.0-script_build_run-80246f34416f2ddc.nix { };
      libsqlite3-sys-0_31_0-16ed399da4d69400 = callPackage' ./deps/libsqlite3-sys-0.31.0-16ed399da4d69400.nix { };
      libsqlite3-sys-0_31_0-script_build-65af74c81b4b60aa = callPackage' ./deps/libsqlite3-sys-0.31.0-script_build-65af74c81b4b60aa.nix { };
      libsqlite3-sys-0_31_0-script_build_run-c31a64d006305f9c = callPackage' ./deps/libsqlite3-sys-0.31.0-script_build_run-c31a64d006305f9c.nix { };
      libssh2-sys-0_3_1-6cd042864dac375d = callPackage' ./deps/libssh2-sys-0.3.1-6cd042864dac375d.nix { };
      libssh2-sys-0_3_1-script_build-6dcd35b2650a9ca9 = callPackage' ./deps/libssh2-sys-0.3.1-script_build-6dcd35b2650a9ca9.nix { };
      libssh2-sys-0_3_1-script_build_run-da060cf47d1b21a6 = callPackage' ./deps/libssh2-sys-0.3.1-script_build_run-da060cf47d1b21a6.nix { };
      libz-sys-1_1_21-4cbe081b1eadb6dd = callPackage' ./deps/libz-sys-1.1.21-4cbe081b1eadb6dd.nix { };
      libz-sys-1_1_21-8eb7d635fee6f8cb = callPackage' ./deps/libz-sys-1.1.21-8eb7d635fee6f8cb.nix { };
      libz-sys-1_1_21-script_build-651e502638c65cf8 = callPackage' ./deps/libz-sys-1.1.21-script_build-651e502638c65cf8.nix { };
      libz-sys-1_1_21-script_build-cacaf64eab4d17c8 = callPackage' ./deps/libz-sys-1.1.21-script_build-cacaf64eab4d17c8.nix { };
      libz-sys-1_1_21-script_build_run-685e49eac1c25b95 = callPackage' ./deps/libz-sys-1.1.21-script_build_run-685e49eac1c25b95.nix { };
      libz-sys-1_1_21-script_build_run-761a456dbed333b2 = callPackage' ./deps/libz-sys-1.1.21-script_build_run-761a456dbed333b2.nix { };
      linux-raw-sys-0_4_15-d3d37c3fa729a730 = callPackage' ./deps/linux-raw-sys-0.4.15-d3d37c3fa729a730.nix { };
      litemap-0_7_4-a3cf4da1c045c439 = callPackage' ./deps/litemap-0.7.4-a3cf4da1c045c439.nix { };
      lock_api-0_4_12-88e61f41ab242739 = callPackage' ./deps/lock_api-0.4.12-88e61f41ab242739.nix { };
      lock_api-0_4_12-script_build-32f26ccb87f26f79 = callPackage' ./deps/lock_api-0.4.12-script_build-32f26ccb87f26f79.nix { };
      lock_api-0_4_12-script_build_run-e5bf3553f6529fb8 = callPackage' ./deps/lock_api-0.4.12-script_build_run-e5bf3553f6529fb8.nix { };
      log-0_4_25-fde7ab722b325b0e = callPackage' ./deps/log-0.4.25-fde7ab722b325b0e.nix { };
      logone-0_2_9-ae524b4cfa794eda = callPackage' ./deps/logone-0.2.9-ae524b4cfa794eda.nix { };
      matchers-0_1_0-cf1bfca3c1f785d1 = callPackage' ./deps/matchers-0.1.0-cf1bfca3c1f785d1.nix { };
      maybe-async-0_2_10-501cd4a953f30b1b = callPackage' ./deps/maybe-async-0.2.10-501cd4a953f30b1b.nix { };
      memchr-2_7_4-a0e5828b48f06e07 = callPackage' ./deps/memchr-2.7.4-a0e5828b48f06e07.nix { };
      memchr-2_7_4-e080da661eb56e29 = callPackage' ./deps/memchr-2.7.4-e080da661eb56e29.nix { };
      memmap2-0_9_5-ad06fecf20fe7317 = callPackage' ./deps/memmap2-0.9.5-ad06fecf20fe7317.nix { };
      minimal-lexical-0_2_1-4dbb39547b607d17 = callPackage' ./deps/minimal-lexical-0.2.1-4dbb39547b607d17.nix { };
      miniz_oxide-0_8_5-dd96155c9162e8a2 = callPackage' ./deps/miniz_oxide-0.8.5-dd96155c9162e8a2.nix { };
      mio-0_8_11-4f2afca5af8b8fd0 = callPackage' ./deps/mio-0.8.11-4f2afca5af8b8fd0.nix { };
      nom-7_1_3-b6ce546ffc2ca11c = callPackage' ./deps/nom-7.1.3-b6ce546ffc2ca11c.nix { };
      nu-ansi-term-0_46_0-7a72ea8fdd3dc3c3 = callPackage' ./deps/nu-ansi-term-0.46.0-7a72ea8fdd3dc3c3.nix { };
      num-conv-0_1_0-ad9feb8f6a55300b = callPackage' ./deps/num-conv-0.1.0-ad9feb8f6a55300b.nix { };
      num-modular-0_6_1-e25974689701d542 = callPackage' ./deps/num-modular-0.6.1-e25974689701d542.nix { };
      num-order-1_2_0-eff9366d228c9b94 = callPackage' ./deps/num-order-1.2.0-eff9366d228c9b94.nix { };
      num-traits-0_2_19-e470ad1dd03fa99a = callPackage' ./deps/num-traits-0.2.19-e470ad1dd03fa99a.nix { };
      num-traits-0_2_19-script_build-1439b8816ccd5d7f = callPackage' ./deps/num-traits-0.2.19-script_build-1439b8816ccd5d7f.nix { };
      num-traits-0_2_19-script_build_run-751c349c04aeff9e = callPackage' ./deps/num-traits-0.2.19-script_build_run-751c349c04aeff9e.nix { };
      once_cell-1_20_3-469ccbdd2c0eb86a = callPackage' ./deps/once_cell-1.20.3-469ccbdd2c0eb86a.nix { };
      once_cell-1_20_3-65600a49c06310f1 = callPackage' ./deps/once_cell-1.20.3-65600a49c06310f1.nix { };
      opener-0_7_2-62099bf816df8f93 = callPackage' ./deps/opener-0.7.2-62099bf816df8f93.nix { };
      openssl-probe-0_1_6-2b78ced4e82f241d = callPackage' ./deps/openssl-probe-0.1.6-2b78ced4e82f241d.nix { };
      openssl-sys-0_9_106-fe430717cd107543 = callPackage' ./deps/openssl-sys-0.9.106-fe430717cd107543.nix { };
      openssl-sys-0_9_106-script_build-00ef8a6cf885066c = callPackage' ./deps/openssl-sys-0.9.106-script_build-00ef8a6cf885066c.nix { };
      openssl-sys-0_9_106-script_build_run-f0141b8f842986bf = callPackage' ./deps/openssl-sys-0.9.106-script_build_run-f0141b8f842986bf.nix { };
      ordered-float-2_10_1-9038a1abe48f7d3f = callPackage' ./deps/ordered-float-2.10.1-9038a1abe48f7d3f.nix { };
      orion-0_17_8-5d62f2ea845e8b5f = callPackage' ./deps/orion-0.17.8-5d62f2ea845e8b5f.nix { };
      os_info-3_10_0-110090feb8887db7 = callPackage' ./deps/os_info-3.10.0-110090feb8887db7.nix { };
      overload-0_1_1-9764eb23d505b8dd = callPackage' ./deps/overload-0.1.1-9764eb23d505b8dd.nix { };
      p384-0_13_1-7d858bca7ae4dcb6 = callPackage' ./deps/p384-0.13.1-7d858bca7ae4dcb6.nix { };
      parking_lot-0_12_3-bd00df7ddce28121 = callPackage' ./deps/parking_lot-0.12.3-bd00df7ddce28121.nix { };
      parking_lot_core-0_9_10-2bd58251de7bc904 = callPackage' ./deps/parking_lot_core-0.9.10-2bd58251de7bc904.nix { };
      parking_lot_core-0_9_10-script_build-a14671daa7ac8ab9 = callPackage' ./deps/parking_lot_core-0.9.10-script_build-a14671daa7ac8ab9.nix { };
      parking_lot_core-0_9_10-script_build_run-323cca02bf1fcaa8 = callPackage' ./deps/parking_lot_core-0.9.10-script_build_run-323cca02bf1fcaa8.nix { };
      pasetors-0_7_2-ec9d83f095443be2 = callPackage' ./deps/pasetors-0.7.2-ec9d83f095443be2.nix { };
      pathdiff-0_2_3-1e0bf37cc5ac710a = callPackage' ./deps/pathdiff-0.2.3-1e0bf37cc5ac710a.nix { };
      pem-rfc7468-0_7_0-a2854727203f56cc = callPackage' ./deps/pem-rfc7468-0.7.0-a2854727203f56cc.nix { };
      percent-encoding-2_3_1-87897a77b555a548 = callPackage' ./deps/percent-encoding-2.3.1-87897a77b555a548.nix { };
      pest-2_7_15-59e44ce85cf440fb = callPackage' ./deps/pest-2.7.15-59e44ce85cf440fb.nix { };
      pest-2_7_15-d1d50d7cd3dcc47b = callPackage' ./deps/pest-2.7.15-d1d50d7cd3dcc47b.nix { };
      pest_derive-2_7_15-928e1e57d91e264c = callPackage' ./deps/pest_derive-2.7.15-928e1e57d91e264c.nix { };
      pest_generator-2_7_15-85e6b47a9be60b20 = callPackage' ./deps/pest_generator-2.7.15-85e6b47a9be60b20.nix { };
      pest_meta-2_7_15-d270fb98bcde068c = callPackage' ./deps/pest_meta-2.7.15-d270fb98bcde068c.nix { };
      pin-project-lite-0_2_16-f8d8932d926df9e6 = callPackage' ./deps/pin-project-lite-0.2.16-f8d8932d926df9e6.nix { };
      pkcs8-0_10_2-d9da1a442d6d1c2e = callPackage' ./deps/pkcs8-0.10.2-d9da1a442d6d1c2e.nix { };
      pkg-config-0_3_31-ff42e244d259eb1a = callPackage' ./deps/pkg-config-0.3.31-ff42e244d259eb1a.nix { };
      powerfmt-0_2_0-85c859974cceb22a = callPackage' ./deps/powerfmt-0.2.0-85c859974cceb22a.nix { };
      ppv-lite86-0_2_20-42fae012c872c1dd = callPackage' ./deps/ppv-lite86-0.2.20-42fae012c872c1dd.nix { };
      primeorder-0_13_6-a91d5073f79f4881 = callPackage' ./deps/primeorder-0.13.6-a91d5073f79f4881.nix { };
      proc-macro2-1_0_93-8972bce74b99a2b8 = callPackage' ./deps/proc-macro2-1.0.93-8972bce74b99a2b8.nix { };
      proc-macro2-1_0_93-script_build-9d8a03f0bd260577 = callPackage' ./deps/proc-macro2-1.0.93-script_build-9d8a03f0bd260577.nix { };
      proc-macro2-1_0_93-script_build_run-63c84d0e53e082e9 = callPackage' ./deps/proc-macro2-1.0.93-script_build_run-63c84d0e53e082e9.nix { };
      prodash-29_0_0-d9f2709fb236f900 = callPackage' ./deps/prodash-29.0.0-d9f2709fb236f900.nix { };
      quote-1_0_38-69fc837ab5040c10 = callPackage' ./deps/quote-1.0.38-69fc837ab5040c10.nix { };
      rand-0_9_0-9c1f064fb8df1dbe = callPackage' ./deps/rand-0.9.0-9c1f064fb8df1dbe.nix { };
      rand_chacha-0_9_0-4430ec8a1f2a5523 = callPackage' ./deps/rand_chacha-0.9.0-4430ec8a1f2a5523.nix { };
      rand_core-0_6_4-fb3f0a376173ae44 = callPackage' ./deps/rand_core-0.6.4-fb3f0a376173ae44.nix { };
      rand_core-0_9_0-57170fd9c65611fe = callPackage' ./deps/rand_core-0.9.0-57170fd9c65611fe.nix { };
      rand_xoshiro-0_6_0-85d0bd006bb29f8e = callPackage' ./deps/rand_xoshiro-0.6.0-85d0bd006bb29f8e.nix { };
      regex-1_11_1-78f28ee524c2cf84 = callPackage' ./deps/regex-1.11.1-78f28ee524c2cf84.nix { };
      regex-automata-0_1_10-deb83e2a03dd8d85 = callPackage' ./deps/regex-automata-0.1.10-deb83e2a03dd8d85.nix { };
      regex-automata-0_4_9-09b7fa440d2dfa3a = callPackage' ./deps/regex-automata-0.4.9-09b7fa440d2dfa3a.nix { };
      regex-syntax-0_6_29-df81fbfb6d4012a2 = callPackage' ./deps/regex-syntax-0.6.29-df81fbfb6d4012a2.nix { };
      regex-syntax-0_8_5-32c6de4fe11e3b8f = callPackage' ./deps/regex-syntax-0.8.5-32c6de4fe11e3b8f.nix { };
      rfc6979-0_4_0-efb691326bf41a38 = callPackage' ./deps/rfc6979-0.4.0-efb691326bf41a38.nix { };
      rusqlite-0_33_0-8c318caee200e796 = callPackage' ./deps/rusqlite-0.33.0-8c318caee200e796.nix { };
      rustc-hash-2_1_1-56f40b181a89ccb3 = callPackage' ./deps/rustc-hash-2.1.1-56f40b181a89ccb3.nix { };
      rustc-stable-hash-0_1_2-b8337645b79370b8 = callPackage' ./deps/rustc-stable-hash-0.1.2-b8337645b79370b8.nix { };
      rustix-0_38_44-bb44290fdf9a9b11 = callPackage' ./deps/rustix-0.38.44-bb44290fdf9a9b11.nix { };
      rustix-0_38_44-script_build-1617132ebd0bc328 = callPackage' ./deps/rustix-0.38.44-script_build-1617132ebd0bc328.nix { };
      rustix-0_38_44-script_build_run-7c5cbcfc99e66ddd = callPackage' ./deps/rustix-0.38.44-script_build_run-7c5cbcfc99e66ddd.nix { };
      ryu-1_0_19-36ea88351cfb3047 = callPackage' ./deps/ryu-1.0.19-36ea88351cfb3047.nix { };
      same-file-1_0_6-c702782bc8f9cf83 = callPackage' ./deps/same-file-1.0.6-c702782bc8f9cf83.nix { };
      scopeguard-1_2_0-81ac818d244aecf5 = callPackage' ./deps/scopeguard-1.2.0-81ac818d244aecf5.nix { };
      sec1-0_7_3-405cf947070e5373 = callPackage' ./deps/sec1-0.7.3-405cf947070e5373.nix { };
      semver-1_0_25-66c86f3f308501e7 = callPackage' ./deps/semver-1.0.25-66c86f3f308501e7.nix { };
      semver-1_0_25-script_build-c0920cb94340a076 = callPackage' ./deps/semver-1.0.25-script_build-c0920cb94340a076.nix { };
      semver-1_0_25-script_build_run-683fc960cd3565a4 = callPackage' ./deps/semver-1.0.25-script_build_run-683fc960cd3565a4.nix { };
      serde-1_0_218-ed8707ff8dc168e7 = callPackage' ./deps/serde-1.0.218-ed8707ff8dc168e7.nix { };
      serde-1_0_218-script_build-ea5202fe569cdd0b = callPackage' ./deps/serde-1.0.218-script_build-ea5202fe569cdd0b.nix { };
      serde-1_0_218-script_build_run-25e53cb7dcc4d452 = callPackage' ./deps/serde-1.0.218-script_build_run-25e53cb7dcc4d452.nix { };
      serde-untagged-0_1_6-c26af987742396e6 = callPackage' ./deps/serde-untagged-0.1.6-c26af987742396e6.nix { };
      serde-value-0_7_0-e37675eb779359e0 = callPackage' ./deps/serde-value-0.7.0-e37675eb779359e0.nix { };
      serde_derive-1_0_218-b6393777f476bd76 = callPackage' ./deps/serde_derive-1.0.218-b6393777f476bd76.nix { };
      serde_ignored-0_1_10-71b955e71e7f10ed = callPackage' ./deps/serde_ignored-0.1.10-71b955e71e7f10ed.nix { };
      serde_json-1_0_139-17182eb61f3853cc = callPackage' ./deps/serde_json-1.0.139-17182eb61f3853cc.nix { };
      serde_json-1_0_139-script_build-45e4b2f960af770d = callPackage' ./deps/serde_json-1.0.139-script_build-45e4b2f960af770d.nix { };
      serde_json-1_0_139-script_build_run-3855ca059ae92bb9 = callPackage' ./deps/serde_json-1.0.139-script_build_run-3855ca059ae92bb9.nix { };
      serde_spanned-0_6_8-f8cca0b2ce20b137 = callPackage' ./deps/serde_spanned-0.6.8-f8cca0b2ce20b137.nix { };
      sha1-0_10_6-0cf4bfd2ea90fd1c = callPackage' ./deps/sha1-0.10.6-0cf4bfd2ea90fd1c.nix { };
      sha1_smol-1_0_1-86ced37a4bdc59fd = callPackage' ./deps/sha1_smol-1.0.1-86ced37a4bdc59fd.nix { };
      sha2-0_10_8-259709e389f530eb = callPackage' ./deps/sha2-0.10.8-259709e389f530eb.nix { };
      sharded-slab-0_1_7-36acbe64fa71ca81 = callPackage' ./deps/sharded-slab-0.1.7-36acbe64fa71ca81.nix { };
      shell-escape-0_1_5-2dddd153d3f4fa85 = callPackage' ./deps/shell-escape-0.1.5-2dddd153d3f4fa85.nix { };
      shell-words-1_1_0-52889fbb9bcda006 = callPackage' ./deps/shell-words-1.1.0-52889fbb9bcda006.nix { };
      shlex-1_3_0-9957bda8660cd585 = callPackage' ./deps/shlex-1.3.0-9957bda8660cd585.nix { };
      shlex-1_3_0-d9cdabc28e4bcb3e = callPackage' ./deps/shlex-1.3.0-d9cdabc28e4bcb3e.nix { };
      signal-hook-0_3_18-e8d16b5f96fe21a7 = callPackage' ./deps/signal-hook-0.3.18-e8d16b5f96fe21a7.nix { };
      signal-hook-0_3_18-script_build-c859dcc9b5669dc0 = callPackage' ./deps/signal-hook-0.3.18-script_build-c859dcc9b5669dc0.nix { };
      signal-hook-0_3_18-script_build_run-ef232cac941a5dce = callPackage' ./deps/signal-hook-0.3.18-script_build_run-ef232cac941a5dce.nix { };
      signal-hook-mio-0_2_4-1832b50a039b9f0e = callPackage' ./deps/signal-hook-mio-0.2.4-1832b50a039b9f0e.nix { };
      signal-hook-registry-1_4_6-8d59c67727f45690 = callPackage' ./deps/signal-hook-registry-1.4.6-8d59c67727f45690.nix { };
      signature-2_2_0-6f3debade63d7ac5 = callPackage' ./deps/signature-2.2.0-6f3debade63d7ac5.nix { };
      sized-chunks-0_6_5-c0f56a3159cd521e = callPackage' ./deps/sized-chunks-0.6.5-c0f56a3159cd521e.nix { };
      smallvec-1_13_2-0ef9b24879be6fdc = callPackage' ./deps/smallvec-1.13.2-0ef9b24879be6fdc.nix { };
      socket2-0_5_8-7375dc9fb1a41258 = callPackage' ./deps/socket2-0.5.8-7375dc9fb1a41258.nix { };
      spki-0_7_3-75041267a176d535 = callPackage' ./deps/spki-0.7.3-75041267a176d535.nix { };
      stable_deref_trait-1_2_0-232ca7c28cd47370 = callPackage' ./deps/stable_deref_trait-1.2.0-232ca7c28cd47370.nix { };
      static_assertions-1_1_0-be7ec43b24b99f28 = callPackage' ./deps/static_assertions-1.1.0-be7ec43b24b99f28.nix { };
      strsim-0_11_1-88401f09d2ecd1d9 = callPackage' ./deps/strsim-0.11.1-88401f09d2ecd1d9.nix { };
      strsim-0_11_1-ffcb0b37b460fa77 = callPackage' ./deps/strsim-0.11.1-ffcb0b37b460fa77.nix { };
      subtle-2_6_1-0584afad8ebd85c1 = callPackage' ./deps/subtle-2.6.1-0584afad8ebd85c1.nix { };
      supports-hyperlinks-3_1_0-047db521a6002c93 = callPackage' ./deps/supports-hyperlinks-3.1.0-047db521a6002c93.nix { };
      supports-unicode-3_0_0-fe8b7a4d9f1dccb8 = callPackage' ./deps/supports-unicode-3.0.0-fe8b7a4d9f1dccb8.nix { };
      syn-2_0_98-cf14ab7ccae9dbe8 = callPackage' ./deps/syn-2.0.98-cf14ab7ccae9dbe8.nix { };
      synstructure-0_13_1-061b7676a8143f31 = callPackage' ./deps/synstructure-0.13.1-061b7676a8143f31.nix { };
      tar-0_4_44-e93826121758945b = callPackage' ./deps/tar-0.4.44-e93826121758945b.nix { };
      tar-0_4_44-ec5e86963dbd14f3 = callPackage' ./deps/tar-0.4.44-ec5e86963dbd14f3.nix { };
      tempfile-3_17_1-b08d0e8469fdeafa = callPackage' ./deps/tempfile-3.17.1-b08d0e8469fdeafa.nix { };
      terminal_size-0_4_1-3f8cbf1619d40d95 = callPackage' ./deps/terminal_size-0.4.1-3f8cbf1619d40d95.nix { };
      thiserror-1_0_69-61a1a8bbaffd387d = callPackage' ./deps/thiserror-1.0.69-61a1a8bbaffd387d.nix { };
      thiserror-1_0_69-script_build-efdbb848505035e6 = callPackage' ./deps/thiserror-1.0.69-script_build-efdbb848505035e6.nix { };
      thiserror-1_0_69-script_build_run-1dad87b2fa437ef8 = callPackage' ./deps/thiserror-1.0.69-script_build_run-1dad87b2fa437ef8.nix { };
      thiserror-2_0_11-c6c4ee382aacde15 = callPackage' ./deps/thiserror-2.0.11-c6c4ee382aacde15.nix { };
      thiserror-2_0_11-e8a246e25e4f6dfd = callPackage' ./deps/thiserror-2.0.11-e8a246e25e4f6dfd.nix { };
      thiserror-2_0_11-script_build-fba4a45f74aabdd3 = callPackage' ./deps/thiserror-2.0.11-script_build-fba4a45f74aabdd3.nix { };
      thiserror-2_0_11-script_build_run-8296f45a178e6d2d = callPackage' ./deps/thiserror-2.0.11-script_build_run-8296f45a178e6d2d.nix { };
      thiserror-2_0_11-script_build_run-d6ba5533733cef05 = callPackage' ./deps/thiserror-2.0.11-script_build_run-d6ba5533733cef05.nix { };
      thiserror-impl-1_0_69-efa88985d450d0cc = callPackage' ./deps/thiserror-impl-1.0.69-efa88985d450d0cc.nix { };
      thiserror-impl-2_0_11-cf1730cbf825e28a = callPackage' ./deps/thiserror-impl-2.0.11-cf1730cbf825e28a.nix { };
      thread_local-1_1_8-c649412a866b5e65 = callPackage' ./deps/thread_local-1.1.8-c649412a866b5e65.nix { };
      time-0_3_37-470f9c4ebcfb97a1 = callPackage' ./deps/time-0.3.37-470f9c4ebcfb97a1.nix { };
      time-core-0_1_2-7f4ef3fe093734ac = callPackage' ./deps/time-core-0.1.2-7f4ef3fe093734ac.nix { };
      tinystr-0_7_6-96e7f5be7ff0a0c7 = callPackage' ./deps/tinystr-0.7.6-96e7f5be7ff0a0c7.nix { };
      tinyvec-1_8_1-09034d7dbfc00fb2 = callPackage' ./deps/tinyvec-1.8.1-09034d7dbfc00fb2.nix { };
      tinyvec_macros-0_1_1-2565c78e7e88e46d = callPackage' ./deps/tinyvec_macros-0.1.1-2565c78e7e88e46d.nix { };
      toml-0_8_20-b9f11c4f8c54e863 = callPackage' ./deps/toml-0.8.20-b9f11c4f8c54e863.nix { };
      toml_datetime-0_6_8-95cf01ad2f83568d = callPackage' ./deps/toml_datetime-0.6.8-95cf01ad2f83568d.nix { };
      toml_edit-0_22_24-265a869043520f6a = callPackage' ./deps/toml_edit-0.22.24-265a869043520f6a.nix { };
      tracing-0_1_41-f95fa3c0b6430cd1 = callPackage' ./deps/tracing-0.1.41-f95fa3c0b6430cd1.nix { };
      tracing-attributes-0_1_28-93b80f5e76ca28cd = callPackage' ./deps/tracing-attributes-0.1.28-93b80f5e76ca28cd.nix { };
      tracing-chrome-0_7_2-69c67e5ad43699de = callPackage' ./deps/tracing-chrome-0.7.2-69c67e5ad43699de.nix { };
      tracing-core-0_1_33-aece38920b28e8c6 = callPackage' ./deps/tracing-core-0.1.33-aece38920b28e8c6.nix { };
      tracing-log-0_2_0-d275e906c288b142 = callPackage' ./deps/tracing-log-0.2.0-d275e906c288b142.nix { };
      tracing-subscriber-0_3_19-5f4c4d18551b276c = callPackage' ./deps/tracing-subscriber-0.3.19-5f4c4d18551b276c.nix { };
      typeid-1_0_2-06b80a723e60dba2 = callPackage' ./deps/typeid-1.0.2-06b80a723e60dba2.nix { };
      typeid-1_0_2-script_build-7d9a84fcce5c617d = callPackage' ./deps/typeid-1.0.2-script_build-7d9a84fcce5c617d.nix { };
      typeid-1_0_2-script_build_run-5defda54e8752cb1 = callPackage' ./deps/typeid-1.0.2-script_build_run-5defda54e8752cb1.nix { };
      typenum-1_17_0-2372da56c1d08181 = callPackage' ./deps/typenum-1.17.0-2372da56c1d08181.nix { };
      typenum-1_17_0-script_build-4323ae1d5b8b7451 = callPackage' ./deps/typenum-1.17.0-script_build-4323ae1d5b8b7451.nix { };
      typenum-1_17_0-script_build_run-a83672c2e2612cfc = callPackage' ./deps/typenum-1.17.0-script_build_run-a83672c2e2612cfc.nix { };
      ucd-trie-0_1_7-994acf8cea80d6cd = callPackage' ./deps/ucd-trie-0.1.7-994acf8cea80d6cd.nix { };
      ucd-trie-0_1_7-e40b6b81debbe578 = callPackage' ./deps/ucd-trie-0.1.7-e40b6b81debbe578.nix { };
      unicase-2_8_1-8a7dec03eccfaf46 = callPackage' ./deps/unicase-2.8.1-8a7dec03eccfaf46.nix { };
      unicode-bom-2_0_3-0618da7d75fc7211 = callPackage' ./deps/unicode-bom-2.0.3-0618da7d75fc7211.nix { };
      unicode-ident-1_0_17-5936f20930bcc897 = callPackage' ./deps/unicode-ident-1.0.17-5936f20930bcc897.nix { };
      unicode-normalization-0_1_24-64cc5e0be95aacea = callPackage' ./deps/unicode-normalization-0.1.24-64cc5e0be95aacea.nix { };
      unicode-width-0_2_0-76d8e9c15baf673e = callPackage' ./deps/unicode-width-0.2.0-76d8e9c15baf673e.nix { };
      unicode-xid-0_2_6-37bd325ac1f9ec54 = callPackage' ./deps/unicode-xid-0.2.6-37bd325ac1f9ec54.nix { };
      url-2_5_4-659fce6bf9b29cb7 = callPackage' ./deps/url-2.5.4-659fce6bf9b29cb7.nix { };
      utf16_iter-1_0_5-ff3a92cdd008ffcf = callPackage' ./deps/utf16_iter-1.0.5-ff3a92cdd008ffcf.nix { };
      utf8_iter-1_0_4-e624cb7375090120 = callPackage' ./deps/utf8_iter-1.0.4-e624cb7375090120.nix { };
      utf8parse-0_2_2-1739a9af55e652af = callPackage' ./deps/utf8parse-0.2.2-1739a9af55e652af.nix { };
      vcpkg-0_2_15-84f0b17bdeb2a70f = callPackage' ./deps/vcpkg-0.2.15-84f0b17bdeb2a70f.nix { };
      version_check-0_9_5-141f421cbfdea5c4 = callPackage' ./deps/version_check-0.9.5-141f421cbfdea5c4.nix { };
      walkdir-2_5_0-1df263e29c1f7c83 = callPackage' ./deps/walkdir-2.5.0-1df263e29c1f7c83.nix { };
      winnow-0_6_26-00c0f9b758fcdd54 = callPackage' ./deps/winnow-0.6.26-00c0f9b758fcdd54.nix { };
      winnow-0_7_1-77a2b40bdf68ade2 = callPackage' ./deps/winnow-0.7.1-77a2b40bdf68ade2.nix { };
      write16-1_0_0-5e50a6c748aa8579 = callPackage' ./deps/write16-1.0.0-5e50a6c748aa8579.nix { };
      writeable-0_5_5-97bfc8c1356c8584 = callPackage' ./deps/writeable-0.5.5-97bfc8c1356c8584.nix { };
      yoke-0_7_5-0ab2f7371d50855c = callPackage' ./deps/yoke-0.7.5-0ab2f7371d50855c.nix { };
      yoke-derive-0_7_5-7f7cc48008852617 = callPackage' ./deps/yoke-derive-0.7.5-7f7cc48008852617.nix { };
      zerocopy-0_7_35-3bfa5c0641b64c54 = callPackage' ./deps/zerocopy-0.7.35-3bfa5c0641b64c54.nix { };
      zerocopy-0_8_17-04d0527ad86fa315 = callPackage' ./deps/zerocopy-0.8.17-04d0527ad86fa315.nix { };
      zerocopy-0_8_17-script_build-e99c5b6fa21fd0f7 = callPackage' ./deps/zerocopy-0.8.17-script_build-e99c5b6fa21fd0f7.nix { };
      zerocopy-0_8_17-script_build_run-e58836af3abc2c45 = callPackage' ./deps/zerocopy-0.8.17-script_build_run-e58836af3abc2c45.nix { };
      zerocopy-derive-0_7_35-dd0eb8a6661fb4f3 = callPackage' ./deps/zerocopy-derive-0.7.35-dd0eb8a6661fb4f3.nix { };
      zerofrom-0_1_5-ea748ae3ec88a0de = callPackage' ./deps/zerofrom-0.1.5-ea748ae3ec88a0de.nix { };
      zerofrom-derive-0_1_5-4c9e526eab656252 = callPackage' ./deps/zerofrom-derive-0.1.5-4c9e526eab656252.nix { };
      zeroize-1_8_1-966e26bee9773779 = callPackage' ./deps/zeroize-1.8.1-966e26bee9773779.nix { };
      zerovec-0_10_4-b38efa70d7d8c99c = callPackage' ./deps/zerovec-0.10.4-b38efa70d7d8c99c.nix { };
      zerovec-derive-0_10_3-fca232bfd80b946c = callPackage' ./deps/zerovec-derive-0.10.3-fca232bfd80b946c.nix { };
    };
  };
in
self
