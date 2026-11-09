#!/usr/bin/env bash
# Tests of the `[env]` table of .cargo/config.toml in nix mode: a build script reads a file through a variable with
# `relative = true`, which cargo makes an absolute path of this machine, and passes its content to the crate.
# The path must be readable in the sandbox, a changed file must arrive in the binary, and the path of the checkout
# must not end up in the derivations.
#
#   tests-libnix/env/run.sh                     # with target/debug/cargo
#   CARGO=path/to/cargo tests-libnix/env/run.sh
#   KEEP=1 tests-libnix/env/run.sh              # leaves target/env-tests/workspace-<pid>
#
# Without a rustc in PATH the flake's rustc_<version>_vanilla_pin of this cargo's version is used. Runs in
# target/env-tests, not in /tmp: the nix-daemon can't see GC roots in a private /tmp.
set -u
repo=$(cd "$(dirname "$0")/../.." && pwd)
cargo=$(readlink -f "${CARGO:-$repo/target/debug/cargo}")
dir="$repo/target/env-tests/workspace-$$"
failed=0

ok() { echo "  ok    $1"; }
fail() { echo "  FAIL  $1"; shift; for l in "$@"; do echo "        $l"; done; failed=1; }

if ! command -v rustc > /dev/null; then
  version=$("$cargo" -V | awk '{print $2}' | cut -d. -f1,2 | tr . _)
  rustc_out=$(nix build --no-link --print-out-paths "$repo#rustc_${version}_vanilla_pin") || exit 1
  export PATH="$rustc_out/bin:$PATH"
fi

mkdir -p "$dir/.cargo" "$dir/conf" "$dir/reader/src" "$dir/app/src"
cat > "$dir/.cargo/config.toml" <<'TOML'
[env]
PLAIN_VALUE = "plain"
CONF_FILE = { value = "conf/value.txt", relative = true }
MISSING_FILE = { value = "conf/missing.txt", relative = true }
TOML
echo one > "$dir/conf/value.txt"
cat > "$dir/Cargo.toml" <<'TOML'
[workspace]
members = ["reader", "app"]
resolver = "2"
TOML
cat > "$dir/reader/Cargo.toml" <<'TOML'
[package]
name = "reader"
version = "0.1.0"
edition = "2021"
TOML
echo 'pub const VALUE: &str = env!("CONF_VALUE");' > "$dir/reader/src/lib.rs"
cat > "$dir/reader/build.rs" <<'RS'
fn main() {
    let path = std::env::var("CONF_FILE").unwrap();
    let value = std::fs::read_to_string(&path).unwrap_or_else(|e| panic!("{path}: {e}"));
    println!("cargo:rustc-env=CONF_VALUE={}", value.trim());
    println!("cargo:rerun-if-env-changed=CONF_FILE");
    println!("cargo:rerun-if-changed={path}");
}
RS
cat > "$dir/app/Cargo.toml" <<'TOML'
[package]
name = "app"
version = "0.1.0"
edition = "2021"

[dependencies]
reader = { path = "../reader" }
TOML
echo 'fn main() { println!("{} {}", reader::VALUE, env!("PLAIN_VALUE")); }' > "$dir/app/src/main.rs"

(cd "$dir" && git init -q . && git add -A)
echo "env ($cargo)"

build() { log=$(cd "$dir" && CARGO_BACKEND=nix "$cargo" build 2>&1); }

if build; then
  ok "builds: relative = true reaches the build script"
  out=$("$dir/target/debug/app" 2>&1)
  if [ "$out" = "one plain" ]; then ok "runs: $out"; else fail "runs" "$out"; fi
  if grep -q 'MISSING_FILE' <<< "$log"; then ok "warns about a path it can't provide"; else fail "warns about a path it can't provide"; fi
  if grep -rlF "CONF_FILE = \"$dir" "$dir/target/debug/nix/derivations" > /dev/null; then fail "the checkout's path in the derivations"
  else ok "no path of the checkout in CONF_FILE"; fi

  echo two > "$dir/conf/value.txt"
  if build; then
    out=$("$dir/target/debug/app" 2>&1)
    if [ "$out" = "two plain" ]; then ok "a changed file is rebuilt: $out"; else fail "a changed file is rebuilt" "$out"; fi
  else
    fail "build after the change" "$(tail -8 <<< "$log")"
  fi
else
  fail "build" "$(grep -v -E '^ +(Compiling|Planning|Status)' <<< "$log" | tail -12)"
fi

[ -n "${KEEP:-}" ] || rm -rf "$dir"
[ $failed -eq 0 ] && echo "env: ok" || { echo "env: FAILED"; exit 1; }
