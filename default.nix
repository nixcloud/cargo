{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib } :
  let
    

in
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-0_88_0-bin-85e09d7d8299b1ad";
    phases = "unpackPhase buildPhase";

    # src = builtins.filterSource
    #   (path: type:
    #     let base = baseNameOf path;
    #     in !(base == "target" || base == "result" || builtins.match "result-*" base != null)
    #   ) /home/nixos/cargo;

    src = lib.fileset.toSource {
      root = ./.;
      fileset = lib.fileset.unions [
        ./src/bin/cargo/main.rs
        ./src/bin/cargo/cli.rs
        ./src/bin/cargo/commands/mod.rs
        ./src/bin/cargo/commands/add.rs
        ./src/bin/cargo/commands/bench.rs
        ./src/bin/cargo/commands/build.rs
        ./src/bin/cargo/commands/check.rs
        ./src/bin/cargo/commands/clean.rs
        ./src/bin/cargo/commands/config.rs
        ./src/bin/cargo/commands/doc.rs
        ./src/bin/cargo/commands/fetch.rs
        ./src/bin/cargo/commands/fix.rs
        ./src/bin/cargo/commands/generate_lockfile.rs
        ./src/bin/cargo/commands/git_checkout.rs
        ./src/bin/cargo/commands/help.rs
        ./src/bin/cargo/commands/info.rs
        ./src/bin/cargo/commands/init.rs
        ./src/bin/cargo/commands/install.rs
        ./src/bin/cargo/commands/locate_project.rs
        ./src/bin/cargo/commands/login.rs
        ./src/bin/cargo/commands/logout.rs
        ./src/bin/cargo/commands/metadata.rs
        ./src/bin/cargo/commands/new.rs
        ./src/bin/cargo/commands/nix.rs
        ./src/bin/cargo/commands/owner.rs
        ./src/bin/cargo/commands/package.rs
        ./src/bin/cargo/commands/pkgid.rs
        ./src/bin/cargo/commands/publish.rs
        ./src/bin/cargo/commands/read_manifest.rs
        ./src/bin/cargo/commands/remove.rs
        ./src/bin/cargo/commands/report.rs
        ./src/bin/cargo/commands/run.rs
        ./src/bin/cargo/commands/rustc.rs
        ./src/bin/cargo/commands/rustdoc.rs
        ./src/bin/cargo/commands/search.rs
        ./src/bin/cargo/commands/test.rs
        ./src/bin/cargo/commands/tree.rs
        ./src/bin/cargo/commands/uninstall.rs
        ./src/bin/cargo/commands/update.rs
        ./src/bin/cargo/commands/vendor.rs
        ./src/bin/cargo/commands/verify_project.rs
        ./src/bin/cargo/commands/version.rs
        ./src/bin/cargo/commands/yank.rs
      ];
    };

buildPhase = '' 
  du -a src
  exit 1
'';
}
