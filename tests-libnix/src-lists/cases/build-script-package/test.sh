# A build script that prints no rerun-if-*: its run gets its package's directory (gen/), like cargo runs it again
# when a file of its package changes. README.md at the workspace root isn't in there, gen/notes.txt is.
export CARGO_LIBNIX_CA=0
BIN=app
step "first build"                                 0 "app (bin),gen,gen (build.rs build),gen (build.rs run)" "one"
echo x >> README.md
step "README edited: the lists"                    0 "app (bin),gen,gen (build.rs build),gen (build.rs run)" "one"
echo x >> README.md
step "README edited again: nothing"                0 "" "one"
echo x >> gen/notes.txt
step "notes.txt (in the package) edited: the run"  0 "app (bin),gen,gen (build.rs run)" "one"
echo x >> README.md
step "README edited: the lists again"              0 "app (bin),gen,gen (build.rs run)" "one"
step "no-op"                                       0 "" "one"
