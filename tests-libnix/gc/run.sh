#!/usr/bin/env bash
# Tests of the GC roots of nix mode builds (nixcloud/cargo#4): what a build no longer uses is deleted from the
# store, also what a failed build left behind and an old binary that was still running during the build (by the
# build after). Each step builds a small workspace (app, lib with a build script) with `CARGO_BACKEND=nix cargo
# build` and checks the store.
#
#   tests-libnix/gc/run.sh                     # with target/debug/cargo
#   CARGO=path/to/cargo tests-libnix/gc/run.sh
#   KEEP=1 tests-libnix/gc/run.sh              # leaves target/gc-tests/workspace-<pid> as it is
#
# Runs in target/gc-tests, not in /tmp: the nix-daemon can't see GC roots in a private /tmp, so nothing there
# would be rooted.
set -u
repo=$(cd "$(dirname "$0")/../.." && pwd)
cargo=$(readlink -f "${CARGO:-$repo/target/debug/cargo}")
dir="$repo/target/gc-tests/workspace-$$"
failed=0

ok() { echo "  ok   $1"; }
fail() { echo "  FAIL $1"; shift; for l in "$@"; do echo "       $l"; done; failed=1; }

build() {
  log=$(cd "$dir" && CARGO_BACKEND=nix "$cargo" build 2>&1)
  status=$?
}

# the store paths of the unit `$1` (app, lib) whatever their hash, without .drv files
outputs() {
  local drv
  drv=$(ls "$dir/target/debug/nix/derivations/" | grep -E "^$1-0\.1\.0-(bin-)?[0-9a-f]{16}\.nix$" | sed 's/\.nix$//; s/\./_/g')
  ls -d /nix/store/*-"$drv" 2>/dev/null
}
current() { readlink -f "$dir/target/debug/$1" | cut -d/ -f1-4; }
built_file() { cat "$dir"/target/debug/nix/gc/*/built 2>/dev/null; }

mkdir -p "$dir/app/src" "$dir/lib/src"
cat > "$dir/Cargo.toml" <<'EOF'
[workspace]
members = ["lib", "app"]
resolver = "2"
EOF
cat > "$dir/lib/Cargo.toml" <<'EOF'
[package]
name = "lib"
version = "0.1.0"
edition = "2021"
EOF
cat > "$dir/lib/build.rs" <<'EOF'
fn main() { println!("cargo:rustc-env=GREETING=hi"); }
EOF
echo 'pub fn greeting() -> &'"'"'static str { env!("GREETING") }' > "$dir/lib/src/lib.rs"
cat > "$dir/app/Cargo.toml" <<'EOF'
[package]
name = "app"
version = "0.1.0"
edition = "2021"

[dependencies]
lib = { path = "../lib" }
EOF
echo 'fn main() { println!("{}", lib::greeting()); }' > "$dir/app/src/main.rs"
(cd "$dir" && git init -q .)

# the outputs of units named app and lib (any project), not .drv files; only valid ones: a failed build of a
# resolved (content-addressed) derivation can leave its output directory behind unregistered, which only
# nix-collect-garbage removes
unit_paths() {
  ls -d /nix/store/*-app-0_1_0-* /nix/store/*-lib-0_1_0-* 2>/dev/null | grep -v -e '\.drv$' -e '\.lock$' |
    while read -r p; do nix-store -q --hash "$p" > /dev/null 2>&1 && echo "$p"; done | sort
}
before_run=$(unit_paths)

echo "gc ($cargo)"

build
if [ $status -eq 0 ] && [ "$("$dir/target/debug/app")" = hi ]; then ok "first build"; else fail "first build" "$log"; fi
list=$(readlink "$dir"/target/debug/nix/gc/*/retained-paths-units-crates-toolchain-deps)
if grep -q -- '-build-rs-libnix-cli-' "$list"; then ok "build-rs-libnix is retained"
else fail "build-rs-libnix is retained" "not in $list"; fi

# an old binary still running while the next build deletes it: deleted by the build after
old_app=$(current app)
tail -f "$old_app/bin/app" > /dev/null &
holder=$!
echo '// edit 1' >> "$dir/lib/src/lib.rs"
build
if [ $status -eq 0 ] && [ -e "$old_app" ] && built_file | grep -qx "$old_app"; then ok "a running binary stays, in built"
else fail "a running binary stays, in built" "exit $status, exists: $([ -e "$old_app" ] && echo yes || echo no)" "built: $(built_file)"; fi
kill $holder; wait $holder 2>/dev/null
build
if [ $status -eq 0 ] && [ ! -e "$old_app" ] && ! built_file | grep -qx "$old_app"; then ok "the build after deletes it"
else fail "the build after deletes it" "exit $status, exists: $([ -e "$old_app" ] && echo yes || echo no)" "built: $(built_file)"; fi

# a failed build: what it built is deleted after the next successful one
before=$(outputs lib)
echo '// edit 2' >> "$dir/lib/src/lib.rs"
cp "$dir/app/src/main.rs" "$dir/main.rs.ok"
echo 'fn broken() { let _x: u32 = "no"; }' >> "$dir/app/src/main.rs"
build
failed_lib=$(comm -13 <(echo "$before" | sort) <(outputs lib | sort))
if [ $status -ne 0 ] && [ -n "$failed_lib" ]; then ok "a failed build leaves a lib output"
else fail "a failed build leaves a lib output" "exit $status, new lib outputs: '$failed_lib'"; fi
cp "$dir/main.rs.ok" "$dir/app/src/main.rs"
echo '// edit 3' >> "$dir/lib/src/lib.rs"
build
left=$(for p in $failed_lib; do [ -e "$p" ] && echo "$p"; done)
if [ $status -eq 0 ] && [ -z "$left" ] && [ "$("$dir/target/debug/app")" = hi ]; then ok "the next build deletes it"
else fail "the next build deletes it" "exit $status, left: $left"; fi

# no-op: nothing is deleted, the current outputs stay rooted
app=$(current app)
build
roots=$(nix-store -q --roots "$app" 2>/dev/null | grep -c "$dir/target/debug/nix/gc/")
if [ $status -eq 0 ] && ! grep -q "Removed" <<< "$log" && [ "$roots" -ge 1 ]; then ok "no-op deletes nothing"
else fail "no-op deletes nothing" "exit $status, roots of $app: $roots" "$log"; fi
# nothing this run built is left but what the last build uses (unit hashes are the same in every run, so what
# was there before doesn't count): listed, or kept by the roots of this workspace. With keep-derivations, the
# output of a content-addressed run keeps the .drv that built it first, and that one its build script compile
used() { grep -qx "$1" "$list" || nix-store -q --roots "$1" 2>/dev/null | grep -q "$dir/target/"; }
list=$(readlink "$dir"/target/debug/nix/gc/*/retained-paths-units-crates-toolchain-deps)
left=$(comm -13 <(echo "$before_run") <(unit_paths) | while read -r p; do used "$p" || echo "$p"; done)
if [ -z "$left" ]; then ok "nothing left but what the build uses"
else fail "nothing left but what the build uses" $left; fi

# KEEP=1 leaves the workspace and its store paths for a look
if [ -z "${KEEP:-}" ]; then
  (cd "$dir" && CARGO_BACKEND=nix "$cargo" clean > /dev/null 2>&1)
  rm -rf "$dir"
fi
if [ $failed -eq 0 ]; then echo "all ok"; else echo "some checks failed"; exit 1; fi
