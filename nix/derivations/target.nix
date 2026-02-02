# generated from target.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, cargo-0_88_0-bin-85e09d7d8299b1ad }:

# pkgs.stdenv.mkDerivation rec {
#     name = "cargo-0_88_0-27e7993d9cf32df7";
#     #src=./.;
#     phases = "buildPhase";

#     buildPhase = ''
#       mkdir -p $out/bin
#       cp -r ${cargo-0_88_0-bin-85e09d7d8299b1ad}/bin/cargo $out/bin/
#     '';
# }

pkgs.writeShellScriptBin "create-symlinks" ''
  rm -f target/debug/cargo
  ln -s ${cargo-0_88_0-bin-85e09d7d8299b1ad}/bin/cargo target/debug/
''