# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "time-0_3_37-b73d8cae561973b7";
    meta.cargo_crate_info = {
      name = "time";
      version = "0.3.37";
      crate_hash = "b73d8cae561973b7";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [deranged-0_3_11-ff4e1a9ba87819f3 itoa-1_0_14-6ae7bc765ab6d9fa num-conv-0_1_0-0df124cc8207c71e powerfmt-0_2_0-daab621ad5d886f7 serde-1_0_218-472e28b9f131b02c time-core-0_1_2-40512bcb5aefef1e];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/time/0.3.37/download";
      sha256 = "35e7868883861bd0e56d9ac6efcaaca0d6d5d82a2a7ec8209ff492c07cf37b21";
    };
    unpackPhase = ''
      tar xf $src
      cd time-0.3.37
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CRATE_NAME = "time";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Jacob Pratt <open-source@jhpratt.dev>:Time contributors";
    CARGO_PKG_DESCRIPTION = "Date and time library. Fully interoperable with the standard library. Mostly compatible with #![no_std].";
    CARGO_PKG_HOMEPAGE = "https://time-rs.github.io";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "time";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/time-rs/time";
    CARGO_PKG_RUST_VERSION = "1.67.1";
    CARGO_PKG_VERSION = "0.3.37";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "37";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m time-0_3_37-b73d8cae561973b7"
      echo "@cargo { \"type\":0, \"crate_name\":\"time\", \"id\":\"time-0_3_37-b73d8cae561973b7\" }"

      rustc_json_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${RUSTC} \
              --crate-name time \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --diagnostic-width=170 \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --warn=unused \
              --warn=clippy::nursery \
              --warn=clippy::all \
              --warn=variant-size-differences \
              --warn=clippy::use-debug \
              --warn=clippy::unwrap-used \
              --warn=clippy::unwrap-in-result \
              --warn=unused-qualifications \
              --warn=unused-lifetimes \
              --warn=unused-import-braces \
              --deny=unstable-syntax-pre-expansion \
              --deny=unsafe-op-in-unsafe-fn \
              --warn=unreachable-pub \
              --warn=clippy::unnested-or-patterns \
              --deny=unnameable-test-items \
              --warn=clippy::uninlined-format-args \
              --warn=clippy::unimplemented \
              --deny=unexpected_cfgs \
              --warn=rustdoc::unescaped-backticks \
              --deny=clippy::undocumented-unsafe-blocks \
              --deny=unconditional-recursion \
              --warn=trivial-numeric-casts \
              --warn=trivial-casts \
              --warn=clippy::todo \
              --deny=suspicious-double-ref-op \
              --deny=clippy::std-instead-of-core \
              --warn=single-use-lifetimes \
              --warn=clippy::semicolon-outside-block \
              --warn=rustdoc::private-doc-tests \
              --warn=clippy::print-stdout \
              --deny=overlapping-range-endpoints \
              --deny=opaque-hidden-inferred-bound \
              --warn=clippy::obfuscated-if-else \
              --warn=noop-method-call \
              --deny=non-ascii-idents \
              --deny=named-arguments-used-positionally \
              --warn=clippy::missing-enforced-import-renames \
              --warn=clippy::missing-docs-in-private-items \
              --warn=missing-docs \
              --warn=missing-debug-implementations \
              --warn=missing-copy-implementations \
              --warn=missing-abi \
              --warn=meta-variable-misuse \
              --warn=clippy::manual-let-else \
              --warn=macro-use-extern-crate \
              --warn=let-underscore \
              --warn=keyword-idents \
              --deny=invalid-value \
              --deny=invalid-reference-casting \
              --deny=invalid-nan-comparisons \
              --deny=invalid-macro-export-arguments \
              --deny=invalid-from-utf8 \
              --deny=improper-ctypes-definitions \
              --deny=improper-ctypes \
              --deny=hidden-glob-reexports \
              --warn=clippy::get-unwrap \
              --deny=future-incompatible \
              --warn=clippy::explicit-auto-deref \
              --deny=drop-bounds \
              --deny=deref-nullptr \
              --warn=clippy::decimal-literal-representation \
              --warn=clippy::dbg-macro \
              --deny=dangling-pointers-from-temporaries \
              --deny=const-item-mutation \
              --deny=clashing-extern-declarations \
              --deny=ambiguous-glob-reexports \
              --deny=clippy::alloc-instead-of-core \
              --allow=unstable-name-collisions \
              --allow=clippy::redundant-pub-crate \
              --allow=clippy::option-if-let-else \
              --check-cfg 'cfg(__ui_tests)' \
              --check-cfg 'cfg(bench)' \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="alloc"' \
              --cfg 'feature="default"' \
              --cfg 'feature="formatting"' \
              --cfg 'feature="parsing"' \
              --cfg 'feature="serde"' \
              --cfg 'feature="std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("alloc", "default", "formatting", "large-dates", "local-offset", "macros", "parsing", "quickcheck", "rand", "serde", "serde-human-readable", "serde-well-known", "std", "wasm-bindgen"))' \
              -C metadata=419ff98ce66da35c \
              -C extra-filename=-b73d8cae561973b7 \
              --out-dir $OUT_DIR \
              ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              --extern deranged=${deranged-0_3_11-ff4e1a9ba87819f3}/libderanged-ff4e1a9ba87819f3.rmeta \
              --extern itoa=${itoa-1_0_14-6ae7bc765ab6d9fa}/libitoa-6ae7bc765ab6d9fa.rmeta \
              --extern num_conv=${num-conv-0_1_0-0df124cc8207c71e}/libnum_conv-0df124cc8207c71e.rmeta \
              --extern powerfmt=${powerfmt-0_2_0-daab621ad5d886f7}/libpowerfmt-daab621ad5d886f7.rmeta \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
              --extern time_core=${time-core-0_1_2-40512bcb5aefef1e}/libtime_core-40512bcb5aefef1e.rmeta \
              --cap-lints allow 2> $rustc_json_output_lines
      rustc_exit_value=$?
      set +x -e
           
      # print errors
      while IFS= read -r line
      do
          tmpFile=$(${pkgs.mktemp}/bin/mktemp)
          echo "$line" > $tmpFile
          ${pkgs.jq}/bin/jq -r -c 'select(."$message_type"=="diagnostic") | .rendered' $tmpFile
      done < $rustc_json_output_lines
      
      
      # return structured formatted errors for later processing
      output=$(${pkgs.jq}/bin/jq -s -r -c \
          --arg fullname "time-0_3_37-b73d8cae561973b7" \
          --arg crate_name "time" \
          --arg exit_code "$rustc_exit_value" \
          '{type: 2, crate_name: $crate_name, id: $fullname, rustc_exit_code: ($exit_code|tonumber), rustc_messages: .}' \
          "$rustc_json_output_lines")
      printf '@cargo %s\n' "$output"
      if [ "$rustc_exit_value" -ne 0 ]; then
          exit $rustc_exit_value
      fi
    '';

}
