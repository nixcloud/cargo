# A build script run gets the files its build script lists (rerun-if-changed: a file, a directory), like cargo
# decides when to run it again; without content-addressed runs, the crates after it get lists too. README.md and
# gen/notes.txt are in no list: once the lists are there, editing them rebuilds nothing.
export CARGO_LIBNIX_CA=0
BIN=app
step "first build"                                 0 "app (bin),gen,gen (build.rs build),gen (build.rs run)" "one 1"
check "the run lists input.txt and assets" bash -c 'f=$(ls target/debug/nix/src-lists/gen-0_1_0-script_build_run-*.json) && grep -q "\"gen/input.txt\"" $f && grep -q "\"gen/assets\"" $f && grep -q "\"gen/assets/a.txt\"" $f && ! grep -q README $f'
echo x >> README.md
step "README edited: the lists"                    0 "app (bin),gen,gen (build.rs build),gen (build.rs run)" "one 1"
echo x >> README.md
step "README edited again: nothing"                0 "" "one 1"
echo x >> gen/notes.txt
step "notes.txt (not listed) edited: nothing"      0 "" "one 1"
echo two > gen/input.txt
step "input.txt edited: the run, gen and app"      0 "app (bin),gen,gen (build.rs run)" "two 1"
echo b > gen/assets/b.txt
step "a file added to assets: the run, gen and app" 0 "app (bin),gen,gen (build.rs run)" "two 2"
echo x >> README.md
step "README edited: the lists again"              0 "app (bin),gen,gen (build.rs run)" "two 2"
step "no-op"                                       0 "" "two 2"
