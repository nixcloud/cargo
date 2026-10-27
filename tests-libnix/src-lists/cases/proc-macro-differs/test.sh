# Without config.txt the macro gives 0usize. Built with all files the first time it is 5; when it gets its list
# (README added), the output differs from the one with all files: app keeps all files from then on.
BIN=app
step "first build"                                 0 "app (bin),embed"           "5"
echo "more" > README.md
step "README added: app differs, keeps all files"  0 "app (bin),app (bin),embed" "5" "app-0_1_0-bin-[0-9a-f]+ keeps all files: built with only the files rustc listed, it differs"
check "app keeps all files" grep -q '"full"' target/debug/nix/src-lists/app-0_1_0-bin-*.json
echo "more" >> README.md
step "README edited: app (all files)"              0 "app (bin)"                 "5"
