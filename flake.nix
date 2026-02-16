{
  description = "a flake to build libnix cargo";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    fenix.url   = "github:nix-community/fenix";
    build-parser.url = "github:nixcloud/cargo-build_script_build-parser";
  };
  outputs =
  { self, nixpkgs, flake-utils, fenix, build-parser } @ inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          project_root = ./.;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              fenix.overlay
            ];
          };
          lib = pkgs.lib;
          external_crate_dependencies =
            if builtins.pathExists ./Cargo.dependencies.nix
              then import ./Cargo.dependencies.nix { inherit pkgs; }
              else { deps = {}; };
          build_parser = pkgs.callPackage ./build-rs-libnix.nix {
            inherit project_root;
          };
          cargo-libnix = (import nix/derivations/default.nix {
            inherit project_root pkgs external_crate_dependencies build_parser;
            rustc = fenix.packages.${system}.stable.rustc;
            cargo = fenix.packages.${system}.stable.cargo;
           }).cargo-0_88_0-bin-fda93888b53983bf;
        in
        with pkgs;
        rec {
          packages = { inherit cargo-libnix; };
          devShells.default = mkShell {
            buildInputs = [
              # to build cargo with 'cargo build'
              openssl
              pkg-config
              # git helper
              tig
              # the toolchain used
              fenix.packages.${system}.stable.rustc
              #fenix.packages.${system}.stable.cargo
              #cargo-libnix
              build_parser
              fenix.packages.${system}.stable.rust-src
              fenix.packages.${system}.stable.rustfmt
              fenix.packages.${system}.stable.clippy
            ];
          };
        }
      );
}
