
# generated from cargo_build_caller.nix.handlebars using cargo (manual edits won't be persistent)
{ system ? builtins.currentSystem }:
let
  nixpkgsSrc = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/25.05.tar.gz";
    sha256 = "sha256:1915r28xc4znrh2vf4rrjnxldw2imysz819gzhk9qlrkqanmfsxd";
  };
  pkgs = import (nixpkgsSrc + "/pkgs/top-level/default.nix") {
    localSystem = { inherit system; };
  };
  build_parser_sources = pkgs.fetchFromGitHub {
    owner = "nixcloud";
    repo = "cargo-build_script_build-parser";
    rev = "96be633fe91c960955af2edfdaa5720345b7948f";
    sha256 = "sha256-5O5EfOcN4DG4tpcZDMvz47+USxaUZ+f+a3OsOlFJuuc=";
  };
  build_parser = pkgs.callPackage build_parser_sources {};
  fenixSrc = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "fenix";
    rev = "6ed03ef4c8ec36d193c18e06b9ecddde78fb7e42";
    sha256 = "sha256-tl/0cnsqB/Yt7DbaGMel2RLa7QG5elA8lkaOXli6VdY=";
  };
  fenix = import fenixSrc {};
  external_crate_dependencies =
    (if builtins.pathExists ./Cargo.dependencies.nix
    then builtins.trace "Using Cargo.dependencies.nix"
         import ./Cargo.dependencies.nix { inherit pkgs; }
    else builtins.trace "No Cargo.dependencies.nix found"
         { deps = {}; envs = {}; });
  toolchain = fenix.stable.toolchain;
  rustc = toolchain;
  cargo = toolchain;
  project_root = ./.;
  cargo-libnix = (import nix/derivations/default.nix {
             inherit project_root pkgs external_crate_dependencies build_parser;
             inherit rustc cargo;
            }).cargo-0_88_0-bin-fda93888b53983bf;
in

  pkgs.stdenv.mkDerivation {
    name = "write-nix-buildsystem";
    src = builtins.filterSource
      (path: type:
          let base = baseNameOf path;
          in !(base == "target" || base == "result" || builtins.match "result-*" base != null)
      ) /home/nixos/cargo;
    buildInputs = [ cargo-libnix rustc];
    phases = "unpackPhase buildPhase";
    buildPhase = ''
      mkdir -p $out/
      CARGO_BACKEND=nix ${cargo-libnix}/bin/cargo build --frozen --offline write-nix-buildsystem --out-dir $out/nix --url https://github.com/nixcloud/cargo/archive/refs/tags/1.83-test-release.tar.gz --hash 1h5j1kl7q7mysa943gvd4c8ih8yxx4igqrx4akv9ixf4zf411b8l
    '';

}
