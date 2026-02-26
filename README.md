# WARNING ⚠️

This is an unofficial fork of Cargo — not endorsed by the Rust Project.

This fork is intended as a PR to contribute this to the official cargo project and to engineer the solution and to get feedback on the work from the nix community.

# What is this?

This project aims to integrate nix as a backend into cargo (libnix) so we can benefit from the nix advantages during development and deployment. Detailed technical status in [README-DEV.md](README-DEV.md).

Ideally you type these commands: 🚀

    git clone https://github.com/nixcloud/cargo
    nix develop
    cargo build

[![asciicast](https://asciinema.org/a/742433.svg)](https://asciinema.org/a/742433)

You can easily add it to your project's flake.nix and use it, too!

# Motivation 💡

Motivation behind this work:

* https://lastlog.de/blog/libnix_cargo-nix-backend.html
* https://lastlog.de/blog/timeline.html?filter=tag::libnix

This project is [xkcd 927](https://xkcd.com/927/).

# Project resources

We use these resources:

* https://github.com/nixcloud/cargo - branch **master-libnix** - exists as a PR to incorperate nix into cargo
* https://github.com/nixcloud/cargo/issues - for issues, do not report issues on the original cargo tracker (or their formus)!
* https://link.excalidraw.com/l/3QhpSMKuoZA/6eoC5kkanvL - diagrams
* https://link.excalidraw.com/p/readonly/HTEjH2WpzNJExWK81BaN - slides

# Success stories 👋

Using `cargo-libnix-1_87_0_rc2` it can compile these projects out of the box. Occasionally you might have to add a `Cargo.dependencies.nix` with some dependencies and environment variables.

```
                       /- cargo legacy    (both use the same cargo / rustc so we know it is buildable)
name                 |   | /-cargo libnix
cargo          v1.87 | + | + |   "openssl-sys" = [ pkg-config openssl ];
logone         0.2.9 | x | x |
build-rs-libnix 0.1.11 x | x | 
build_rs_example     | x | x |   - OUT_DIR problem in bin (using cp -r build_script_run/* $out/ now)
rust-analyzer        | x | x | requires deps = { "proc-macro-test" = [ cargo ]; }; envs = { "proc-macro-test" = { "PROC_MACRO_TEST_LOCATION" = ""; }; };
atuin        v18.5.0 | x | x |
nushell      0.102.0 | + | + |   "openssl-sys" = [ pkg-config openssl ];
ripgrep      v14.1.1 | x | x |
fd            v7.3.0 | x | x |
eza   58b98cfa       | x | x |   - OUT_DIR problem in bin (using cp -r build_script_run/* $out/ now)
bat          v0.25.0 | x | x |
sd            v1.0.0 | x | x |
coreutils            | x | x |   - OUT_DIR problem in bin (using cp -r build_script_run/* $out/ now)
synapse        1.0.0 | x | x |
nix-installer 3.15.1 | + | + |   envs = { "nix-installer" = { NIX_TARBALL_URL = "foo.tar.xz"; 
                                 DETERMINATE_NIX_TARBALL_PATH = "../README.md"; DETERMINATE_NIXD_BINARY_PATH = "../README.md"; }; };
delta        v0.18.2 | x | x |
   2025-01-07     
sniffnet             | + | + |   deps = {"alsa-sys" = [ pkg-config alsa-lib ]; "sniffnet" = [ pkg-config libpcap ]; };
RustPython           | x | x |   - requires nix-prefetch-git
   2024-12-30-main-4
axum                 | x | x | 
tokio                | x | x |
yew                  | x | x |
lightningcss         | x | x |
klick         v0.5.7 | x | x | requires 'just run' before compile
trunk       v0.21.14 | x | x |
just           v1.46 | x | x |
leptos               | x | x | 
cargo-leptos         | + | + | deps = { "openssl-sys" = [ pkg-config openssl pkg-config perl ]; ... }
vaultwarden          | x | x | legacy+nix: `cargo build  --features sqlite` works
mdBook        v0.5.2 | x | x |
pankat-rs     v0.1.1 | + | + |   "libsqlite3-sys" = [ pkg-config sqlite ];
rustpad       v0.1.0 | x | x |
fuse-rs              | + | + | deps = { "fuse-sys" = [ pkg-config fuse ];};envs = {};
codex                | + | + | cd doex-rs; -> deps = { "openssl-sys" = [ pkg-config openssl ]; }
typst                | + | + | deps = { "openssl-sys" = [ pkg-config openssl ];};
starship    ~v1.24.1 | + | + | "openssl-sys" = [ pkg-config openssl ];  "libz-ng-sys" = [ cmake ];
                                rev 37b6225a12ba2e8576cc8d6181c3fba7c9661395

x builds out of the box
+ builds, but requires Cargo.dependencies.nix
```

* https://github.com/EvanLi/Github-Ranking/blob/master/Top100/Rust.md
* https://perf.rust-lang.org/compare.html

# Using cargo (libnix)

There are two ways to install cargo (libnix) on your system:

1. integrate cargo (libnix) it into your flake.nix
2. integrate cargo (libnix) it into your nix documents

## 1. cargo (libnix) with flake.nix

When you use fenix to manage your Rust installation, simply add a few lines to extend the installation with the custom cargo binary as shown below:

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

+# 1_87_0_plus_v1_src
+          cargo-libnix-1_87_0_plus_v1_src = builtins.fetchTarball {
+            url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0%2Bv1/libnix-1.87.0+v1.tar.bz2";
+            sha256 = "sha256:1pa5yg6i5rk0f50f0syv3ci0864ca3w9ch60rx2q6mp7fy86h086";
+          };
+          cargo-libnix-1_87_0_plus_v1 = (import (cargo-libnix-1_87_0_plus_v1_src + "/derivations/default.nix"){ 
+            inherit project_root pkgs;
+            external_crate_dependencies = import (cargo-libnix-1_87_0_plus_v1_src + "/Cargo.dependencies.nix") { inherit pkgs; };
+            rustc = fenix.packages.${system}.stable.rustc;
+            cargo = fenix.packages.${system}.stable.cargo;
+          }).cargo-0_88_0-bin-b4cc6eeacb818d24;

          external_crate_dependencies = { envs = {}; deps = {}; } // (
            if builtins.pathExists ./Cargo.dependencies.nix
              then import ./Cargo.dependencies.nix { inherit pkgs; }
              else { });
        in
        with pkgs;
        rec {
          packages = { inherit cargo-libnix-1_87_0_plus_v1; };
          devShells.default = mkShell {
            buildInputs = [
              # to build cargo with 'CARGO_BACKEND=legacy cargo build' 
              openssl
              pkg-config
              # git helper
              tig
              # the toolchain used
              fenix.packages.${system}.stable.rustc
              # your cargo compiler
              #fenix.packages.${system}.stable.cargo
+             cargo-libnix-1_87_0_plus_v1
              # comfy tools
              fenix.packages.${system}.stable.rust-src
              fenix.packages.${system}.stable.rustfmt
              fenix.packages.${system}.stable.clippy
              # used by cargo (libnix)
              nix-prefetch-scripts
            ];
            shellHook = ''
              export CARGO_BACKEND=nix
            '';
          };
        }
      );
}
```

Afterwards check with `which cargo` that it points to the right path.

    which cargo
    /nix/store/dpihj64vqhxir9bmdj3aciv5sf1myx7b-cargo-0_88_0-bin-b4cc6eeacb818d24/bin/cargo

## 2. cargo (libnix) in your nix documents

With this you can extend your build system with a `cargo` (libnix) binary, you need to add a `rustc` and other rust toolchain parts in addition similar to the flake setup:

```nix
libnix_cargo_src = builtins.fetchTarball {
  url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0%2Bv1/libnix-1.87.0+v1.tar.bz2";
  sha256 = "sha256:1pa5yg6i5rk0f50f0syv3ci0864ca3w9ch60rx2q6mp7fy86h086";
};
libnix_cargo = (import (libnix_cargo_src + "/cargo_build_caller.nix"){ inherit system;}).cargo-0_88_0-bin-b4cc6eeacb818d24;
...
systemPackages = [ libnix_cargo ];
```

WARNING: **cargo_build_caller.nix** acts like a flake.nix since it has its own input section and uses a different nixpkgs because this way we can share the build artifacts between machines. Feel free to also use the **nix/derivations/default.nix** as entry point while providing your own `cargo`, `rustc` and `pkgs`.

# Injecting dependencies 

The cargo (libnix) supports fine grained dependencies per crate, so you can enhance individual `buildInputs` and `environment variables`!

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
  3. run `cargo build`, it should show something like

Note: The name / version of a crate can be copied from `Cargo.lock` (version is optional).

# Release workflow

The command `cargo build` creates a nix toolchain on the fly in _target/debug/nix_ but you can also write it with `cargo build write-nix-buildsystem ...` so it can be used from a _flake_ or _nixpkgs_. When using _write-nix-buildsystem_ a URL/HASH is used with `builtins.fetchTarball` instead of the local source.

```
   ┌─────────────────┐
   │  flake.nix      │
   └────────┬────────┘
            │
            ▼
┌────────────────────────────┐
│  Nix toolchain             │
│  • cargo_build_caller.nix  │
│  • derivations/default.nix │
│  • derivations/ ...        │
└───────────┬────────────────┘
            │
            ▼
┌───────────────────────┐
│  Project source code  │
│  • src/               │
│  • Cargo.toml / ...   │
└───────────────────────┘
```

This are the steps:

1. create a `git` commit with a `git tag` you like and push it
2. create a github release for the tag
3. use `nix-prefetch-url https://github.com/nixcloud/cargo/archive/refs/tags/1.83-test-release.tar.gz` to create the hash
4. create the static `nix build system`

    ```bash
    CARGO_BACKEND=nix cargo build --release write-nix-buildsystem \
      --out-dir ./libnix-1.83-test-release \
      --url https://github.com/nixcloud/cargo/archive/refs/tags/1.83-test-release.tar.gz \
      --hash 1h5j1kl7q7mysa943gvd4c8ih8yxx4igqrx4akv9ixf4zf411b8l
    ```

5. you can test it locally: `nix build --file libnix-1.83-test-release/cargo_build_caller.nix target -L` and see if it works
6. finally add this to your git repo and use with a flake concept (done for libnix, see the ./nix folder) or
   zip & upload the files and call the builder like:

    ```nix
    libnix_cargo_src = builtins.fetchTarball {
      url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.87.0-rc1/libnix-1.87.0-rc1.tar.bz2";
      sha256 = "sha256:03lfx59j1kpbkcwx7pnbrwdyh2s8wzmsbnsrf0kla9gpsshdffmc";
    };
    libnix_cargo = (import (libnix_cargo_src + "/cargo_build_caller.nix"){ inherit system;}).cargo-0_88_0-bin-114d5ce240d74699;
    ```

The generated nix build system has two entry points:

1. `./cargo_build_caller.nix` for `nix` (like from nixpkgs)
2. `./derivations/default.nix` for `flake.nix` but you have to provide the environment (see the [flake.nix](flake.nix) in this repository).

And you can build most rust projects without touching `cargo` again.

Finally you can create a tar.bz2 of the build system and add it to the release section of your project. See https://github.com/nixcloud/cargo/releases/tag/libnix-1.87.0-rc2, which contains 3 files:

* source code (zip)
* source code (tar.gz)
* libnix-1.87.0-rc2.tar.bz2 (the build system)

# Similar projects 📚

* [crane](https://github.com/ipetkov/crane)
* [naersk](https://github.com/nix-community/naersk)
* [cargo2nix](https://github.com/cargo2nix/cargo2nix)
* [crate2nix](https://github.com/nix-community/crate2nix)

# Sponsors

This project was sponsored by nlnet

![nlnet](https://lastlog.de/blog/media/nlnet-logo.gif)

# Legal 📝

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
