# WARNING

This is an unofficial fork of Cargo — not endorsed by the Rust Project.

This fork is intended as a PR to contribute this to the official cargo project and to engineer the solution and to get feedback on the work from the nix community.

We use these resources:

* https://github.com/nixcloud/cargo exists as a PR with to goal to integrate the libnix concept by adding a 'nix build backend', see discussion at https://lastlog.de/blog/timeline.html?filter=tag::libnix
* https://github.com/nixcloud/cargo/issues for issues, do not report issues on the original cargo tracker (or their formus)!
* https://lastlog.de/blog/libnix_cargo-nix-backend.html

Similar projects:

* naersk
* crane
* cargo2nix
* crate2nix

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

## What still requires love

### Actively working on

* no IFD support (from nix, call 'cargo build', use produced nix files via IFD)

    --generate-buildsystem <DIR>    Output a build system to the specified directory instead of building.
                                    Additional option: --upstream-repo <GIT-URL> (clone and generate from upstream repo).

    --upstream-repo <GIT-URL>       [Requires --generate-buildsystem]
                                    Clone and generate the buildsystem from this upstream repo, not the local directory.

* BUG: eza shows that for -bin.nix crates this is missing
  cp -r ${fn.get_rust_crate_parent passthru.rust_crate_parent}/* $OUT_DIR

  also add rust_crate_parent into the -bin crate (currently only rust_script_build_run is set)
  OR can we not use rust_crate_parent at all and only use rust_script_build_run?

            match crate_build_type(unit) {
                    CrateBuildType::BinBuild => {
                        additional_build_phase_arguments.push(source_environment_variables.indentation(6));
                    }
                    CrateBuildType::LibBuild | CrateBuildType::ScriptBuild | CrateBuildType::ScriptBuildRun => {
                        match &deps.rust_crate_parent {
                            Some(_) => {
                                if crate_build_type(unit) == CrateBuildType::LibBuild {
                                    additional_build_phase_arguments
                                        .push(format!("cp -r ${{fn.get_rust_crate_parent passthru.rust_crate_parent}}/* $OUT_DIR").to_string().indentation(6));

    [nixos@nixos:~/tests/eza]$ vim target/debug/nix/derivations/eza-0.23.4-bin-748779b38cd5bdac.nix
        { fn, pkgs, rustc, cargo, deps, eza-0_23_4-5425a52509ec25ff, eza-0_23_4-script_build_run-ae522e8eeb4be1ec }: with deps;
        pkgs.stdenv.mkDerivation rec {
            name = "eza-0_23_4-bin-748779b38cd5bdac";
            meta.cargo_crate_info = {
                name = "eza";
                version = "0.23.4";
                crate_hash = "748779b38cd5bdac";
            };
            buildInputs = [] ++ fn.inject_deps meta.cargo_crate_info;
            env = fn.inject_envs meta.cargo_crate_info;

            passthru.rust_crate_libraries = [ansi-width-0_1_0-925be429a32c343d backtrace-0_3_76-6b1d223f918ea607 chrono-0_4_42-dc2daccceef10cf6 dirs-6_0_0-a8934f498a729747 eza-0_23_4-5425a52509ec25ff git2-0_20_2-b99c5890ceaf2f84 glob-0_3_3-dddedbc796f0a88e libc-0_2_176-064bf35aaaf99812 locale-0_2_2-bc678a5bd3906d41 log-0_4_28-568abef6574317d3 natord-plus-plus-2_0_0-3ea526056716a7bd nu-ansi-term-0_50_1-56ff9cf424470041 palette-0_7_6-9c2d79530faad57c path-clean-1_0_1-120aac488f84091c percent-encoding-2_3_2-463af3bb23658951 phf-0_12_1-9adefdbb9bb546bf plist-1_8_0-3cc9278b0e88958a proc-mounts-0_3_0-4eeec1e729034304 rayon-1_11_0-b8f3f6bbb3f7e8af serde-1_0_228-7af073b37626f843 serde_norway-0_9_42-f49089c5f05e89ce terminal_size-0_4_3-ec5168ee8d279ecd timeago-0_4_2-f439956bebf181d2 unicode-width-0_2_2-d4d444ee72791683 unit-prefix-0_5_2-4538036d5e8fb6f7 uutils_term_grid-0_7_0-f53739b5a5b375a3 uzers-0_12_1-7211e8b4e705e7e4];
            passthru.rust_crate_parent = [];
            passthru.rust_script_build_run = [eza-0_23_4-5425a52509ec25ff];
            phases = "unpackPhase buildPhase installPhase";

    # generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
    { pkgs, fn, cargo, rustc, deps, build_parser, cargo-0_88_0-script_build-cfc654fccb259515 }: with deps;
      pkgs.stdenv.mkDerivation rec {
        name = "cargo-0_88_0-script_build_run-f5d51778f22880c0";
        meta.cargo_crate_info = {
          name = "cargo";
          version = "0.88.0";
          crate_hash = "f5d51778f22880c0";
        };
        buildInputs = [] ++ fn.inject meta.cargo_crate_info;
        passthru.rust_crate_libraries = [];
        passthru.rust_crate_parent = [cargo-0_88_0-script_build-cfc654fccb259515];
        passthru.rust_script_build_run = [curl-sys-0_4_80_plus_curl-8_12_1-db5fbe1d9680c71f libgit2-sys-0_18_0_plus_1_9_0-86c4b3f8f5bf526a];
        phases = "unpackPhase buildPhase";



* incremental target, add this to rustc call:
  $(if [ -d /incremental-target ]; then echo "-C incremental=/incremental-target"; fi) \

* release of this work
  * create a release workflow (for cargo-libnix as well as for projects using this toolchain)
  * create something 'simple' like fenix so ppl can experiment with this toolchain

* BUG: on `cargo build` garbage-collect .nix files in target/debug/nix/* which are not used anymore

* use of this work
  * create a workflow on how to make use of cargo+rustc for your own project

* no .fingerprint support yet, so no fast iteration on builds, __LOTS__ of unnecessary recompiles
  * https://github.com/nixcloud/cargo/issues/3

    starte to play with  --extra-sandbox-paths /tmp/sandbox-file
    https://github.com/NixOS/nix/issues/6115

    /home/nixos/cargo/src/cargo/core/compiler/mod.rs:1238 opt(cmd, "-C", "incremental=$INC_DIR", None);

* implement nix/rustc_link_arg_benches for cargo:rustc-link-arg-benches=-rdynamic in the generated nix code

* REFACTOR:
  * BUG: Cargo.dependencies.nix is not picked up with `~/tests/influxdb]$ time CARGO_BACKEND=nix /home/nixos/cargo/cargo build -v`
    but it works with: nix build --file target/debug/nix/cargo_build_caller.nix target -L --keep-going, why?

* REFACTOR:
  * use  https://nix.dev/manual/nix/2.18/language/constructs (asserts) on function calls arguments
  * make cargo_parser a direct argument and don't inject into pkgs and later compile so we can override it easily
  * pass "src" / "project_root" as argument to target/debug/nix/cargo_build_caller.nix so we can use
    external_crate_dependencies =
        (if builtins.pathExists ${project_root}/Cargo.dependencies.nix
        then builtins.trace "Using Cargo.dependencies.nix"
            import ${project_root}/Cargo.dependencies.nix { inherit pkgs; }

* BUG: tokio crate: binary is actually called test-cat, nix-backend calls it test_cat
  /nix/store/mrb3dfk0c3c2sm40r26qn5ms84w7j0ij-tests-integration-0_1_0-bin-892dd4ee4c5aadcd/bin/test_cat

* BUG: no lib targets in target.nix
  * add library targets (to targets.nix) for 'cargo build'
  * if no targets are found (an error in generating the build system) don't evaluate later with nix build....

* get more targets to work out of the box, see fail stories

* refactor the codebase
  * make /tmp/out for legacy runs more obvious, also clean directory before start


* BUG: if there is a problem with a rustc call which lacks the openssl DEP_ env variables, errors are
  very hard to understand. i think it did not even print an error, had this with

### Backlog

* experiment with rewriting the bash in nushell (better error messages)

* RUSTFLAGS might not be supported ATM (nix-backend)

  i looked at the cargo source code for RUSTFLAGS mentions but did not find a function which appends the RUSTFLAGS and 
  my generated nix files don't do it either. so did it get lost in translation?
  
   https://grok.com/share/bGVnYWN5_d6b5f489-ac0c-49d0-99a2-8f97e3dbb571

* remove --emit=dep-info from builds

* implement equivalent of `cargo build --timings` for nix backend

* cargo install --locked cargo-leptos

* logone support is a good start but:
  * "cargo" as build target is listed 4 times when it should be: cargo (lib), cargo (build.rs_build), cargo (build.rs_run), cargo (bin)
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

* get this PR upstream

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

# How to use

Type:

    nix develop
    cargo build

## Use custom cargo

    alias cargo=/home/nixos/cargo/target/debug/cargo

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
name                 |   | cargo libnix
cargo          v1.87 | x | +   "openssl-sys" = [ pkg-config openssl ];
build-parser  v0.1.8 | x | x
ripgrep      v14.1.1 | x | x
atuin        v18.5.0 | x | x
trunk       v0.21.14 | x | x
sd            v1.0.0 | x | x
mdBook        v0.5.2 | x | x
just           v1.46 | x | x
fd            v7.3.0 | x | x
pankat-rs     v0.1.1 | x | +   "libsqlite3-sys" = [ pkg-config sqlite ];
rustpad       v0.1.0 | x | x
synapse        1.0.0 |   | x
starship             |   | +   "openssl-sys" = [ pkg-config openssl ];  "libz-ng-sys" = [ cmake ];
nix-installer 3.15.1 |   | +
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
coreutils            |   | x  (requires manual patch because of OUT_DIR) 
   ++++ we could introduce BUILD_OUT_DIR="${coreutils-0_5_0-script_build_run-7d8760345f435e2a}"; so in the source include!(concat!(env!("BUILD_OUT_DIR"), "/uutils_map.rs"));
   ++++ horrible amount of useless recompiles due to src = builtins.filterSource on 80 root crate targets

bat          v0.25.0 | x | x
delta        v0.18.2 |   | x
rust-analyzer        |   | x
   2025-01-07
nushell      0.102.0 | x | +   "openssl-sys" = [ pkg-config openssl ];
eza   58b98cfa       |   | x error: include_str!(concat!(env!("OUT_DIR"), "/version_string.txt")) -> fixed by adding '  cp -r ${fn.get_rust_crate_parent passthru.rust_script_build_run}/* $OUT_DIR' to the bin crate
```

# fail stories

```
tokio                |   | (wrong bin name, no libs)
slint           1.15 |   | ? /derivations/i-slint-backend-qt-1.15.0-script_build_run-c2a74fa170f66d1e.nix':","\nthread 'main' panicked at internal/backends/qt/build.rs:18:38:\ncalled `Result::unwrap()` on an `Err` value: NotPresent
lightningcss         | x | (no targets, it is just a library)
rphtml       v0.5.10 | x | (no targets, it is just a library)
axum                 | x | (no targets, it is just a library)
yew                  | x | (no targets, it is just a library)
servo                |   | (no targets, it is just a library) 
`cargo build` does not compile:
 Compiling idna v1.1.0
 thread 'main' panicked at /home/nixos/.cargo/git/checkouts/stylo-482338307e42a9ea/a47ab67/style/build.rs:38:9:
  Can't find python (tried python3)! Try fixing PATH or setting the PYTHON3 env var
  note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
cargo-leptos         | x | deps/openssl-sys-0.9.110-script_build_run-c7b5d3a81281fe1c.nix':","\n\n\n/build/openssl-src-300.5.4+3.5.4/openssl: No such fi
                           bundled openssl won't compile (source can't be found)
leptos               | x | fails to create build system (target)
bevy                 |   | fails to create build system (target)
fuse-rs              |   | fails to create build system (target)
uv                   | ? | generated build system is wrong: error: evaluation aborted with the following error message: 'lib.customisation.callPackageWith: Function called without required argument "uv-version-0_9_22-69df0fced6bb13c4" at /home/nixos/tests/uv/target/debug/nix/derivations/uv-0.9.22-bin-389c9a1de962636b.nix:2'
vaultwarden          | x | legacy: `cargo build  --features sqlite` works
    nix build --file target/debug/nix/cargo_build_caller.nix target -L
    CARGO_BACKEND=nix ~/cargo/target/debug/cargo build -v --features sqlite
    error: evaluation aborted with the following error message: 'lib.customisation.callPackageWith: Function called without required argument "vaultwarden-1_0_0-script_build-ab50c3dfe01f1634" at /home/nixos/tests/vaultwarden/target/debug/nix/derivations/vaultwarden-1.0.0-script_build_run-373c093bb6046a0d.nix:2'
ka4h2        v0.0.30 |   | Downloading git --url, https://codeberg.org/slowtec/utbw, --rev, 202510d2592d791a65aa7a7cc4f0dc6c17964c0d, --branch-name, , --sparse-checkout
klick         v0.5.7 |   | Downloading git --url, https://codeberg.org/slowtec/utbw, --rev, 4980fb49ad4871d8f41a80a2d56466c19f382273, --branch-name, , --sparse-checkout
influxdb             | ? | Downloading git --url, https://github.com fails...
ruff                 |   | 
  0.11.7 -> Downloading git --url, https://github.com/salsa-rs/salsa.git, --rev, 87bf6b6c2d5f6479741271da73bd9d30c2580c26, --branch-name, , --sparse-checkout
  0.11.4 -> Downloading git --url, https://github.com/salsa-rs/salsa.git, --rev, 296a8c78da1b54c76ff5795eb4c1e3fe2467e9fc, --branch-name, , --sparse-checkout
  0.10.0 -> Downloading git --url, https://github.com/salsa-rs/salsa.git, --rev, 095d8b2b8115c3cf8bf31914dd9ea74648bb7cf9, --branch-name, , --sparse-checkout
helix                |   | helix-term/build.rs:5:26:\nFailed to fetch tree-sitter grammars: 277 grammars failed to fetch
codex                |   | cd codex-rs -> generates incomplete nix based build system for 'ratatui'
fuel-core            |   |
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
zed                  |   | async-task: error: No such file or directory (os error 2)
meilisearch          |   | error: No such file or directory (os error 2) during `cargo build`
typst                |   | error: No such file or directory (os error 2) during `cargo build`
RustPython           |   | error: No such file or directory (os error 2) during `cargo build`
   2024-12-30-main-4
egui                 | x | error: evaluation aborted with the following error message: 'lib.customisation.callPackageWith: Function called without required argument "epaint_default_fonts-0_33_3-ddad1624ebe00829" at /home/nixos/tests/egui/target/debug/nix/derivations/epaint-0.33.3-3fd34fda4c0e1cfc.nix:2'
    646fea2133b4793ff077905fa4bacd8c636f52eb
zellij               |   | 
  v0.40.0

            openssl-sys> Compiling openssl-sys-0_9_93-script_build_run-7187b6a4caac7e43
            openssl-sys> @cargo { "type":0, "crate_name":"openssl-sys", "id":"openssl-sys-0_9_93-script_build_run-7187b6a4caac7e43" }
            openssl-sys> +++ /nix/store/1v3a0zdgihczyzb509jxh75yircyap0x-openssl-sys-0_9_93-script_build-7e55d923cd5b48bd/build_script_build
            openssl-sys> +++ build_script_build_exit_value=101
            openssl-sys> +++ set +x -e
            openssl-sys> @cargo {"type":3,"crate_name":"openssl-sys","exit_code":101,"messages":["There was an error executing build_script_build in file: '/home/nixos/tests/zellij/target/debug/nix/derivations/deps/openssl-sys-0.9.93-script_build_run-7187b6a4caac7e43.nix':","\nthread 'main' panicked at src/lib.rs:601:32:\ncalled `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: \"No such file or directory\" }\nnote: run with `RUST_BACKTRACE=1` environment variable to display a backtrace\n"]}
            openssl-sys>
            openssl-sys> thread 'main' panicked at src/lib.rs:601:32:
            openssl-sys> called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: "No such file or directory" }
            openssl-sys> note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
            note: keeping build directory '/nix/var/nix/builds/nix-2071057-3168327591/build'

fish-shell           |   | git clone error - error: No such file or directory (os error 2)
surrealdb            |   | There was an error executing build_script_build in file: '/home/nixos/tests/surrealdb/target/debug/nix/derivations/deps/rquickjs-sys-0.9.0-script_build_run-cc5015d81fa1961f.nix
Unable to find libclang: "couldn't find any valid shared libraries matching: ['libclang.so', 'libclang-*.so', 'libclang.so.*', 'libclang-*.so.*'], set the `LIBCLANG_PATH` environment variable to a path where one of these files can be found (invalid: [])"
difftastic           |   | Compiling tikv-jemalloc-sys  error: returning 'char *' from a function with return type 'int' makes integer from pointer without a cast [-Wint-conversion] "make" "-j" "8"
expected success, got: exit status: 2
sniffnet             |   | sniffnet-1_4_2-bin-3810a677ed3b815e: bin/mktemp: Argument list too long (maybe this means the -L ... list to rustc because it is huge)
dioxus               |   | `cargo build` does not create anything in target/debug and nix-backend does not build anything

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
