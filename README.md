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
    * injecting custom dependencies or environment variables with Cargo.dependencies.nix per crate (both root crates and dependency crates)

## What still requires love

* pretty print library (vs. redundant code in dep/...) - https://x.com/joschelboschel/status/2008536931383095783

* cargo install --locked cargo-leptos

* figure max cpu utilization:
  * `nix build` has such a minor cpu utilization, i only see a load of 25% at max 
  * `cargo build` basically goes to 100%

* logone support is a good start but:
  * cargo build is listed several times even though it is cargo (lib), cargo (build.rs_build), cargo (build.rs_run), cargo (bin)
  * cargo status is sometimes wrong
  * * https://github.com/NixOS/nix/issues?q=is%3Aissue%20state%3Aopen%20author%3Aqknight (the tickets with "internal-json logger improvements" in the title)

* tokio crate: binary is actually called test-cat, nix-backend calls it test_cat
  /nix/store/mrb3dfk0c3c2sm40r26qn5ms84w7j0ij-tests-integration-0_1_0-bin-892dd4ee4c5aadcd/bin/test_cat

* no .fingerprint support yet, so no fast iteration on builds, __LOTS__ of unnecessary recompiles
  * https://github.com/nixcloud/cargo/issues/3

* build.rs: static file/directory list
* Cargo.dependencies.nix is not picked up with `~/tests/influxdb]$ time CARGO_BACKEND=nix /home/nixos/cargo/cargo build -v`
  but it works with: nix build --file target/debug/nix/cargo_build_caller.nix target -L --keep-going, why?
* targets
  * add library targets (to targets.nix) for 'cargo build'
  * if no targets are found (an error in generating the build system) don't evaluate later with nix build....
* build.rs execution error messages are not working in @cargo, needs `nix build --file ... taget` evaluation
* no IFD support (from nix, call 'cargo build', use produced nix files via IFD)

* no rustdoc support
* no testing support
* no rust-analyzer support (whith code for dependencies referencing the nix store at /nix/store)
* using `CARGO_BACKEND=nix cargo build` still downloads deps the legacy way unnecessarly
* in theory we could get rid of -C metadata=8abf83ef020a3059 / -C extra-filename=-27e7993d9cf32df7 (did not want to touch this early)
* create concept for nix vendoring (so i know i can build offline)
* improved gc handling: 
  * reference all active sources from somewhere (to prevent GC)
  * reference active toolchain (to prevent GC)
* cargo tests execution
* cargo doc
* add " Finished `dev` profile [unoptimized + debuginfo] target(s) in 1m 40s" to the end of the build

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

    [ ] clean                Remove artifacts that cargo has generated in the past
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

    # less common commands (which require NO backend adaptions)

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

### injecting dependencies (pkg-config, openssl, ...) or environment variables

There is an easy way to inject dependencies into the cargo generated nix attributes:

1. create a file `Cargo.dependencies.nix` next to Cargo.lock / Cargo.toml

2. fill it with your desired nix dependencies like `openssl` or `curl` or environment variables:

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

Note: The name and version of a crate can be copied from Cargo.lock but keep in mind
there is no check for unused or wrongly spelled dependencies or out of date versions.

Note: This file is optional and explicitly outside of the generated nix files so it stays in your repository.

# success stories

https://github.com/EvanLi/Github-Ranking/blob/master/Top100/Rust.md

                       /- cargo legacy 
name                 |   | cargo libnix
cargo          v1.87 | x | x
build-parser  v0.1.8 | x | x
ripgrep      v14.1.1 | x | x
atuin        v18.5.0 | x | x 
trunk       v0.21.14 | x | x
bat          v0.25.0 | x | x
sd            v1.0.0 | x | x
mdBook        v0.5.2 | x | x
just           v1.46 | x | x
fd            v7.3.0 | x | x
pankat-rs     v0.1.1 | x | x
rustpad       v0.1.0 | x | x
synapse        1.0.0 |   | x
nix-installer 3.15.1 |   | x
    { pkgs }: 
            with pkgs;
            {
                deps = {};
                envs = {
                    "nix-installer" = {
                        NIX_TARBALL_URL = "foo.tar.xz";
                        DETERMINATE_NIX_TARBALL_PATH = "../README.md";
                        DETERMINATE_NIXD_BINARY_PATH = "../README.md";
                    };
                };
            }
coreutils            |   | fails (build.rs, couldn't read ...  include!(concat!(env!("OUT_DIR"), "/uutils_map.rs"));)
starship             |   | fails DEP_Z-NG_ROOT=/nix... (uses illegal env variable name, no - allowed, use envify() from cargo to normalize names)
nushell      0.102.0 |   | build.rs: cargo:rustc-link-arg-benches=-rdynamic not implemented yet, requires pkg-config/openssl
tokio                |   | (wrong bin name, no libs)
slint           1.15 |   | ? /derivations/i-slint-backend-qt-1.15.0-script_build_run-c2a74fa170f66d1e.nix':","\nthread 'main' panicked at internal/backends/qt/build.rs:18:38:\ncalled `Result::unwrap()` on an `Err` value: NotPresent
lightningcss         | x | fails to create build system (target)
leptos               | x | fails to create build system (target)
cargo-leptos         | x | deps/openssl-sys-0.9.110-script_build_run-c7b5d3a81281fe1c.nix':","\n\n\n/build/openssl-src-300.5.4+3.5.4/openssl: No such fi
bevy                 |   | fails to create build system (target)
fuse-rs              |   | fails to create build system (target)
uv                   | ? | 
ka4h2        v0.0.24 | x |
klick         v0.5.7 | x |
influxdb             | ? | Downloading git --url, https://github.com fails...
helix                |   | helix-term/build.rs:5:26:\nFailed to fetch tree-sitter grammars: 277 grammars failed to fetch
rphtml       v0.5.10 | x | (no targets, it is just a library)
axum                 |   | (no targets, it is just a library)
servo                |   | (no targets, it is just a library)
yew                  |   | (no targets, it is just a library)

x means compiles out of the box
+ means needs Cargo.dependencies.nix
? means tried but failed