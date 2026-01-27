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

    * incremental target, add this to rustc call:
      $(if [ -d /incremental-target ]; then echo "-C incremental=/incremental-target"; fi) \


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

* BUG: improve error quality in typst for git clone errors (using nixcloud/cargo d922a5bca855964209473671d9e4ec8a2666776d)
  Downloading git --url, https://github.com/typst/typst-assets, --rev, 57a38ca98236748ad83c806a48096b281686a7de, --branch-name, , --sparse-checkout
  error: No such file or directory (os error 2)

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

bat          v0.25.0 | x | x
delta        v0.18.2 |   | x
rust-analyzer        |   | x
   2025-01-07
nushell      0.102.0 | x | +   "openssl-sys" = [ pkg-config openssl ];
coreutils            |   | x   - OUT_DIR problem in bin (using cp -r build_script_run/* $out/ now)
eza   58b98cfa       |   | x   - OUT_DIR problem in bin (using cp -r build_script_run/* $out/ now)
build_rs_example     | x | x   - OUT_DIR problem in bin (using cp -r build_script_run/* $out/ now)
```

# fail stories

```
################################################################# error generating nix build system ################################################################################################################################
tokio                |   | (wrong bin name, no libs)
leptos               | x | fails to create build system (target)
bevy                 |   | fails to create build system (target)
fuse-rs              |   | fails to create build system (target)
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
################################################################# /error generating nix build system ###############################################################################################################################
################################################################# git ################################################################################################################################
fish-shell           |   | Downloading git --url, https://github.com/fish-shell/rust-pcre2, --rev, 85b7afba1a9d9bd445779800e5bcafeb732e4421, --branch-name, , --sparse-checkout
ka4h2        v0.0.30 |   | Downloading git --url, https://codeberg.org/slowtec/utbw, --rev, 202510d2592d791a65aa7a7cc4f0dc6c17964c0d, --branch-name, , --sparse-checkout
klick         v0.5.7 |   | Downloading git --url, https://codeberg.org/slowtec/utbw, --rev, 4980fb49ad4871d8f41a80a2d56466c19f382273, --branch-name, , --sparse-checkout
influxdb             | ? | Downloading git --url, https://github.com fails...
ruff                 |   | 
  0.11.7 -> Downloading git --url, https://github.com/salsa-rs/salsa.git, --rev, 87bf6b6c2d5f6479741271da73bd9d30c2580c26, --branch-name, , --sparse-checkout
  0.11.4 -> Downloading git --url, https://github.com/salsa-rs/salsa.git, --rev, 296a8c78da1b54c76ff5795eb4c1e3fe2467e9fc, --branch-name, , --sparse-checkout
  0.10.0 -> Downloading git --url, https://github.com/salsa-rs/salsa.git, --rev, 095d8b2b8115c3cf8bf31914dd9ea74648bb7cf9, --branch-name, , --sparse-checkout
zed                  |   | Downloading git --url, https://github.com/smol-rs/async-task.git, --rev, b4486cd71e4e94fbda54ce6302444de14f4d190e, --branch-name, , --sparse-checkout
meilisearch          |   | Downloading git --url, https://github.com/meilisearch/bbqueue, --rev, e8af4a4bccc8eb36b2b0442c4a9c5cb839d1cea2, --branch-name, , --sparse-checkout
typst                |   | Downloading git --url, https://github.com/typst/typst-assets, --rev, 57a38ca98236748ad83c806a48096b281686a7de, --branch-name, , --sparse-checkout
RustPython           |   | Downloading git --url, https://github.com/RustPython/__doc__, --rev, 8b62ce5d796d68a091969c9fa5406276cb483f79, --branch-name, , --sparse-checkout
   2024-12-30-main-4
################################################################# /git ################################################################################################################################   
codex                |   | cd codex-rs -> generates incomplete nix based build system for 'ratatui'
egui                 | x | error: evaluation aborted with the following error message: 'lib.customisation.callPackageWith: Function called without required argument "epaint_default_fonts-0_33_3-ddad1624ebe00829" at /home/nixos/tests/egui/target/debug/nix/derivations/epaint-0.33.3-3fd34fda4c0e1cfc.nix:2'
    646fea2133b4793ff077905fa4bacd8c636f52eb
uv                   | ? | generated build system is wrong: error: evaluation aborted with the following error message: 'lib.customisation.callPackageWith: Function called without required argument "uv-version-0_9_22-69df0fced6bb13c4" at /home/nixos/tests/uv/target/debug/nix/derivations/uv-0.9.22-bin-389c9a1de962636b.nix:2'
vaultwarden          | x | legacy: `cargo build  --features sqlite` works
    nix build --file target/debug/nix/cargo_build_caller.nix target -L
    CARGO_BACKEND=nix ~/cargo/target/debug/cargo build -v --features sqlite
    error: evaluation aborted with the following error message: 'lib.customisation.callPackageWith: Function called without required argument "vaultwarden-1_0_0-script_build-ab50c3dfe01f1634" at /home/nixos/tests/vaultwarden/target/debug/nix/derivations/vaultwarden-1.0.0-script_build_run-373c093bb6046a0d.nix:2'
cargo-leptos         | x | deps/openssl-sys-0.9.110-script_build_run-c7b5d3a81281fe1c.nix':","\n\n\n/build/openssl-src-300.5.4+3.5.4/openssl: No such fi
                           bundled openssl won't compile (source can't be found)
slint           1.15 |   | ? /derivations/i-slint-backend-qt-1.15.0-script_build_run-c2a74fa170f66d1e.nix':","\nthread 'main' panicked at internal/backends/qt/build.rs:18:38:\ncalled `Result::unwrap()` on an `Err` value: NotPresent
helix                |   | helix-term/build.rs:5:26:\nFailed to fetch tree-sitter grammars: 277 grammars failed to fetch
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
