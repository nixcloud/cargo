{ pkgs }:
with pkgs;
{
    deps = {
        "openssl-sys" = [ pkg-config openssl ];
        "libz-ng-sys" = [ cmake ];
    };
    envs = {};
}
