# generated from rustc-call.nix.handlebars
{ fn, pkgs, rustc, cargo, deps }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "rustix-0_38_44-c73c53514f7b96d9";
    meta.cargo_crate_info = {
      name = "rustix";
      version = "0.38.44";
      crate_hash = "c73c53514f7b96d9";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    passthru.rust_crate_libraries = [bitflags-2_8_0-27b6a5758605f436 linux-raw-sys-0_4_15-4a0c260c6dd78b8e];
    passthru.rust_crate_parent = [rustix-0_38_44-script_build_run-dc0ff43c8b8648ff];
    passthru.rust_script_build_run = [rustix-0_38_44-script_build_run-dc0ff43c8b8648ff];
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

    CARGO_CRATE_NAME = "rustix";
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

      echo -e "\e[92mCompiling\e[0m rustix-0_38_44-c73c53514f7b96d9"
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
        --crate-name rustix \
        --edition=2021 src/lib.rs \
        --crate-type lib \
        --emit=dep-info,metadata,link \
        -C embed-bitcode=no \
        -C debuginfo=2 \
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
        -C metadata=3937917d4c72041a \
        -C extra-filename=-c73c53514f7b96d9 \
        --out-dir $OUT_DIR \
        ${fn.rustc_linker_arguments passthru.rust_crate_libraries} \
        ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
        --extern bitflags=${bitflags-2_8_0-27b6a5758605f436}/libbitflags-27b6a5758605f436.rmeta \
        --extern linux_raw_sys=${linux-raw-sys-0_4_15-4a0c260c6dd78b8e}/liblinux_raw_sys-4a0c260c6dd78b8e.rmeta \
        --cap-lints allow
      )
    '';
}
