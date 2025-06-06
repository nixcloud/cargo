{
  description = "The cargo project flake";
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs =
  { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ (import rust-overlay) ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };
          rust = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
          platform_packages =
            if pkgs.stdenv.isLinux then
              with pkgs; [ ]
            else if pkgs.stdenv.isDarwin then
              with pkgs.darwin.apple_sdk.frameworks; [
                CoreFoundation
                Security
                SystemConfiguration
              ]
            else
              throw "unsupported platform";
        in
        with pkgs;
        rec {
          devShells.default = mkShell {
            buildInputs = [
              openssl
              pkg-config
              nushell
              rust-bin.stable."1.87.0".default
            ] ++ platform_packages;
          };
        }
      );
}
