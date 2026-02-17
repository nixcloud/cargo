# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ fn, pkgs, rustc, cargo, deps, project_root }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "linux-raw-sys-0_4_15-624798d9199ea3b3";
    meta.cargo_crate_info = {
      name = "linux-raw-sys";
      version = "0.4.15";
      crate_hash = "624798d9199ea3b3";
      type = "";
    };
    buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [];
    passthru.rust_script_build_run = [];
    phases = "unpackPhase buildPhase";

    src = pkgs.fetchurl {
      url = "https://crates.io/api/v1/crates/linux-raw-sys/0.4.15/download";
      sha256 = "d26c52dbd32dccf2d10cac7725f8eae5296885fb5703b261f7d0a0739ec807ab";
    };
    unpackPhase = ''
      tar xf $src
      cd linux-raw-sys-0.4.15
    '';

    RUSTC = "${rustc}/bin/rustc";
    CARGO_CRATE_NAME = "linux_raw_sys";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "Dan Gohman <dev@sunfishcode.online>";
    CARGO_PKG_DESCRIPTION = "Generated bindings for Linux's userspace API";
    CARGO_PKG_HOMEPAGE = "";
    CARGO_PKG_LICENSE = "Apache-2.0 WITH LLVM-exception OR Apache-2.0 OR MIT";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "linux-raw-sys";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/sunfishcode/linux-raw-sys";
    CARGO_PKG_RUST_VERSION = "1.63";
    CARGO_PKG_VERSION = "0.4.15";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "4";
    CARGO_PKG_VERSION_PATCH = "15";
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
              --crate-name linux_raw_sys \
              --edition=2021 src/lib.rs \
              --error-format=json \
              --json=diagnostic-rendered-ansi,artifacts,future-incompat \
              --crate-type lib \
              --emit=dep-info,metadata,link \
              -C embed-bitcode=no \
              -C debuginfo=2 \
              --warn=unexpected_cfgs \
              --check-cfg 'cfg(target_arch, values("xtensa"))' \
              ${fn.rustc_arguments passthru.rust_crate_parent} \
              --cfg 'feature="elf"' \
              --cfg 'feature="errno"' \
              --cfg 'feature="general"' \
              --cfg 'feature="ioctl"' \
              --cfg 'feature="no_std"' \
              --check-cfg 'cfg(docsrs,test)' \
              --check-cfg 'cfg(feature, values("bootparam", "btrfs", "compiler_builtins", "core", "default", "elf", "elf_uapi", "errno", "general", "if_arp", "if_ether", "if_packet", "io_uring", "ioctl", "landlock", "loop_device", "mempolicy", "net", "netlink", "no_std", "prctl", "ptrace", "rustc-dep-of-std", "std", "system", "xdp"))' \
              -C metadata=9b35832d4dbf8423 \
              -C extra-filename=-624798d9199ea3b3 \
              --out-dir $OUT_DIR \
              -L dependency=${fn.rustc_linker_arguments_dir passthru.rust_crate_libraries}/deps \
              ${fn.rustc_propagated_arguments passthru.rust_script_build_run} \
              ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
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
