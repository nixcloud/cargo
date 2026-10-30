# With content-addressed build script runs (nixcloud/cargo#20, needs ca-derivations in the daemon's nix.conf): only
# a new output of the run makes the crates after it rebuild (gen reads input.txt with std::fs, app depends on gen).
# The run prints no rerun-if-*, so it gets its package's directory (gen/) as its list: the README isn't in there.
# The README is in the src of gen too until the lists: gen and app would be rebuilt whatever the output of the run,
# cargo sees that in their drvs before building, so they compile once, with their lists.
export CARGO_LIBNIX_CA=1
BIN=app
step "first build"                              0 "app (bin),gen,gen (build.rs build),gen (build.rs run)" "one"
echo x >> README.md
step "README edited: the lists"                 0 "app (bin),gen,gen (build.rs build),gen (build.rs run)" "one"
echo x >> README.md
step "README edited again: nothing"             0 "" "one"
echo "// a comment" >> gen/build.rs
step "build.rs comment: build and run"          0 "gen (build.rs build),gen (build.rs run)" "one"
echo two > gen/input.txt
step "input.txt (new run output): gen and app"  0 "app (bin),gen,gen (build.rs build),gen (build.rs run)" "two" "the output of gen-0_1_0-script_build_run-[0-9a-f]+ changed"
step "no-op"                                    0 "" "two"
check "the run's output is recorded" bash -c 'grep -q "\"output\"" target/debug/nix/src-lists/gen-0_1_0-script_build_run-*.json'
