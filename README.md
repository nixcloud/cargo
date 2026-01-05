# WARNING

This is an unofficial fork of Cargo — not endorsed by the Rust Project.

* https://github.com/nixcloud/cargo exists as a PR with to goal to integrate the libnix concept by adding a 'nix build backend', see discussion at https://lastlog.de/blog/timeline.html?filter=tag::libnix
* https://github.com/nixcloud/cargo/issues for issues, do not report issues on the original cargo tracker (or their formus)!

# State of development

## What works great

* 'cargo build' uses 'nix build' internally (dynamically generating nix files on the fly and then build it using 'nix build')
  * crate dependencies like serde, fmt, ... are downloaded/built into and from nix store paths (using the nix sandbox)
  * root crate builds (uses nix store also, builds innix sandbox)
  * full build.rs support using third party tool build-parser
  * build artifacts during build can be reused during deployment (speedup, size reduction)
  * advanced nix build logging with using `logone` in the `cargo build` style using the @cargo protocol (i.e. enhanced @nix protocol)
  * improved GC
    * toolchain (cargo/rustc) managed from nix
    * intermediate artefacts (crates.io libraries downloads): ~/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/getrandom-0.3.1/ has been moved to the /nix/store
    * intermediate artefacts (crates.io libraries builds with different feature sets): target/debug/deps has been moved to the /nix/store
    * however, registry clone is still at ~/.cargo/registry

## What requires love still

* no IFD support (from nix, call 'cargo build', use produced nix files via IFD)
* no .fingerprint support yet, so no fast iteration on builds, __LOTS__ of unnecessary recompiles
* no rustdoc support
* no testing support
* no rust-analyzer support (whith code for dependencies referencing the nix store at /nix/store)
* using `CARGO_BACKEND=nix cargo build` downloads deps the legacy way unnecessarly
* logone support is a good start but:
  * cargo build is listed several times even though it is cargo (lib), cargo (build.rs_build), cargo (build.rs_run), cargo (bin)
  * cargo status is sometimes wrong
* in theory we could get rid of -C metadata=8abf83ef020a3059 / -C extra-filename=-27e7993d9cf32df7 (did not want to touch this early)
* create concept for nix vendoring (so i know i can build offline)
* improved gc handling: 
  * reference all active sources from somewhere (to prevent GC)
  * reference active toolchain (to prevent GC)
* cargo tests execution
* cargo doc

## Cargo commands

### New Commands

    [ ] nix                  Use 'nix build' with the nix job scheduler to build crates inside a sandbox

### Commands status

    # very common commands

    [x] build                Compile a local package and all of its dependencies
    [ ] run                  Run a binary or example of the local package
    [ ] doc                  Build a package's documentation
    [ ] test                 Execute all unit and integration tests and build examples of a local package
    [ ] check                Check a local package and all of its dependencies for errors
    [ ] clippy               Checks a package to catch common mistakes and improve your Rust code.
    
    # less common commands (which require backend adaptions)

    [0] clean                Remove artifacts that cargo has generated in the past
    [0] install              Install a Rust binary
    [0] uninstall            Remove a Rust binary
    [0] rustdoc              Build a package's documentation, using specified custom flags.
    [0] lint-docs            alias: run --package xtask-lint-docs --
    [0] fetch                Fetch dependencies of a package from the network
    [0] generate-lockfile    Generate the lockfile for a package
    [0] vendor               Vendor all dependencies for a project locally
    [0] bench                Execute all benchmarks of a local package
    [0] build-man            alias: run --package xtask-build-man --
    [0] bump-check           alias: run --package xtask-bump-check --
    [0] rustc                Compile a package, and pass extra options to the compiler
    [0] package              Assemble the local package into a distributable tarball

    if matches!(gctx.backend()?, BuildBackend::Nix) {
        return Err(CliError::new(
            anyhow::format_err!("cargo 'clean' is not supported yet"),
            101,
        ));
    }

    [!] verify-project       DEPRECATED: Check correctness of crate manifest.
    [!] config               Inspect configuration values
    [!] fix                  Automatically fix lint warnings reported by rustc
    [!] fmt                  Formats all bin and lib files of the current crate using rustfmt.
    [!] help                 Displays help for a cargo subcommand
    [!] info                 Display information about a package
    [!] init                 Create a new cargo package in an existing directory
    [!] locate-project       Print a JSON representation of a Cargo.toml file's location
    [!] login                Log in to a registry.
    [!] logout               Remove an API token from the registry locally
    [!] metadata             Output the resolved dependencies of a package, the concrete used versions including overrides, in machine-readable format
    [!] new                  Create a new cargo package at <path>
    [!] owner                Manage the owners of a crate on the registry
    [!] pkgid                Print a fully qualified package specification
    [!] publish              Upload a package to the registry
    [!] read-manifest        DEPRECATED: Print a JSON representation of a Cargo.toml manifest.
    [!] remove               Remove dependencies from a Cargo.toml manifest file
    [!] report               Generate and display various kinds of reports
    [!] rm                   alias: remove
    [!] search               Search packages in the registry. Default registry is crates.io
    [!] stale-label          alias: run --package xtask-stale-label --
    [!] tree                 Display a tree visualization of a dependency graph
    [!] update               Update dependencies as recorded in the local lock file
    [!] version              Show version information
    [!] yank                 Remove a pushed crate from the index

    legend

    [x] means explicit libnix enhanced code to support this feature
    [0] means unsupported feature, needs code like in run to show the user that there is no support (unsupported)
    [ ] not supported yet, but command won't tell you but at times fail strangely
    [!] no changes were required, using vanilla cargo

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
