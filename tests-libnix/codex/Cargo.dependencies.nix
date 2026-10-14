# onig_sys 69.8.1 bundles oniguruma 6.9.8, which doesn't compile as C23 (GCC 15's default): link nixpkgs' oniguruma
{ pkgs }:
with pkgs;
{
    deps = {
        "openssl-sys" = [ pkg-config openssl ];
        "onig_sys" = [ pkg-config oniguruma ];
    };
    envs = {
        "onig_sys" = { "RUSTONIG_SYSTEM_LIBONIG" = "1"; };
    };
}
