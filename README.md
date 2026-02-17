# WARNING

This is an unofficial fork of Cargo — not endorsed by the Rust Project.

This fork is intended as a PR to contribute this to the official cargo project and to engineer the solution and to get feedback on the work from the nix community.

We use these resources:

* https://github.com/nixcloud/cargo - branch **libnix** - exists as a PR to incorperate nix into cargo
* https://github.com/nixcloud/cargo/issues - for issues, do not report issues on the original cargo tracker (or their formus)!

Motivation behind this work:

* https://lastlog.de/blog/libnix_cargo-nix-backend.html
* https://lastlog.de/blog/timeline.html?filter=tag::libnix

Similar projects:

* naersk
* crane
* cargo2nix
* crate2nix

This project is [xkcd 927](https://xkcd.com/927/).

# compare

* registry management
* per crate store download
* per crate store build
* per crate dependencies
* per crate environment variables
* rustc incremental builds
* IFD support
* IFD free support
* build.rs handling

# State of development

## What works great

* 'cargo build' uses 'nix build' internally (dynamically generating nix files on the fly and then build it using 'nix build')
  * crate dependencies like serde, fmt, ... are downloaded/built into and from nix store paths (using the nix sandbox)
  * root crate builds (uses nix store also, builds innix sandbox)
  * full build.rs support using third party tool build-parser
  * build artifacts during build can be reused during deployment (speedup, size reduction)
  * dynamically generating a deps folder with symlinks to rlib/rmeta/so/... so we can supply one argument like:
    -L dependency=${fn.rustc_linker_arguments passthru.rust_crate_libraries} instead of many -L ... arguments.
    Reduces noise in the compiler call.
  * advanced nix build logging with using `logone` in the `cargo build` style using the @cargo protocol (i.e. enhanced @nix protocol)
  * improved GC
    * toolchain (cargo/rustc) managed from nix
    * intermediate artefacts (crates.io libraries downloads): ~/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/getrandom-0.3.1/ has been moved to the /nix/store
    * intermediate artefacts (crates.io libraries builds with different feature sets): target/debug/deps has been moved to the /nix/store
    * however, registry clone is still at ~/.cargo/registry
    * injecting custom dependencies or environment variables with Cargo.dependencies.nix per crate (both root crates and dependency crates)
* export the build system:
  * CARGO_BACKEND=nix cargo build write-nix-buildsystem --out-dir /tmp/nix --url https://github.com/nixcloud/cargo/archive/refs/tags/1.83-test-release.tar.gz --hash 1h5j1kl7q7mysa943gvd4c8ih8yxx4igqrx4akv9ixf4zf411b8l

* build-rs-libnix (as standalone tool is no inside the cargo source base), build with:
    CARGO_BACKEND=nix cargo build -p build-rs-libnix
  execute with
    
## What still requires love

### high prio

until 1.may 2026

* integrate
  * integrate build_parser standalone into cargo (so no additional binary) - for users of libnix cargo
    * still find to find a way to bootstrap cargo from nix, which means: a standalone program for only that purpose
    * rework cargo nix code generation like:
      * cargo build: add 'build-rs-libnix' for bootstrapping 'cargo' (with nix-backend)
      * any other build: use cargo internal
  * while at it, rework nix code    
    * add nix-prefetch-git as argument to default.nix
      { pkgs, rustc, cargo, external_crate_dependencies, build_parser, nix_prefetch_git, project_root }:
    * remove build_parser as argument to default.nix
      { pkgs, rustc, cargo, external_crate_dependencies, build_parser, nix_prefetch_git, project_root }:    

* logone
  * rework --json --mode cargo (both as defaults)
  * see if i can do better error machting so it can be also used to develop with nix build from shell

* release workflow
  * README.md: "how do projects use **cargo libnix** in their flake.nix or from nixpkgs so they can develop & deploy?
    * create something 'simple' like fenix so ppl can experiment with this toolchain

* no .fingerprint support yet, so no fast iteration on builds, __LOTS__ of unnecessary recompiles
  * https://github.com/nixcloud/cargo/issues/3

    starte to play with  --extra-sandbox-paths /tmp/sandbox-file
    https://github.com/NixOS/nix/issues/6115

    /home/nixos/cargo/src/cargo/core/compiler/mod.rs:1238 opt(cmd, "-C", "incremental=$INC_DIR", None);

    * incremental target, add this to rustc call:
      $(if [ -d /incremental-target ]; then echo "-C incremental=/incremental-target"; fi) \
    * add 

* refactor the codebase
  * rewrite to drop_println
  * make /tmp/out for legacy runs more obvious, also clean directory before start
  * rebase libnix into libnix-1.89.0 and release

* do a release libnix-1.89.0 tag

### mid prio

* IFD support
  * update documents in dest dir or
  * create IFD support example (see if it works)
  * currently this is generated during the default.nix evaluation
      [nixos@nixos:~/cargo]$ nix build --file IFD-experiment.nix -L
      trace: Using Cargo.dependencies.nix
      write-nix-buildsystem> Running phase: unpackPhase
      write-nix-buildsystem> unpacking source archive /nix/store/dv6brs09hvs9hy93xqi8bgl7ck26w49y-cargo
      write-nix-buildsystem> source root is cargo
      write-nix-buildsystem> Running phase: buildPhase
      write-nix-buildsystem> ❄❄❄  nixcloud edition ❄❄❄
      write-nix-buildsystem> This is an unofficial fork of Cargo — not endorsed by the Rust Project.
      write-nix-buildsystem> Support me: Consider a star at https://github.com/nixcloud/cargo/stargazers
      write-nix-buildsystem> Support you: File issues at: https://github.com/nixcloud/cargo/issues/
      write-nix-buildsystem> Using 'nix' backend to build crates
      write-nix-buildsystem> error: no matching package named `serde` found


* https://github.com/nixcloud/cargo/issues/10
* https://github.com/nixcloud/cargo/issues/8

* build_script_build is not always the build.rs binary name:

    program: "/home/nixos/cargo-leptos/target/debug/build/openssl-sys-bb979fa1fa087c4d/build-script-main",
    command123: Command {
        program: "rustc",
        args: [
            "rustc",
            "--crate-name",
            "build_script_main",
            "--edition=2021",
            "/home/nixos/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/openssl-sys-0.9.110/build/main.rs",
            "--error-format=json",
    [package]
    edition = "2021"
    rust-version = "1.70.0"
    name = "openssl-sys"
    version = "0.9.110"
    authors = [
        "Alex Crichton <alex@alexcrichton.com>",
        "Steven Fackler <sfackler@gmail.com>",
    ]
    build = "build/main.rs"        

    # new knowledge

    it seems that the crate name in legacy is usually: build_script_build but the binary name is then build-script-build

    FINDING: so the binary name is probably: "build-script" + build_filename or "build" as default, since it is build.rs

    * in libnix backend: i hardcoded them to "build_script_build" where it should be "build-script-build" or even "build-script-${build_filename}
    * build_script_main is also the crate name in openssl-sys-0.9.110-script_build-bb979fa1fa087c4d.nix so maybe we just need to use name() instead of crate_name() somewhere....


* support klick
    
    cargo zigbuild --release --target x86_64-unknown-linux-musl

* how to support this in nix build?

    cd pankat-wasm && wasm-pack build --target web --release --manifest-path ./Cargo.toml 
    [INFO]: 🎯  Checking for the Wasm target...
    [INFO]: 🌀  Compiling to Wasm...
    warning: unused variable: `target`
      --> src/lib.rs:27:13
      |
    27 |         let target: Element = document.get_element_by_id(self.id.as_str()).unwrap();
      |             ^^^^^^ help: if this is intentional, prefix it with an underscore: `_target`
      |
      = note: `#[warn(unused_variables)]` on by default

    warning: `pankat-wasm` (lib) generated 1 warning
        Finished `release` profile [optimized] target(s) in 0.30s


    solution:
    export PATH=/home/nixos/cargo/target/debug:$PATH
    [nixos@nixos:~/pankat-rs/pankat-wasm]$ CARGO_BACKEND=nix wasm-pack build --target web --debug --manifest-path ./Cargo.toml
    [INFO]: 🎯  Checking for the Wasm target...
    [INFO]: 🌀  Compiling to Wasm...
    ❄❄❄  nixcloud edition ❄❄❄
    This is an unofficial fork of Cargo — not endorsed by the Rust Project.
    Support me: Consider a star at https://github.com/nixcloud/cargo/stargazers
    Support you: File issues at: https://github.com/nixcloud/cargo/issues/
    Using 'nix' backend to build crates
    error[E0463]: can't find crate for `core`
      |
      = note: the `wasm32-unknown-unknown` target may not be installed
      = help: consider downloading the target with `rustup target add wasm32-unknown-unknown`

    error: aborting due to 1 previous error


* BUG: on `cargo build` garbage-collect .nix files in target/debug/nix/* which are not used anymore
* FEATURE: add fixup_out_path_build_rs_paths() function
    for file in $out/environment-variables $out/rustc-arguments $out/rustc-propagated-arguments; do
        if [ -f "$file" ]; then
        sed -i "s|${fn.get_rust_crate_parent passthru.rust_crate_parent}|$out|g" "$file"
        fi
    done
* REFACTOR:
  * BUG: Cargo.dependencies.nix pickup is not working or shown up with `~/tests/influxdb]$ time CARGO_BACKEND=nix /home/nixos/cargo/cargo build -v`
    but it works with: nix build --file target/debug/nix/cargo_build_caller.nix target -L --keep-going

* EXPERIMENT: when logging a absolute path in the build_script_build run phase, can i pass the path to the source into like

    {path}

    and inside the build_script_build use:
        print_cargo_message_type_3 "${meta.cargo_crate_info.name}" "There was an error executing build_script_build in file: '${path}/target/debug/nix/derivations/cargo-0.88.0-script_build_run-f5d51778f22880c0.nix':" $build_script_build_exit_value $build_script_build_output_lines
    instead of     
        print_cargo_message_type_3 "${meta.cargo_crate_info.name}" "There was an error executing build_script_build in file: '/home/nixos/cargo/target/debug/nix/derivations/cargo-0.88.0-script_build_run-f5d51778f22880c0.nix':" $build_script_build_exit_value $build_script_build_output_lines

  and then expect that the source won't be recompiled if i move it to a different directory? i guess it needs to be recompiled

* implement nix/rustc_link_arg_benches for cargo:rustc-link-arg-benches=-rdynamic in the generated nix code

* REFACTOR:
  * use  https://nix.dev/manual/nix/2.18/language/constructs (asserts) on function calls arguments
  * make cargo_parser a direct argument and don't inject into pkgs and later compile so we can override it easily
  * pass "src" / "project_root" as argument to target/debug/nix/cargo_build_caller.nix so we can use
    external_crate_dependencies =
        (if builtins.pathExists ${project_root}/Cargo.dependencies.nix
        then builtins.trace "Using Cargo.dependencies.nix"
            import ${project_root}/Cargo.dependencies.nix { inherit pkgs; }


* BUG: if there is a problem with a rustc call which lacks the openssl DEP_ env variables, errors are
  very hard to understand. i think it did not even print an error, had this with

* experiment with rewriting the bash in nushell 
  * better error messages
  * typed function

### low prio


* FEATURE: git usage in src
  * cache the git entry if found in the store, which requires that we
  * write the hash into Cargo.dependency.nix so we can lookup the store path
  Downloading "git --url https://github.com/typst/typst-assets, --rev 57a38ca98236748ad83c806a48096b281686a7de  --sparse-checkout"


* cargo build vs. cargo build -v vs. cargo build -vv (nix-backend should work similar)

* RUSTFLAGS might not be supported ATM (nix-backend)

  i looked at the cargo source code for RUSTFLAGS mentions but did not find a function which appends the RUSTFLAGS and 
  my generated nix files don't do it either. so did it get lost in translation?
  
   https://grok.com/share/bGVnYWN5_d6b5f489-ac0c-49d0-99a2-8f97e3dbb571

* remove --emit=dep-info from builds

* implement equivalent of `cargo build --timings` for nix backend

* cargo install --locked cargo-leptos

* logone support is a good start but:
  * "cargo" as build target is listed 4 times when it should be: cargo (lib), cargo (build.rs_build), cargo (build.rs_run), cargo (bin)
    * codex-app-server(bin) - creates a bin target
    * zerocopy(build.rs) - This means Cargo is compiling zerocopy's build.rs script.
    * mylib (lib) - creates a library target
  * cargo status line is a bit broken... (list of all targets should only increase, parallel builds broken?!)
  * build.rs execution error messages are not working in @cargo, needs `nix build --file ... taget` evaluation
  * "error: could not compile target" which occures when there is an error in the generated nix code target/debug/nix/cargo_build_caller.nix
    * https://github.com/NixOS/nix/issues/13909
    * https://github.com/NixOS/nix/issues/13910
  * https://github.com/NixOS/nix/issues?q=is%3Aissue%20state%3Aopen%20author%3Aqknight (the tickets with "internal-json logger improvements" in the title)

* figure max cpu utilization:
  * `nix build` has such a minor cpu utilization, i only see a load of 25% at max 
  * `cargo build` basically goes to 100%
  it seems in this video it was doing much more parallel builds: https://asciinema.org/a/742433
  
  nix build --file target/debug/nix/cargo_build_caller.nix deps.adler2-2_0_0-115180b36279fc7c deps.anstyle-1_0_10-bf6d032cb7d79be1 deps.allocator-api2-0_2_21-bd3713078dfee01f -L

  shows that these 3 are build in parallel!

  * created logone/passthru-test to experiment, seems parallel builds work there so far, logone seems to display 4 parallel builds correctly. it must be burried in the abstraction of the
    generated nix build system

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

* convert crate license into nix license so it can be BOM'ed

* what about support to compile for different archs (cross compile)

* get this PR upstream

* don't download git each time, cache it in Cargo.dependencies.nix
  Downloading git --url https://github.com/fish-shell/rust-pcre2 --rev 85b7afba1a9d9bd445779800e5bcafeb732e4421 --sparse-checkout

## Cargo commands

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

# Build cargo with libnix

## build using legacy cargo

    nix develop
    cargo build
    alias cargo=target/debug/cargo

## build using flake

    nix develop
    nix build .#cargo-libnix
    alias cargo=result/bin/cargo

    CARGO_BACKEND=nix cargo build

## build using cargo_build_caller.nix

Using the cargo_build_caller.nix is similar to using the flake.nix as it preparse a build-environment which
mimics a flake.nix and works everywhere.

    nix develop
    nix build target --file nix/cargo_build_caller.nix --out-link ./result
    result/bin/create-symlinks
    alias cargo=result/bin/cargo

Note: Instead of calling cargo_build_caller.nix one can call nix/derivations/default.nix directly but needs
to prepare the environment. This becomes interesting when integrating a cargo libnix based project into nixpkgs.

# Use cargo with libnix

Call with: `CARGO_BACKEND=nix cargo build` to generate files in target/debug/nix and build + install project with the nix-backend
Call with: `cargo build` to study the traditional build and see /tmp/out but this needs a manual cleanup before each run.

Alternative calls for using the nix backend in cargo:

    CARGO_BACKEND=nix cargo build
    CARGO_BACKEND=legacy cargo build

### nix build system

    time nix build --file target/debug/nix/default.nix --impure -L --no-link --print-out-paths target --json --log-format internal-json --option extra-sandbox-paths '/incremental-target=/cargo-incremental-target'

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

https://perf.rust-lang.org/compare.html

cargo with checkout: 093c427c1 (HEAD -> libnix, origin/libnix, origin/HEAD) Updated cargo-build_script_build-parser to fix DEP_Z-NG_ROOT to DEP_Z_NG_ROOT

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
klick         v0.5.7 | x | x | nix-backend: First compiling klick-infrastructure-server failed but 'just run'

```

# fail stories

```
######################### error generating nix build system #######################################################
rust                |   |   |    Compiling smallvec
        error[E0554]: `#![feature]` may not be used on the stable release channel
          --> src/lib.rs:96:37
96 | #![cfg_attr(feature = "may_dangle", feature(dropck_eyepatch))]
leptos               | x |   | fails to create build system (target)
  ./or_poisoned/src/lib.rs a lib in the workspace lacks a nix attribute to compile and include it
bevy                 |   |   | fails to create build system (target)
fuse-rs              | + |   | fails to create build system (target)
  `cargo build` compiles:
  buildInputs = pkg-config fuse
vaultwarden          | x |   | legacy: `cargo build  --features sqlite` works
    nix build --file target/debug/nix/cargo_build_caller.nix target -L
    CARGO_BACKEND=nix ~/cargo/target/debug/cargo build -v --features sqlite
    error: evaluation aborted with the following error message: 'lib.customisation.callPackageWith: Function called without required argument "vaultwarden-1_0_0-script_build-ab50c3dfe01f1634" at /home/nixos/tests/vaultwarden/target/debug/nix/derivations/vaultwarden-1.0.0-script_build_run-373c093bb6046a0d.nix:2'
egui                 | x |   | error: evaluation aborted with the following error message: 'lib.customisation.callPackageWith: Function called without required argument "epaint_default_fonts-0_33_3-ddad1624ebe00829" at /home/nixos/tests/egui/target/debug/nix/derivations/epaint-0.33.3-3fd34fda4c0e1cfc.nix:2'
    646fea2133b4793ff077905fa4bacd8c636f52eb
uv                   | ? |   | generated build system is wrong: error: evaluation aborted with the following error message: 'lib.customisation.callPackageWith: Function called without required argument "uv-version-0_9_22-69df0fced6bb13c4" at /home/nixos/tests/uv/target/debug/nix/derivations/uv-0.9.22-bin-389c9a1de962636b.nix:2'
codex                | x |   | cd codex-rs -> generates incomplete nix based build system for 'ratatui'
    'lib.customisation.callPackageWith: Function called without required argument "codex-utils-string-0_0_0-cefa78c3ad9fc803" at /home/nixos/tests/codex/codex-rs/target/debug/nix/derivations/codex-core-0.0.0-8096744b3ee573af.nix:2'
typst                | x |   | lib.customisation.callPackageWith: Function called without required argument "codex-utils-string-0_0_0-cefa78c3ad9fc803" at /home/nixos/tests/codex/codex-rs/target/debug/nix/derivations/codex-core-0.0.0-8096744b3ee573af.nix:2'
######################### /error generating nix build system ######################################################

######################### system libs #############################################################################

servo                | + |   | (no targets, it is a library + bin called servo)
  `cargo build` compiles:
  export LIBCLANG_PATH="/nix/store/xid2z20mcf5ylgpl5w3jbd1bsh7zk4iv-clang-19.1.7-lib/lib"
  buildInputs = python3 uv fontconfig udev libclang clang pkg-config (maybe openssl)
surrealdb            |   |   | There was an error executing build_script_build in file: '/home/nixos/tests/surrealdb/target/debug/nix/derivations/deps/rquickjs-sys-0.9.0-script_build_run-cc5015d81fa1961f.nix
    Unable to find libclang: "couldn't find any valid shared libraries matching: ['libclang.so', 'libclang-*.so', 'libclang.so.*', 'libclang-*.so.*'], set the `LIBCLANG_PATH` environment variable to a path where one of these files can be found (invalid: [])"

difftastic           | ? |   | 
  `cargo build`: Compiling tikv-jemalloc-sys  error: returning 'char *' from a function with return type 'int' makes integer from pointer without a cast [-Wint-conversion] "make" "-j" "8"
expected success, got: exit status: 2
ruff                 |   |   | 
      make: *** [Makefile:478: src/malloc_io.sym.o] Error 1
      make: *** Waiting for unfinished jobs....
      In file included from /nix/store/r25srliigrrv5q3n7y8ms6z10spvjcd9-glibc-2.40-66-dev/include/bits/libc-header-start.h:33,
                      from /nix/store/r25srliigrrv5q3n7y8ms6z10spvjcd9-glibc-2.40-66-dev/include/math.h:27,
                      from include/jemalloc/internal/jemalloc_internal_decls.h:4,
                      from include/jemalloc/internal/jemalloc_preamble.h:5,
                      from src/pa.c:1:
      /nix/store/r25srliigrrv5q3n7y8ms6z10spvjcd9-glibc-2.40-66-dev/include/features.h:422:4: warning: #warning _FORTIFY_SOURCE requires compiling with optimization (-O) [-Wcpp]
        422 | #  warning _FORTIFY_SOURCE requires compiling with optimization (-O)
            |    ^~~~~~~

      thread 'main' panicked at build.rs:388:9:
      command did not execute successfully: cd "/nix/store/dad6ml39l6aw86zpwh52riqs99n76ww1-tikv-jemalloc-sys-0_6_0_plus_5_3_0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7-script_build_run-0944f779b2abc523/build" && "make" "-j" "8"
      expected success, got: exit status: 2
      note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace

################################################################# /system libs ######################################

zed                  |   |   | 

fish-shell           | x |   | 
    fish> thread 'main' panicked at build.rs:9:33:
    fish> called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: "No such file or directory" }
    fish> note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
    note: keeping build directory '/nix/var/nix/builds/nix-2707034-4188332499/build'

slint           1.15 |   |   | ? /derivations/i-slint-backend-qt-1.15.0-script_build_run-c2a74fa170f66d1e.nix':","\nthread 'main' panicked at internal/backends/qt/build.rs:18:38:\ncalled `Result::unwrap()` on an `Err` value: NotPresent
fuel-core            |   |   |
  v0.45.1
            error: hiding a lifetime that's elided elsewhere is confusing
            --> crates/types/src/blockchain/transaction.rs:32:15
            |
            32 |     fn inputs(&self) -> Cow<[Input]>;
            |               ^^^^^     ------------ the same lifetime is hidden here
            |               |
            |               the lifetime is elided here
            |
            = help: the same lifetime is referred to in inconsistent ways, making the signature confusing 
zellij               | ? |   | 
  v0.40.0
  `cargo build`: error: couldn't read `/home/nixos/tests/zellij/zellij-utils/../target/wasm32-wasi/debug/compact-bar.wasm`: No such file or directory (os error 2)


dioxus               |   |   | 
  `cargo build` does not create anything in target/debug and nix-backend does not build anything
  `cargo nix-backend: does not create anything either

################################################################# build.rs ######################################

influxdb             | ? |   | 
   Compiling proc-macro2
      error: linking with `cc` failed: exit status: 1
        |
        = note:  "cc" "-m64" "/build/rustcwQmWHJ/symbols.o" "<3 object files omitted>" "-Wl,--as-needed" "-Wl,-Bstatic" "<sysroot>/lib/rustlib/x86_64-unknown-linux-gnu/lib/{libstd-*,libpanic_unwind-*,libobject-*,libmemchr-*,libaddr2line-*,libgimli-*,librustc_demangle-*,libstd_detect-*,libhashbrown-*,librustc_std_workspace_alloc-*,libminiz_oxide-*,libadler2-*,libunwind-*,libcfg_if-*,liblibc-*,librustc_std_workspace_core-*,liballoc-*,libcore-*,libcompiler_builtins-*}.rlib" "-Wl,-Bdynamic" "-lgcc_s" "-lutil" "-lrt" "-lpthread" "-lm" "-ldl" "-lc" "-L" "/build/rustcwQmWHJ/raw-dylibs" "-Wl,--eh-frame-hdr" "-Wl,-z,noexecstack" "-L" "<sysroot>/lib/rustlib/x86_64-unknown-linux-gnu/lib" "-o" "/nix/store/71r81vqx67srsq3xp39wxwn5mj4gkmkf-proc-macro2-1_0_104-script_build-ce509221ad1d58e7/build_script_build-ce509221ad1d58e7" "-Wl,--gc-sections" "-pie" "-Wl,-z,relro,-z,now" "-nodefaultlibs" "-fuse-ld=lld" "-Wl,--no-rosegment"
        = note: some arguments are omitted. use `--verbose` to show all linker arguments
        = note: collect2: fatal error: cannot find 'ld'
                compilation terminated.
meilisearch          |   |   | 
  Compiling lindera-ko-dic
    There was an error executing build_script_build in file: '/home/nixos/tests/meilisearch/target/debug/nix/derivations/deps/lindera-ko-dic-0.43.3-script_build_run-e80b3a3ed484e7a3.nix':
    Error: "Failed to download a valid file from all sources"
ka4h2        v0.0.30 | x |   |    
    Compiling ka4h2 error: couldn't read `src/pages/../../target/markdown/datenschutz.html`: No such file or directory (os error 2)
      --> src/pages/datenschutz.rs:3:29
      3 | const ABOUT_DE_HTML: &str = include_str!("../../target/markdown/datenschutz.html");
        |                             ^^^^^^^^^^^^^^
      
helix                |   |   | helix-term/build.rs:5:26:\nFailed to fetch tree-sitter grammars: 277 grammars failed to fetch
cargo-leptos         | x |   | deps/openssl-sys-0.9.110-script_build_run-c7b5d3a81281fe1c.nix'
                           /build/openssl-src-300.5.4+3.5.4/openssl: No such file or directory (os error 2)
                     the dep: openssl-src-300.5.4_plus_3.5.4-7c6cff061836171c seems to have this folder...

       openssl-src-300.5.4_plus_3.5.4-7c6cff061836171c $out lists:
       > 4      /nix/store/q66rcss30a7dip5i9iavfix7cflfmr88-openssl-src-300_5_4_plus_3_5_4-7c6cff061836171c/openssl_src-7c6cff061836171c.d
       > 300  /nix/store/q66rcss30a7dip5i9iavfix7cflfmr88-openssl-src-300_5_4_plus_3_5_4-7c6cff061836171c/libopenssl_src-7c6cff061836171c.rlib
       > 4      /nix/store/q66rcss30a7dip5i9iavfix7cflfmr88-openssl-src-300_5_4_plus_3_5_4-7c6cff061836171c/nix
       > 20      /nix/store/q66rcss30a7dip5i9iavfix7cflfmr88-openssl-src-300_5_4_plus_3_5_4-7c6cff061836171c/libopenssl_src-7c6cff061836171c.rmeta
       > 332   /nix/store/q66rcss30a7dip5i9iavfix7cflfmr88-openssl-src-300_5_4_plus_3_5_4-7c6cff061836171c/

      for comparison, the legacy target: 
      
      du -a target/debug/deps/libopenssl_src-*
      300     target/debug/deps/libopenssl_src-7c6cff061836171c.rlib
      20      target/debug/deps/libopenssl_src-7c6cff061836171c.rmeta
      304     target/debug/deps/libopenssl_src-9cc85fc46ed2c149.rlib
      20      target/debug/deps/libopenssl_src-9cc85fc46ed2c149.rmeta
      300     target/debug/deps/libopenssl_src-dfcbb6c0ca6b1d68.rlib
      20      target/debug/deps/libopenssl_src-dfcbb6c0ca6b1d68.rmeta

      this seems similar, also the ENV for both abstractions look same

https://github.com/alexcrichton/openssl-src-rs

cd openssl-src-300.5.4+3.5.4 -> could this be a + rename issue?!

it seems that the copying from openssl-src-300.5.4_plus_3.5.4-7c6cff061836171c is not working, /openssl is empty

grok thinks i forgot to add pkg-config perl into openssl-src, tried it with no different result

################################################################# /build.rs ########################################
################################################################# package cargo (with libnix backend) ########################################

to make this work 

[nixos@nixos:~/klick/frontend]$ trunk build
2026-01-31T06:29:55.259049Z  INFO 🚀 Starting trunk 0.21.14
2026-01-31T06:29:55.259495Z  INFO 📦 starting build
❄❄❄  nixcloud edition ❄❄❄
This is an unofficial fork of Cargo — not endorsed by the Rust Project.
Support me: Consider a star at https://github.com/nixcloud/cargo/stargazers
Support you: File issues at: https://github.com/nixcloud/cargo/issues/
Using 'nix' backend to build crates
Browserslist: caniuse-lite is outdated. Please run:
  npx update-browserslist-db@latest
  Why you should do it regularly: https://github.com/browserslist/update-db#readme

Rebuilding...

Done in 1114ms.

thread 'main' panicked at src/cargo/core/compiler/nix_build/mod.rs:609:62:
called `Result::unwrap()` on an `Err` value: StripPrefixError(())
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
2026-01-31T06:30:00.237226Z ERROR ❌ error
error from build pipeline

Caused by:
    0: HTML build pipeline failed (1 errors), showing first
    1: error from asset pipeline
    2: running cargo build
    3: error during cargo build execution
    4: cargo call to executable 'cargo' with args: '["build", "--target=wasm32-unknown-unknown", "--manifest-path", "/home/nixos/klick/frontend/Cargo.toml"]' returned a bad status: exit status: 101
2026-01-31T06:30:00.237295Z ERROR error from build pipeline
2026-01-31T06:30:00.237321Z  INFO   1: HTML build pipeline failed (1 errors), showing first
2026-01-31T06:30:00.237342Z  INFO   2: error from asset pipeline
2026-01-31T06:30:00.237347Z  INFO   3: running cargo build
2026-01-31T06:30:00.237350Z  INFO   4: error during cargo build execution
2026-01-31T06:30:00.237368Z  INFO   5: cargo call to executable 'cargo' with args: '["build", "--target=wasm32-unknown-unknown", "--manifest-path", "/home/nixos/klick/frontend/Cargo.toml"]' returned a bad status: exit status: 101


################################################################# /package cargo (with libnix backend) ########################################

x means compiles out of the box
+ means needs Cargo.dependencies.nix
? means tried but failed
```

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
