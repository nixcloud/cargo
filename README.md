# cargo (libnix)

> ⚠️ This is an unofficial fork of Cargo, not endorsed by the Rust Project. It is intended as a PR to contribute a nix backend to the official cargo, and to get feedback on the work from the nix community.

cargo (libnix) is cargo with [nix](https://nixos.org) as its build backend. You keep using `cargo build`, `cargo run` and `cargo test` as usual, but every crate is built by nix:

* **reproducible**: each crate is built in the nix sandbox, with exactly the system libraries you declare
* **shared**: a crate built once (same version, features and dependencies) is reused by every project and, with a binary cache, every machine
* **deployable**: the same build can be exported as nix code, so your project builds with nix alone, from a flake or nixpkgs

[![asciicast](asciinema.png)](https://asciinema.org/a/1268068)

# Quick start 🚀

1. **Install nix** with the nix-daemon (the "multi-user" installation) from [nixos.org/download](https://nixos.org/download/); on NixOS you already have it. Then enable flakes:

    ```bash
    mkdir -p ~/.config/nix
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
    ```

2. **Go to a Rust project** (a directory with a `Cargo.toml`):

    ```bash
    cd my-rust-project
    ```

3. **Enter the cargo (libnix) shell:**

    ```bash
    nix develop github:nixcloud/cargo
    ```

    The first time this compiles cargo (libnix) itself, which takes a while; afterwards it starts in seconds. The shell has `cargo`, the matching `rustc` and `nix-prefetch-git`, and sets `CARGO_BACKEND=nix`. Check that you got it:

    ```
    $ cargo --version
    cargo 1.99.0 +libnix
    ```

4. **Build:**

    ```
    $ cargo build
    …
    Using 'nix' backend to build crates
             Nix Creating nix build system for 2 cargo units.
      Evaluating /…/my-rust-project/target/debug/nix/cargo_build_caller.nix
       Evaluated target in 2.5s
        Planning 3 derivation(s) to build, 0 path(s) to fetch (0.0 MiB)
       Compiling my-rust-project (bin)
        Finished 3 built, 0 fetched, 0 fresh, 0 failed, 0 skipped in 3.6s
    $ readlink target/debug/my-rust-project
    /nix/store/…-my-rust-project-0_1_0-bin-…/bin/my-rust-project
    ```

    The binary is a link into `/nix/store`. `cargo run` and `cargo test` work the same way.

Without `CARGO_BACKEND=nix` this cargo behaves exactly like the upstream cargo. To go back, leave the shell with `exit`, or run a single command with `CARGO_BACKEND=legacy cargo build`. Without entering a shell: `CARGO_BACKEND=nix nix run github:nixcloud/cargo -- build`.

**Which version?** The shell above is cargo (libnix) 1.99 with Rust 1.99.0, the right choice for most projects. If your project has to stay on Rust 1.87, use `nix develop github:nixcloud/cargo#rust-1_87`, or run `cargo +1.87 build` in the default shell.

# Troubleshooting 🩺

**`error: experimental Nix feature 'nix-command' is disabled`**: flakes aren't enabled yet, see step 1 of the [Quick start](#quick-start-).

**A `*-sys` crate fails to build, e.g. `openssl-sys`: "Could not find directory of OpenSSL installation"**: in the nix sandbox a crate only sees the system libraries you give it. Create a `Cargo.dependencies.nix` next to your `Cargo.toml`:

```nix
{ pkgs }:
with pkgs;
{
  deps = {
    "openssl-sys" = [ pkg-config openssl ];
  };
  envs = { };
}
```

and run `cargo build` again. Other common ones are `libsqlite3-sys` (`[ pkg-config sqlite ]`) and `libz-sys` (`[ pkg-config zlib ]`); see [Injecting dependencies](#injecting-dependencies).

**`error: cargo 'check' is not supported yet`, or your editor shows errors everywhere**: rust-analyzer runs `cargo check`, which the nix backend doesn't support yet. Let the editor use the normal cargo backend and its own target directory, e.g. in VS Code's `settings.json`:

```json
{
  "rust-analyzer.cargo.extraEnv": { "CARGO_BACKEND": "legacy" },
  "rust-analyzer.check.extraEnv": { "CARGO_BACKEND": "legacy" },
  "rust-analyzer.cargo.targetDir": true
}
```

The separate target directory matters: a legacy build in `target/` replaces the links into `/nix/store` with ordinary files.

**A git dependency fails with `nix-prefetch-git: command not found`**: the devshell has it; in your own flake or `shell.nix`, add `pkgs.nix-prefetch-scripts`.

**Rebuilding after a change is slower than with normal cargo**: the nix backend has no incremental compilation yet, so a crate you change is compiled from scratch ([#3](https://github.com/nixcloud/cargo/issues/3)). Your dependencies are not rebuilt, they come from `/nix/store`.

Anything else: [open an issue](https://github.com/nixcloud/cargo/issues), not on the upstream cargo tracker.

# Limitations

* Linux only, developed and tested on x86_64-linux; Darwin is untested
* not supported yet in nix mode: `cargo check`, `doc`, `bench`, `package`, incremental builds, registries other than crates.io; cross-compilation is untested
* cargo (libnix) needs a `rustc` of its own version; everything this flake provides brings the matching one

The full list is in [Supported subcommands and features](#supported-subcommands-and-features-).

# Using cargo (libnix) in your project

## In a flake

Add cargo (libnix) with its `rustc` to your project's devshell:

```nix
{
  description = "myproject";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    cargo-libnix.url = "github:nixcloud/cargo";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, cargo-libnix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            cargo-libnix.packages.${system}.rust-1_99   # or rust-1_87
            pkgs.nix-prefetch-scripts
          ];
          shellHook = ''
            export CARGO_BACKEND=nix
          '';
        };
      });
}
```

Then `nix develop` in your project gives you the same shell as the [Quick start](#quick-start-). Use `rust-1_87` instead of `rust-1_99` to stay on Rust 1.87.

`rust-1_99` follows the 1.99 line (`libnix-1.99.0+v2` once it is released); to stay on one release, use `cargo-libnix-1_99_0_plus_v1` and its `.rustc`, or pin the flake input to a commit of this branch.

## Traditional nix code

A `shell.nix` that builds cargo (libnix) from the build system of release `libnix-1.99.0+v1` with a pinned rustc/cargo 1.99.0 from [fenix](https://github.com/nix-community/fenix):

```nix
{ pkgs ? import <nixpkgs> { } }:
let
  fenix = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/fenix/archive/6ed03ef4c8ec36d193c18e06b9ecddde78fb7e42.tar.gz";
    sha256 = "1mjmp9c5x3j6jqy50ymr07nxl4nrlp3iininxhnzc1ragdrg8pxn";
  }) { inherit pkgs; };
  toolchain = fenix.toolchainOf {
    channel = "1.99.0";
    sha256 = "sha256-zm3dyIY2T414ZRR3EhLOvptzG6gta4WZUcawzMUWtqI=";
  };
  # since 1.90 rustc links with its own lld, which bypasses nix's ld wrapper (no rpath: the binaries miss their
  # libraries, e.g. libssl.so.3); -C linker-features=-lld links with the cc's ld again
  rustc = pkgs.symlinkJoin {
    name = "rustc-1.99.0-nix-ld";
    paths = [ toolchain.rustc ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for b in rustc rustdoc; do wrapProgram $out/bin/$b --add-flags "-C linker-features=-lld"; done
    '';
  };
  # the generated build system of cargo (libnix) and the cargo sources it builds
  buildsystem = builtins.fetchTarball {
    url = "https://github.com/nixcloud/cargo/releases/download/libnix-1.99.0%2Bv1/libnix-1.99.0+v1.tar.bz2";
    sha256 = "sha256:1mwxjyr9ccbq71p1mq296xvs2b10kxb159a90dh3w6wbgs5qizg4";
  };
  cargo-src = builtins.fetchTarball {
    url = "https://github.com/nixcloud/cargo/archive/refs/tags/libnix-1.99.0%2Bv1.tar.gz";
    sha256 = "sha256:03fywzj68mj56m1lis3ghjn4i35kjd8frfkydlwldn8y6a87qviv";
  };
  cargo-libnix = (import (buildsystem + "/derivations/default.nix") {
    inherit pkgs rustc;
    project_root = cargo-src;
    external_crate_dependencies = import (buildsystem + "/Cargo.dependencies.nix") { inherit pkgs; };
    cargo = toolchain.cargo;
  }).cargo-0_100_0-bin-463824861cef8abc;
in
pkgs.mkShell {
  packages = [ cargo-libnix rustc pkgs.nix-prefetch-scripts ];
  shellHook = "export CARGO_BACKEND=nix";
}
```

For a NixOS configuration, put `cargo-libnix` and `rustc` into `environment.systemPackages` instead and set `CARGO_BACKEND=nix` in `environment.variables`.

## Flake outputs

The [flake.nix](flake.nix) of this branch serves the newest release of each supported toolchain; 1.99 is the default:

| output | contents |
|---|---|
| `packages.default`, `devShells.default` | cargo `libnix-1.99.0+v1` and rustc 1.99.0; `cargo +1.87 …` runs the 1.87 release instead (like rustup's `+toolchain`) |
| `packages.rust-1_99`, `devShells.rust-1_99` | cargo `libnix-1.99.0+v1` and rustc 1.99.0 |
| `packages.rust-1_87`, `devShells.rust-1_87` | cargo `libnix-1.87.0+v4` and rustc 1.87.0 |
| `packages.cargo-libnix-1_99`, `packages.cargo-libnix-1_87` | only cargo, the newest release of that line; its rustc is `.rustc` |
| `packages.cargo-libnix-1_99_0_plus_v1`, `packages.cargo-libnix-1_87_0_plus_v4` | only cargo, exactly that release |
| `overlays.default` | `cargo-libnix` (= `default`), `cargo-libnix_1_99`, `cargo-libnix_1_87` (= `rust-1_99`, `rust-1_87`) |

cargo (libnix) only works with a rustc of its own version, so use `rust-1_99` / `rust-1_87` (cargo and rustc in one package), or `cargo-libnix-*` together with its `.rustc`, never a rustc from elsewhere. The rustc 1.99.0 is wrapped with `-C linker-features=-lld`: since 1.90 rustc links with its own lld, which bypasses nix's linker wrapper (no rpath, the binaries miss their libraries).

# Injecting dependencies

Crates that link against system libraries (`openssl-sys`, `libsqlite3-sys`, …) or need environment variables at build time get them from a `Cargo.dependencies.nix` next to `Cargo.toml` / `Cargo.lock`. Without the file, crates are built with the toolchain only; a `*-sys` crate whose build script can't find its library is the typical sign that an entry is missing.

1. create `Cargo.dependencies.nix` in the workspace root
2. add `buildInputs` per crate in `deps` and environment variables per crate in `envs`; the name and version are the ones in `Cargo.lock`. The version is optional, but once a crate is keyed by version, `deps` must list every version of it in `Cargo.lock`:

    ```nix
    { pkgs }:
    with pkgs;
    {
      deps = {
        "openssl-sys" = [ pkg-config openssl ];       # every version
        "libsqlite3-sys" = {
          "0.30.1" = [ pkg-config sqlite ];           # only this version
        };
      };
      envs = {
        "proc-macro-test" = {
          "PROC_MACRO_TEST_LOCATION" = "";
        };
      };
    }
    ```

3. run `cargo build`; the inputs and variables are added to every derivation of that crate (build script, build script run, compilation)

More examples are in [Cargo.dependencies.nix](https://github.com/nixcloud/cargo/blob/rust-1.99.0-libnix/Cargo.dependencies.nix) (the one of cargo itself) and in [tests-libnix](https://github.com/nixcloud/cargo/tree/rust-1.99.0-libnix/tests-libnix).

# Reference

## Supported subcommands and features 🧰

With `CARGO_BACKEND=nix`, the build-related subcommands go through nix; all others are plain cargo. Details and the state of development are in [README-DEV.md](https://github.com/nixcloud/cargo/blob/rust-1.99.0-libnix/README-DEV.md).

| subcommand | nix mode | notes |
|---|---|---|
| `build` | ✅ | every unit is built in nix; `build write-nix-buildsystem` exports the build system for flakes and nixpkgs |
| `run` | ✅ | binaries and examples; `std::env::current_exe()` is the binary in the store |
| `test` | ✅ | unit, integration and doc tests; the tests run outside of nix, the sources at `env!("CARGO_MANIFEST_DIR")` are read-only |
| `clean` | ✅ partial | the target directory or a profile, together with the store paths it rooted; `clean -p` and `clean gc` are refused |
| `check` | ❌ planned | refused with "not supported yet" |
| `install`, `uninstall` | ✅ | binaries stay in the store, rooted in `<root>/nix/install`, `<root>/bin` links to them; uninstall deletes the store paths nothing else uses |
| `doc`, `rustdoc`, `rustc`, `bench`, `package`, `vendor` | ❌ | refused with "not supported yet" |
| `new`, `init`, `add`, `remove`, `update`, `fetch`, `generate-lockfile`, `tree`, `metadata`, `fmt`, `publish`, … | unchanged | vanilla cargo, the backend is not involved |
| `fix` | ❓ | untested, it builds in check mode internally |

| feature | state | notes |
|---|---|---|
| crates.io dependencies | ✅ | downloaded and built in `/nix/store`, shared between projects and machines |
| path dependencies, workspaces, `-p`, `--features` | ✅ | |
| build scripts (`build.rs`), proc macros | ✅ | build scripts run in the nix sandbox |
| `cargo:` directives of build scripts | ⚠️ | parsed by build-rs-libnix; `cargo::` syntax, generic metadata, `rustc-flags` and the target-specific `rustc-link-arg-*` are not supported yet, see [build scripts and build-rs-libnix](https://github.com/nixcloud/cargo/blob/rust-1.99.0-libnix/README.md#build-scripts-and-build-rs-libnix) |
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
| toolchain | ⚠️ | `rustc` and `cargo` must have the same version (currently 1.99.0); rustc ≥ 1.90 links with its bundled lld, which bypasses nix's linker wrapper, so the units are built with a wrapped rustc passing `-C linker-features=-lld` |

The tables describe the 1.99 line (`libnix-1.99.0+v1`). The 1.87 line (`libnix-1.87.0+v4`) has the same subcommands and features and needs no wrapped rustc; see the README of [rust-1.87.0-libnix](https://github.com/nixcloud/cargo/tree/rust-1.87.0-libnix) for its state.

## How it works

cargo resolves the dependencies and plans the build as usual. In nix mode it then writes one nix derivation per unit (a crate with its features and profile, a build script, a build script run, a test harness) to _target/&lt;profile&gt;/nix_, builds them with `nix build` and links the results into _target/&lt;profile&gt;_, so `target/debug/<bin>` is a symlink into `/nix/store`.

* every crate is built in the nix sandbox, with its system libraries from `Cargo.dependencies.nix`
* crates.io downloads and crate builds are store paths, shared between projects and machines (and between `cargo build`, `cargo run` and `cargo test`)
* the same nix code can be exported with `cargo build write-nix-buildsystem` and built by nix alone, from a flake or nixpkgs, without calling cargo again
* build scripts run in the nix sandbox too; their `cargo:` directives are parsed by [build-rs-libnix](https://github.com/nixcloud/build-rs-libnix), see [build scripts and build-rs-libnix](https://github.com/nixcloud/cargo/blob/rust-1.99.0-libnix/README.md#build-scripts-and-build-rs-libnix)

## Requirements

* nix with the `nix-command` and `flakes` features, a running nix-daemon and the sandbox enabled (the defaults on NixOS)
* Linux; developed and tested on x86_64-linux
* `rustc` of the same version as the cargo (1.87.0 or 1.99.0); every package of the flake brings the matching one
* `nix-prefetch-git` in `PATH` for git dependencies (part of the devshell)

## Regression tests

Each branch's `test.nix` builds the projects of [#18](https://github.com/nixcloud/cargo/issues/18) at pinned revisions and runs their binaries: the 1.99 line passes all 31, among them [grok-build](https://github.com/xai-org/grok-build); the 1.87 line passes 30 of 31 (union needs a nightly rustc). Details are in the README of [rust-1.99.0-libnix](https://github.com/nixcloud/cargo/tree/rust-1.99.0-libnix#regression-tests).

# Exporting the build system

`cargo build` writes the nix code to _target/&lt;profile&gt;/nix_ on every run. `cargo build write-nix-buildsystem` writes the same code to a directory of your choice, without building, so your project can be built by nix alone: from a flake, nixpkgs or another project.

```
   ┌─────────────────┐
   │  flake.nix      │
   └────────┬────────┘
            │
            ▼
┌────────────────────────────┐
│  nix build system          │
│  • cargo_build_caller.nix  │
│  • derivations/default.nix │
│  • derivations/ ...        │
└───────────┬────────────────┘
            │
            ▼
┌───────────────────────┐
│  project source code  │
│  • src/               │
│  • Cargo.toml / ...   │
└───────────────────────┘
```

The project's own crates either come from a directory (the default, the `project_root` argument) or from a tarball given with `--url` and `--hash`. For a release of your project, e.g. tag `v1.0.0` on GitHub:

1. tag the release and push it
2. get the hash of the source tarball:

    ```bash
    nix-prefetch-url https://github.com/<owner>/<project>/archive/refs/tags/v1.0.0.tar.gz
    ```

3. write the build system:

    ```bash
    CARGO_BACKEND=nix cargo build --release write-nix-buildsystem \
      --out-dir ./nix \
      --url https://github.com/<owner>/<project>/archive/refs/tags/v1.0.0.tar.gz \
      --hash <hash from step 2>
    ```

4. test it: `nix build --file nix/cargo_build_caller.nix target -L`
5. publish it: commit the directory to your repository, or attach a tarball of it to the release (as cargo (libnix) does, see its [releases](https://github.com/nixcloud/cargo/releases))

The build system has two entry points:

1. `cargo_build_caller.nix` is self-contained: it pins its own nixpkgs and the rustc/cargo of its release, 1.99.0 or 1.87.0 (from fenix, without `rust-src`, which would end up in the runtime closure of every binary), so build artifacts can be shared between machines, and reads `Cargo.dependencies.nix` from `project_root`. It takes `system` and `project_root` (default: its own directory)
2. `derivations/default.nix` is for flakes and other nix code: you pass `pkgs`, `rustc`, `cargo`, `external_crate_dependencies` and `project_root` yourself, see [traditional nix code](#traditional-nix-code) and the [flake.nix](flake.nix) of this branch

Both return an attribute set with a derivation per unit (e.g. `cargo-0_100_0-bin-463824861cef8abc`) and `target`, which links all root units like _target/&lt;profile&gt;_.

# Branches and releases 🌿

cargo (libnix) does not follow every upstream cargo release, only selected Rust toolchains. Each supported toolchain is a patch stack on top of upstream's release of that toolchain, in a branch of its own.

| branch | what it is |
|---|---|
| `master-libnix` | this README and the [flake.nix](flake.nix) serving the releases; no code |
| [`rust-1.99.0-libnix`](https://github.com/nixcloud/cargo/tree/rust-1.99.0-libnix) | the main line, on the newest supported toolchain: new features, `README-DEV.md`, `test.nix`; pull requests go here |
| [`rust-1.87.0-libnix`](https://github.com/nixcloud/cargo/tree/rust-1.87.0-libnix) | maintenance branch of the 1.87 line |
| `master` | upstream cargo, untouched |

The naming follows upstream: cargo has a release branch per toolchain (`rust-1.87.0`, `rust-1.99.0`) and tags the cargo crate version (`0.88.0` is the cargo of Rust 1.87.0, `0.100.0` the one of Rust 1.99.0).

Releases are tags named after the toolchain plus a libnix revision: `libnix-1.87.0+v1`, `libnix-1.87.0+v2`, … Each release has a tarball of its generated nix build system on the [releases](https://github.com/nixcloud/cargo/releases) page. The tags stay valid no matter what happens to the branches; flakes and nix code should pin a tag, a release tarball or a commit of `master-libnix`, not a version branch.

## Releasing

1. tag the release on its branch, e.g. `libnix-1.99.0+v2`, and attach the tarball of `cargo build --release write-nix-buildsystem`
2. on `master-libnix`, add a `release { … }` for it to [flake.nix](flake.nix) and point its line in `lines` to it (and `defaultLine`, for a new toolchain); `nix flake check` runs every line's cargo with its rustc

## Supporting a new toolchain

1. base on upstream's release of that toolchain (the cargo crate tag, e.g. `0.100.0`, or the `rust-<version>` branch), not on an upstream `master` commit, so the upstream backports are included
2. rebase the libnix patch stack of the current main line onto it, in a new `rust-<version>-libnix` branch; squashing the stack into a few logical patches first (nix backend, daemon/runner, templates, write-nix-buildsystem, crate store/GC roots, flake) keeps the conflicts manageable and `git diff <upstream tag>..` readable
3. once cargo builds itself with `CARGO_BACKEND=nix` and the example projects work, the new branch is the main line and the previous one a maintenance branch
4. tag the first release of the new line, e.g. `libnix-1.99.0+v1`, and add it to `master-libnix` as the default

## Maintenance branches

`rust-<version>-libnix` branches of older toolchains only get fixes (cherry-picked), no new features; a fix released there gets the next tag of that line, e.g. `libnix-1.87.0+v5`.

# Similar projects 📚

| project | how it differs from cargo (libnix) |
|---|---|
| [crane](https://github.com/ipetkov/crane) | nix library that runs cargo inside a few derivations (dependencies, then the workspace); you write the nix code |
| [naersk](https://github.com/nix-community/naersk) | like crane: builds the dependencies and the project in two derivations from `Cargo.lock` |
| [cargo2nix](https://github.com/cargo2nix/cargo2nix) | a separate tool generates a `Cargo.nix` with a derivation per crate, regenerated when `Cargo.lock` changes |
| [crate2nix](https://github.com/nix-community/crate2nix) | like cargo2nix, based on nixpkgs' `buildRustCrate`, can also generate during evaluation (IFD) |

cargo (libnix) is cargo itself: the derivation per unit comes from cargo's own build plan on every `cargo build`, during development as well, with no extra tool, nix code or generation step.

# Motivation 💡

* https://lastlog.de/blog/libnix_cargo-nix-backend.html
* https://lastlog.de/blog/timeline.html?filter=tag::libnix

This project is [xkcd 927](https://xkcd.com/927/).

# Commercial support & consulting 🤝

cargo (libnix) is open source and stays that way. If your team wants to use it, or wants Nix builds for Rust in general, I'm available for paid work:

* **adoption**: move your Rust workspace to cargo (libnix), write the `Cargo.dependencies.nix` for your `*-sys` crates and get your project building in the nix sandbox
* **CI and caching**: binary caches, remote builders and shared store paths, so crates built once are never built again on another machine or pipeline
* **exporting**: ship your project as a flake or nixpkgs package with `write-nix-buildsystem`, pinned and reproducible
* **toolchains and platforms**: port cargo (libnix) to the Rust version you're on, or to Darwin
* **funded features**: `cargo check`, incremental builds ([#3](https://github.com/nixcloud/cargo/issues/3)), cross-compilation and wasm. If you need one of these, sponsoring it is the fastest way to get it upstream-ready
* **Nix in general**: NixOS deployments, build systems for C/C++ projects, reproducible toolchains

All work is clearly separate from the Rust Project; this is not official Cargo support.

## About me

I'm Joachim Schiele, a freelance software engineer based in Germany. I've worked on Nix for over a decade: at Daimler I spent almost three years researching distributed deployment with Nix/NixOS, and before that my diploma thesis covered multi-platform software package management. I founded nixcloud GmbH and have worked on several projects with NLnet, including this one.

Outside Nix, I build web apps in Rust/Leptos and Go backends. I've also done C++ and CMake build systems for embedded and industrial software, and run Linux infrastructure at scale (5000 RHEL machines at Bosch).

* CV: https://lastlog.de/cv/
* blog: https://lastlog.de/blog
* GitHub: [qknight](https://github.com/qknight), [nixcloud](https://github.com/nixcloud)
* YouTube: https://www.youtube.com/@nixcloud

📧 **js@lastlog.de**: tell me what you're building and where your builds hurt, and I'll reply with how I can help.

# Project resources

* https://github.com/nixcloud/cargo - intended as a PR to incorporate nix into cargo; the code is in the `rust-<version>-libnix` branches (see [Branches and releases](#branches-and-releases-))
* https://github.com/nixcloud/cargo/issues - for issues; do not report them on the upstream cargo tracker or forums!
* https://link.excalidraw.com/l/3QhpSMKuoZA/6eoC5kkanvL - diagrams
* https://link.excalidraw.com/p/readonly/HTEjH2WpzNJExWK81BaN - slides

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
