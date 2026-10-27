# The macro emits include_bytes!: config.txt is in the list, the minimal src has it.
BIN=app
step "first build"                                   0 "app (bin),embed" "5"
echo "seven!" > app/config.txt
step "config.txt edited: app, and embed's list"      0 "app (bin),embed" "7"
check "app/config.txt is in the list" grep -q '"app/config.txt"' target/debug/nix/src-lists/app-0_1_0-bin-*.json
echo "eight!!" > app/config.txt
step "config.txt edited again: app"                  0 "app (bin)"       "8"
