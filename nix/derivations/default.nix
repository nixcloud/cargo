# generated from default.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, rustc, cargo, external_crate_dependencies, build_rs_libnix ? null, project_root }:
let
  lib = pkgs.lib;
  callPackage' = lib.callPackageWith (pkgs // lib // self // { inherit fn rustc cargo project_root; });
  fn = rec {
    build_rs_libnix' =
      if build_rs_libnix != null then
        "${build_rs_libnix}/bin/build-rs-libnix"
      else
        "${cargo}/bin/cargo build build-rs-nix";
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
    build-rs-libnix-0_1_10-c4222d9c28b5ac49 = callPackage' ./build-rs-libnix-0.1.10-c4222d9c28b5ac49.nix { };
    cargo-0_88_0-46cd318ceff9739d = callPackage' ./cargo-0.88.0-46cd318ceff9739d.nix { };
    cargo-0_88_0-bin-25c525326f58ed30 = callPackage' ./cargo-0.88.0-bin-25c525326f58ed30.nix { };
    cargo-0_88_0-script_build-cfc654fccb259515 = callPackage' ./cargo-0.88.0-script_build-cfc654fccb259515.nix { };
    cargo-0_88_0-script_build_run-f5d51778f22880c0 = callPackage' ./cargo-0.88.0-script_build_run-f5d51778f22880c0.nix { };
    cargo-credential-0_4_8-a5adc6ab9fe103b0 = callPackage' ./cargo-credential-0.4.8-a5adc6ab9fe103b0.nix { };
    cargo-credential-libsecret-0_4_13-4e698a0b35f72d06 = callPackage' ./cargo-credential-libsecret-0.4.13-4e698a0b35f72d06.nix { };
    cargo-platform-0_2_0-c5f768769f22a333 = callPackage' ./cargo-platform-0.2.0-c5f768769f22a333.nix { };
    cargo-util-0_2_20-7087e4a73afc7b23 = callPackage' ./cargo-util-0.2.20-7087e4a73afc7b23.nix { };
    cargo-util-schemas-0_8_1-bce7b79eff35b46a = callPackage' ./cargo-util-schemas-0.8.1-bce7b79eff35b46a.nix { };
    crates-io-0_40_10-cb0425982b906266 = callPackage' ./crates-io-0.40.10-cb0425982b906266.nix { };
    rustfix-0_9_0-9f1c66820d29e14a = callPackage' ./rustfix-0.9.0-9f1c66820d29e14a.nix { };
    deps = {
      adler2-2_0_0-115180b36279fc7c = callPackage' ./deps/adler2-2.0.0-115180b36279fc7c.nix { };
      ahash-0_8_11-8f60023f209663c7 = callPackage' ./deps/ahash-0.8.11-8f60023f209663c7.nix { };
      ahash-0_8_11-script_build-dfb7cac56dd48573 = callPackage' ./deps/ahash-0.8.11-script_build-dfb7cac56dd48573.nix { };
      ahash-0_8_11-script_build_run-e66d9dc18aec0370 = callPackage' ./deps/ahash-0.8.11-script_build_run-e66d9dc18aec0370.nix { };
      aho-corasick-1_1_3-4faf1ab2f37c32c1 = callPackage' ./deps/aho-corasick-1.1.3-4faf1ab2f37c32c1.nix { };
      allocator-api2-0_2_21-bd3713078dfee01f = callPackage' ./deps/allocator-api2-0.2.21-bd3713078dfee01f.nix { };
      annotate-snippets-0_11_5-4d47bac9cbcd3256 = callPackage' ./deps/annotate-snippets-0.11.5-4d47bac9cbcd3256.nix { };
      anstream-0_6_18-3af54164fe68ad61 = callPackage' ./deps/anstream-0.6.18-3af54164fe68ad61.nix { };
      anstyle-1_0_10-bf6d032cb7d79be1 = callPackage' ./deps/anstyle-1.0.10-bf6d032cb7d79be1.nix { };
      anstyle-parse-0_2_6-7e3167a48452c319 = callPackage' ./deps/anstyle-parse-0.2.6-7e3167a48452c319.nix { };
      anstyle-query-1_1_2-df1354162236cfa0 = callPackage' ./deps/anstyle-query-1.1.2-df1354162236cfa0.nix { };
      anyhow-1_0_96-139173be5e005a44 = callPackage' ./deps/anyhow-1.0.96-139173be5e005a44.nix { };
      anyhow-1_0_96-script_build-118337b27fb502c0 = callPackage' ./deps/anyhow-1.0.96-script_build-118337b27fb502c0.nix { };
      anyhow-1_0_96-script_build_run-b3473c23ca96d3eb = callPackage' ./deps/anyhow-1.0.96-script_build_run-b3473c23ca96d3eb.nix { };
      arc-swap-1_7_1-f146b4ecdaec6a73 = callPackage' ./deps/arc-swap-1.7.1-f146b4ecdaec6a73.nix { };
      arrayref-0_3_9-70eb58486769037f = callPackage' ./deps/arrayref-0.3.9-70eb58486769037f.nix { };
      arrayvec-0_7_6-0f41f30094bbac6c = callPackage' ./deps/arrayvec-0.7.6-0f41f30094bbac6c.nix { };
      autocfg-1_4_0-30cc6115a8e43b39 = callPackage' ./deps/autocfg-1.4.0-30cc6115a8e43b39.nix { };
      base16ct-0_2_0-9e432686303aee04 = callPackage' ./deps/base16ct-0.2.0-9e432686303aee04.nix { };
      base64-0_22_1-169e80cc244b88d1 = callPackage' ./deps/base64-0.22.1-169e80cc244b88d1.nix { };
      base64ct-1_6_0-1b5228084c65d5fb = callPackage' ./deps/base64ct-1.6.0-1b5228084c65d5fb.nix { };
      bitflags-2_8_0-d8308ebf07e22afd = callPackage' ./deps/bitflags-2.8.0-d8308ebf07e22afd.nix { };
      bitmaps-2_1_0-f1176e47abd2310d = callPackage' ./deps/bitmaps-2.1.0-f1176e47abd2310d.nix { };
      blake3-1_6_1-3250b34f7bcecb8a = callPackage' ./deps/blake3-1.6.1-3250b34f7bcecb8a.nix { };
      blake3-1_6_1-script_build-3d70c75841764a5f = callPackage' ./deps/blake3-1.6.1-script_build-3d70c75841764a5f.nix { };
      blake3-1_6_1-script_build_run-22b5db8b15d30a2c = callPackage' ./deps/blake3-1.6.1-script_build_run-22b5db8b15d30a2c.nix { };
      block-buffer-0_10_4-8ecc6e390505da10 = callPackage' ./deps/block-buffer-0.10.4-8ecc6e390505da10.nix { };
      bstr-1_11_3-14003bcd5b7b8103 = callPackage' ./deps/bstr-1.11.3-14003bcd5b7b8103.nix { };
      byteorder-1_5_0-618674731e49623e = callPackage' ./deps/byteorder-1.5.0-618674731e49623e.nix { };
      bytes-1_10_0-64a68773187e68cf = callPackage' ./deps/bytes-1.10.0-64a68773187e68cf.nix { };
      cc-1_2_16-76812c37260a1dd3 = callPackage' ./deps/cc-1.2.16-76812c37260a1dd3.nix { };
      cfg-if-1_0_0-616d46354eebf850 = callPackage' ./deps/cfg-if-1.0.0-616d46354eebf850.nix { };
      chrono-0_4_42-96bd1c38842d70ed = callPackage' ./deps/chrono-0.4.42-96bd1c38842d70ed.nix { };
      clap-4_5_31-a6f5f68162f5c661 = callPackage' ./deps/clap-4.5.31-a6f5f68162f5c661.nix { };
      clap_builder-4_5_31-36539e5faae81e9e = callPackage' ./deps/clap_builder-4.5.31-36539e5faae81e9e.nix { };
      clap_complete-4_5_46-aac8805c5395ded9 = callPackage' ./deps/clap_complete-4.5.46-aac8805c5395ded9.nix { };
      clap_derive-4_5_28-711a9dfd1da9cb19 = callPackage' ./deps/clap_derive-4.5.28-711a9dfd1da9cb19.nix { };
      clap_lex-0_7_4-dbd607f73f847c4c = callPackage' ./deps/clap_lex-0.7.4-dbd607f73f847c4c.nix { };
      clru-0_6_2-15ba3530c90c5d9a = callPackage' ./deps/clru-0.6.2-15ba3530c90c5d9a.nix { };
      color-print-0_3_7-4ae3eda36d442220 = callPackage' ./deps/color-print-0.3.7-4ae3eda36d442220.nix { };
      color-print-proc-macro-0_3_7-37e3c528ba1c98b5 = callPackage' ./deps/color-print-proc-macro-0.3.7-37e3c528ba1c98b5.nix { };
      colorchoice-1_0_3-3fd8e2bb93f5239a = callPackage' ./deps/colorchoice-1.0.3-3fd8e2bb93f5239a.nix { };
      colored-3_1_1-c3f17f7b73321ed9 = callPackage' ./deps/colored-3.1.1-c3f17f7b73321ed9.nix { };
      console-0_15_11-5031eeae5635e303 = callPackage' ./deps/console-0.15.11-5031eeae5635e303.nix { };
      const-oid-0_9_6-78dc06c180518cb4 = callPackage' ./deps/const-oid-0.9.6-78dc06c180518cb4.nix { };
      constant_time_eq-0_3_1-52e5576b18736f3b = callPackage' ./deps/constant_time_eq-0.3.1-52e5576b18736f3b.nix { };
      cpufeatures-0_2_17-e2bead5fbcbc1f9e = callPackage' ./deps/cpufeatures-0.2.17-e2bead5fbcbc1f9e.nix { };
      crc32fast-1_4_2-3d7fbbab345759e0 = callPackage' ./deps/crc32fast-1.4.2-3d7fbbab345759e0.nix { };
      crossbeam-channel-0_5_14-302e921e2a8d4ce6 = callPackage' ./deps/crossbeam-channel-0.5.14-302e921e2a8d4ce6.nix { };
      crossbeam-deque-0_8_6-33404d844ef9489b = callPackage' ./deps/crossbeam-deque-0.8.6-33404d844ef9489b.nix { };
      crossbeam-epoch-0_9_18-f5fba84889add492 = callPackage' ./deps/crossbeam-epoch-0.9.18-f5fba84889add492.nix { };
      crossbeam-utils-0_8_21-2755be6070eb63e1 = callPackage' ./deps/crossbeam-utils-0.8.21-2755be6070eb63e1.nix { };
      crossbeam-utils-0_8_21-script_build-12f6a43a9fc01710 = callPackage' ./deps/crossbeam-utils-0.8.21-script_build-12f6a43a9fc01710.nix { };
      crossbeam-utils-0_8_21-script_build_run-fe6d54db4bf41090 = callPackage' ./deps/crossbeam-utils-0.8.21-script_build_run-fe6d54db4bf41090.nix { };
      crossterm-0_27_0-a8da3ec9393855f8 = callPackage' ./deps/crossterm-0.27.0-a8da3ec9393855f8.nix { };
      crypto-bigint-0_5_5-5115490596bc9280 = callPackage' ./deps/crypto-bigint-0.5.5-5115490596bc9280.nix { };
      crypto-common-0_1_6-761785559be53d0e = callPackage' ./deps/crypto-common-0.1.6-761785559be53d0e.nix { };
      ct-codecs-1_1_3-4c4f37d16030cc7d = callPackage' ./deps/ct-codecs-1.1.3-4c4f37d16030cc7d.nix { };
      curl-0_4_47-f684c2bd7b0f950d = callPackage' ./deps/curl-0.4.47-f684c2bd7b0f950d.nix { };
      curl-0_4_47-script_build-9620d559725db5b1 = callPackage' ./deps/curl-0.4.47-script_build-9620d559725db5b1.nix { };
      curl-0_4_47-script_build_run-ba10f3f61d2b9233 = callPackage' ./deps/curl-0.4.47-script_build_run-ba10f3f61d2b9233.nix { };
      curl-sys-0_4_80_plus_curl-8_12_1-db5fbe1d9680c71f = callPackage' ./deps/curl-sys-0.4.80_plus_curl-8.12.1-db5fbe1d9680c71f.nix { };
      curl-sys-0_4_80_plus_curl-8_12_1-script_build-dc795e51d6e22aca = callPackage' ./deps/curl-sys-0.4.80_plus_curl-8.12.1-script_build-dc795e51d6e22aca.nix { };
      curl-sys-0_4_80_plus_curl-8_12_1-script_build_run-5dbbf84b2b7464b9 = callPackage' ./deps/curl-sys-0.4.80_plus_curl-8.12.1-script_build_run-5dbbf84b2b7464b9.nix { };
      darling-0_20_10-cbd8405b60358367 = callPackage' ./deps/darling-0.20.10-cbd8405b60358367.nix { };
      darling_core-0_20_10-172f1f370b743a5f = callPackage' ./deps/darling_core-0.20.10-172f1f370b743a5f.nix { };
      darling_macro-0_20_10-17446a65ae911349 = callPackage' ./deps/darling_macro-0.20.10-17446a65ae911349.nix { };
      der-0_7_9-39bc94e6d7deac42 = callPackage' ./deps/der-0.7.9-39bc94e6d7deac42.nix { };
      deranged-0_3_11-ff4e1a9ba87819f3 = callPackage' ./deps/deranged-0.3.11-ff4e1a9ba87819f3.nix { };
      derive_builder-0_20_2-8c9b1e471d93f01c = callPackage' ./deps/derive_builder-0.20.2-8c9b1e471d93f01c.nix { };
      derive_builder_core-0_20_2-0830c718387d2825 = callPackage' ./deps/derive_builder_core-0.20.2-0830c718387d2825.nix { };
      derive_builder_macro-0_20_2-1dd7f3a916fa5d84 = callPackage' ./deps/derive_builder_macro-0.20.2-1dd7f3a916fa5d84.nix { };
      digest-0_10_7-d61413dd55c3b709 = callPackage' ./deps/digest-0.10.7-d61413dd55c3b709.nix { };
      displaydoc-0_2_5-a3932aec884d58b9 = callPackage' ./deps/displaydoc-0.2.5-a3932aec884d58b9.nix { };
      ecdsa-0_16_9-95753d738a0973a7 = callPackage' ./deps/ecdsa-0.16.9-95753d738a0973a7.nix { };
      ed25519-compact-2_1_1-1c5101fb43379bc2 = callPackage' ./deps/ed25519-compact-2.1.1-1c5101fb43379bc2.nix { };
      either-1_13_0-726cdf5dc5458bb7 = callPackage' ./deps/either-1.13.0-726cdf5dc5458bb7.nix { };
      elliptic-curve-0_13_8-62624c894feb112b = callPackage' ./deps/elliptic-curve-0.13.8-62624c894feb112b.nix { };
      encoding_rs-0_8_35-92f62b88e615318e = callPackage' ./deps/encoding_rs-0.8.35-92f62b88e615318e.nix { };
      equivalent-1_0_1-68f6175885f97842 = callPackage' ./deps/equivalent-1.0.1-68f6175885f97842.nix { };
      erased-serde-0_4_5-f987b2e59c60f727 = callPackage' ./deps/erased-serde-0.4.5-f987b2e59c60f727.nix { };
      fallible-iterator-0_3_0-2494fdfb0552e808 = callPackage' ./deps/fallible-iterator-0.3.0-2494fdfb0552e808.nix { };
      fallible-streaming-iterator-0_1_9-6db7f5334e34a8b5 = callPackage' ./deps/fallible-streaming-iterator-0.1.9-6db7f5334e34a8b5.nix { };
      faster-hex-0_9_0-9e79ca4676bbbaec = callPackage' ./deps/faster-hex-0.9.0-9e79ca4676bbbaec.nix { };
      fastrand-2_3_0-02ab7f4546011650 = callPackage' ./deps/fastrand-2.3.0-02ab7f4546011650.nix { };
      ff-0_13_0-c7a3e6a3c0308f8f = callPackage' ./deps/ff-0.13.0-c7a3e6a3c0308f8f.nix { };
      fiat-crypto-0_2_9-92e05bb23b31efe5 = callPackage' ./deps/fiat-crypto-0.2.9-92e05bb23b31efe5.nix { };
      filetime-0_2_25-36b58a90b887714e = callPackage' ./deps/filetime-0.2.25-36b58a90b887714e.nix { };
      flate2-1_1_0-42c7a212f7b33f26 = callPackage' ./deps/flate2-1.1.0-42c7a212f7b33f26.nix { };
      flate2-1_1_0-8e647ae5b177ac6d = callPackage' ./deps/flate2-1.1.0-8e647ae5b177ac6d.nix { };
      fnv-1_0_7-e86d9923dc926ea6 = callPackage' ./deps/fnv-1.0.7-e86d9923dc926ea6.nix { };
      foldhash-0_1_4-d4aabb52aef12cd1 = callPackage' ./deps/foldhash-0.1.4-d4aabb52aef12cd1.nix { };
      form_urlencoded-1_2_1-bfd2f5119314e35c = callPackage' ./deps/form_urlencoded-1.2.1-bfd2f5119314e35c.nix { };
      generic-array-0_14_7-cf1af5fa7e31ffd0 = callPackage' ./deps/generic-array-0.14.7-cf1af5fa7e31ffd0.nix { };
      generic-array-0_14_7-script_build-c51e36621e4a3a62 = callPackage' ./deps/generic-array-0.14.7-script_build-c51e36621e4a3a62.nix { };
      generic-array-0_14_7-script_build_run-c657b946b2e7d7ad = callPackage' ./deps/generic-array-0.14.7-script_build_run-c657b946b2e7d7ad.nix { };
      getrandom-0_2_15-8bcd08ec7ff910e6 = callPackage' ./deps/getrandom-0.2.15-8bcd08ec7ff910e6.nix { };
      getrandom-0_3_1-f98539da635491d1 = callPackage' ./deps/getrandom-0.3.1-f98539da635491d1.nix { };
      getrandom-0_3_1-script_build-84bfc3afc25bedc8 = callPackage' ./deps/getrandom-0.3.1-script_build-84bfc3afc25bedc8.nix { };
      getrandom-0_3_1-script_build_run-63e4c9b982414d98 = callPackage' ./deps/getrandom-0.3.1-script_build_run-63e4c9b982414d98.nix { };
      git2-0_20_0-a5a6e57aa11f1a77 = callPackage' ./deps/git2-0.20.0-a5a6e57aa11f1a77.nix { };
      git2-curl-0_21_0-d43c11566cc114b0 = callPackage' ./deps/git2-curl-0.21.0-d43c11566cc114b0.nix { };
      gix-0_70_0-992c380a7e61bb6a = callPackage' ./deps/gix-0.70.0-992c380a7e61bb6a.nix { };
      gix-actor-0_33_2-6f4ab7bcb15a2392 = callPackage' ./deps/gix-actor-0.33.2-6f4ab7bcb15a2392.nix { };
      gix-attributes-0_24_0-b71cf5283dcbf9ad = callPackage' ./deps/gix-attributes-0.24.0-b71cf5283dcbf9ad.nix { };
      gix-bitmap-0_2_14-f354064ea405ef42 = callPackage' ./deps/gix-bitmap-0.2.14-f354064ea405ef42.nix { };
      gix-chunk-0_4_11-a4d754f37e748441 = callPackage' ./deps/gix-chunk-0.4.11-a4d754f37e748441.nix { };
      gix-command-0_4_1-e29484d4d4e346e8 = callPackage' ./deps/gix-command-0.4.1-e29484d4d4e346e8.nix { };
      gix-commitgraph-0_26_0-f831d83001ac5121 = callPackage' ./deps/gix-commitgraph-0.26.0-f831d83001ac5121.nix { };
      gix-config-0_43_0-c2a2493ddeeda786 = callPackage' ./deps/gix-config-0.43.0-c2a2493ddeeda786.nix { };
      gix-config-value-0_14_11-712acc74f435528f = callPackage' ./deps/gix-config-value-0.14.11-712acc74f435528f.nix { };
      gix-credentials-0_27_0-48aff77da2287bad = callPackage' ./deps/gix-credentials-0.27.0-48aff77da2287bad.nix { };
      gix-date-0_9_3-ef3873a712c7b7c9 = callPackage' ./deps/gix-date-0.9.3-ef3873a712c7b7c9.nix { };
      gix-diff-0_50_0-fed3014ae47894e9 = callPackage' ./deps/gix-diff-0.50.0-fed3014ae47894e9.nix { };
      gix-dir-0_12_0-5131791182ccf5a3 = callPackage' ./deps/gix-dir-0.12.0-5131791182ccf5a3.nix { };
      gix-discover-0_38_0-3541dc1bd7f8a291 = callPackage' ./deps/gix-discover-0.38.0-3541dc1bd7f8a291.nix { };
      gix-features-0_40_0-7b4fa941d491da9c = callPackage' ./deps/gix-features-0.40.0-7b4fa941d491da9c.nix { };
      gix-filter-0_17_0-e2f5328c169aa835 = callPackage' ./deps/gix-filter-0.17.0-e2f5328c169aa835.nix { };
      gix-fs-0_13_0-32f209ecf862a862 = callPackage' ./deps/gix-fs-0.13.0-32f209ecf862a862.nix { };
      gix-glob-0_18_0-7b254994b5e9c6fa = callPackage' ./deps/gix-glob-0.18.0-7b254994b5e9c6fa.nix { };
      gix-hash-0_16_0-2dd06b7faad8300b = callPackage' ./deps/gix-hash-0.16.0-2dd06b7faad8300b.nix { };
      gix-hashtable-0_7_0-cf7f65c45ebb5acb = callPackage' ./deps/gix-hashtable-0.7.0-cf7f65c45ebb5acb.nix { };
      gix-ignore-0_13_0-a762477646d7d9f7 = callPackage' ./deps/gix-ignore-0.13.0-a762477646d7d9f7.nix { };
      gix-index-0_38_0-fd774084d6371cea = callPackage' ./deps/gix-index-0.38.0-fd774084d6371cea.nix { };
      gix-lock-16_0_0-c0e4d3d42bd1d641 = callPackage' ./deps/gix-lock-16.0.0-c0e4d3d42bd1d641.nix { };
      gix-negotiate-0_18_0-3bc90a63e768c830 = callPackage' ./deps/gix-negotiate-0.18.0-3bc90a63e768c830.nix { };
      gix-object-0_47_0-1feb494be43bf821 = callPackage' ./deps/gix-object-0.47.0-1feb494be43bf821.nix { };
      gix-odb-0_67_0-75c8e2fcff23733b = callPackage' ./deps/gix-odb-0.67.0-75c8e2fcff23733b.nix { };
      gix-pack-0_57_0-86d1b37081390307 = callPackage' ./deps/gix-pack-0.57.0-86d1b37081390307.nix { };
      gix-packetline-0_18_3-bfc74beed2d78867 = callPackage' ./deps/gix-packetline-0.18.3-bfc74beed2d78867.nix { };
      gix-packetline-blocking-0_18_2-638c01d5b51657b1 = callPackage' ./deps/gix-packetline-blocking-0.18.2-638c01d5b51657b1.nix { };
      gix-path-0_10_14-6bb928c9998da5a8 = callPackage' ./deps/gix-path-0.10.14-6bb928c9998da5a8.nix { };
      gix-pathspec-0_9_0-8c1afc1e63b302a6 = callPackage' ./deps/gix-pathspec-0.9.0-8c1afc1e63b302a6.nix { };
      gix-prompt-0_9_1-fa757bef7affaabd = callPackage' ./deps/gix-prompt-0.9.1-fa757bef7affaabd.nix { };
      gix-protocol-0_48_0-3d59eb97d302f3a0 = callPackage' ./deps/gix-protocol-0.48.0-3d59eb97d302f3a0.nix { };
      gix-quote-0_4_15-8a0f189e1c6e7301 = callPackage' ./deps/gix-quote-0.4.15-8a0f189e1c6e7301.nix { };
      gix-ref-0_50_0-9c43a6c2d25dc4c1 = callPackage' ./deps/gix-ref-0.50.0-9c43a6c2d25dc4c1.nix { };
      gix-refspec-0_28_0-e29e1a847ad4941f = callPackage' ./deps/gix-refspec-0.28.0-e29e1a847ad4941f.nix { };
      gix-revision-0_32_0-e2b81ece8deb27a8 = callPackage' ./deps/gix-revision-0.32.0-e2b81ece8deb27a8.nix { };
      gix-revwalk-0_18_0-58438d094712a949 = callPackage' ./deps/gix-revwalk-0.18.0-58438d094712a949.nix { };
      gix-sec-0_10_11-a898e4a50340a006 = callPackage' ./deps/gix-sec-0.10.11-a898e4a50340a006.nix { };
      gix-shallow-0_2_0-17cceba6b74ec6c7 = callPackage' ./deps/gix-shallow-0.2.0-17cceba6b74ec6c7.nix { };
      gix-submodule-0_17_0-3e55b4fc27cc42ec = callPackage' ./deps/gix-submodule-0.17.0-3e55b4fc27cc42ec.nix { };
      gix-tempfile-16_0_0-83660278b0f5c0f2 = callPackage' ./deps/gix-tempfile-16.0.0-83660278b0f5c0f2.nix { };
      gix-trace-0_1_12-6fa342b8ee63f664 = callPackage' ./deps/gix-trace-0.1.12-6fa342b8ee63f664.nix { };
      gix-transport-0_45_0-6a2f0d56c387db84 = callPackage' ./deps/gix-transport-0.45.0-6a2f0d56c387db84.nix { };
      gix-traverse-0_44_0-2765cfa05e8b8e89 = callPackage' ./deps/gix-traverse-0.44.0-2765cfa05e8b8e89.nix { };
      gix-url-0_29_0-74b20df333b8da83 = callPackage' ./deps/gix-url-0.29.0-74b20df333b8da83.nix { };
      gix-utils-0_1_14-4da59f2b8afebe0a = callPackage' ./deps/gix-utils-0.1.14-4da59f2b8afebe0a.nix { };
      gix-validate-0_9_3-5cd523d9060c9684 = callPackage' ./deps/gix-validate-0.9.3-5cd523d9060c9684.nix { };
      gix-worktree-0_39_0-441c8c8134035536 = callPackage' ./deps/gix-worktree-0.39.0-441c8c8134035536.nix { };
      glob-0_3_2-544549cd000b48bc = callPackage' ./deps/glob-0.3.2-544549cd000b48bc.nix { };
      globset-0_4_15-2a50c1c4f3461932 = callPackage' ./deps/globset-0.4.15-2a50c1c4f3461932.nix { };
      group-0_13_0-b2c2c02d111760d6 = callPackage' ./deps/group-0.13.0-b2c2c02d111760d6.nix { };
      handlebars-6_3_1-1d5c39ccada6570e = callPackage' ./deps/handlebars-6.3.1-1d5c39ccada6570e.nix { };
      hashbrown-0_14_5-0902b9e9c2cf4ed1 = callPackage' ./deps/hashbrown-0.14.5-0902b9e9c2cf4ed1.nix { };
      hashbrown-0_15_2-6ee06c8f0a23f90a = callPackage' ./deps/hashbrown-0.15.2-6ee06c8f0a23f90a.nix { };
      hashlink-0_10_0-39cf9e95ebd42033 = callPackage' ./deps/hashlink-0.10.0-39cf9e95ebd42033.nix { };
      heck-0_5_0-368295e68f50b2c3 = callPackage' ./deps/heck-0.5.0-368295e68f50b2c3.nix { };
      hex-0_4_3-ccbbd905e94f34bd = callPackage' ./deps/hex-0.4.3-ccbbd905e94f34bd.nix { };
      hkdf-0_12_4-bbec6e1cfb889215 = callPackage' ./deps/hkdf-0.12.4-bbec6e1cfb889215.nix { };
      hmac-0_12_1-84aacd8a0108f7c5 = callPackage' ./deps/hmac-0.12.1-84aacd8a0108f7c5.nix { };
      home-0_5_11-43ef4c896a7488bc = callPackage' ./deps/home-0.5.11-43ef4c896a7488bc.nix { };
      http-auth-0_1_10-b3940f62a0eee11f = callPackage' ./deps/http-auth-0.1.10-b3940f62a0eee11f.nix { };
      iana-time-zone-0_1_64-e266c5c8a338d056 = callPackage' ./deps/iana-time-zone-0.1.64-e266c5c8a338d056.nix { };
      icu_collections-1_5_0-4d027eaae4cb9000 = callPackage' ./deps/icu_collections-1.5.0-4d027eaae4cb9000.nix { };
      icu_locid-1_5_0-294b75cdeaebd083 = callPackage' ./deps/icu_locid-1.5.0-294b75cdeaebd083.nix { };
      icu_locid_transform-1_5_0-291edb4addc628ca = callPackage' ./deps/icu_locid_transform-1.5.0-291edb4addc628ca.nix { };
      icu_locid_transform_data-1_5_0-13b6af6aebf3cbc0 = callPackage' ./deps/icu_locid_transform_data-1.5.0-13b6af6aebf3cbc0.nix { };
      icu_normalizer-1_5_0-4a9dc4faf2f4cca0 = callPackage' ./deps/icu_normalizer-1.5.0-4a9dc4faf2f4cca0.nix { };
      icu_normalizer_data-1_5_0-d2c229093da62481 = callPackage' ./deps/icu_normalizer_data-1.5.0-d2c229093da62481.nix { };
      icu_properties-1_5_1-36033132eb86e488 = callPackage' ./deps/icu_properties-1.5.1-36033132eb86e488.nix { };
      icu_properties_data-1_5_0-4f08bfd4250192ce = callPackage' ./deps/icu_properties_data-1.5.0-4f08bfd4250192ce.nix { };
      icu_provider-1_5_0-df823559bbe57634 = callPackage' ./deps/icu_provider-1.5.0-df823559bbe57634.nix { };
      icu_provider_macros-1_5_0-4a62175d1a529a39 = callPackage' ./deps/icu_provider_macros-1.5.0-4a62175d1a529a39.nix { };
      ident_case-1_0_1-2dc10d9b37d5f124 = callPackage' ./deps/ident_case-1.0.1-2dc10d9b37d5f124.nix { };
      idna-1_0_3-96990aad07408c76 = callPackage' ./deps/idna-1.0.3-96990aad07408c76.nix { };
      idna_adapter-1_2_0-912ba833bfc7b013 = callPackage' ./deps/idna_adapter-1.2.0-912ba833bfc7b013.nix { };
      ignore-0_4_23-dab7af6f0867647c = callPackage' ./deps/ignore-0.4.23-dab7af6f0867647c.nix { };
      im-rc-15_1_0-6db31ca18b586012 = callPackage' ./deps/im-rc-15.1.0-6db31ca18b586012.nix { };
      im-rc-15_1_0-script_build-f7c17dbc012e64d9 = callPackage' ./deps/im-rc-15.1.0-script_build-f7c17dbc012e64d9.nix { };
      im-rc-15_1_0-script_build_run-7f18a1872a44f952 = callPackage' ./deps/im-rc-15.1.0-script_build_run-7f18a1872a44f952.nix { };
      indexmap-2_7_1-dcbfc0f8f5b442a0 = callPackage' ./deps/indexmap-2.7.1-dcbfc0f8f5b442a0.nix { };
      indoc-2_0_6-3e36bbc9b09ee6b1 = callPackage' ./deps/indoc-2.0.6-3e36bbc9b09ee6b1.nix { };
      is_executable-1_0_4-cbdb08034b5ed4b3 = callPackage' ./deps/is_executable-1.0.4-cbdb08034b5ed4b3.nix { };
      is_terminal_polyfill-1_70_1-38de4a7f1aa06bfb = callPackage' ./deps/is_terminal_polyfill-1.70.1-38de4a7f1aa06bfb.nix { };
      itertools-0_14_0-27edccb8d0332424 = callPackage' ./deps/itertools-0.14.0-27edccb8d0332424.nix { };
      itoa-1_0_14-6ae7bc765ab6d9fa = callPackage' ./deps/itoa-1.0.14-6ae7bc765ab6d9fa.nix { };
      jiff-0_1_29-8b125d776e08e3f6 = callPackage' ./deps/jiff-0.1.29-8b125d776e08e3f6.nix { };
      jiff-0_2_3-16345f2ab32d9b14 = callPackage' ./deps/jiff-0.2.3-16345f2ab32d9b14.nix { };
      jobserver-0_1_32-04274db7c36dbe6c = callPackage' ./deps/jobserver-0.1.32-04274db7c36dbe6c.nix { };
      kstring-2_0_2-811efab5b9fe5921 = callPackage' ./deps/kstring-2.0.2-811efab5b9fe5921.nix { };
      lazy_static-1_5_0-ffebef2c0e161fa7 = callPackage' ./deps/lazy_static-1.5.0-ffebef2c0e161fa7.nix { };
      lazycell-1_3_0-5468cb6502e4542b = callPackage' ./deps/lazycell-1.3.0-5468cb6502e4542b.nix { };
      libc-0_2_175-df0687d6868fdede = callPackage' ./deps/libc-0.2.175-df0687d6868fdede.nix { };
      libc-0_2_175-script_build-8e5406a56535c6d3 = callPackage' ./deps/libc-0.2.175-script_build-8e5406a56535c6d3.nix { };
      libc-0_2_175-script_build_run-5eb49f300dc6bcbc = callPackage' ./deps/libc-0.2.175-script_build_run-5eb49f300dc6bcbc.nix { };
      libgit2-sys-0_18_0_plus_1_9_0-86c4b3f8f5bf526a = callPackage' ./deps/libgit2-sys-0.18.0_plus_1.9.0-86c4b3f8f5bf526a.nix { };
      libgit2-sys-0_18_0_plus_1_9_0-script_build-df53d2b5ce2efa6a = callPackage' ./deps/libgit2-sys-0.18.0_plus_1.9.0-script_build-df53d2b5ce2efa6a.nix { };
      libgit2-sys-0_18_0_plus_1_9_0-script_build_run-394f4058e10471ef = callPackage' ./deps/libgit2-sys-0.18.0_plus_1.9.0-script_build_run-394f4058e10471ef.nix { };
      libloading-0_8_6-2aeac1c54ae56457 = callPackage' ./deps/libloading-0.8.6-2aeac1c54ae56457.nix { };
      libnghttp2-sys-0_1_11_plus_1_64_0-d8f3869573ff8422 = callPackage' ./deps/libnghttp2-sys-0.1.11_plus_1.64.0-d8f3869573ff8422.nix { };
      libnghttp2-sys-0_1_11_plus_1_64_0-script_build-0f5adb8e3f098d69 = callPackage' ./deps/libnghttp2-sys-0.1.11_plus_1.64.0-script_build-0f5adb8e3f098d69.nix { };
      libnghttp2-sys-0_1_11_plus_1_64_0-script_build_run-b5bd9d1c0a296bf4 = callPackage' ./deps/libnghttp2-sys-0.1.11_plus_1.64.0-script_build_run-b5bd9d1c0a296bf4.nix { };
      libsqlite3-sys-0_31_0-8e2c6f3f6c420058 = callPackage' ./deps/libsqlite3-sys-0.31.0-8e2c6f3f6c420058.nix { };
      libsqlite3-sys-0_31_0-script_build-ccf5f6176bdb99ad = callPackage' ./deps/libsqlite3-sys-0.31.0-script_build-ccf5f6176bdb99ad.nix { };
      libsqlite3-sys-0_31_0-script_build_run-2e938fb39223d7f4 = callPackage' ./deps/libsqlite3-sys-0.31.0-script_build_run-2e938fb39223d7f4.nix { };
      libssh2-sys-0_3_1-7b0b3bce8fea88d8 = callPackage' ./deps/libssh2-sys-0.3.1-7b0b3bce8fea88d8.nix { };
      libssh2-sys-0_3_1-script_build-ca72618460c8858e = callPackage' ./deps/libssh2-sys-0.3.1-script_build-ca72618460c8858e.nix { };
      libssh2-sys-0_3_1-script_build_run-1fb24ef6763538ce = callPackage' ./deps/libssh2-sys-0.3.1-script_build_run-1fb24ef6763538ce.nix { };
      libz-sys-1_1_21-2665ee861d863bc2 = callPackage' ./deps/libz-sys-1.1.21-2665ee861d863bc2.nix { };
      libz-sys-1_1_21-69f52d4cc5a20a24 = callPackage' ./deps/libz-sys-1.1.21-69f52d4cc5a20a24.nix { };
      libz-sys-1_1_21-script_build-10baa270a769a71e = callPackage' ./deps/libz-sys-1.1.21-script_build-10baa270a769a71e.nix { };
      libz-sys-1_1_21-script_build-501e1097ea06d2b0 = callPackage' ./deps/libz-sys-1.1.21-script_build-501e1097ea06d2b0.nix { };
      libz-sys-1_1_21-script_build_run-06993c87126df69f = callPackage' ./deps/libz-sys-1.1.21-script_build_run-06993c87126df69f.nix { };
      libz-sys-1_1_21-script_build_run-f6f880365d589702 = callPackage' ./deps/libz-sys-1.1.21-script_build_run-f6f880365d589702.nix { };
      linux-raw-sys-0_4_15-624798d9199ea3b3 = callPackage' ./deps/linux-raw-sys-0.4.15-624798d9199ea3b3.nix { };
      litemap-0_7_4-1f4d69d5dc04ca70 = callPackage' ./deps/litemap-0.7.4-1f4d69d5dc04ca70.nix { };
      lock_api-0_4_12-f118f1acdf24e8f3 = callPackage' ./deps/lock_api-0.4.12-f118f1acdf24e8f3.nix { };
      lock_api-0_4_12-script_build-d0a80824f419daa1 = callPackage' ./deps/lock_api-0.4.12-script_build-d0a80824f419daa1.nix { };
      lock_api-0_4_12-script_build_run-a80fcfc254bcd832 = callPackage' ./deps/lock_api-0.4.12-script_build_run-a80fcfc254bcd832.nix { };
      log-0_4_25-7616f5eb69eb8f7e = callPackage' ./deps/log-0.4.25-7616f5eb69eb8f7e.nix { };
      logone-0_2_9-ddf18829cbe9b77e = callPackage' ./deps/logone-0.2.9-ddf18829cbe9b77e.nix { };
      matchers-0_1_0-2e1fa76cca5e7310 = callPackage' ./deps/matchers-0.1.0-2e1fa76cca5e7310.nix { };
      maybe-async-0_2_10-3a2823bcacaa3374 = callPackage' ./deps/maybe-async-0.2.10-3a2823bcacaa3374.nix { };
      memchr-2_7_4-3cee6db17bbe0dde = callPackage' ./deps/memchr-2.7.4-3cee6db17bbe0dde.nix { };
      memmap2-0_9_5-74a37f7611502dc0 = callPackage' ./deps/memmap2-0.9.5-74a37f7611502dc0.nix { };
      minimal-lexical-0_2_1-2ce393d32276a2f1 = callPackage' ./deps/minimal-lexical-0.2.1-2ce393d32276a2f1.nix { };
      miniz_oxide-0_8_5-a4a0cc7b24b565c3 = callPackage' ./deps/miniz_oxide-0.8.5-a4a0cc7b24b565c3.nix { };
      mio-0_8_11-6d022cfdfb03dec5 = callPackage' ./deps/mio-0.8.11-6d022cfdfb03dec5.nix { };
      nom-7_1_3-f13dd91924a7c5d9 = callPackage' ./deps/nom-7.1.3-f13dd91924a7c5d9.nix { };
      nu-ansi-term-0_46_0-f0dd67bbc4fc7bc7 = callPackage' ./deps/nu-ansi-term-0.46.0-f0dd67bbc4fc7bc7.nix { };
      num-conv-0_1_0-0df124cc8207c71e = callPackage' ./deps/num-conv-0.1.0-0df124cc8207c71e.nix { };
      num-modular-0_6_1-0701415c71b50c28 = callPackage' ./deps/num-modular-0.6.1-0701415c71b50c28.nix { };
      num-order-1_2_0-192b41e262367e4b = callPackage' ./deps/num-order-1.2.0-192b41e262367e4b.nix { };
      num-traits-0_2_19-8946f1ffa19e3055 = callPackage' ./deps/num-traits-0.2.19-8946f1ffa19e3055.nix { };
      num-traits-0_2_19-script_build-34b314758d860194 = callPackage' ./deps/num-traits-0.2.19-script_build-34b314758d860194.nix { };
      num-traits-0_2_19-script_build_run-7e89687594b4e195 = callPackage' ./deps/num-traits-0.2.19-script_build_run-7e89687594b4e195.nix { };
      once_cell-1_20_3-60992a3834e62ae0 = callPackage' ./deps/once_cell-1.20.3-60992a3834e62ae0.nix { };
      opener-0_7_2-e60a19764aabfbee = callPackage' ./deps/opener-0.7.2-e60a19764aabfbee.nix { };
      openssl-probe-0_1_6-6d5d5ac82de655f5 = callPackage' ./deps/openssl-probe-0.1.6-6d5d5ac82de655f5.nix { };
      openssl-sys-0_9_106-adcaf6cb517a5566 = callPackage' ./deps/openssl-sys-0.9.106-adcaf6cb517a5566.nix { };
      openssl-sys-0_9_106-script_build-842500ea8308bd23 = callPackage' ./deps/openssl-sys-0.9.106-script_build-842500ea8308bd23.nix { };
      openssl-sys-0_9_106-script_build_run-c8c90d54d12f4385 = callPackage' ./deps/openssl-sys-0.9.106-script_build_run-c8c90d54d12f4385.nix { };
      ordered-float-2_10_1-fa1acc7f921d5351 = callPackage' ./deps/ordered-float-2.10.1-fa1acc7f921d5351.nix { };
      orion-0_17_8-a6cc6ad3939ba568 = callPackage' ./deps/orion-0.17.8-a6cc6ad3939ba568.nix { };
      os_info-3_10_0-1475caac7a528f34 = callPackage' ./deps/os_info-3.10.0-1475caac7a528f34.nix { };
      overload-0_1_1-36d6dc4b2c1d5222 = callPackage' ./deps/overload-0.1.1-36d6dc4b2c1d5222.nix { };
      p384-0_13_1-82d825337ebe46c2 = callPackage' ./deps/p384-0.13.1-82d825337ebe46c2.nix { };
      parking_lot-0_12_3-4fd4df098a55c376 = callPackage' ./deps/parking_lot-0.12.3-4fd4df098a55c376.nix { };
      parking_lot_core-0_9_10-e6343e9285ac5c5a = callPackage' ./deps/parking_lot_core-0.9.10-e6343e9285ac5c5a.nix { };
      parking_lot_core-0_9_10-script_build-e99209837e9ad3b4 = callPackage' ./deps/parking_lot_core-0.9.10-script_build-e99209837e9ad3b4.nix { };
      parking_lot_core-0_9_10-script_build_run-4c2f97e461ca5b1a = callPackage' ./deps/parking_lot_core-0.9.10-script_build_run-4c2f97e461ca5b1a.nix { };
      pasetors-0_7_2-0e3e06d4cbb54d3a = callPackage' ./deps/pasetors-0.7.2-0e3e06d4cbb54d3a.nix { };
      pathdiff-0_2_3-4adfc518be1c04af = callPackage' ./deps/pathdiff-0.2.3-4adfc518be1c04af.nix { };
      pem-rfc7468-0_7_0-9363a4c91bcb7bc9 = callPackage' ./deps/pem-rfc7468-0.7.0-9363a4c91bcb7bc9.nix { };
      percent-encoding-2_3_1-e8b9e34a5db857ef = callPackage' ./deps/percent-encoding-2.3.1-e8b9e34a5db857ef.nix { };
      pest-2_7_15-a8485b5b1580dc17 = callPackage' ./deps/pest-2.7.15-a8485b5b1580dc17.nix { };
      pest_derive-2_7_15-d16fa3e9d28681c6 = callPackage' ./deps/pest_derive-2.7.15-d16fa3e9d28681c6.nix { };
      pest_generator-2_7_15-c669ba2a5e7aeb38 = callPackage' ./deps/pest_generator-2.7.15-c669ba2a5e7aeb38.nix { };
      pest_meta-2_7_15-31f9acc074a73589 = callPackage' ./deps/pest_meta-2.7.15-31f9acc074a73589.nix { };
      pin-project-lite-0_2_16-dbb7ad05ebc1034f = callPackage' ./deps/pin-project-lite-0.2.16-dbb7ad05ebc1034f.nix { };
      pkcs8-0_10_2-1efc71bd7be4e9c5 = callPackage' ./deps/pkcs8-0.10.2-1efc71bd7be4e9c5.nix { };
      pkg-config-0_3_31-9f951027c189d1c8 = callPackage' ./deps/pkg-config-0.3.31-9f951027c189d1c8.nix { };
      powerfmt-0_2_0-daab621ad5d886f7 = callPackage' ./deps/powerfmt-0.2.0-daab621ad5d886f7.nix { };
      ppv-lite86-0_2_20-7474c6cf375c1c2a = callPackage' ./deps/ppv-lite86-0.2.20-7474c6cf375c1c2a.nix { };
      primeorder-0_13_6-348bf520b75b2852 = callPackage' ./deps/primeorder-0.13.6-348bf520b75b2852.nix { };
      proc-macro2-1_0_93-cfe81a59cf98819f = callPackage' ./deps/proc-macro2-1.0.93-cfe81a59cf98819f.nix { };
      proc-macro2-1_0_93-script_build-44658edbe8e1d4ac = callPackage' ./deps/proc-macro2-1.0.93-script_build-44658edbe8e1d4ac.nix { };
      proc-macro2-1_0_93-script_build_run-a36de409238acb5c = callPackage' ./deps/proc-macro2-1.0.93-script_build_run-a36de409238acb5c.nix { };
      prodash-29_0_0-a503f1586841c872 = callPackage' ./deps/prodash-29.0.0-a503f1586841c872.nix { };
      quote-1_0_38-12b99e3192e30e82 = callPackage' ./deps/quote-1.0.38-12b99e3192e30e82.nix { };
      rand-0_9_0-6c716ea579f406d5 = callPackage' ./deps/rand-0.9.0-6c716ea579f406d5.nix { };
      rand_chacha-0_9_0-f1a4de95022c8f74 = callPackage' ./deps/rand_chacha-0.9.0-f1a4de95022c8f74.nix { };
      rand_core-0_6_4-5078be04f75dc0b2 = callPackage' ./deps/rand_core-0.6.4-5078be04f75dc0b2.nix { };
      rand_core-0_9_0-96341d5e808f2af5 = callPackage' ./deps/rand_core-0.9.0-96341d5e808f2af5.nix { };
      rand_xoshiro-0_6_0-9966516d1098f296 = callPackage' ./deps/rand_xoshiro-0.6.0-9966516d1098f296.nix { };
      regex-1_11_1-c278e9a7e455d20f = callPackage' ./deps/regex-1.11.1-c278e9a7e455d20f.nix { };
      regex-automata-0_1_10-1c5c0ed324ef2b9a = callPackage' ./deps/regex-automata-0.1.10-1c5c0ed324ef2b9a.nix { };
      regex-automata-0_4_9-5e0d341bfc5bf703 = callPackage' ./deps/regex-automata-0.4.9-5e0d341bfc5bf703.nix { };
      regex-syntax-0_6_29-d734c3560e3e0cdb = callPackage' ./deps/regex-syntax-0.6.29-d734c3560e3e0cdb.nix { };
      regex-syntax-0_8_5-26304aacfbc68086 = callPackage' ./deps/regex-syntax-0.8.5-26304aacfbc68086.nix { };
      rfc6979-0_4_0-c30ead22cbafbf08 = callPackage' ./deps/rfc6979-0.4.0-c30ead22cbafbf08.nix { };
      rusqlite-0_33_0-0e7a13217d933375 = callPackage' ./deps/rusqlite-0.33.0-0e7a13217d933375.nix { };
      rustc-hash-2_1_1-eecec28cc151ccd3 = callPackage' ./deps/rustc-hash-2.1.1-eecec28cc151ccd3.nix { };
      rustc-stable-hash-0_1_2-5e3739f6900f7bdf = callPackage' ./deps/rustc-stable-hash-0.1.2-5e3739f6900f7bdf.nix { };
      rustix-0_38_44-83758b3e1a43a320 = callPackage' ./deps/rustix-0.38.44-83758b3e1a43a320.nix { };
      rustix-0_38_44-script_build-15ab18fbe197bdef = callPackage' ./deps/rustix-0.38.44-script_build-15ab18fbe197bdef.nix { };
      rustix-0_38_44-script_build_run-8ba6ad9cbdc9b810 = callPackage' ./deps/rustix-0.38.44-script_build_run-8ba6ad9cbdc9b810.nix { };
      ryu-1_0_19-e43e7d32117cb8d6 = callPackage' ./deps/ryu-1.0.19-e43e7d32117cb8d6.nix { };
      same-file-1_0_6-82920d733726b0a3 = callPackage' ./deps/same-file-1.0.6-82920d733726b0a3.nix { };
      scopeguard-1_2_0-675bcd8d02509606 = callPackage' ./deps/scopeguard-1.2.0-675bcd8d02509606.nix { };
      sec1-0_7_3-c1e3b07f235180b4 = callPackage' ./deps/sec1-0.7.3-c1e3b07f235180b4.nix { };
      semver-1_0_25-44d2ac63fb520e42 = callPackage' ./deps/semver-1.0.25-44d2ac63fb520e42.nix { };
      semver-1_0_25-script_build-47409475ecea4507 = callPackage' ./deps/semver-1.0.25-script_build-47409475ecea4507.nix { };
      semver-1_0_25-script_build_run-e61c72ddfe9a1461 = callPackage' ./deps/semver-1.0.25-script_build_run-e61c72ddfe9a1461.nix { };
      serde-1_0_218-472e28b9f131b02c = callPackage' ./deps/serde-1.0.218-472e28b9f131b02c.nix { };
      serde-1_0_218-script_build-1d089bb9d3c47726 = callPackage' ./deps/serde-1.0.218-script_build-1d089bb9d3c47726.nix { };
      serde-1_0_218-script_build_run-e17f586beb12995f = callPackage' ./deps/serde-1.0.218-script_build_run-e17f586beb12995f.nix { };
      serde-untagged-0_1_6-6d07b1ee988da762 = callPackage' ./deps/serde-untagged-0.1.6-6d07b1ee988da762.nix { };
      serde-value-0_7_0-7784867bacba5e84 = callPackage' ./deps/serde-value-0.7.0-7784867bacba5e84.nix { };
      serde_derive-1_0_218-5e91c4ae42a1c7c1 = callPackage' ./deps/serde_derive-1.0.218-5e91c4ae42a1c7c1.nix { };
      serde_ignored-0_1_10-dc3c1b953dc9ba97 = callPackage' ./deps/serde_ignored-0.1.10-dc3c1b953dc9ba97.nix { };
      serde_json-1_0_139-ae78ec5bae97c420 = callPackage' ./deps/serde_json-1.0.139-ae78ec5bae97c420.nix { };
      serde_json-1_0_139-script_build-fb6175468e374361 = callPackage' ./deps/serde_json-1.0.139-script_build-fb6175468e374361.nix { };
      serde_json-1_0_139-script_build_run-0c75c9c70c6b060e = callPackage' ./deps/serde_json-1.0.139-script_build_run-0c75c9c70c6b060e.nix { };
      serde_spanned-0_6_8-b8b72c3377341dbf = callPackage' ./deps/serde_spanned-0.6.8-b8b72c3377341dbf.nix { };
      sha1-0_10_6-7f98ce853a3fd8dc = callPackage' ./deps/sha1-0.10.6-7f98ce853a3fd8dc.nix { };
      sha1_smol-1_0_1-44d22cb8cb02d9b3 = callPackage' ./deps/sha1_smol-1.0.1-44d22cb8cb02d9b3.nix { };
      sha2-0_10_8-bdde0649695b7ac6 = callPackage' ./deps/sha2-0.10.8-bdde0649695b7ac6.nix { };
      sharded-slab-0_1_7-10e31a831cdc1a9e = callPackage' ./deps/sharded-slab-0.1.7-10e31a831cdc1a9e.nix { };
      shell-escape-0_1_5-fc06a701b65fbe9d = callPackage' ./deps/shell-escape-0.1.5-fc06a701b65fbe9d.nix { };
      shell-words-1_1_0-584d11ea81812f9b = callPackage' ./deps/shell-words-1.1.0-584d11ea81812f9b.nix { };
      shlex-1_3_0-0c449fab60129fd9 = callPackage' ./deps/shlex-1.3.0-0c449fab60129fd9.nix { };
      signal-hook-0_3_18-1abb298067a85eda = callPackage' ./deps/signal-hook-0.3.18-1abb298067a85eda.nix { };
      signal-hook-0_3_18-script_build-1ac0ce670fbb2a9a = callPackage' ./deps/signal-hook-0.3.18-script_build-1ac0ce670fbb2a9a.nix { };
      signal-hook-0_3_18-script_build_run-40557db598ae01b9 = callPackage' ./deps/signal-hook-0.3.18-script_build_run-40557db598ae01b9.nix { };
      signal-hook-mio-0_2_4-cd56e28dfd710f50 = callPackage' ./deps/signal-hook-mio-0.2.4-cd56e28dfd710f50.nix { };
      signal-hook-registry-1_4_6-e6450daef8f1b40e = callPackage' ./deps/signal-hook-registry-1.4.6-e6450daef8f1b40e.nix { };
      signature-2_2_0-bdcd5e167033dfda = callPackage' ./deps/signature-2.2.0-bdcd5e167033dfda.nix { };
      sized-chunks-0_6_5-e757fe722119bf9b = callPackage' ./deps/sized-chunks-0.6.5-e757fe722119bf9b.nix { };
      smallvec-1_13_2-e5874423828ed52b = callPackage' ./deps/smallvec-1.13.2-e5874423828ed52b.nix { };
      socket2-0_5_8-5c7e1d07a2b2a7e8 = callPackage' ./deps/socket2-0.5.8-5c7e1d07a2b2a7e8.nix { };
      spki-0_7_3-71eafb32dcb1867a = callPackage' ./deps/spki-0.7.3-71eafb32dcb1867a.nix { };
      stable_deref_trait-1_2_0-62798fe62205e471 = callPackage' ./deps/stable_deref_trait-1.2.0-62798fe62205e471.nix { };
      static_assertions-1_1_0-a2f250d3376c1838 = callPackage' ./deps/static_assertions-1.1.0-a2f250d3376c1838.nix { };
      strsim-0_11_1-08697f8fab7ff2ae = callPackage' ./deps/strsim-0.11.1-08697f8fab7ff2ae.nix { };
      subtle-2_6_1-61dbca2d742edabc = callPackage' ./deps/subtle-2.6.1-61dbca2d742edabc.nix { };
      supports-hyperlinks-3_1_0-d01c256720ea7038 = callPackage' ./deps/supports-hyperlinks-3.1.0-d01c256720ea7038.nix { };
      supports-unicode-3_0_0-bf24266a6bf9ea5d = callPackage' ./deps/supports-unicode-3.0.0-bf24266a6bf9ea5d.nix { };
      syn-2_0_98-93aa0f13dad61a07 = callPackage' ./deps/syn-2.0.98-93aa0f13dad61a07.nix { };
      synstructure-0_13_1-b52c6310fdbcc413 = callPackage' ./deps/synstructure-0.13.1-b52c6310fdbcc413.nix { };
      tar-0_4_44-1da5ced4b8e7e118 = callPackage' ./deps/tar-0.4.44-1da5ced4b8e7e118.nix { };
      tempfile-3_17_1-94ecc3046797cc75 = callPackage' ./deps/tempfile-3.17.1-94ecc3046797cc75.nix { };
      terminal_size-0_4_1-d80a87ba3231c1b4 = callPackage' ./deps/terminal_size-0.4.1-d80a87ba3231c1b4.nix { };
      thiserror-1_0_69-19f3044926d2abbd = callPackage' ./deps/thiserror-1.0.69-19f3044926d2abbd.nix { };
      thiserror-1_0_69-script_build-6cadb049729033d9 = callPackage' ./deps/thiserror-1.0.69-script_build-6cadb049729033d9.nix { };
      thiserror-1_0_69-script_build_run-ac159c9a9043953b = callPackage' ./deps/thiserror-1.0.69-script_build_run-ac159c9a9043953b.nix { };
      thiserror-2_0_11-a57592ffa4ea41e0 = callPackage' ./deps/thiserror-2.0.11-a57592ffa4ea41e0.nix { };
      thiserror-2_0_11-script_build-2df167878601bd22 = callPackage' ./deps/thiserror-2.0.11-script_build-2df167878601bd22.nix { };
      thiserror-2_0_11-script_build_run-83d85e9483fbe13c = callPackage' ./deps/thiserror-2.0.11-script_build_run-83d85e9483fbe13c.nix { };
      thiserror-impl-1_0_69-284cfbbe4814f2b5 = callPackage' ./deps/thiserror-impl-1.0.69-284cfbbe4814f2b5.nix { };
      thiserror-impl-2_0_11-66c29e07c551aa3d = callPackage' ./deps/thiserror-impl-2.0.11-66c29e07c551aa3d.nix { };
      thread_local-1_1_8-e251696b830b4015 = callPackage' ./deps/thread_local-1.1.8-e251696b830b4015.nix { };
      time-0_3_37-b73d8cae561973b7 = callPackage' ./deps/time-0.3.37-b73d8cae561973b7.nix { };
      time-core-0_1_2-40512bcb5aefef1e = callPackage' ./deps/time-core-0.1.2-40512bcb5aefef1e.nix { };
      tinystr-0_7_6-887be2ca1a583610 = callPackage' ./deps/tinystr-0.7.6-887be2ca1a583610.nix { };
      tinyvec-1_8_1-eb639ac0d54a4875 = callPackage' ./deps/tinyvec-1.8.1-eb639ac0d54a4875.nix { };
      tinyvec_macros-0_1_1-f3f6efb33c1e7caa = callPackage' ./deps/tinyvec_macros-0.1.1-f3f6efb33c1e7caa.nix { };
      toml-0_8_20-7a483d12a9e19406 = callPackage' ./deps/toml-0.8.20-7a483d12a9e19406.nix { };
      toml_datetime-0_6_8-c22a379486cde223 = callPackage' ./deps/toml_datetime-0.6.8-c22a379486cde223.nix { };
      toml_edit-0_22_24-24142c1671b8cfdf = callPackage' ./deps/toml_edit-0.22.24-24142c1671b8cfdf.nix { };
      tracing-0_1_41-7b5284fa1d5dcd0d = callPackage' ./deps/tracing-0.1.41-7b5284fa1d5dcd0d.nix { };
      tracing-attributes-0_1_28-056492cde3f32925 = callPackage' ./deps/tracing-attributes-0.1.28-056492cde3f32925.nix { };
      tracing-chrome-0_7_2-5b548189b83dd8d2 = callPackage' ./deps/tracing-chrome-0.7.2-5b548189b83dd8d2.nix { };
      tracing-core-0_1_33-a96acb2d986ff9b2 = callPackage' ./deps/tracing-core-0.1.33-a96acb2d986ff9b2.nix { };
      tracing-log-0_2_0-42539ffc045b2c08 = callPackage' ./deps/tracing-log-0.2.0-42539ffc045b2c08.nix { };
      tracing-subscriber-0_3_19-8f98042188b2d3ba = callPackage' ./deps/tracing-subscriber-0.3.19-8f98042188b2d3ba.nix { };
      typeid-1_0_2-e066b933ff0261e3 = callPackage' ./deps/typeid-1.0.2-e066b933ff0261e3.nix { };
      typeid-1_0_2-script_build-8b627282cced2319 = callPackage' ./deps/typeid-1.0.2-script_build-8b627282cced2319.nix { };
      typeid-1_0_2-script_build_run-55b3ee01b747ba43 = callPackage' ./deps/typeid-1.0.2-script_build_run-55b3ee01b747ba43.nix { };
      typenum-1_17_0-34b9dff24cc50896 = callPackage' ./deps/typenum-1.17.0-34b9dff24cc50896.nix { };
      typenum-1_17_0-script_build-4ca096dc05fa85f4 = callPackage' ./deps/typenum-1.17.0-script_build-4ca096dc05fa85f4.nix { };
      typenum-1_17_0-script_build_run-6370bc66f402e7bf = callPackage' ./deps/typenum-1.17.0-script_build_run-6370bc66f402e7bf.nix { };
      ucd-trie-0_1_7-174fa1c20d2742b4 = callPackage' ./deps/ucd-trie-0.1.7-174fa1c20d2742b4.nix { };
      unicase-2_8_1-07d4133086b7fec6 = callPackage' ./deps/unicase-2.8.1-07d4133086b7fec6.nix { };
      unicode-bom-2_0_3-c41344f0afa7072b = callPackage' ./deps/unicode-bom-2.0.3-c41344f0afa7072b.nix { };
      unicode-ident-1_0_17-19b9bf45cc26c223 = callPackage' ./deps/unicode-ident-1.0.17-19b9bf45cc26c223.nix { };
      unicode-normalization-0_1_24-d55d29ecb6c4fe97 = callPackage' ./deps/unicode-normalization-0.1.24-d55d29ecb6c4fe97.nix { };
      unicode-width-0_2_0-0c384aa902aa0aa2 = callPackage' ./deps/unicode-width-0.2.0-0c384aa902aa0aa2.nix { };
      unicode-xid-0_2_6-2091b14caaa2c4d2 = callPackage' ./deps/unicode-xid-0.2.6-2091b14caaa2c4d2.nix { };
      url-2_5_4-7b68be8bb56d0713 = callPackage' ./deps/url-2.5.4-7b68be8bb56d0713.nix { };
      utf16_iter-1_0_5-e2c4d90fc6d42e47 = callPackage' ./deps/utf16_iter-1.0.5-e2c4d90fc6d42e47.nix { };
      utf8_iter-1_0_4-09be6fe1c1163a1d = callPackage' ./deps/utf8_iter-1.0.4-09be6fe1c1163a1d.nix { };
      utf8parse-0_2_2-971e9f48d47f3e38 = callPackage' ./deps/utf8parse-0.2.2-971e9f48d47f3e38.nix { };
      vcpkg-0_2_15-586bd5fdef1a0fde = callPackage' ./deps/vcpkg-0.2.15-586bd5fdef1a0fde.nix { };
      version_check-0_9_5-0f6ab564ae9887d4 = callPackage' ./deps/version_check-0.9.5-0f6ab564ae9887d4.nix { };
      walkdir-2_5_0-742d7f303f7cfcda = callPackage' ./deps/walkdir-2.5.0-742d7f303f7cfcda.nix { };
      winnow-0_6_26-83cf2fecf0abf70e = callPackage' ./deps/winnow-0.6.26-83cf2fecf0abf70e.nix { };
      winnow-0_7_1-a5873bca62debc35 = callPackage' ./deps/winnow-0.7.1-a5873bca62debc35.nix { };
      write16-1_0_0-26b1931c23e70fcd = callPackage' ./deps/write16-1.0.0-26b1931c23e70fcd.nix { };
      writeable-0_5_5-126ae34b487ba069 = callPackage' ./deps/writeable-0.5.5-126ae34b487ba069.nix { };
      yoke-0_7_5-06c6b7b4d71d5784 = callPackage' ./deps/yoke-0.7.5-06c6b7b4d71d5784.nix { };
      yoke-derive-0_7_5-a7212319c1d2a9df = callPackage' ./deps/yoke-derive-0.7.5-a7212319c1d2a9df.nix { };
      zerocopy-0_7_35-04fb0a6a0df5a3bd = callPackage' ./deps/zerocopy-0.7.35-04fb0a6a0df5a3bd.nix { };
      zerocopy-0_8_17-7759749ca810547a = callPackage' ./deps/zerocopy-0.8.17-7759749ca810547a.nix { };
      zerocopy-0_8_17-script_build-870030e50d165c92 = callPackage' ./deps/zerocopy-0.8.17-script_build-870030e50d165c92.nix { };
      zerocopy-0_8_17-script_build_run-71620538d8125d09 = callPackage' ./deps/zerocopy-0.8.17-script_build_run-71620538d8125d09.nix { };
      zerocopy-derive-0_7_35-df502606a617a786 = callPackage' ./deps/zerocopy-derive-0.7.35-df502606a617a786.nix { };
      zerofrom-0_1_5-67ba692659162de9 = callPackage' ./deps/zerofrom-0.1.5-67ba692659162de9.nix { };
      zerofrom-derive-0_1_5-6de1175abc985e61 = callPackage' ./deps/zerofrom-derive-0.1.5-6de1175abc985e61.nix { };
      zeroize-1_8_1-9a1357fe1b2d7a82 = callPackage' ./deps/zeroize-1.8.1-9a1357fe1b2d7a82.nix { };
      zerovec-0_10_4-e3e96206699c2afa = callPackage' ./deps/zerovec-0.10.4-e3e96206699c2afa.nix { };
      zerovec-derive-0_10_3-229ca38161287853 = callPackage' ./deps/zerovec-derive-0.10.3-229ca38161287853.nix { };
    };
  };
in
self
