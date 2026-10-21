{
  description = "cargo (libnix): cargo with a nix build backend, the releases of each supported Rust toolchain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    fenix.url = "github:nix-community/fenix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, fenix, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          lib = pkgs.lib;
          toolchainOf = fenix.packages.${system}.toolchainOf;

          # a release of cargo (libnix): the generated nix build system (release tarball) builds the cargo sources of
          # the tag with the rustc/cargo of its toolchain. The result carries that rustc as `.rustc` (its version as
          # `.rustVersion`): cargo (libnix)
          # needs a rustc of its own version next to it (`rustc -vV`, the legacy backend); nix mode builds with the
          # toolchain the generated cargo_build_caller.nix pins itself
          release = { tag, buildsystemSha256, srcSha256, unit, channel, toolchainSha256, wrapRustc ? (rustc: rustc) }:
            let
              tagUrl = lib.replaceStrings [ "+" ] [ "%2B" ] tag;
              buildsystem = builtins.fetchTarball {
                url = "https://github.com/nixcloud/cargo/releases/download/${tagUrl}/${tag}.tar.bz2";
                sha256 = buildsystemSha256;
              };
              src = builtins.fetchTarball {
                url = "https://github.com/nixcloud/cargo/archive/refs/tags/${tagUrl}.tar.gz";
                sha256 = srcSha256;
              };
              toolchain = toolchainOf { inherit channel; sha256 = toolchainSha256; };
              rustc = wrapRustc toolchain.rustc;
              cargo = (import (buildsystem + "/derivations/default.nix") {
                inherit pkgs rustc;
                cargo = toolchain.cargo;
                project_root = src;
                external_crate_dependencies = import (buildsystem + "/Cargo.dependencies.nix") { inherit pkgs; };
              }).${unit};
            in
            cargo // { inherit rustc; rustVersion = channel; };

          # since 1.90 rustc links with its own lld on x86_64-linux, which bypasses the ld wrapper of nix's cc (no rpath:
          # the binaries miss their libraries, e.g. libssl.so.3); -C linker-features=-lld links with the cc's ld again
          nixLd = rustc: pkgs.symlinkJoin {
            name = "rustc-${rustc.version or "1.99.0"}-nix-ld";
            paths = [ rustc ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              for b in rustc rustdoc; do wrapProgram $out/bin/$b --add-flags "-C linker-features=-lld"; done
            '';
          };

          cargo-libnix-1_87_0_plus_v4 = release {
            tag = "libnix-1.87.0+v4";
            buildsystemSha256 = "sha256:0zhj8sl05g861c7pkwgd1ij26mf68qj1flbad2ivwj113vac9chq";
            srcSha256 = "sha256:0lm951801chcdnjni4068jjwlzyf94byjgjk5qzlr9vihsp5i3ym";
            unit = "cargo-0_88_0-bin-8cad88ffd54a16db";
            channel = "1.87.0";
            toolchainSha256 = "sha256-KUm16pHj+cRedf8vxs/Hd2YWxpOrWZ7UOrwhILdSJBU=";
          };

          cargo-libnix-1_99_0_plus_v1 = release {
            tag = "libnix-1.99.0+v1";
            buildsystemSha256 = "sha256:1mwxjyr9ccbq71p1mq296xvs2b10kxb159a90dh3w6wbgs5qizg4";
            srcSha256 = "sha256:03fywzj68mj56m1lis3ghjn4i35kjd8frfkydlwldn8y6a87qviv";
            unit = "cargo-0_100_0-bin-463824861cef8abc";
            channel = "1.99.0";
            toolchainSha256 = "sha256-zm3dyIY2T414ZRR3EhLOvptzG6gta4WZUcawzMUWtqI=";
            wrapRustc = nixLd;
          };

          # the newest release of each line
          lines = {
            "1.87" = cargo-libnix-1_87_0_plus_v4;
            "1.99" = cargo-libnix-1_99_0_plus_v1;
          };
          defaultLine = "1.99";

          # cargo and the rustc of its release, in one package
          withRustc = line: cargo: pkgs.symlinkJoin {
            name = "cargo-libnix-${line}-with-rustc";
            paths = [ cargo cargo.rustc ];
            meta.mainProgram = "cargo";
          };

          # `cargo …` runs the default line, `cargo +1.87 …` another one (like rustup's `+toolchain`), each with the
          # rustc of its release in PATH and RUSTC
          cargo-switch = pkgs.writeShellScriptBin "cargo" ''
            line=${defaultLine}
            case "''${1-}" in
              +*) line=''${1#+}; shift ;;
            esac
            case "$line" in
            ${lib.concatStrings (lib.mapAttrsToList (l: c: ''
              ${l} | ${c.rustVersion}) c=${c}; r=${c.rustc} ;;
            '') lines)}
              *) echo "cargo (libnix): unknown toolchain +$line, available: ${lib.concatMapStringsSep ", " (l: "+${l}") (lib.attrNames lines)}" >&2; exit 1 ;;
            esac
            export PATH=$r/bin:$PATH RUSTC=$r/bin/rustc
            exec $c/bin/cargo "$@"
          '';

          shell = cargo: pkgs.mkShell {
            # nix-prefetch-git: for git dependencies
            packages = [ cargo pkgs.nix-prefetch-scripts ];
            shellHook = ''
              export CARGO_BACKEND=nix
            '';
          };

          rust-1_87 = withRustc "1.87" lines."1.87";
          rust-1_99 = withRustc "1.99" lines."1.99";
          default = pkgs.symlinkJoin {
            name = "cargo-libnix";
            paths = [ cargo-switch lines.${defaultLine}.rustc ];
            meta.mainProgram = "cargo";
          };
        in
        {
          packages = {
            # a fixed release
            inherit cargo-libnix-1_87_0_plus_v4 cargo-libnix-1_99_0_plus_v1;
            # the newest release of a line
            cargo-libnix-1_87 = lines."1.87";
            cargo-libnix-1_99 = lines."1.99";
            # the newest release of a line with its rustc
            inherit rust-1_87 rust-1_99;
            # rust-1_99, `cargo +1.87 …` for the 1.87 line
            inherit default;
          };

          devShells = {
            default = shell default;
            rust-1_87 = shell rust-1_87;
            rust-1_99 = shell rust-1_99;
          };

          # each line's cargo runs with the rustc of its release, in its own package and through the `+line` switch
          checks = lib.mapAttrs'
            (l: c: lib.nameValuePair "rust-${lib.replaceStrings [ "." ] [ "_" ] l}"
              (pkgs.runCommand "check-rust-${l}" { } ''
                check() {
                  "$@" --version | grep -q "^cargo ${c.rustVersion} +libnix" || { echo "$*: not cargo ${c.rustVersion}" >&2; exit 1; }
                }
                check ${withRustc l c}/bin/cargo
                check ${default}/bin/cargo +${l}
                check ${default}/bin/cargo +${c.rustVersion}
                PATH=${withRustc l c}/bin rustc --version | grep -q "^rustc ${c.rustVersion} "
                ${default}/bin/cargo +${l} --version > $out
              ''))
            lines;
        })
    // {
      overlays.default = final: prev:
        let p = self.packages.${prev.stdenv.hostPlatform.system}; in {
          cargo-libnix = p.default;
          cargo-libnix_1_87 = p.rust-1_87;
          cargo-libnix_1_99 = p.rust-1_99;
        };
    };
}
