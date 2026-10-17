# grok-build (xai-org/grok-build, main): system dependencies of the build scripts for cargo (libnix)
{ pkgs }:
with pkgs;
{
    deps = {
        "openssl-sys" = [ pkg-config openssl ];
        "libz-sys" = [ pkg-config zlib ];
        "libssh2-sys" = [ pkg-config openssl zlib ];
        "libgit2-sys" = [ pkg-config ];
        "aws-lc-sys" = [ cmake perl ];
        # proto codegen: bin/protoc is a DotSlash script that downloads protoc, which the sandbox can't
        "xai-grok-tools-api" = [ protobuf ];
    };
    envs = {
        "xai-grok-tools-api" = { "PROTOC" = "${protobuf}/bin/protoc"; };
        # release builds embed rg/fd binaries the build scripts download from GitHub releases (no network in the
        # sandbox); their offline overrides take nixpkgs' instead
        "xai-grok-shell" = { "GROK_SHELL_BUNDLE_RG_PATH" = "${ripgrep}/bin/rg"; };
        "xai-grok-tools" = {
            "GROK_TOOLS_BUNDLE_RG_PATH" = "${ripgrep}/bin/rg";
            "GROK_TOOLS_BUNDLE_FD_PATH" = "${fd}/bin/fd";
        };
    };
}
