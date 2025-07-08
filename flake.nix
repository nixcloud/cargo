{
  description = "The cargo project flake";
  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    build-parser.url = "github:nixcloud/cargo-build_script_build-parser";
  };
  outputs =
  { self, nixpkgs, flake-utils, rust-overlay, build-parser }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ (import rust-overlay) build-parser.overlay ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };
          allPackages = import nix/default.nix { inherit pkgs; };
        in
        with pkgs;
        rec {
          packages = allPackages // {
            inherit defaultPackage;
          };
          devShells.default = mkShell {
            buildInputs = [
              openssl
              pkg-config
              nushell
              rust-bin.stable."1.87.0".default
            ];
          };
        }
      );
}
