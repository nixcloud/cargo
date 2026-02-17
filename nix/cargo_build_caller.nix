# generated from cargo_build_caller.nix.handlebars using cargo (manual edits won't be persistent)
{ system ? builtins.currentSystem }:
let
  project_root = ../.;
  nixpkgsSrc = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/25.05.tar.gz";
    sha256 = "sha256:1915r28xc4znrh2vf4rrjnxldw2imysz819gzhk9qlrkqanmfsxd";
  };
  pkgs = import (nixpkgsSrc + "/pkgs/top-level/default.nix") {
    localSystem = { inherit system; };
  };
  fenixSrc = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "fenix";
    rev = "6ed03ef4c8ec36d193c18e06b9ecddde78fb7e42";
    sha256 = "sha256-tl/0cnsqB/Yt7DbaGMel2RLa7QG5elA8lkaOXli6VdY=";
  };
  fenix = import fenixSrc {};
  external_crate_dependencies =
    (if builtins.pathExists ../Cargo.dependencies.nix
    then builtins.trace "Using Cargo.dependencies.nix"
         import ../Cargo.dependencies.nix { inherit pkgs; }
    else builtins.trace "No Cargo.dependencies.nix found"
         { deps = {}; });
  build_rs_libnix = pkgs.callPackage build-rs-libnix/default.nix {
    inherit pkgs;
  };
  toolchain = fenix.stable.toolchain;
  cargoPackages = import ./derivations/default.nix {
    inherit pkgs external_crate_dependencies build_rs_libnix project_root;
    rustc = toolchain;
    cargo = toolchain;
  };
in
cargoPackages