# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "rustix-0_38_44-script_build-da988dbb6aec674f";
    meta.cargo_crate_info = {
      name = "rustix";
      version = "0.38.44";
      crate_hash = "da988dbb6aec674f";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/rustix/0.38.44/download";
      sha256 = "fdb5bc1ae2baa591800df16c9ca78619bf65c0488b41b96ccec5d11220d8c154";
    };
    unpackPhase = ''
      tar xf $src
      cd rustix-0.38.44
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${rustc}/bin/rustc";

    CARGO_CRATE_NAME = "build_script_build";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Dan Gohman <dev@sunfishcode.online>:Jakub Konka <kubkon@jakubkonka.com>";
    CARGO_PKG_DESCRIPTION = "Safe Rust bindings to POSIX/Unix/Linux/Winsock-like syscalls";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 WITH LLVM-exception OR Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "rustix";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/bytecodealliance/rustix";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "0.38.44";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "38";
    CARGO_PKG_VERSION_PATCH = "44";
    CARGO_PKG_VERSION_PRE = "";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(mktemp -d)

      echo -e "\e[92mCompiling\e[0m rustix-0_38_44-script_build-da988dbb6aec674f"

      (set -x 
      ${rustc}/bin/rustc \
        --crate-name build_script_build \
        --edition=2021 build.rs \
        --crate-type bin \
        --emit=dep-info,link \
        -C embed-bitcode=no \
        --warn=unexpected_cfgs \
        --check-cfg 'cfg(alloc_c_string)' \
        --check-cfg 'cfg(alloc_ffi)' \
        --check-cfg 'cfg(apple)' \
        --check-cfg 'cfg(asm_experimental_arch)' \
        --check-cfg 'cfg(bsd)' \
        --check-cfg 'cfg(core_c_str)' \
        --check-cfg 'cfg(core_ffi_c)' \
        --check-cfg 'cfg(core_intrinsics)' \
        --check-cfg 'cfg(criterion)' \
        --check-cfg 'cfg(document_experimental_runtime_api)' \
        --check-cfg 'cfg(fix_y2038)' \
        --check-cfg 'cfg(freebsdlike)' \
        --check-cfg 'cfg(libc)' \
        --check-cfg 'cfg(linux_kernel)' \
        --check-cfg 'cfg(linux_like)' \
        --check-cfg 'cfg(linux_raw)' \
        --check-cfg 'cfg(netbsdlike)' \
        --check-cfg 'cfg(rustc_attrs)' \
        --check-cfg 'cfg(solarish)' \
        --check-cfg 'cfg(staged_api)' \
        --check-cfg 'cfg(static_assertions)' \
        --check-cfg 'cfg(thumb_mode)' \
        --check-cfg 'cfg(wasi)' \
        --check-cfg 'cfg(wasi_ext)' \
        --check-cfg 'cfg(target_arch, values("xtensa"))' \
        ${fn.rustc_arguments passthru.rust_crate_parent} \
        --cfg 'feature="alloc"' \
        --cfg 'feature="default"' \
        --cfg 'feature="fs"' \
        --cfg 'feature="libc-extra-traits"' \
        --cfg 'feature="std"' \
        --cfg 'feature="termios"' \
        --cfg 'feature="use-libc-auxv"' \
        --check-cfg 'cfg(docsrs,test)' \
        --check-cfg 'cfg(feature, values("all-apis", "alloc", "cc", "compiler_builtins", "core", "default", "event", "fs", "io_uring", "itoa", "libc", "libc-extra-traits", "libc_errno", "linux_4_11", "linux_latest", "mm", "mount", "net", "once_cell", "param", "pipe", "process", "procfs", "pty", "rand", "runtime", "rustc-dep-of-std", "rustc-std-workspace-alloc", "shm", "std", "stdio", "system", "termios", "thread", "time", "try_close", "use-explicitly-provided-auxv", "use-libc", "use-libc-auxv"))' \
        -C metadata=703766113efd8502 \
        -C extra-filename=-da988dbb6aec674f \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --cap-lints allow
      ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-da988dbb6aec674f $OUT_DIR/build_script_build
      )
    '';
}
