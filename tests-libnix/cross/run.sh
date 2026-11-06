#!/usr/bin/env bash
# Tests of cross compiling in nix mode: two workspaces are built with `CARGO_BACKEND=nix cargo build --target
# <triple>` for each target below, and the binary is checked (architecture, statically linked) and run: natively,
# with qemu-user or wasmtime.
#   hello      a main.rs that prints its std::env::consts::ARCH, which must be the target's
#   c-library  tests-libnix/cross/c-library: a C library (returns "hello world from c"), compiled for the target by
#              the build script of its rust wrapper with clang (from its Cargo.dependencies.nix), and a bin
#              printing it
#
#   tests-libnix/cross/run.sh                                   # all targets, with target/debug/cargo
#   tests-libnix/cross/run.sh wasm32-wasip1 aarch64-unknown-linux-musl
#   CASES=c-library tests-libnix/cross/run.sh                   # one workspace only
#   CARGO=path/to/cargo tests-libnix/cross/run.sh
#   KEEP=1 tests-libnix/cross/run.sh                            # leaves target/cross-tests/workspace-<pid>
#
# cargo itself needs a rustc for the target info (`rustc --print cfg --target …`, no std of the target needed);
# without one in PATH the flake's rustc_<version>_vanilla_pin of this cargo's version is used (on the 1.99 line not
# rustc_1_99_nix_ld: its -C linker-features=-lld is an error with any --target other than x86_64-unknown-linux-gnu,
# also in a rustc in PATH). The units build with the toolchain of cargo_build_caller.nix, which adds the rust-std of
# each --target.
#
# The binaries are taken from the unit's store output; where legacy mode puts them (target/<triple>/debug/hello)
# is checked as well and reported as `xfail` while nix mode links cross outputs to target/debug (see
# ticket-output-links.md).
#
# Runs in target/cross-tests, not in /tmp: the nix-daemon can't see GC roots in a private /tmp.
set -u
repo=$(cd "$(dirname "$0")/../.." && pwd)
cargo=$(readlink -f "${CARGO:-$repo/target/debug/cargo}")
dir="$repo/target/cross-tests/workspace-$$"
failed=0

ok() { echo "  ok    $1"; }
xfail() { echo "  xfail $1"; }
fail() { echo "  FAIL  $1"; shift; for l in "$@"; do echo "        $l"; done; failed=1; }

# triple, the ARCH it prints, how it runs, extra settings
#   run: native, qemu-<arch>, wasmtime, none (built and checked only)
#   musl targets link with rust-lld and the target's self-contained crt (the host cc can't link them); riscv64
#   musl links dynamically by default, so +crt-static
targets=(
  "x86_64-unknown-linux-gnu        x86_64  native"
  "x86_64-unknown-linux-musl       x86_64  native        static"
  "i686-unknown-linux-musl         x86     qemu-i386     static lld"
  "aarch64-unknown-linux-musl      aarch64 qemu-aarch64  static lld"
  "armv7-unknown-linux-musleabihf  arm     qemu-arm      static lld"
  "riscv64gc-unknown-linux-musl    riscv64 qemu-riscv64  static lld crt-static"
  "wasm32-wasip1                   wasm32  wasmtime"
  "wasm32-unknown-unknown          wasm32  none"
  # glibc targets other than the host need a cross C toolchain (the cc and glibc of the target) in the units'
  # build environment; rustc links them with the host cc today (`rust-lld: error: --fix-cortex-a53-843419 is only
  # supported on AArch64`)
  "aarch64-unknown-linux-gnu       aarch64 qemu-aarch64  xfail"
)

if [ $# -gt 0 ]; then
  selected=()
  for t in "$@"; do
    line=$(printf '%s\n' "${targets[@]}" | awk -v t="$t" '$1 == t')
    [ -n "$line" ] || { echo "unknown target $t"; exit 2; }
    selected+=("$line")
  done
  targets=("${selected[@]}")
fi

if ! command -v rustc > /dev/null; then
  version=$("$cargo" -V | awk '{print $2}' | cut -d. -f1,2 | tr . _)
  rustc_out=$(nix build --no-link --print-out-paths "$repo#rustc_${version}_vanilla_pin") || exit 1
  export PATH="$rustc_out/bin:$PATH"
fi
# the runners, only those needed
tool() {
  case $1 in
    qemu-*) echo "$(nix build --no-link --print-out-paths nixpkgs#qemu-user)/bin/$1" ;;
    wasmtime) echo "$(nix build --no-link --print-out-paths nixpkgs#wasmtime)/bin/wasmtime" ;;
  esac
}

# the workspaces: "hello" a main.rs, "c-library" (tests-libnix/cross/c-library) a C library (c/hello.c, compiled
# by its build script with clang for the target), its rust wrapper (hello-c-sys) and a bin using it (hello-c)
cases=(${CASES:-hello c-library})
mkdir -p "$dir/hello/src"
cat > "$dir/hello/Cargo.toml" <<'EOF'
[package]
name = "hello"
version = "0.1.0"
edition = "2021"

[workspace]
EOF
echo 'fn main() { println!("hello from {}", std::env::consts::ARCH); }' > "$dir/hello/src/main.rs"
cp -r "$repo/tests-libnix/cross/c-library" "$dir/c-library"
for c in "${cases[@]}"; do
  [ -d "$dir/$c" ] || { echo "unknown case $c"; exit 2; }
  (cd "$dir/$c" && git init -q .)
done

echo "cross ($cargo)"

for c in "${cases[@]}"; do
for line in "${targets[@]}"; do
  read -r triple arch run flags <<< "$line"
  flags=" ${flags:-} "
  case $c in
    hello) name=hello; want_out="hello from $arch" ;;
    c-library) name=hello-c; want_out="hello world from c" ;;
  esac
  t="$c $triple"
  var=$(echo "$triple" | tr a-z- A-Z_)
  envs=(CARGO_BACKEND=nix)
  [[ $flags == *" lld "* ]] && envs+=("CARGO_TARGET_${var}_LINKER=rust-lld")
  [[ $flags == *" crt-static "* ]] && envs+=("CARGO_TARGET_${var}_RUSTFLAGS=-C target-feature=+crt-static")

  log=$(cd "$dir/$c" && env "${envs[@]}" "$cargo" build --target "$triple" 2>&1)
  status=$?
  if [ $status -ne 0 ]; then
    if [[ $flags == *" xfail "* ]]; then xfail "$t: build (needs a cross C toolchain)"
    else fail "$t: build" "$(echo "$log" | grep -E '^error|note: .*error|panicked' | head -5)"; fi
    continue
  fi
  [[ $flags == *" xfail "* ]] && fail "$t: build" "builds now, remove xfail"

  # the binary: the unit's store output, whichever link cargo wrote
  bin=$(readlink -f "$dir/$c/target/debug/$name")
  # wasm: $out/bin/<name> points at $out/<crate>-<hash>, but the file is <crate>-<hash>.wasm (ticket-output-links.md)
  [ "$arch" = wasm32 ] && bin=$(ls "$(dirname "$bin")"/"${name//-/_}"-*.wasm 2>/dev/null | head -1)
  if [ -z "$bin" ] || [ ! -f "$bin" ]; then fail "$t: output" "no binary in the store output"; continue; fi
  ok "$t: build"

  # where legacy mode has it
  expected="$dir/$c/target/$triple/debug/$name"
  [ "$arch" = wasm32 ] && expected="$expected.wasm"
  if [ -e "$expected" ]; then ok "$t: $expected"; else xfail "$t: target/$triple/debug/$name* (output links)"; fi

  info=$(file -L "$bin")
  case $arch in
    x86_64) want="x86-64" ;; x86) want="Intel 80386\|Intel i386" ;; aarch64) want="ARM aarch64" ;; arm) want="ARM, EABI5" ;;
    riscv64) want="RISC-V" ;; wasm32) want="WebAssembly" ;;
  esac
  if echo "$info" | grep -q "$want"; then ok "$t: $want"; else fail "$t: architecture" "$info"; fi
  if [[ $flags == *" static "* ]]; then
    if echo "$info" | grep -q "statically linked\|static-pie linked"; then ok "$t: statically linked"
    else fail "$t: statically linked" "$info"; fi
  fi

  case $run in
    native) out=$("$bin" 2>&1) ;;
    qemu-*|wasmtime) out=$("$(tool "$run")" "$bin" 2>&1) ;;
    none) continue ;;
  esac
  if [ "$out" = "$want_out" ]; then ok "$t: runs ($run): $out"; else fail "$t: runs ($run)" "$out"; fi
done
done

[ -n "${KEEP:-}" ] || rm -rf "$dir"
[ $failed -eq 0 ] && echo "cross: ok" || { echo "cross: FAILED"; exit 1; }
