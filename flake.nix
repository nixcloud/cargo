{
  description = "a flake to build libnix cargo";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
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
              fenix.overlays.default
            ];
          };
          rustc_1_87_vanilla_pin = (fenix.packages.${system}.toolchainOf {
            channel = "1.87.0";
            sha256 = "sha256-KUm16pHj+cRedf8vxs/Hd2YWxpOrWZ7UOrwhILdSJBU=";
          }).rustc;
          # 1_87_0_plus_v1_src
          cargo-libnix-1_87_0_plus_v1_src = builtins.fetchTarball {
            url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0%2Bv1/libnix-1.87.0+v1.tar.bz2";
            sha256 = "sha256:1pa5yg6i5rk0f50f0syv3ci0864ca3w9ch60rx2q6mp7fy86h086";
          };
          cargo-libnix-1_87_0_plus_v1 = (import (cargo-libnix-1_87_0_plus_v1_src + "/derivations/default.nix"){ 
            inherit project_root pkgs;
            external_crate_dependencies = import (cargo-libnix-1_87_0_plus_v1_src + "/Cargo.dependencies.nix") { inherit pkgs; };
            rustc = rustc_1_87_vanilla_pin;
            cargo = fenix.packages.${system}.stable.cargo;
          }).cargo-0_88_0-bin-b4cc6eeacb818d24;

          # external_crate_dependencies = { envs = {}; deps = {}; } // (
          #   if builtins.pathExists ./Cargo.dependencies.nix
          #     then import ./Cargo.dependencies.nix { inherit pkgs; }
          #     else { });
          # # the cargo binary unit of a generated build system; its hash isn't known in advance
          # cargoBin = units: units.${pkgs.lib.findFirst (n: pkgs.lib.hasPrefix "cargo-0_88_0-bin-" n)
          #   (throw "no cargo-0_88_0-bin-* unit in the generated build system") (builtins.attrNames units)};

          # # most recent development: bootstrap cargo from the build system committed in nix/
          # # (regenerate with `cargo build write-nix-buildsystem --out-dir nix` when the units change)
          # cargo-libnix = cargoBin (import nix/derivations/default.nix {
          #   inherit project_root pkgs external_crate_dependencies;
          #   rustc = rustc_1_87_vanilla_pin;
          #   cargo = fenix.packages.${system}.stable.cargo;
          # });

          # src = builtins.filterSource
          #   (path: type:
          #       let base = baseNameOf path;
          #       in !(base == "target" || base == "result" || builtins.match "result-*" base != null)
          #   ) project_root;
          # cargoVendor = pkgs.rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };
          # generated = pkgs.runCommand "cargo-nix-generated" { nativeBuildInputs = [ pkgs.openssl pkgs.pkg-config cargo-libnix rustc_1_87_vanilla_pin ]; } ''
          #   export HOME=$TMPDIR CARGO_BACKEND=nix
          #   cp -r ${src} project && chmod -R u+w project && cd project
          #   cat >> .cargo/config.toml <<EOF
          #   [source.crates-io]
          #   replace-with = "vendored-sources"
          #   [source.vendored-sources]
          #   directory = "${cargoVendor}"
          #   EOF
          #   ${cargo-libnix}/bin/cargo build --offline write-nix-buildsystem --out-dir $out
          # '';
          # libnix-master-via-ifd = cargoBin (import "${generated}/cargo_build_caller.nix" { inherit system; project_root = src; });
        in
        with pkgs;
        rec {
          packages = { inherit cargo-libnix-1_87_0_plus_v1; inherit rustc_1_87_vanilla_pin; };
          devShells.default = mkShell {
            buildInputs = [
              # rust toolchain
              rustc_1_87_vanilla_pin
              cargo-libnix-1_87_0_plus_v1
              #libnix-master-via-ifd
              # used by cargo (libnix)
              nix-prefetch-scripts
              # comfy tools
              fenix.packages.${system}.stable.rust-src
              fenix.packages.${system}.stable.rustfmt
              fenix.packages.${system}.stable.clippy
            ];
            shellHook = ''
              export CARGO_BACKEND=nix
            '';
          };
        }
      );
}
