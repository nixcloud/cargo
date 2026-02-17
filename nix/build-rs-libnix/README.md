This crate was built by hand from the crates/build-rs-libnix source to bootstrap this toolchain.

The main goal is to create a minimal build-rs-libnix executable:

      ${build_parser}/bin/build-rs-libnix --script-output  $OUT_DIR/nix/build_script_build.out --out-dir $out/nix 2> $build_parser_output_lines

I originally used the source from cargo/crates/build-rs-libnix/Cargo.toml and cargo/Cargo.lock but it caused recompiles everytime. This is a more static version.