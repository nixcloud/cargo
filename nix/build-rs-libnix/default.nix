{ pkgs, lib ? pkgs.lib }:
let
  project_root = ./.;
  relativeFileset = project_root: relPaths: lib.fileset.unions (map (p: project_root + "/${p}") relPaths);
in
pkgs.rustPlatform.buildRustPackage {
    pname = "build-rs-libnix";
    version = "0.1.10";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = relativeFileset project_root [
        "Cargo.toml"
        "Cargo.lock"
        "src/lib.rs"
        "src/main.rs"
        "src/tests.rs"
      ];
    };

    cargoLock = {
      lockFile = ./Cargo.lock;
    };
    
    doCheck = false;
    nativeBuildInputs = [];
    buildInputs = [];
}