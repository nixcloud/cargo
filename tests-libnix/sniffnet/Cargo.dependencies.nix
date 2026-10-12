{ pkgs }:
with pkgs;
{
    deps = {
        "alsa-sys" = [ pkg-config alsa-lib ];
        "sniffnet" = [ pkg-config libpcap ];
    };
    envs = {};
}
