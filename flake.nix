{
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs =
  { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ rust-overlay.overlays.default ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };
          rust = pkgs.rust-bin.stable.latest.default;
        in
        with pkgs;
        rec {
          devShells.default = mkShell {
            buildInputs = [
              rust
              git
              pkg-config
              openssl
              nixVersions.latest
              rustPlatform.bindgenHook
            ];
          };
        }
      );
}
