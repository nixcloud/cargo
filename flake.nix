# please read flake introduction here:
# https://fasterthanli.me/series/building-a-rust-service-with-nix/part-10#a-flake-with-a-dev-shell
{
  description = "The klick project flake";
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
          trunk = pkgs.callPackage ./trunk.nix {
            inherit (darwin.apple_sdk.frameworks) CoreServices Security SystemConfiguration;
          };
          devShells.default = mkShell {
            buildInputs = [
nushell
              zig
              rust
              cargo-zigbuild           # required for static musl builds
              trunk                    # required to bundle the frontend
              binaryen                 # required to minify WASM files with wasm-opt
              wasm-bindgen-cli         # required to generate JS files to bootstrap WASM in the browser
              wasm-pack                # required to run wasm-bindgen-tests
              git
              tig
              pkg-config
              just                     # task runner
              tailwindcss              # build CSS files
              nodejs                   # required to install tailwind plugins
              pandoc                   # required to process markdown files
              texliveMedium            # required to generate PDF reports
              librsvg                  # required to render SVG image
              openssl                  # required for cargo-edit
              firefox                  # required by wasm-bindgen-test
            ] ++ platform_packages;
          };
        }
      );
}
