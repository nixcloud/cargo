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
          cargo_1_87_vanilla_pin = (fenix.packages.${system}.toolchainOf {
            channel = "1.87.0";
            sha256 = "sha256-KUm16pHj+cRedf8vxs/Hd2YWxpOrWZ7UOrwhILdSJBU=";
          }).cargo;
          # 1_87_0_plus_v1_src
          cargo-libnix-1_87_0_plus_v1_src = builtins.fetchTarball {
            url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0%2Bv1/libnix-1.87.0+v1.tar.bz2";
            sha256 = "sha256:1pa5yg6i5rk0f50f0syv3ci0864ca3w9ch60rx2q6mp7fy86h086";
          };
          cargo-libnix-1_87_0_plus_v1 = (import (cargo-libnix-1_87_0_plus_v1_src + "/derivations/default.nix"){ 
            inherit project_root pkgs;
            external_crate_dependencies = import (cargo-libnix-1_87_0_plus_v1_src + "/Cargo.dependencies.nix") { inherit pkgs; };
            rustc = rustc_1_87_vanilla_pin;
            cargo = cargo_1_87_vanilla_pin;
          }).cargo-0_88_0-bin-b4cc6eeacb818d24;

          cargo-libnix-1_87_0_plus_v2_src = builtins.fetchTarball {
            url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0%2Bv2/libnix-1.87.0+v2-release.tar.bz2";
            sha256 = "sha256:1w3hksx45jdr11l1ccs8i34h98ll5pf9ldc3mdv7sp94p7zs9168";
          };
          cargo-libnix-1_87_0_plus_v2 = (import (cargo-libnix-1_87_0_plus_v2_src + "/derivations/default.nix"){ 
            inherit project_root pkgs;
            external_crate_dependencies = import (cargo-libnix-1_87_0_plus_v2_src + "/Cargo.dependencies.nix") { inherit pkgs; };
            rustc = rustc_1_87_vanilla_pin;
            cargo = cargo_1_87_vanilla_pin;
          }).cargo-0_88_0-bin-8cad88ffd54a16db;

          cargo-libnix-1_87_0_plus_v3_src = builtins.fetchTarball {
            url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0%2Bv3/libnix-1.87.0+v3.tar.bz2";
            sha256 = "sha256:00cqp5s8gdzz2abwlggz3v9qhizln7f06nilkb34fvkr9hywgk2v";
          };
          cargo-libnix-1_87_0_plus_v3 = (import (cargo-libnix-1_87_0_plus_v3_src + "/derivations/default.nix"){ 
            inherit project_root pkgs;
            external_crate_dependencies = import (cargo-libnix-1_87_0_plus_v3_src + "/Cargo.dependencies.nix") { inherit pkgs; };
            rustc = rustc_1_87_vanilla_pin;
            cargo = cargo_1_87_vanilla_pin;
          }).cargo-0_88_0-bin-8cad88ffd54a16db;

          ######################## cargo-libnix-master-via-ifd ###########################

          external_crate_dependencies = { envs = {}; deps = {}; } // (
            if builtins.pathExists ./Cargo.dependencies.nix
              then import ./Cargo.dependencies.nix { inherit pkgs; }
              else { });

          # the cargo binary unit of a generated build system; its hash isn't known in advance
          cargoBin = units: units.${pkgs.lib.findFirst (n: pkgs.lib.hasPrefix "cargo-0_88_0-bin-" n)
            (throw "no cargo-0_88_0-bin-* unit in the generated build system") (builtins.attrNames units)};

          src = builtins.filterSource
            (path: type:
                let base = baseNameOf path;
                in !(base == "target" || base == "result" || builtins.match "result-*" base != null)
            ) project_root;

          lock = builtins.fromTOML (builtins.readFile ./Cargo.lock);
          crateTarballs = map (p: pkgs.fetchurl {
              name = "crate-${p.name}-${p.version}.tar.gz";
              url = "https://crates.io/api/v1/crates/${p.name}/${p.version}/download";
              sha256 = p.checksum;
            })
            (builtins.filter (p: (p.source or "") == "registry+https://github.com/rust-lang/crates.io-index") lock.package);

          generated = pkgs.runCommand "cargo-nix-generated" { inherit crateTarballs; nativeBuildInputs = [ pkgs.openssl pkgs.pkg-config cargo-libnix-1_87_0_plus_v3 rustc_1_87_vanilla_pin ]; } ''
            export HOME=$TMPDIR CARGO_BACKEND=nix
            cp -r ${src} project && chmod -R u+w project && cd project
            ${cargo-libnix-1_87_0_plus_v3}/bin/cargo build --offline write-nix-buildsystem --out-dir $out
          '';
          cargo-libnix-master-via-ifd = cargoBin (import "${generated}/cargo_build_caller.nix" { inherit system; project_root = src; });
        in
        with pkgs;
        rec {
          packages = {
            inherit cargo-libnix-1_87_0_plus_v1 cargo-libnix-1_87_0_plus_v2 cargo-libnix-1_87_0_plus_v3 rustc_1_87_vanilla_pin cargo-libnix-master-via-ifd;
            default = pkgs.symlinkJoin {
              name = "cargo-libnix-1_87_0_plus_v3-with-rustc";
              paths = [
                cargo-libnix-1_87_0_plus_v3
                rustc_1_87_vanilla_pin
              ];
            };
          };
          devShells.default = mkShell {
            buildInputs = [
              # rust toolchain
              rustc_1_87_vanilla_pin
              cargo-libnix-1_87_0_plus_v3
              #cargo-libnix-master-via-ifd
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
