{ pkgs }: 
with pkgs;
{
    deps = {
        "openssl-sys" = [ pkg-config openssl ];
    };
    envs = {};
}
