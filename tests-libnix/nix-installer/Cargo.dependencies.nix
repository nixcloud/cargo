# the installer embeds a Determinate Nix tarball and determinate-nixd (its flake fetches them from FlakeHub):
# placeholders, relative to src/distribution.rs, so it builds and runs `--version`, but can't install
{ pkgs }:
{
    deps = {};
    envs = {
        "nix-installer" = {
            NIX_TARBALL_URL = "foo.tar.xz";
            DETERMINATE_NIX_TARBALL_PATH = "../README.md";
            DETERMINATE_NIXD_BINARY_PATH = "../README.md";
        };
    };
}
