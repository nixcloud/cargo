# symlinks (a file and a directory) to files outside of the crate: rustc lists the symlinks, the minimal src
# needs their targets too.
BIN=hello
step "first build"                   0 "hello (bin)" "data v1 more v1"
check "shared/data.txt is in the list" grep -q '"shared/data.txt"' target/debug/nix/src-lists/hello-0_1_0-bin-*.json
check "shared/dir/more.txt is in the list" grep -q '"shared/dir/more.txt"' target/debug/nix/src-lists/hello-0_1_0-bin-*.json
echo "data v2" > shared/data.txt
step "link target edited: once"      0 "hello (bin)" "data v2 more v1"
echo "more v2" > shared/dir/more.txt
step "target in a linked dir: once"  0 "hello (bin)" "data v2 more v2"
echo "still not read" > shared/notes.txt
step "notes.txt edited: the list"    0 "hello (bin)" "data v2 more v2"
echo "data v3" > shared/data.txt
step "link target edited again"      0 "hello (bin)" "data v3 more v2"
