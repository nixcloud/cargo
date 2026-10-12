{ pkgs }:
with pkgs;
{
    deps = {
        "fuse-sys" = [ pkg-config fuse ];
    };
    envs = {};
}
