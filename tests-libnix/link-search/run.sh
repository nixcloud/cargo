#!/usr/bin/env bash
# Tests of `cargo:rustc-link-search` and `cargo:rustc-link-arg-bins` in nix mode, as cargo handles them: a workspace
# with a library and a bin, each with a build script, is built with `CARGO_BACKEND=nix cargo build` and run.
#   sys  build script: a C library in OUT_DIR/lib (native=, a directory below OUT_DIR, for the crate itself) and a
#        linker script in OUT_DIR/ld (no kind, for its dependents)
#   app  build script: a linker script in OUT_DIR (no kind, for the crate itself); -T of both linker scripts with
#        rustc-link-arg-bins, which only the bin target gets
#
#   tests-libnix/link-search/run.sh                     # with target/debug/cargo
#   CARGO=path/to/cargo tests-libnix/link-search/run.sh
#   KEEP=1 tests-libnix/link-search/run.sh              # leaves target/link-search-tests/workspace-<pid>
#
# Without a rustc in PATH the flake's rustc_<version>_vanilla_pin of this cargo's version is used. Runs in
# target/link-search-tests, not in /tmp: the nix-daemon can't see GC roots in a private /tmp.
set -u
repo=$(cd "$(dirname "$0")/../.." && pwd)
cargo=$(readlink -f "${CARGO:-$repo/target/debug/cargo}")
dir="$repo/target/link-search-tests/workspace-$$"
failed=0

ok() { echo "  ok    $1"; }
fail() { echo "  FAIL  $1"; shift; for l in "$@"; do echo "        $l"; done; failed=1; }

if ! command -v rustc > /dev/null; then
  version=$("$cargo" -V | awk '{print $2}' | cut -d. -f1,2 | tr . _)
  rustc_out=$(nix build --no-link --print-out-paths "$repo#rustc_${version}_vanilla_pin") || exit 1
  export PATH="$rustc_out/bin:$PATH"
fi

mkdir -p "$dir/sys/src" "$dir/sys/c" "$dir/app/src"
cat > "$dir/Cargo.toml" <<'TOML'
[workspace]
members = ["sys", "app"]
resolver = "2"
TOML

cat > "$dir/sys/Cargo.toml" <<'TOML'
[package]
name = "sys"
version = "0.1.0"
edition = "2021"
TOML
echo 'int sys_value(void) { return 42; }' > "$dir/sys/c/value.c"
cat > "$dir/sys/src/lib.rs" <<'RS'
extern "C" {
    fn sys_value() -> i32;
}
pub fn value() -> i32 {
    unsafe { sys_value() }
}
RS
cat > "$dir/sys/build.rs" <<'RS'
use std::fs;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    let out = PathBuf::from(std::env::var("OUT_DIR").unwrap());
    let (lib, ld) = (out.join("lib"), out.join("ld"));
    fs::create_dir_all(&lib).unwrap();
    fs::create_dir_all(&ld).unwrap();
    let obj = lib.join("value.o");
    assert!(Command::new("cc").args(["-fPIC", "-c", "c/value.c", "-o"]).arg(&obj).status().unwrap().success());
    assert!(Command::new("ar").arg("crs").arg(lib.join("libsysvalue.a")).arg(&obj).status().unwrap().success());
    fs::write(ld.join("from-sys.ld"), "SECTIONS { .from_sys : { BYTE(42) } } INSERT AFTER .text;\n").unwrap();
    println!("cargo:rustc-link-search=native={}", lib.display());
    println!("cargo:rustc-link-lib=static=sysvalue");
    println!("cargo:rustc-link-search={}", ld.display());
}
RS

cat > "$dir/app/Cargo.toml" <<'TOML'
[package]
name = "app"
version = "0.1.0"
edition = "2021"

[lib]
path = "src/lib.rs"

[[bin]]
name = "app"
path = "src/main.rs"

[dependencies]
sys = { path = "../sys" }
TOML
echo 'pub fn app_value() -> i32 { sys::value() }' > "$dir/app/src/lib.rs"
echo 'fn main() { println!("value {}", app::app_value()); }' > "$dir/app/src/main.rs"
cat > "$dir/app/build.rs" <<'RS'
use std::fs;
use std::path::PathBuf;

fn main() {
    let out = PathBuf::from(std::env::var("OUT_DIR").unwrap());
    fs::write(out.join("from-app.ld"), "SECTIONS { .from_app : { BYTE(42) } } INSERT AFTER .text;\n").unwrap();
    println!("cargo:rustc-link-search={}", out.display());
    println!("cargo:rustc-link-arg-bins=-Tfrom-app.ld");
    println!("cargo:rustc-link-arg-bins=-Tfrom-sys.ld");
}
RS

(cd "$dir" && git init -q . && git add -A)
echo "link-search ($cargo)"

log=$(cd "$dir" && CARGO_BACKEND=nix "$cargo" build 2>&1)
if [ $? -eq 0 ]; then
  ok "builds: -l from OUT_DIR/lib, -T from OUT_DIR and from a dependent's OUT_DIR/ld"
  out=$("$dir/target/debug/app" 2>&1)
  if [ "$out" = "value 42" ]; then ok "runs: $out"; else fail "runs" "$out"; fi
  sections=$(nix shell nixpkgs#binutils -c readelf -S "$dir/target/debug/app" 2>&1)
  for s in .from_app .from_sys; do
    if grep -q "$s" <<< "$sections"; then ok "linker script applied: $s"; else fail "linker script applied: $s" "not in the binary"; fi
  done
else
  fail "build" "$(grep -v -E '^ +(Compiling|Planning|Status)' <<< "$log" | tail -12)"
fi

# only the bin target gets rustc-link-arg-bins
derivations="$dir/target/debug/nix/derivations"
if [ -n "$(grep -l 'rustc-link-arg-bins' "$derivations"/app-0.1.0-bin-*.nix 2>/dev/null)" ]; then ok "bin target reads rustc-link-arg-bins"
else fail "bin target reads rustc-link-arg-bins"; fi
if [ -z "$(grep -l 'rustc-link-arg-bins' "$derivations"/app-0.1.0-lib-*.nix "$derivations"/deps/*.nix 2>/dev/null)" ]; then ok "lib targets don't"
else fail "lib targets don't"; fi

[ -n "${KEEP:-}" ] || rm -rf "$dir"
[ $failed -eq 0 ] && echo "link-search: ok" || { echo "link-search: FAILED"; exit 1; }
