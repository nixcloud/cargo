# The compile of a build script (build.rs build) gets a file list like any crate. Its run (build.rs run) prints no
# rerun-if-*, so it reruns on any change of its package, the whole workspace: it and the crates after it keep all
# files, until the build script prints rerun-if-changed (checked again whenever the run is built).
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
cat > build.rs <<'RS'
#[path = "build/helper.rs"]
mod helper;
fn main() {
    for f in ["build.rs", "greeting.txt", "build/helper.rs"] {
        println!("cargo:rerun-if-changed={f}");
    }
    println!("cargo:rustc-env=GREETING={}", helper::greeting(include_str!("greeting.txt").trim()));
}
RS
step "build.rs prints rerun-if-changed"          0 "hello (bin),hello (build.rs build),hello (build.rs run)" "hello!"
check "the run has a list now" bash -c '! grep -q "\"full\"" target/debug/nix/src-lists/*script_build_run-*.json'
echo "more" >> README.md
step "README edited: run and bin get lists"     0 "hello (bin),hello (build.rs build),hello (build.rs run)" "hello!"
echo "more" >> README.md
step "README edited again: nothing"              0 "" "hello!"
