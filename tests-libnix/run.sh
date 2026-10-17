#!/usr/bin/env bash
# Regression tests (nixcloud/cargo#18): builds the projects of test.nix one by one with the cargo (libnix) of this
# checkout, keeps a log each and writes a summary.
#
#   tests-libnix/run.sh                 # all projects
#   tests-libnix/run.sh fd ripgrep      # some
#
# Logs, result links and RESULTS.md go to target/tests (OUT_DIR overrides it).
set -u
cd "$(dirname "$0")/.."
out=${OUT_DIR:-target/tests}
mkdir -p "$out"

if [ $# -gt 0 ]; then
  projects=("$@")
else
  mapfile -t projects < <(nix eval --impure --json --expr 'builtins.attrNames (import ./test.nix {}).projects' | jq -r '.[]')
fi

# result and details of a project from its log and smoke test output
classify() {
  local p=$1 log=$2 rc=$3
  if [ "$rc" = 0 ]; then
    echo "ok"
    sed 's/^ok //' "$out/$p-smoke/smoke.txt" | paste -sd ';' | sed 's/;/; /g'
  elif grep -q "is not supported by the following package" "$log"; then
    echo "needs newer rustc"
    grep -o "requires rustc [0-9.]*" "$log" | awk '{print $3}' | sort -uV | tail -1 | sed 's/^/rustc /'
  elif grep -q "^ *error: Cannot build '.*-cargo-nix-generated-" "$log"; then
    # (during evaluation: IFD)
    echo "generation failed"
    grep -m1 "^       > error" "$log" | sed 's/^ *> //'
  elif grep -q "^error: Cannot build '.*-cargo-libnix-smoke-" "$log" && ! grep -q "dependenc.* failed" <(grep -A1 "^error: Cannot build '.*-cargo-libnix-smoke-" "$log"); then
    echo "binary failed"
    grep "FAILED" "$log" | head -1 | sed 's/^ *> //'
  elif grep -q "^error: Cannot build" "$log"; then
    echo "build failed"
    # the first unit that failed by itself, and its first error
    local drv
    drv=$(grep -A1 "^error: Cannot build" "$log" | grep -B1 "builder failed" | grep -o "[a-z0-9]\{32\}-[^']*\.drv" | head -1)
    echo "${drv#*-}: $(grep -m1 "^error\(\[E[0-9]*\]\)\?: " "$log" | grep -v "Cannot build\|^error:$")"
  else
    echo "evaluation failed"
    grep "^ *error: " "$log" | tail -1 | sed 's/^ *//'
  fi
}

declare -A result details
for p in "${projects[@]}"; do
  log="$out/$p.log"
  start=$(date +%s)
  printf '%-16s ' "$p"
  nix-build test.nix -A "$p.smoke" -o "$out/$p-smoke" --keep-going > "$log" 2>&1
  rc=$?
  echo "exit=$rc" >> "$log"
  mapfile -t c < <(classify "$p" "$log" "$rc")
  result[$p]=${c[0]}
  details[$p]=${c[1]:-}
  echo "${result[$p]} ($(( $(date +%s) - start ))s) ${details[$p]}"
done

# summary of all projects that have a log, not only the ones of this run
{
  echo "# cargo (libnix) regression tests"
  echo
  rustc=$(nix eval --impure --raw --expr '(builtins.getFlake "git+file://${toString ./.}").packages.${builtins.currentSystem}.rustc_1_99_nix_ld.name' 2>/dev/null)
  echo "$(date -u '+%Y-%m-%d %H:%M UTC'), cargo (libnix) $(git rev-parse --short HEAD)$(git diff --quiet HEAD -- || echo ' with uncommitted changes'), $rustc"
  echo
  echo "| project | revision | result | details |"
  echo "|---|---|---|---|"
  nix eval --impure --json --expr 'builtins.mapAttrs (n: p: "${p.owner}/${p.repo} ${builtins.substring 0 8 p.rev}") (import ./test.nix {}).projects' \
    | jq -r 'to_entries[] | "\(.key) \(.value)"' | while read -r p repo rev; do
      log="$out/$p.log"
      [ -f "$log" ] || continue
      if [ -n "${result[$p]:-}" ]; then
        r=${result[$p]} d=${details[$p]}
      else
        rc=$(sed -n 's/^exit=//p' "$log" | tail -1)
        mapfile -t c < <(classify "$p" "$log" "${rc:-1}")
        r=${c[0]} d=${c[1]:-}
      fi
      echo "| [$p](https://github.com/$repo/tree/$rev) | \`$rev\` | $r | ${d//|/\\|} |"
    done
} > "$out/RESULTS.md"
echo
echo "$out/RESULTS.md"
