{
  description = "a flake to build cargo 1.89.0 with libnix backend";
  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-25.05";
    fenix.url        = "github:nix-community/fenix";
    build-parser.url = "github:nixcloud/cargo-build_script_build-parser";
  };
  outputs =
  { self, nixpkgs, flake-utils, fenix, build-parser } @ inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
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

          rustc = fenix.packages.${system}.stable.rustc;
          cargo = fenix.packages.${system}.stable.cargo;
          build_parser = build-parser.packages.${system}.default;
          
          project_root = ./.;
          cargo-libnix = (import nix/derivations/default.nix {
            inherit project_root pkgs external_crate_dependencies build_parser;
            rustc = fenix.packages.${system}.stable.rustc;
            cargo = fenix.packages.${system}.stable.cargo;
           }).cargo-0_88_0-bin-85e09d7d8299b1ad;
        in
        with pkgs;
        rec {
          packages = { inherit cargo-libnix; };

          devShells.default = mkShell {
            buildInputs = [
	            nix-output-monitor
              openssl
              pkg-config
              nushell
              tig
              fenix.packages.${system}.stable.rustc
              fenix.packages.${system}.stable.cargo
              fenix.packages.${system}.stable.rust-src
              fenix.packages.${system}.stable.rustfmt
              fenix.packages.${system}.stable.clippy
            ];
          };
        }
      );
}
