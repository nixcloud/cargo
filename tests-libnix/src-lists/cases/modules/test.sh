# A new file can only be read through a changed listed file (mod, #[path], include_*!): no list misses it.
BIN=hello
step "first build"                     0 "hello (bin)" "one"
echo 'pub const NAME: &str = "two";' > src/extra.rs
step "extra.rs alone: the list"        0 "hello (bin)" "one"
printf 'mod extra;\nfn main() { println!("{}", extra::NAME); }\n' > src/main.rs
step "mod extra; added: once"          0 "hello (bin)" "two"
check "src/extra.rs is in the list" grep -q '"src/extra.rs"' target/debug/nix/src-lists/hello-0_1_0-bin-*.json
echo 'fn main() { println!("three"); }' > src/main.rs
rm src/extra.rs
step "module removed: once"            0 "hello (bin)" "three"
