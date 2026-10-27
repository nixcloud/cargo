# The compile of a build script (build.rs build) gets a file list like any crate; its run (build.rs run) is out of
# scope: it and the package's crates keep all files and rebuild on any edit.
export CARGO_LIBNIX_CA=0   # without content-addressed runs (build-script-ca has them)
BIN=hello
step "first build"                               0 "hello (bin),hello (build.rs build),hello (build.rs run)" "hi"
check "build.rs, greeting.txt, build/helper.rs listed" bash -c 'f=$(ls target/debug/nix/src-lists/*script_build-*.json) && grep -q "\"build.rs\"" $f && grep -q "\"greeting.txt\"" $f && grep -q "\"build/helper.rs\"" $f'
echo "more" >> README.md
step "README edited: build.rs build gets its list" 0 "hello (bin),hello (build.rs build),hello (build.rs run)" "hi"
echo "more" >> README.md
step "README edited again: run and bin, not build" 0 "hello (bin),hello (build.rs run)" "hi"
echo hello > greeting.txt
step "greeting.txt (include_str!) edited"        0 "hello (bin),hello (build.rs build),hello (build.rs run)" "hello"
echo 'pub fn greeting(s: &str) -> String { format!("{s}!") }' > build/helper.rs
step "build/helper.rs (#[path] mod) edited"      0 "hello (bin),hello (build.rs build),hello (build.rs run)" "hello!"
step "no-op"                                     0 "" "hello!"
