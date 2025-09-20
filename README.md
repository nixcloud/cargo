# WARNING

This is the libnix concept integrated into cargo using a 'nix build backend', see discussion at https://lastlog.de/blog/timeline.html?filter=tag::libnix

# What it can do

* extended 'cargo build' so it uses 'nix build' internally by generating nix files on the fly and then build it using 'nix build'!
* each dependency crate download/build uses its own store path and built in a sandbox so you will never have to recompile them again unless their input changes (rustc, cargo, env vars)
* the root crate builds are built in a sandbox also
* build artifacts during build can be reused during deployment (speedup, size reduction)
* most 'heavy weight' asses like the toolchain and intermediate downloads/build artifacts are in the /nix/store and NOT in target/debug or target/release so now garbage collection is done by nix-collect-garbage
* the cargo binary generates a nix-based toolchain and spawns the environment used to build (rustc, cargo, ...)
* supports build-script-build aka build.rs execution using build-parser 
* can easily be used from a flake
* features the @cargo protocol (similar to the @nix protocol) which mimics `cargo build`'s status output

# What it can't do

* no .fingerprint support yet, so no fast iteration on builds

## State of development

see a `cargo build` output at https://asciinema.org/a/740836

* experimental backend builds 'cargo' (itself) and klick without any issues
* project setup to use it is still a lot of work
* 'cargo build' prints a store path and requires one more manual step

# How to use

Type:

    nix develop
    cargo build

## Use custom cargo

    alias cargo=/home/nixos/cargo/target/debug/cargo

Call with: `CARGO_BACKEND=nix cargo build` to generate files in target/debug/nix
Call with: `cargo build` to study the traditional build and see /tmp/out but this needs a manual cleanup before each run.

Alternative calls for using the nix backend in cargo:

    CARGO_BACKEND=nix cargo build
    CARGO_BACKEND=legacy cargo build

### nix build system

    time nix build --file target/debug/nix/default.nix --impure -L --no-link --print-out-paths target --json --log-format internal-json

afterwards install it with running something like:

    /nix/store/5646xcjihqq11icyxyr3s0jc89s8j1hj-cargo-targets-symlinks/bin/cargo-targets-symlinks

### injecting dependencies (pkg-config, openssl, ...)

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
there is no check for unused or wrongly spelled dependencies or out of date versions.

Note: This file is optional and explicitly outside of the generated nix files so it stays in your repository.

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

