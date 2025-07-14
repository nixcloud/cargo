{ pkgs }: 
with pkgs;
{
    deps = {
        "openssl-sys" = [ pkg-config openssl ];
        "curl-sys" = [ pkg-config curl ]; # this is a hack, it should use the bundled version
    };
}
