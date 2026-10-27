#!/usr/bin/env bash
# Tests of the file lists of the workspace's crates (nixcloud/cargo#3): each case in
# cases/<name> is a minimal workspace with a test.sh of steps. It is copied to target/src-lists-tests/<name>-<time>
# (a new name each run, so no store path of an earlier run is reused) and built step by step with
# `CARGO_BACKEND=nix cargo build`; each step checks which units compile (`Compiling X`): a dirty unit once, with all
# files; it gets its list the first time something else changes, which compiles it once more.
#
#   tests-libnix/src-lists/run.sh                          # all cases, with target/debug/cargo
#   CARGO=path/to/cargo tests-libnix/src-lists/run.sh readme proc-macro-untracked
#
# Run by hand, not in nix: it needs a nix-daemon and rustc on PATH (e.g. `nix develop`). Not in /tmp: the GC roots
# there aren't visible to the nix-daemon.
set -u
here=$(cd "$(dirname "$0")" && pwd)
repo=$(cd "$here/../.." && pwd)
cargo=$(readlink -f "${CARGO:-$repo/target/debug/cargo}")
out=$repo/target/src-lists-tests
mkdir -p "$out"

if [ $# -gt 0 ]; then cases=("$@"); else mapfile -t cases < <(ls "$here/cases"); fi

failed=0
# step <description> <exit: 0|1> <`Compiling` lines, sorted, comma separated> [<output of $BIN>] [<regex the log has to match>]
step() {
  local what=$1 rc_expected=$2 compiled_expected=$3 out_expected=${4:-} log_expected=${5:-}
  local log rc compiled bin_out="" ok=1
  log=$(CARGO_BACKEND=nix "$cargo" build 2>&1)
  rc=$?
  [ $rc -ne 0 ] && rc=1
  compiled=$(grep -o 'Compiling .*' <<<"$log" | sed 's/^Compiling //' | LC_ALL=C sort | paste -sd ',')
  [ "$rc" = "$rc_expected" ] || ok=0
  [ "$compiled" = "$compiled_expected" ] || ok=0
  if [ -n "$out_expected" ]; then
    bin_out=$("target/debug/$BIN" 2>&1)
    [ "$bin_out" = "$out_expected" ] || ok=0
  fi
  if [ -n "$log_expected" ] && ! grep -qE "$log_expected" <<<"$log"; then ok=0; fi
  if [ $ok = 1 ]; then
    echo "  ok   $what"
  else
    echo "  FAIL $what"
    echo "       exit $rc (expected $rc_expected)"
    echo "       compiled [$compiled] (expected [$compiled_expected])"
    [ -n "$out_expected" ] && echo "       $BIN printed '$bin_out' (expected '$out_expected')"
    [ -n "$log_expected" ] && echo "       log has to match: $log_expected"
    grep -v '^trace:\|nixcloud edition\|unofficial fork\|Support me\|Support you\|backend to build' <<<"$log" | sed 's/^/       | /'
    failed=1
  fi
}

# check <description> <command…>: a step that is a command, e.g. a grep in the file lists
check() {
  local what=$1; shift
  if "$@" >/dev/null 2>&1; then echo "  ok   $what"; else echo "  FAIL $what"; failed=1; fi
}

for c in "${cases[@]}"; do
  [ -f "$here/cases/$c/test.sh" ] || { echo "no case $c"; failed=1; continue; }
  echo "$c"
  rm -rf "$out/$c"-*
  dir="$out/$c-$(date +%s)"
  cp -r "$here/cases/$c" "$dir"
  rm "$dir/test.sh"
  BIN=""
  (cd "$dir" && { source "$here/cases/$c/test.sh"; exit $failed; })
  [ $? = 0 ] || failed=1
done

[ $failed = 0 ] && echo "all cases ok" || echo "some cases failed"
exit $failed
