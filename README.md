# WARNING

For now it is just an experiment!

This cargo extension wants to be a 'nix based build system' directly used from cargo.

* This code can generate nix files to build 'cargo' itself and generate a working binary!
* Each dependency crate is its own nix store path so you will never have to recompile them again unless changes are in place
* It does not use the .fingerprint mechanism to have 'faster' (impure) compiles which means you probably stil want
to stick to the normal 'cargo build' workflow but when you want to try it with nix it is as simple as
changing an environment variable and compile.

State of development:
* Currently only 'fast' is implemented, 'sandbox' was never used
* `cargo build` only generates nix files which have to be run manually through 'nix build'

Here is the todo list:

* [ ] add `cargo nix generate --path /tmp/nix` support to cargo
  * [ ] check if the --path belongs to the root of a workspace, if not don't delete anything. writing new files should be allowed, but deleting not.
  * [ ] maintain a list of files in use and only update (delte/chage ones which are known)
  * [ ] add a reference to the Cargo.toml file
  * [ ] on successful build (cargo nix generate), add the generated nix files into target/nix (aka the result)


* [ ] using cargo nix extension from nix:
  * [x] add flake.nix which compiles this custom cargo so it can be used in nix
  * [ ] integrate https://github.com/nixcloud/cargo-nix-build-test-environment-declarative into cargo subcommand or standalone binary

* [ ] smooth drop-in integration of the nix backend into cargo
  * [ ] call nix build from cargo and also link resulting binaries to `target/debug/binaryname` after compile using `link_targets()` into target/debug/XXX
  * [ ] check that `cargo run foo` works
  * [ ] cargo build
  * [ ] support `cargo dry run` with nix-backend
  * [ ] cargo test
  * [ ] cargo doc
  * [ ] cargo install
  * [ ] cargo clean
      * [ ] 'rm result link' aka target/debug/nix/source target/debug/${references}, propose nix-collect-garbage

* [ ] consider a 'installPhase' equivalent to 'cargo install' when doing a nix build .#something-0.88-bin

* [ ] update the build queue output of nix, similar to cargo build output
  * [ ] see the json streaming

* [ ] extend https://github.com/nixcloud/cargo-nix-build-test-environment-declarative
    
    see cargo-build_script_build-parser source code

* [ ] give instructions how to use my custom `cargo` from nix/nixos
* [ ] major refactor, one commit & cleanup of code base; rebase on most recent cargo?
* [ ] create tests to ensure most 'edge' cases can be built properly with the nix backend
* [ ] publish work, ask for feedback and plan PR for cargo contribution
* [ ] create video

# How to use

Type:

    nix develop
    cargo build

## Use custom cargo

    alias cargo=/home/nixos/cargo/target/debug/cargo

Call with: `CARGO_NIX_BUILDER=fast cargo build` to generate files in /tmp/nix and use the output from a flake to build.
Call with: `cargo build` to study the traditional build and see /tmp/out but this needs a manual cleanup before each run.

Alternative calls for using the nix backend in cargo:

    CARGO_NIX_BUILDER=fast cargo build
    CARGO_NIX_BUILDER=sandbox cargo build
    CARGO_NIX_BUILDER= cargo build

    cargo -Znix --config build.nix=\"fast\" build
    cargo -Znix --config build.nix=\"sandbox\" build

The nix backend currently supports this:
* generates a nix build system which needs to be evaluated outside of cargo (for now)
* builds rphtml, html5ever, klick and cargo so far
* supports build-script-build aka build.rs execution using build-parser 
* supports crates residing in: local fs, crates.io and using git (all but local is in /nix/store)
* build dependencies inside a nix-build isolated environment
* integrates well with the flake concept

## flake

    {
      description = "The cargo-nix using example project flake";
      inputs = {
        nixpkgs.url      = "github:NixOS/nixpkgs/nixos-25.05";
        rust-overlay.url = "github:oxalica/rust-overlay";
        build-parser.url = "github:nixcloud/cargo-build_script_build-parser";
      };
      outputs =
      { self, nixpkgs, flake-utils, rust-overlay, build-parser }:
        flake-utils.lib.eachDefaultSystem
          (system:
            let
              overlays = [ (import rust-overlay) build-parser.overlay ];
              pkgs = import nixpkgs {
                inherit system overlays;
              };
              allPackages = import /tmp/nix/default.nix { inherit pkgs; };
            in
            with pkgs;
            rec {
              packages = allPackages // {
                inherit defaultPackage;
              };
              devShells.default = mkShell {
                buildInputs = [
                  rust-bin.stable."1.86.0".default
                  nix-prefetch-scripts
                ];
              };
            }
          );
    }

    nix build .#anyhow-1_0_97 -L --impure --print-out-paths
    nix build .#rphtml-0_5_10 -L --impure --print-out-paths

There is an easy way to inject dependencies into the cargo generated nix attributes:

1. create a file `Cargo.dependencies.nix` next to Cargo.lock / Cargo.toml

2. fill it with your desired nix dependencies like `openssl` or `curl`:

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
        }

Note: The name and version of a crate can be copied from Cargo.lock but keep in mind
there is no check for unused or wrongly spelled dependencies or out of date versions just yet.

Note: This file is optional and explicitly outside of the generated nix files so it stays in your repository.

## tests

need to write these tests:

* several serde instances of the same version but different features (like klick does)
* a bundled c library
* a system c library (with pkg-config usage)
* different arch to build for
* usage of zig (WASM)

<hr>

# Cargo

Cargo downloads your Rust project’s dependencies and compiles your project.

**To start using Cargo**, learn more at [The Cargo Book].

**To start developing Cargo itself**, read the [Cargo Contributor Guide].

[The Cargo Book]: https://doc.rust-lang.org/cargo/
[Cargo Contributor Guide]: https://rust-lang.github.io/cargo/contrib/

> The Cargo binary distributed through with Rust is maintained by the Cargo
> team for use by the wider ecosystem.
> For all other uses of this crate (as a binary or library) this is maintained
> by the Cargo team, primarily for use by Cargo and not intended for external
> use (except as a transitive dependency). This crate may make major changes to
> its APIs.

## Code Status

[![CI](https://github.com/rust-lang/cargo/actions/workflows/main.yml/badge.svg?branch=auto-cargo)](https://github.com/rust-lang/cargo/actions/workflows/main.yml)

Code documentation: <https://doc.rust-lang.org/nightly/nightly-rustc/cargo/>

## Compiling from Source

### Requirements

Cargo requires the following tools and packages to build:

* `cargo` and `rustc`
* A C compiler [for your platform](https://github.com/rust-lang/cc-rs#compile-time-requirements)
* `git` (to clone this repository)

**Other requirements:**

The following are optional based on your platform and needs.

* `pkg-config` — This is used to help locate system packages, such as `libssl` headers/libraries. This may not be required in all cases, such as using vendored OpenSSL, or on Windows.
* OpenSSL — Only needed on Unix-like systems and only if the `vendored-openssl` Cargo feature is not used.

  This requires the development headers, which can be obtained from the `libssl-dev` package on Ubuntu or `openssl-devel` with apk or yum or the `openssl` package from Homebrew on macOS.

  If using the `vendored-openssl` Cargo feature, then a static copy of OpenSSL will be built from source instead of using the system OpenSSL.
  This may require additional tools such as `perl` and `make`.

  On macOS, common installation directories from Homebrew, MacPorts, or pkgsrc will be checked. Otherwise it will fall back to `pkg-config`.

  On Windows, the system-provided Schannel will be used instead.

  LibreSSL is also supported.

**Optional system libraries:**

The build will automatically use vendored versions of the following libraries. However, if they are provided by the system and can be found with `pkg-config`, then the system libraries will be used instead:

* [`libcurl`](https://curl.se/libcurl/) — Used for network transfers.
* [`libgit2`](https://libgit2.org/) — Used for fetching git dependencies.
* [`libssh2`](https://www.libssh2.org/) — Used for SSH access to git repositories.
* [`libz`](https://zlib.net/) (aka zlib) — Used for data compression.

It is recommended to use the vendored versions as they are the versions that are tested to work with Cargo.

### Compiling

First, you'll want to check out this repository

```
git clone https://github.com/rust-lang/cargo.git
cd cargo
```

With `cargo` already installed, you can simply run:

```
cargo build --release
```

## Adding new subcommands to Cargo

Cargo is designed to be extensible with new subcommands without having to modify
Cargo itself. See [the Wiki page][third-party-subcommands] for more details and
a list of known community-developed subcommands.

[third-party-subcommands]: https://github.com/rust-lang/cargo/wiki/Third-party-cargo-subcommands


## Releases

Cargo releases coincide with Rust releases.
High level release notes are available as part of [Rust's release notes][rel].
Detailed release notes are available in the [changelog].

[rel]: https://github.com/rust-lang/rust/blob/master/RELEASES.md
[changelog]: https://doc.rust-lang.org/nightly/cargo/CHANGELOG.md

## Reporting issues

Found a bug? We'd love to know about it!

Please report all issues on the GitHub [issue tracker][issues].

[issues]: https://github.com/rust-lang/cargo/issues

## Contributing

See the **[Cargo Contributor Guide]** for a complete introduction
to contributing to Cargo.

## License

Cargo is primarily distributed under the terms of both the MIT license
and the Apache License (Version 2.0).

See [LICENSE-APACHE](LICENSE-APACHE) and [LICENSE-MIT](LICENSE-MIT) for details.

### Third party software

This product includes software developed by the OpenSSL Project
for use in the OpenSSL Toolkit (https://www.openssl.org/).

In binary form, this product includes software that is licensed under the
terms of the GNU General Public License, version 2, with a linking exception,
which can be obtained from the [upstream repository][1].

See [LICENSE-THIRD-PARTY](LICENSE-THIRD-PARTY) for details.

[1]: https://github.com/libgit2/libgit2

