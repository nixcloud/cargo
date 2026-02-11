# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "handlebars-6_3_1-1d5c39ccada6570e";
    meta.cargo_crate_info = {
      name = "handlebars";
      version = "6.3.1";
      crate_hash = "1d5c39ccada6570e";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [derive_builder-0_20_2-8c9b1e471d93f01c log-0_4_25-7616f5eb69eb8f7e num-order-1_2_0-192b41e262367e4b pest-2_7_15-a8485b5b1580dc17 pest_derive-2_7_15-d16fa3e9d28681c6 serde-1_0_218-472e28b9f131b02c serde_json-1_0_139-ae78ec5bae97c420 thiserror-2_0_11-a57592ffa4ea41e0 walkdir-2_5_0-742d7f303f7cfcda];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/handlebars/6.3.1/download";
      sha256 = "d752747ddabc4c1a70dd28e72f2e3c218a816773e0d7faf67433f1acfa6cba7c";
    };
    unpackPhase = ''
      tar xf $src
      cd handlebars-6.3.1
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "handlebars";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Ning Sun <sunng@pm.me>";
    CARGO_PKG_DESCRIPTION = "Handlebars templating implemented in Rust.";
    CARGO_PKG_HOMEPAGE = "https://github.com/sunng87/handlebars-rust";
    CARGO_PKG_LICENSE = "MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "handlebars";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/sunng87/handlebars-rust";
    CARGO_PKG_RUST_VERSION = "1.73";
    CARGO_PKG_VERSION = "6.3.1";
    CARGO_PKG_VERSION_MAJOR = "6";
    CARGO_PKG_VERSION_MINOR = "3";
    CARGO_PKG_VERSION_PATCH = "1";
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
              --crate-name handlebars \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="default"' \
              --cfg 'feature="dir_source"' \
              --cfg 'feature="walkdir"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("default", "dir_source", "heck", "no_logging", "rhai", "rust-embed", "script_helper", "string_helpers", "walkdir"))' \
              -C metadata=9ba6a26e66e29fbb \
              -C extra-filename=-1d5c39ccada6570e \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
              --extern derive_builder=${derive_builder-0_20_2-8c9b1e471d93f01c}/libderive_builder-8c9b1e471d93f01c.rmeta \
              --extern log=${log-0_4_25-7616f5eb69eb8f7e}/liblog-7616f5eb69eb8f7e.rmeta \
              --extern num_order=${num-order-1_2_0-192b41e262367e4b}/libnum_order-192b41e262367e4b.rmeta \
              --extern pest=${pest-2_7_15-a8485b5b1580dc17}/libpest-a8485b5b1580dc17.rmeta \
              --extern pest_derive=${pest_derive-2_7_15-d16fa3e9d28681c6}/libpest_derive-d16fa3e9d28681c6.so \
              --extern serde=${serde-1_0_218-472e28b9f131b02c}/libserde-472e28b9f131b02c.rmeta \
              --extern serde_json=${serde_json-1_0_139-ae78ec5bae97c420}/libserde_json-ae78ec5bae97c420.rmeta \
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
