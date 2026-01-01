# WARNING

This is an unofficial fork of Cargo — not endorsed by the Rust Project.

* https://github.com/nixcloud/cargo exists as a PR with to goal to integrate the libnix concept by adding a 'nix build backend', see discussion at https://lastlog.de/blog/timeline.html?filter=tag::libnix
* https://github.com/nixcloud/cargo/issues for issues, do not report issues on the original cargo tracker (or their formus)!

# State of development

## What it can do

* extendeds 'cargo build' so it uses 'nix build' internally by generating nix files on the fly and then build it using 'nix build'!
* each dependency crate download/build uses its own store path and built in a sandbox so you will never have to recompile them again unless their input changes (rustc, cargo, env vars)
* the root crate builds are built in a sandbox also
* build artifacts during build can be reused during deployment (speedup, size reduction)
* most 'heavy weight' asses like the toolchain and intermediate downloads/build artifacts are in the /nix/store and NOT in target/debug or target/release so now garbage collection is done by nix-collect-garbage
* the cargo binary generates a nix-based toolchain and spawns the environment used to build (rustc, cargo, ...)
* supports build-script-build aka build.rs execution using build-parser 
* can easily be used from a flake
* features the @cargo protocol (similar to the @nix protocol) which mimics `cargo build`'s status output

## What it can't do

* no .fingerprint support yet, so no fast iteration on builds
* no rustdoc support
* no sandbox testing support
* no rust-analyzer support whith code for dependencies referencing the nix store at /nix/store

## Cargo commands

### New Commands

    [ ] nix                  Use 'nix build' with the nix job scheduler to build crates inside a sandbox

### Supported commands

    [x] build                Compile a local package and all of its dependencies

    [ ] run                  Run a binary or example of the local package
    [ ] install              Install a Rust binary
    [ ] uninstall            Remove a Rust binary
    [ ] clean                Remove artifacts that cargo has generated in the past
    [ ] doc                  Build a package's documentation
    [ ] lint-docs            alias: run --package xtask-lint-docs --
    [ ] fetch                Fetch dependencies of a package from the network
    [ ] generate-lockfile    Generate the lockfile for a package
    [ ] vendor               Vendor all dependencies for a project locally
    [ ] verify-project       DEPRECATED: Check correctness of crate manifest.
    [ ] bench                Execute all benchmarks of a local package
    [ ] build-man            alias: run --package xtask-build-man --
    [ ] bump-check           alias: run --package xtask-bump-check --
    [ ] package              Assemble the local package into a distributable tarball
    [ ] rustdoc              Build a package's documentation, using specified custom flags.
    [ ] test                 Execute all unit and integration tests and build examples of a local package

    [!] check                Check a local package and all of its dependencies for errors
    [!] clippy               Checks a package to catch common mistakes and improve your Rust code.
    [!] config               Inspect configuration values
    [!] files
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
    [!] rustc                Compile a package, and pass extra options to the compiler
    [!] search               Search packages in the registry. Default registry is crates.io
    [!] stale-label          alias: run --package xtask-stale-label --
    [!] tree                 Display a tree visualization of a dependency graph
    [!] update               Update dependencies as recorded in the local lock file
    [!] version              Show version information
    [!] yank                 Remove a pushed crate from the index

    legend

    [x] means explicit libnix enhanced code to support this feature
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
