# A unit is dirty when a unit it depends on is dirty: a macro of lib could change which files app reads.
BIN=app
step "first build"                               0 "app (bin),lib" "hi"
echo 'pub fn greeting() -> &'"'"'static str { "hello" }' > lib/src/lib.rs
step "lib edited: lib and app"                   0 "app (bin),lib" "hello"
echo 'fn main() { println!("{}!", lib::greeting()); }' > app/src/main.rs
step "app edited: app, and lib gets its list"    0 "app (bin),lib" "hello!" "lib-0_1_0-[0-9a-f]+ would be rebuilt: building with the files rustc listed"
echo "x" > lib/unrelated.txt
step "a new file nothing reads: app's list"      0 "app (bin)"     "hello!"
echo "y" > lib/unrelated.txt
step "again: nothing"                            0 ""              "hello!"
