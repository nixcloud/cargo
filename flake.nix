{
  description = "a flake to build libnix cargo";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    fenix.url   = "github:nix-community/fenix";
  };
  outputs =
  { self, nixpkgs, flake-utils, fenix } @ inputs:
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
          build_rs_libnix = pkgs.callPackage nix/build-rs-libnix/default.nix {
            inherit pkgs;
          };
          cargo-libnix = (import nix/derivations/default.nix {
            inherit project_root pkgs external_crate_dependencies build_rs_libnix;
            rustc = fenix.packages.${system}.stable.rustc;
            cargo = fenix.packages.${system}.stable.cargo;
           }).cargo-0_88_0-bin-25c525326f58ed30;
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
              cargo-libnix
              fenix.packages.${system}.stable.rust-src
              fenix.packages.${system}.stable.rustfmt
              fenix.packages.${system}.stable.clippy
            ];
          };
        }
      );
}
