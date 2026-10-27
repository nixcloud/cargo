# The macro reads config.txt with std::fs: built with all files the first time; with its list (README added) app
# fails, so it keeps all files from then on.
BIN=app
step "first build"                                 0 "app (bin),embed"           "5"
echo "more" > README.md
step "README added: app fails, keeps all files"    0 "app (bin),app (bin),embed" "5" "app-0_1_0-bin-[0-9a-f]+ keeps all files: compiles with all files, but fails with only the files rustc listed"
check "app keeps all files" grep -q '"full"' target/debug/nix/src-lists/app-0_1_0-bin-*.json
echo "more" >> README.md
step "README edited: app (all files)"              0 "app (bin)"                 "5"
