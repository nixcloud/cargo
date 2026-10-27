# The untracked macro again, but app opts out: it always gets all files, so it rebuilds on every edit.
BIN=app
step "first build"                                 0 "app (bin),embed" "5"
step "no-op"                                       0 ""                "5"
echo "more" > README.md
step "README added: app, and embed's list"         0 "app (bin),embed" "5"
echo "more" >> README.md
step "README edited: app rebuilds (all files)"     0 "app (bin)"       "5"
