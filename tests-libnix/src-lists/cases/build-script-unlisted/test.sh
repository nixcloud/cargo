# A build script that reads a file it doesn't list (version.txt, only build.rs is listed): run with only the listed
# files, its output differs from the run with all files, so it keeps all files from then on. Content-addressed:
# compared before anything after the run is built, which keeps its outputs.
export CARGO_LIBNIX_CA=1
BIN=app
step "first build"                                 0 "app (bin),gen,gen (build.rs build),gen (build.rs run)" "v1"
echo x >> README.md
step "README edited: the run keeps all files"      0 "app (bin),gen,gen (build.rs build),gen (build.rs run),gen (build.rs run)" "v1" "gen-0_1_0-script_build_run-[0-9a-f]+ keeps all files: run with only the files its build script lists"
check "the run keeps all files" grep -q '"full"' $(ls target/debug/nix/src-lists/gen-0_1_0-script_build_run-*.json | grep -v output)
echo x >> README.md
step "README edited again: only the run"           0 "gen (build.rs run)" "v1"
echo v2 > gen/version.txt
step "version.txt edited: the run, gen and app"    0 "app (bin),gen,gen (build.rs run)" "v2"
step "no-op"                                       0 "" "v2"
