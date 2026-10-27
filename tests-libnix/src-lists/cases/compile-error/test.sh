# A compile error is reported as usual; the unit stays dirty.
BIN=hello
step "first build"                0 "hello (bin)" "ok"
echo 'fn main() { println!("broken") ' > src/main.rs
step "syntax error: fails once"   1 "hello (bin)" "ok"  "unclosed delimiter"
echo 'fn main() { println!("fixed"); }' > src/main.rs
step "fixed: once"                0 "hello (bin)" "fixed"
