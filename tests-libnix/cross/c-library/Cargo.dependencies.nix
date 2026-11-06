# the build script of hello-c-sys compiles c/hello.c with clang for the --target and archives it with llvm-ar;
# unwrapped, so nothing of the host (its glibc, hardening flags) is added. Only the two binaries, in a derivation of
# their own: cargo roots every output of the deps here, and clang's include its debug output (gigabytes)
{ pkgs }:
let
  inherit (pkgs.llvmPackages) clang-unwrapped llvm;
  tools = pkgs.runCommand "hello-c-tools" { } ''
    mkdir -p $out/bin
    ln -s ${clang-unwrapped}/bin/clang ${llvm}/bin/llvm-ar $out/bin/
  '';
in
{
  deps = {
    "hello-c-sys" = [ tools ];
  };
  envs = {};
}
