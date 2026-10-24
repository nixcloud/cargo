{ pkgs }:
with pkgs;
{
    deps = {
        "openssl-sys" = [ pkg-config openssl ];
        "cargo" = [ git ];
    };
    envs = {};
    project_src = {
        # cargo's build.rs runs `git log` for the commit hash and date of `cargo -vV`
        include = [ ".git" ];
        # generated nix build systems, no crate builds from them
        exclude = [ "nix" "nix_" "nix__" ];
    };
}
