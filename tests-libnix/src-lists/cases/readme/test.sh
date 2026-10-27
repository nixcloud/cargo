# A crate gets only the files rustc read: README.md isn't one of them. The first build is with all files; the
# first other change (README) gets the crate its list, after that README doesn't rebuild it.
BIN=hello
step "first build: once, with all files"     0 "hello (bin)" "hello"
step "no-op"                                  0 ""            "hello"
echo "more" >> README.md
step "README edited: once, with the list"    0 "hello (bin)" "hello" "would be rebuilt: building with the files rustc listed"
echo "more" >> README.md
step "README edited again: nothing"          0 ""            "hello"
echo 'fn main() { println!("hello v2"); }' > src/main.rs
step "main.rs edited: once, with all files"  0 "hello (bin)" "hello v2"
