# This build-rs-libnix target is used for bootstrapping cargo (libnix)'s generated source code from nixpkgs.

{ pkgs, lib ? pkgs.lib }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "build-rs-libnix-cli";
  version = "0.1.11";

  src = pkgs.fetchFromGitHub {
    owner = "nixcloud";
    repo = "build-rs-libnix";
    rev = "8b5b8adad644a842429ca8fe060325630789ea5a";
    sha256 = "sha256-s/2C5G36uCNIoHDz6sNadZLcG3OoKihqWB1UZAq7+qQ=";
  };

  cargoHash = "sha256-gJ35ScjnwgBMux4i4oHOyxcNc3jqolMkGhoJGEA1On4=";

  nativeBuildInputs = [];
  buildInputs = [];

  cargoBuildFlags = [ "-p cli" ];

  doCheck = true;

  meta = with lib; {
    description = "A command-line utility that extracts `--cfg` and `--check-cfg` flags from `cargo:`";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}