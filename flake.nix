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

          ######################## cargo-libnix-1_87_0_plus_v4 ###########################

          cargo-libnix-1_87_0_plus_v4_src = builtins.fetchTarball {
            url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0%2Bv4/libnix-1.87.0+v4.tar.bz2";
            sha256 = "sha256:0zhj8sl05g861c7pkwgd1ij26mf68qj1flbad2ivwj113vac9chq";
          };
          cargo-libnix-1_87_0_plus_v4 = (import (cargo-libnix-1_87_0_plus_v4_src + "/derivations/default.nix"){ 
            inherit project_root pkgs;
            external_crate_dependencies = import (cargo-libnix-1_87_0_plus_v4_src + "/Cargo.dependencies.nix") { inherit pkgs; };
            rustc = rustc_1_87_vanilla_pin;
            cargo = cargo_1_87_vanilla_pin;
          }).cargo-0_88_0-bin-8cad88ffd54a16db;

          ######################## cargo-libnix-1_99_0_plus_v1 ###########################

          cargo-libnix-1_99_0_plus_v1_src = builtins.fetchTarball {
            url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.99.0%2Bv1/libnix-1.99.0+v1.tar.bz2";
            sha256 = "sha256:1mwxjyr9ccbq71p1mq296xvs2b10kxb159a90dh3w6wbgs5qizg4";
          };
          cargo-libnix-1_99_0_plus_v1 = (import (cargo-libnix-1_99_0_plus_v1_src + "/derivations/default.nix"){ 
            inherit project_root pkgs;
            external_crate_dependencies = import (cargo-libnix-1_99_0_plus_v1_src + "/Cargo.dependencies.nix") { inherit pkgs; };
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
          # builds with the toolchain the generated cargo_build_caller.nix pins itself). libnix-1.99.0+v1 pins rustc
          # 1.99.0, wrapped without rustc's own lld; libnix-1.87.0+v4 pins 1.87.0, for sources of the 1.87 line.
          buildCargoBin = { src, generator ? cargo-libnix-1_99_0_plus_v1, rustc ? rustc_1_99_nix_ld }:
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
          cargo-libnix-git-revision-via-ifd = buildCargoBin { src = revision-src; generator = cargo-libnix-1_87_0_plus_v4; rustc = rustc_1_87_vanilla_pin; };

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
            inherit cargo-libnix-1_87_0_plus_v4;
            inherit cargo-libnix-1_99_0_plus_v1;
            inherit cargo-libnix-git-head-via-ifd;
            inherit cargo-libnix-git-revision-via-ifd;

            default = pkgs.symlinkJoin {
              name = "cargo-libnix-1_99_0_plus_v1-with-rustc";
              paths = [
                cargo-libnix-1_99_0_plus_v1
                rustc_1_99_vanilla_pin
              ];
            };
          };
          devShells.default = mkShell {
            buildInputs = [
              # rust toolchain: this branch needs rustc 1.99 (rust-version), driven by the cargo-libnix-1.99.0+v1
              # release; nix mode pins its own rustc, so building this repository itself needs CARGO_BACKEND=legacy
              rustc_1_99_vanilla_pin
              cargo-libnix-1_99_0_plus_v1
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
