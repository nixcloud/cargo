# WARNING

This is an unofficial fork of Cargo — not endorsed by the Rust Project.

This fork is intended as a PR to contribute this to the official cargo project and to engineer the solution and to get feedback on the work from the nix community.

# What is this?

This project aims to integrate nix as a backend into cargo (libnix) so we can benefit from the nix advantages during development.

Motivation behind this work:

* https://lastlog.de/blog/libnix_cargo-nix-backend.html
* https://lastlog.de/blog/timeline.html?filter=tag::libnix

This project is [xkcd 927](https://xkcd.com/927/).

# Online resources

We use these resources:

* https://github.com/nixcloud/cargo - branch **libnix** - exists as a PR to incorperate nix into cargo
* https://github.com/nixcloud/cargo/issues - for issues, do not report issues on the original cargo tracker (or their formus)!

# Similar projects

* [crane](https://github.com/ipetkov/crane)
* [naersk](https://github.com/nix-community/naersk)
* [cargo2nix](https://github.com/cargo2nix/cargo2nix)
* [crate2nix](https://github.com/nix-community/crate2nix)

# Using 'cargo build' (nix backend)

## flake.nix

```nix
{
  description = "a flake to build logone for libnix cargo";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    fenix.url   = "github:nix-community/fenix";
    cargo-libnix.url = "github:nixcloud/cargo";
  };
  outputs =
  { self, nixpkgs, flake-utils, fenix, cargo-libnix } @ inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          project_root = ./.;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              fenix.overlay
            ];
          };
          lib = pkgs.lib;
        in
        with pkgs;
        rec {
          packages = { inherit cargo-libnix; };
          devShells = {
            default = mkShell {
              buildInputs = [
                # to build cargo with 'cargo build'
                openssl
                pkg-config
                # git helper
                tig
                # the toolchain used
                fenix.packages.${system}.stable.rustc
                #fenix.packages.${system}.stable.cargo
                cargo-libnix.packages.${system}.cargo-libnix
                fenix.packages.${system}.stable.rust-src
                fenix.packages.${system}.stable.rustfmt
                fenix.packages.${system}.stable.clippy
              ];
              shellHook = ''
                export CARGO_BACKEND=nix
              '';
            };  
          };
        }
      );
}
```

## nixpkgs & you nix files

This will give you the a `cargo` binary, you need to add a `rustc` and other rust toolchain parts in addition.

```
libnix_cargo_src = builtins.fetchTarball {
  url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0-rc1/libnix-1.87.0-rc1.tar.bz2";
  sha256 = "sha256:03lfx59j1kpbkcwx7pnbrwdyh2s8wzmsbnsrf0kla9gpsshdffmc";
};
libnix_cargo = (import (libnix_cargo_src + "/cargo_build_caller.nix"){ inherit system;}).cargo-0_88_0-bin-114d5ce240d74699;
...
buildInputs = [ libnix_cargo ]
```

# Releases using 'cargo build' (nix backend)

After you finished work with `cargo build` and `cargo run` you might want to create a release, this are the steps:

1. create a `git` commit with a `git tag` you like and push it
2. create a github release for the tag
3. use `nix-prefetch-url https://github.com/nixcloud/cargo/archive/refs/tags/1.83-test-release.tar.gz` to create the hash
4. create the static `nix build system`

    ```bash
    CARGO_BACKEND=nix cargo build write-nix-buildsystem \
      --out-dir /tmp/nix \
      --url https://github.com/nixcloud/cargo/archive/refs/tags/1.83-test-release.tar.gz \
      --hash 1h5j1kl7q7mysa943gvd4c8ih8yxx4igqrx4akv9ixf4zf411b8l
    ```

5. you can test it locally: `nix build --file /tmp/nix/cargo_build_caller.nix target -L` and see if it works
6. finally add this to your git repo and use with a flake concept (done for libnix, see the ./nix folder) or
   zip & upload the files and call the builder like:

    ```bash
    libnix_cargo_src = builtins.fetchTarball {
      url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0-rc1/libnix-1.87.0-rc1.tar.bz2";
      sha256 = "sha256:03lfx59j1kpbkcwx7pnbrwdyh2s8wzmsbnsrf0kla9gpsshdffmc";
    };
    libnix_cargo = (import (libnix_cargo_src + "/cargo_build_caller.nix"){ inherit system;}).cargo-0_88_0-bin-114d5ce240d74699;
    ```

Note: Instead of calling `./nix/cargo_build_caller.nix` one can also call into `./nix/derivations/default.nix` and provide the required arguments for the build:

    ```nix
      {
        description = "a flake to build libnix cargo";
        inputs = {
          nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
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
                    fenix.overlay
                  ];
                };
                lib = pkgs.lib;
                external_crate_dependencies =
                  if builtins.pathExists ./Cargo.dependencies.nix
                    then import ./Cargo.dependencies.nix { inherit pkgs; }
                    else { deps = {}; };
                build_rs_libnix = pkgs.callPackage nix/build-rs-libnix/default.nix {
                  inherit pkgs;
                };
                cargo-libnix = (import nix/derivations/default.nix {
                  inherit project_root pkgs external_crate_dependencies build_rs_libnix;
                  rustc = fenix.packages.${system}.stable.rustc;
                  cargo = fenix.packages.${system}.stable.cargo;
                }).cargo-0_88_0-bin-25c525326f58ed30;
              in
                with pkgs;
                rec {
                  packages = { inherit cargo-libnix; };
                  devShells.default = mkShell {
                    buildInputs = [
                      # to build cargo with 'cargo build'
                      openssl
                      pkg-config
                      # git helper
                      tig
                      # the toolchain used
                      fenix.packages.${system}.stable.rustc
                      #fenix.packages.${system}.stable.cargo
                      cargo-libnix
                      fenix.packages.${system}.stable.rust-src
                      fenix.packages.${system}.stable.rustfmt
                      fenix.packages.${system}.stable.clippy
                    ];
                  };
                }
              );
            }
    ```

# Injecting dependencies 

cargo-libnix has fine grained dependencies per crate for `buildInputs` and `environment variables`:

How to use it:

1. create a file `Cargo.dependencies.nix` next to Cargo.lock / Cargo.toml

2. fill it with your desired nix dependencies like `openssl` or `curl` or environment variables:

    ```nix
        { pkgs }:
        with pkgs;
        {
            deps = {
                "markup5ever_rcdom" = {
                    "0.3.0" =
                        [ pkg-config openssl ];
                };
                "unicode-ident" = [ pkg-config curl ];
                "xml5ever" = {
                    "0.20.0" = [];
                };
            };
            envs = {
                "cargo" = {
                    "0.88.0" = {
                        "FOO" = "bar11 asdf";
                    };
                };
                "cargo-platform" = {
                    "FOO" = "worx";
                };
            };
        }
    ```

Note: The name and version of a crate can be copied from Cargo.lock but keep in mind
there is no check for unused or wrongly spelled dependencies or out of date versions.

Note: This file is optional and explicitly outside of the generated nix files so it stays in your repository.

# Success stories

```
                       /- cargo legacy    (both use the same cargo / rustc so we know it is buildable)
name                 |   | /-cargo libnix
cargo          v1.87 | + | + |   "openssl-sys" = [ pkg-config openssl ];
build-parser  v0.1.8 | x | x |
ripgrep      v14.1.1 | x | x |
atuin        v18.5.0 | x | x |
trunk       v0.21.14 | x | x |
sd            v1.0.0 | x | x |
mdBook        v0.5.2 | x | x |
just           v1.46 | x | x |
fd            v7.3.0 | x | x |
pankat-rs     v0.1.1 | + | + |   "libsqlite3-sys" = [ pkg-config sqlite ];
rustpad       v0.1.0 | x | x |
synapse        1.0.0 |   | x |
starship     v1.22.0 |   | + |   "openssl-sys" = [ pkg-config openssl ];  "libz-ng-sys" = [ cmake ];
nix-installer 3.15.1 |   | + |   envs = { "nix-installer" = { NIX_TARBALL_URL = "foo.tar.xz"; DETERMINATE_NIX_TARBALL_PATH = "../README.md"; DETERMINATE_NIXD_BINARY_PATH = "../README.md"; }; };
bat          v0.25.0 | x | x |
delta        v0.18.2 |   | x |
rust-analyzer        |   | x |
   2025-01-07
nushell      0.102.0 | + | + |   "openssl-sys" = [ pkg-config openssl ];
coreutils            |   | x |   - OUT_DIR problem in bin (using cp -r build_script_run/* $out/ now)
eza   58b98cfa       |   | x |   - OUT_DIR problem in bin (using cp -r build_script_run/* $out/ now)
build_rs_example     | x | x |   - OUT_DIR problem in bin (using cp -r build_script_run/* $out/ now)
sniffnet             |   | x |   deps = {"alsa-sys" = [ pkg-config alsa-lib ]; "sniffnet" = [ pkg-config libpcap ]; };
RustPython           |   | x | 
   2024-12-30-main-4
axum                 | x | x | 
tokio                | x | x |
lightningcss         | x | x |
yew                  | x | x |
klick         v0.5.7 | x | x | requires 'just run' before compile
```

* https://github.com/EvanLi/Github-Ranking/blob/master/Top100/Rust.md
* https://perf.rust-lang.org/compare.html

# Legal

This is the email response of the Rust Foundation to https://internals.rust-lang.org/t/new-rust-backend-libnix/23848 

> Your fork falls under the explicit allowance in the Rust trademark policy to "host a fork of the code for the purpose of making changes, additions, or deletions that will be submitted as proposed improvements to the Rust Project". The policy does not restrict the size, depth, or architectural significance of the changes. Adding a new build backend is permitted by this allowance.

> You're entitled to publicly host and distribute a fork, in source form, under the Cargo name, provided that:
> it is clearly presented as unofficial,
> it is not marketed or promoted as an official or endorsed version of Cargo, and
> it is positioned as work intended for upstream contribution rather than as a competing product.
> The measures you mention (namespaced repository, clear disclaimers, experimental framing) are sufficient and appropriate for this, and we appreciate the care you've taken to do that!
> 
> Providing commercial support or consulting around this work does not, in itself, violate the trademark policy. The requirement is simply that such services must not be presented as official Cargo support, and must not imply endorsement by the Rust Project or the Rust Foundation. You would only need to seek explicit written permission if you intended to market, brand, or distribute your fork as a product in its own right using the Cargo name, or in a way that a reasonable user could interpret as official Cargo. In those circumstances I think the Rust Foundation's board would most likely want you to choose a new name for it to avoid any confusion.
> 
> I hope that's helpful.
> 
> Abi Broom
> Director of Operations
> Rust Foundation
