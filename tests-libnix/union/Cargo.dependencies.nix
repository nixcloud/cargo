# tikv-jemalloc-sys 0.5.4 bundles jemalloc 5.3.0, whose strerror_r use fails with GCC >= 14 (-Wint-conversion is an error)
{ pkgs }:
with pkgs;
{
    deps = {
        "openssl-sys" = [ pkg-config openssl ];
    };
    envs = {
        "tikv-jemalloc-sys" = { "CFLAGS" = "-Wno-error=int-conversion"; };
    };
}
