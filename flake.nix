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

          ######################## cargo-libnix-1_87_0_plus_v1 ###########################

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

          ######################## cargo-libnix-1_87_0_plus_v2 ###########################

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

          ######################## cargo-libnix-1_87_0_plus_v3 ###########################

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

          ######################## cargo-libnix-*-via-ifd ###########################

          cargoBin = units: units.${pkgs.lib.findFirst (n: pkgs.lib.hasPrefix "cargo-0_88_0-bin-" n)
            (throw "no cargo-0_88_0-bin-* unit in the generated build system") (builtins.attrNames units)};

          # src -> generated nix build system (IFD) -> cargo binary
          buildCargoBin = { src }:
            let
              lock = builtins.fromTOML (builtins.readFile "${src}/Cargo.lock");
              crateTarballs = map (p: pkgs.fetchurl {
                  name = "crate-${p.name}-${p.version}.tar.gz";
                  url = "https://crates.io/api/v1/crates/${p.name}/${p.version}/download";
                  sha256 = p.checksum;
                })
                (builtins.filter (p: (p.source or "") == "registry+https://github.com/rust-lang/crates.io-index") lock.package);

              generated = pkgs.runCommand "cargo-nix-generated" { inherit crateTarballs; nativeBuildInputs = [ cargo-libnix-1_87_0_plus_v5 rustc_1_87_vanilla_pin ]; } ''
                export HOME=$TMPDIR CARGO_BACKEND=nix
                cp -r ${src} project && chmod -R u+w project && cd project
                ${cargo-libnix-1_87_0_plus_v5}/bin/cargo build --offline write-nix-buildsystem --out-dir $out
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
          cargo-libnix-git-revision-via-ifd = buildCargoBin { src = revision-src; };

          ######################################################################################

        in
        with pkgs;
        rec {
          packages = {
            inherit rustc_1_87_vanilla_pin;
            inherit cargo_1_87_vanilla_pin;
            inherit cargo-libnix-1_87_0_plus_v1;
            inherit cargo-libnix-1_87_0_plus_v2;
            inherit cargo-libnix-1_87_0_plus_v3;
            inherit cargo-libnix-1_87_0_plus_v4;
            inherit cargo-libnix-1_87_0_plus_v5;
            inherit cargo-libnix-git-head-via-ifd;
            inherit cargo-libnix-git-revision-via-ifd;

            default = pkgs.symlinkJoin {
              name = "cargo-libnix-1_87_0_plus_v5-with-rustc";
              paths = [
                cargo-libnix-1_87_0_plus_v5
                rustc_1_87_vanilla_pin
              ];
            };
          };
          devShells.default = mkShell {
            buildInputs = [
              # rust toolchain
              rustc_1_87_vanilla_pin
              cargo-libnix-1_87_0_plus_v5
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
