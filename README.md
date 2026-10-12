# WARNING ⚠️

This is an unofficial fork of Cargo — not endorsed by the Rust Project.

This fork is intended as a PR to contribute this to the official cargo project and to engineer the solution and to get feedback on the work from the nix community.

# What is this?

This project aims to integrate nix as a backend into cargo (libnix) so we can benefit from the nix advantages during development and deployment. Detailed technical status in [README-DEV.md](README-DEV.md).

Ideally you type these commands: 🚀

    nix develop github:nixcloud/cargo
    cargo build

[![asciicast](https://asciinema.org/a/1268068.svg)](https://asciinema.org/a/1268068)

You can easily add it to your project's flake.nix and use it, too!

# Motivation 💡

Motivation behind this work:

* https://lastlog.de/blog/libnix_cargo-nix-backend.html
* https://lastlog.de/blog/timeline.html?filter=tag::libnix

This project is [xkcd 927](https://xkcd.com/927/).

# Project resources

We use these resources:

* https://github.com/nixcloud/cargo - branch **master-libnix** - exists as a PR to incorperate nix into cargo (see [Branches and releases](#branches-and-releases-))
* https://github.com/nixcloud/cargo/issues - for issues, do not report issues on the original cargo tracker (or their formus)!
* https://link.excalidraw.com/l/3QhpSMKuoZA/6eoC5kkanvL - diagrams
* https://link.excalidraw.com/p/readonly/HTEjH2WpzNJExWK81BaN - slides

# Supported subcommands and features 🧰

With `CARGO_BACKEND=nix`, the build-related subcommands go through nix; all others are plain cargo. Details and the state of development are in [README-DEV.md](README-DEV.md).

| subcommand | nix mode | notes |
|---|---|---|
| `build` | ✅ | every unit is built in nix; `build write-nix-buildsystem` exports the build system for flakes and nixpkgs |
| `run` | ✅ | binaries and examples; `std::env::current_exe()` is the binary in the store |
| `test` | ✅ | unit, integration and doc tests; the tests run outside of nix, the sources at `env!("CARGO_MANIFEST_DIR")` are read-only |
| `clean` | ✅ partial | the target directory or a profile, together with the store paths it rooted; `clean -p` and `clean gc` are refused |
| `check` | ❌ planned | refused with "not supported yet" |
| `doc`, `rustdoc`, `rustc`, `bench`, `install`, `uninstall`, `package`, `vendor` | ❌ | refused with "not supported yet" |
| `new`, `init`, `add`, `remove`, `update`, `fetch`, `generate-lockfile`, `tree`, `metadata`, `fmt`, `publish`, … | unchanged | vanilla cargo, the backend is not involved |
| `fix` | ❓ | untested, it builds in check mode internally |

| feature | state | notes |
|---|---|---|
| crates.io dependencies | ✅ | downloaded and built in `/nix/store`, shared between projects and machines |
| path dependencies, workspaces, `-p`, `--features` | ✅ | |
| build scripts (`build.rs`), proc macros | ✅ | build scripts run in the nix sandbox |
| system libraries, environment variables | ✅ | per crate in `Cargo.dependencies.nix`, see [Injecting dependencies](#injecting-dependencies) |
| git dependencies | ✅ | needs `nix-prefetch-git` in `PATH` |
| vendored sources, source replacement | ✅ | |
| `--offline` | ✅ | crates.io is served from the store tarballs of `Cargo.lock`, so the build system can be generated inside a nix build (IFD) |
| `--release` | ✅ | profile options (`lto`, `codegen-units`, `panic`, …) are passed on, but untested |
| GC roots | ✅ | per selection of units in `target/<profile>/nix/gc`, the 8 most recent are kept; `cargo clean` removes them |
| cargo-like output | ✅ | nix logs are shown in cargo's format |
| other registries | ❌ | only crates.io; others fail when the build system is generated |
| incremental builds / fingerprints | ❌ | changed crates are always compiled from scratch, so iterating is slower than with cargo (legacy) ([#3](https://github.com/nixcloud/cargo/issues/3)) |
| cross-compilation, `--target` (e.g. wasm) | ❓ | untested, known failures (wasm) |
| platforms | ❓ | developed and tested on x86_64-linux only, Darwin is untested |
| toolchain | ⚠️ | `rustc` and `cargo` must have the same version (currently 1.87.0) |

## Regression tests

[test.nix](test.nix) builds the projects of [#18](https://github.com/nixcloud/cargo/issues/18) at pinned revisions with this cargo and runs their binaries; `tests-libnix/run.sh` writes a `RESULTS.md`. Currently 23 of 31 projects pass, the others need a newer rustc than 1.87. Some projects need a `Cargo.dependencies.nix`, see [tests-libnix](tests-libnix).

# Using cargo (libnix)

There are several ways to use cargo+libnix on your system:

1. cargo+libnix used via **devshell**
2. cargo+libnix used via **flake**
3. cargo+libnix used via **traditional nix code**

## 1. cargo+libnix used via **devshell**

```bash  
nix develop github:nixcloud/cargo
```

This adds the `cargo` and `rustc` binary into your environment and you can start to build software.

## 2. cargo+libnix used via **flake**

When you use fenix to manage your Rust installation, simply add a few lines to extend the installation with the custom cargo binary as shown below:

```nix
{
  description = "myproject";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    libnix-flake.url = "github:nixcloud/cargo";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, libnix-flake }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            libnix-flake.packages.${system}.rustc_1_87_vanilla_pin
            libnix-flake.packages.${system}.cargo-libnix-1_87_0_plus_v3
          ];
          shellHook = ''
            export CARGO_BACKEND=nix
          '';
        };
      });
}
```

Afterwards check with `which cargo` that it points to the right path.

    which cargo
    /nix/store/dpihj64vqhxir9bmdj3aciv5sf1myx7b-cargo-0_88_0-bin-b4cc6eeacb818d24/bin/cargo

## 3. cargo+libnix used via **traditional nix code**

With this you can extend your build system with a `cargo` (libnix) binary, you need to add a `rustc` and other rust toolchain parts in addition similar to the flake setup:

```nix
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
...
systemPackages = [ cargo-libnix-1_87_0_plus_v3 rustc_1_87_vanilla_pin ];
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

# Workflow for using cargo+libnix in your project

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

# Branches and releases 🌿

cargo (libnix) does not follow every upstream cargo release, only selected Rust toolchains. Each supported toolchain is a patch stack on top of upstream's release of that toolchain.

| branch | what it is |
|---|---|
| `master-libnix` | the main line, on the newest supported toolchain (currently Rust 1.87.0) |
| `rust-<version>-libnix` | one maintenance branch per supported toolchain, e.g. `rust-1.87.0-libnix`; mirrors upstream's `rust-<version>` branch |
| `master` | upstream cargo, untouched |

The naming follows upstream: cargo has a release branch per toolchain (`rust-1.87.0`, `rust-1.99.0`) and tags the cargo crate version (`0.88.0` is the cargo of Rust 1.87.0, `0.100.0` the one of Rust 1.99.0).

Releases are tags named after the toolchain plus a libnix revision: `libnix-1.87.0+v1`, `libnix-1.87.0+v2`, … The tags stay valid no matter what happens to the branches; flakes and nix code should pin a tag or a release tarball, not a branch.

## supporting a new toolchain

1. base on upstream's release of that toolchain (the cargo crate tag, e.g. `0.100.0`, or the `rust-<version>` branch), not on an upstream `master` commit, so the upstream backports are included
2. rebase the libnix patch stack onto it on a work branch; squashing the stack into a few logical patches first (nix backend, daemon/runner, templates, write-nix-buildsystem, crate store/GC roots, flake) keeps the conflicts manageable and `git diff <upstream tag>..` readable
3. once cargo builds itself with `CARGO_BACKEND=nix` and the example projects work, the previous toolchain's state is kept in its `rust-<version>-libnix` branch and the work branch becomes the main line
4. tag the first release of the new line, e.g. `libnix-1.99.0+v1`

## maintenance branches

`rust-<version>-libnix` branches only get fixes (cherry-picked), no new features; a fix released there gets the next tag of that line, e.g. `libnix-1.87.0+v4`.

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
