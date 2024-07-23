{
  description = "a flake to build libnix cargo";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    fenix.url   = "github:nix-community/fenix";
    flake-utils.url = "github:numtide/flake-utils";
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
          # 1_87_0_plus_v1_src
          cargo-libnix-1_87_0_plus_v1_src = builtins.fetchTarball {
            url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0%2Bv1/libnix-1.87.0+v1.tar.bz2";
            sha256 = "sha256:1pa5yg6i5rk0f50f0syv3ci0864ca3w9ch60rx2q6mp7fy86h086";
          };
          cargo-libnix-1_87_0_plus_v1 = (import (cargo-libnix-1_87_0_plus_v1_src + "/derivations/default.nix"){ 
            inherit project_root pkgs;
            external_crate_dependencies = import (cargo-libnix-1_87_0_plus_v1_src + "/Cargo.dependencies.nix") { inherit pkgs; };
            rustc = fenix.packages.${system}.stable.rustc;
            cargo = fenix.packages.${system}.stable.cargo;
          }).cargo-0_88_0-bin-b4cc6eeacb818d24;

          external_crate_dependencies = { envs = {}; deps = {}; } // (
            if builtins.pathExists ./Cargo.dependencies.nix
              then import ./Cargo.dependencies.nix { inherit pkgs; }
              else { });
          # most recent development    
          cargo-libnix = (import nix/derivations/default.nix {
            inherit project_root pkgs external_crate_dependencies;
            rustc = fenix.packages.${system}.stable.rustc;
            cargo = fenix.packages.${system}.stable.cargo;
           }).cargo-0_88_0-bin-b4cc6eeacb818d24;
        in
        with pkgs;
        rec {
          packages = { inherit cargo-libnix cargo-libnix-1_87_0_plus_v1; };
          devShells.default = mkShell {
            buildInputs = [
              # to build cargo with 'CARGO_BACKEND=legacy cargo build' 
              openssl
              pkg-config
              # git helper
              tig
              # the toolchain used
              fenix.packages.${system}.stable.rustc
              # your cargo compiler
              #fenix.packages.${system}.stable.cargo
              cargo-libnix-1_87_0_plus_v1
              #cargo-libnix
              # comfy tools
              fenix.packages.${system}.stable.rust-src
              fenix.packages.${system}.stable.rustfmt
              fenix.packages.${system}.stable.clippy
              # used by cargo (libnix)
              nix-prefetch-scripts
            ];
            shellHook = ''
              export CARGO_BACKEND=nix
            '';
          };
        }
      );
}
