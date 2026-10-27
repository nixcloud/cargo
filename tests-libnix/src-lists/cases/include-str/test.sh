# include_str! files are in the .d, other files of the package aren't.
BIN=hello
step "first build"                      0 "hello (bin)" "data v1"
echo "data v2" > data.txt
step "data.txt edited: once"            0 "hello (bin)" "data v2"
echo "still not read" > notes.txt
step "notes.txt edited: the list"       0 "hello (bin)" "data v2"
echo "still not read!" > notes.txt
step "notes.txt edited again: nothing"  0 ""            "data v2"
