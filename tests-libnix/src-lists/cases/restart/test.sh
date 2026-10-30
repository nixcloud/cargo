# An env var from Cargo.dependencies.nix changes the derivation, not the files: the crate, still on all files,
# gets its list (the comparison is skipped: more than the src changed). After that the env rebuilds it with its list.
BIN=hello
step "first build"                                     0 "hello (bin)" "hello"
echo '{ pkgs }: { deps = {}; envs = { hello = { LIBNIX_TEST = "1"; }; }; }' > Cargo.dependencies.nix
step "Cargo.dependencies.nix: the list"                0 "hello (bin)" "hello" "would be rebuilt: building with their file lists"
step "no-op"                                           0 ""            "hello"
echo '{ pkgs }: { deps = {}; envs = { hello = { LIBNIX_TEST = "2"; }; }; }' > Cargo.dependencies.nix
step "Cargo.dependencies.nix again: once, with the list" 0 "hello (bin)" "hello"
