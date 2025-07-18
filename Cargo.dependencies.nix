{ pkgs }: 
with pkgs;
{
    deps = {
        "openssl-sys" = [ pkg-config openssl ];
#        "curl-sys" = [ pkg-config curl ]; # optional, but works with bundled version also
    };
}
