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

          # the toolchain this branch (rust-1.99.0 + libnix) builds with, the one its nix mode pins
          toolchain_1_99 = {
            channel = "1.99.0";
            sha256 = "sha256-zm3dyIY2T414ZRR3EhLOvptzG6gta4WZUcawzMUWtqI=";
          };
          rustc_1_99_vanilla_pin = (fenix.packages.${system}.toolchainOf toolchain_1_99).rustc;
          cargo_1_99_vanilla_pin = (fenix.packages.${system}.toolchainOf toolchain_1_99).cargo;
          # the rustc the generated build system of this branch builds with (cargo_build_caller.nix.handlebars):
          # without rustc's own lld, which bypasses the ld wrapper of nix's cc (and with it the rpaths)
          rustc_1_99_nix_ld = pkgs.symlinkJoin {
            name = "rustc-1.99.0-nix-ld";
            paths = [ rustc_1_99_vanilla_pin ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              for b in rustc rustdoc; do wrapProgram $out/bin/$b --add-flags "-C linker-features=-lld"; done
            '';
          };

          # the releases this branch uses as generators (cargo-libnix-*-via-ifd); for users, master-libnix serves the
          # releases of every line

          ######################## cargo-libnix-1_87_0_plus_v5 ###########################

          cargo-libnix-1_87_0_plus_v5_src = builtins.fetchTarball {
            url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0%2Bv5/libnix-1.87.0+v5.tar.bz2";
            sha256 = "sha256:0k5265x6x5618yvx44qlg6z1rmc0k76g9fj82pmyiacazr8nh7zd";
          };
          cargo-libnix-1_87_0_plus_v5 = (import (cargo-libnix-1_87_0_plus_v5_src + "/derivations/default.nix"){ 
            inherit project_root pkgs;
            external_crate_dependencies = import (cargo-libnix-1_87_0_plus_v5_src + "/Cargo.dependencies.nix") { inherit pkgs; };
            rustc = rustc_1_87_vanilla_pin;
            cargo = cargo_1_87_vanilla_pin;
          }).cargo-0_88_0-bin-d7e8a77a599efbea;

          ######################## cargo-libnix-1_99_0_plus_v2 ###########################

          cargo-libnix-1_99_0_plus_v2_src = builtins.fetchTarball {
            url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.99.0%2Bv2/libnix-1.99.0+v2.tar.bz2";
            sha256 = "sha256:0v10kxslf5140wd5b14anc79n9c0lkz5yv2y0ni1vxxbzzmadh35";
          };
          cargo-libnix-1_99_0_plus_v2 = (import (cargo-libnix-1_99_0_plus_v2_src + "/derivations/default.nix"){ 
            inherit project_root pkgs;
            external_crate_dependencies = import (cargo-libnix-1_99_0_plus_v2_src + "/Cargo.dependencies.nix") { inherit pkgs; };
            # rustc >= 1.90 links with its own lld otherwise, past nix's ld wrapper: no rpath (libssl.so.3 not found)
            rustc = rustc_1_99_nix_ld;
            cargo = cargo_1_99_vanilla_pin;
          }).cargo-0_100_0-bin-463824861cef8abc;

          ######################## cargo-libnix-*-via-ifd ###########################

          # the cargo binary unit (cargo-0_88_0-bin-…, cargo-0_100_0-bin-…)
          cargoBin = units: units.${pkgs.lib.findFirst (n: builtins.match "cargo-[0-9_]+-bin-.*" n != null)
            (throw "no cargo-*-bin-* unit in the generated build system") (builtins.attrNames units)};

          # src -> generated nix build system (IFD) -> cargo binary
          #
          # The generator is a cargo (libnix) release, run with the rustc of its line (cargo needs `rustc -vV`; nix mode
          # builds with the toolchain the generated cargo_build_caller.nix pins itself). libnix-1.99.0+v2 pins rustc
          # 1.99.0, wrapped without rustc's own lld; libnix-1.87.0+v5 pins 1.87.0, for sources of the 1.87 line.
          buildCargoBin = { src, generator ? cargo-libnix-1_99_0_plus_v2, rustc ? rustc_1_99_nix_ld }:
            let
              lock = builtins.fromTOML (builtins.readFile "${src}/Cargo.lock");
              crateTarballs = map (p: pkgs.fetchurl {
                  name = "crate-${p.name}-${p.version}.tar.gz";
                  url = "https://crates.io/api/v1/crates/${p.name}/${p.version}/download";
                  sha256 = p.checksum;
                })
                (builtins.filter (p: (p.source or "") == "registry+https://github.com/rust-lang/crates.io-index") lock.package);

              generated = pkgs.runCommand "cargo-nix-generated" { inherit crateTarballs; nativeBuildInputs = [ generator rustc ]; } ''
                export HOME=$TMPDIR CARGO_BACKEND=nix
                cp -r ${src} project && chmod -R u+w project && cd project
                ${generator}/bin/cargo build --offline write-nix-buildsystem --out-dir $out
              '';
            in
            cargoBin (import "${generated}/cargo_build_caller.nix" { inherit system; project_root = src; });

          # the working tree, without top-level build outputs (target/, result, result-*)
          head-src = builtins.filterSource
            (path: type:
                let base = baseNameOf path;
                in !(dirOf path == toString project_root && (base == "target" || base == "result" || builtins.match "result-.*" base != null))
            ) project_root;

          # a pinned commit of nixcloud/cargo
          revision-src = builtins.fetchGit {
            url = "https://github.com/nixcloud/cargo";
            ref = "rust-1.87.0-libnix";
            rev = "4445af918349cec57adc3c431c9eb8b1f46054a2";
          };

          cargo-libnix-git-head-via-ifd = buildCargoBin { src = head-src; };
          cargo-libnix-git-revision-via-ifd = buildCargoBin { src = revision-src; generator = cargo-libnix-1_87_0_plus_v5; rustc = rustc_1_87_vanilla_pin; };

          ######################################################################################

        in
        with pkgs;
        rec {
          packages = {
            inherit rustc_1_87_vanilla_pin;
            inherit cargo_1_87_vanilla_pin;
            inherit rustc_1_99_vanilla_pin;
            inherit cargo_1_99_vanilla_pin;
            inherit rustc_1_99_nix_ld;
            inherit cargo-libnix-1_87_0_plus_v5;
            inherit cargo-libnix-1_99_0_plus_v2;
            inherit cargo-libnix-git-head-via-ifd;
            inherit cargo-libnix-git-revision-via-ifd;

            default = pkgs.symlinkJoin {
              name = "cargo-libnix-1_99_0_plus_v2-with-rustc";
              paths = [
                cargo-libnix-1_99_0_plus_v2
                rustc_1_99_vanilla_pin
              ];
            };
          };
          devShells.default = mkShell {
            buildInputs = [
              # rust toolchain: this branch needs rustc 1.99 (rust-version), driven by the cargo-libnix-1.99.0+v2
              # release; nix mode pins its own rustc, so building this repository itself needs CARGO_BACKEND=legacy
              rustc_1_99_vanilla_pin
              cargo-libnix-1_99_0_plus_v2
              # for the legacy backend: openssl-sys
              openssl
              pkg-config
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
