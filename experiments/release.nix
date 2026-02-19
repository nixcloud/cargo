#nix build target --file /home/nixos/cargo/target/debug/nix/cargo_build_caller.nix --out-link /home/nixos/cargo/target/debug/nix/gc/result

let
  src = builtins.fetchTarball {
    url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0-rc1/libnix-1.87.0-rc1.tar.bz2";
    sha256 = "sha256:03lfx59j1kpbkcwx7pnbrwdyh2s8wzmsbnsrf0kla9gpsshdffmc";
  };

  libnix = import (src + "/cargo_build_caller.nix"){};
in
  (libnix).cargo-0_88_0-bin-114d5ce240d74699
