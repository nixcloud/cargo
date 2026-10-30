# WARNING ⚠️

This is an unofficial fork of Cargo — not endorsed by the Rust Project.

This fork is intended as a PR to contribute this to the official cargo project and to engineer the solution and to get feedback on the work from the nix community.

# What is this?

This project integrates nix as a build backend into cargo (libnix), so you get the advantages of nix during development and deployment. The detailed technical status is in [README-DEV.md](README-DEV.md).

Ideally you type these commands: 🚀

```
nix develop github:nixcloud/cargo
export CARGO_BACKEND=nix 
cargo build
```

[![asciicast](asciinema.png)](https://asciinema.org/a/1268068)

The nix backend is switched on with the environment variable `CARGO_BACKEND=nix` the devshell above sets it. Without it, or with any other value, this cargo behaves like the upstream cargo (legacy).

## How it works

cargo resolves the dependencies and plans the build as usual. In nix mode it then writes one nix derivation per unit (a crate with its features and profile, a build script, a build script run, a test harness) to _target/&lt;profile&gt;/nix_, builds them with `nix build` and links the results into _target/&lt;profile&gt;_, so `target/debug/<bin>` is a symlink into `/nix/store`.

* every crate is built in the nix sandbox, with its system libraries from `Cargo.dependencies.nix`
* crates.io downloads and crate builds are store paths, shared between projects and machines (and between `cargo build`, `cargo run` and `cargo test`)
* the same nix code can be exported with `cargo build write-nix-buildsystem` and built by nix alone, from a flake or nixpkgs, without calling cargo again

### build scripts and build-rs-libnix 

cargo (legacy) runs a `build.rs`, reads the `cargo:` directives it prints (`rustc-cfg`, `rustc-link-lib`, `rustc-env`, …) and applies them to the rustc calls that follow. In nix mode the build script run is a derivation of its own, and the units built after it can't ask cargo anything, so the parsing happens inside that derivation: its output goes through [build-rs-libnix](https://github.com/nixcloud/build-rs-libnix), a small CLI that writes the result to `$out/nix` (`rustc-arguments` for the crate itself, `rustc-propagated-arguments` for the crates linking it, `environment-variables`, e.g. `DEP_<LINKS>_<KEY>`), which the dependent derivations read.

* the generated `build_rs_libnix.nix` builds it from a pinned commit of nixcloud/build-rs-libnix; the 1.87 and the 1.99 line pin the same version, as the `cargo:` protocol didn't change between them
* every build script run depends on it, so changing the pin rebuilds all build script runs and everything after them; fixes go to nixcloud/build-rs-libnix first and each branch bumps its pin in one step
* the `cargo::` syntax (Rust ≥ 1.77) is parsed like `cargo:` (since 0.1.14, the pinned version)
* not supported yet: metadata other than `include`, `root`, `conf`, `version_number` and `static` (`cargo:KEY=VALUE`, `cargo::metadata=KEY=VALUE`) is skipped with a warning; `cargo:metadata`, `rustc-flags` and `rustc-link-arg-{bin,bins,tests,examples,cdylib}` fail the build script run
* the `rerun-if-*` lines are ignored there; cargo reads them itself from the run's output for its file list (see below)

### file lists of the workspace's crates

A crate of the workspace gets only the files rustc reads as its `src` (a build script run: the files its build script lists), not the whole workspace, so editing a README or another crate's files doesn't rebuild it ([#3](https://github.com/nixcloud/cargo/issues/3), part 1). rustc writes the files it read to the dep-info file (`.d`) in the unit's output; cargo keeps that list with a hash of each file in _target/&lt;profile&gt;/nix/src-lists_.

* a unit without a list, with a listed file changed or gone, or depending on such a unit is built once, with all files, and its `.d` gives the new list. It stays on all files while that build is the current one: a no-op rebuilds nothing, editing the crate again builds it with all files again
* the first time something else changes (a README, another crate, `Cargo.dependencies.nix`), it would be rebuilt with all files anyway: it is built with its list instead (`Nix app-… would be rebuilt: building with their file lists from now on`), and from then on such changes don't rebuild it. That build is compared with the one with all files (store hashes and the random names of incremental object files aside), when only the src differs between both derivations; if it differs or fails, the unit keeps all files from then on (`warning: app-… keeps all files: …`)
* that happens when a file is read without rustc knowing, e.g. by a proc macro using `std::fs` instead of `include_bytes!` (or `proc_macro::tracked_path` on nightly); fix the crate, or give the package all files right away with `[package.metadata.libnix] src = "full"` in its `Cargo.toml` (the comparison can't catch a file that changes nothing in the output then)
* a build script's compile (`build.rs build`) gets a list like any crate
* a build script run (`build.rs run`) gets the files its build script lists, like cargo decides when to run it again: what it prints as `cargo:rerun-if-changed` / `cargo::rerun-if-changed` (files, directories with everything below them, also paths that don't exist yet), or, without any `rerun-if-*` directive, its package's directory. It goes through the same steps: built with all files first, its list from the first unrelated change on, and that run compared with the one with all files; a build script that reads a file it doesn't list differs or fails then and keeps all files (`warning: gen-…-script_build_run-… keeps all files: run with only the files its build script lists …`). `rerun-if-env-changed` needs no list: what a build script can read of the environment in the sandbox is part of its derivation, so a change reruns it anyway. A package at the workspace root without `rerun-if-changed` keeps all files (its package is the whole workspace); cargo checks again whenever the run is built, so it gets a list once the build script prints `rerun-if-changed`. Example: cargo's own `build.rs` runs `git log` for the commit hash in `cargo -vV` without listing `.git` (legacy cargo doesn't rerun it on a commit, so the hash goes stale); without `.git` in the sandbox its output differs, so its run keeps all files and reruns on every edit (about 12 s), while the lib and the bin after it don't rebuild with `ca-derivations`
* the crates after a run with a list get lists like any other, and are dirty when the run is. With the experimental nix feature `ca-derivations` enabled (`experimental-features = … ca-derivations` in nix.conf, for the daemon too) the runs of the workspace are content-addressed derivations ([#20](https://github.com/nixcloud/cargo/issues/20)): cargo builds them first, and only a new output makes the crates after them dirty, which are then built with all files for new lists, as above; the same output rebuilds nothing, also when the run itself reran (e.g. a run that keeps all files, or an edited build script), and a run's first build with its list is compared before anything after it is built. When such a crate would be rebuilt because its own files or a dependency changed, cargo sees that before building and it gets its list right away; only when nothing but the run changed (e.g. the build script itself) does nix tell during the build, so the one time such a crate gets its list it compiles twice (with all files, then with the list). cargo enables it when `nix config show` lists the feature, `CARGO_LIBNIX_CA=1`/`0` overrides that. A build script that writes something else on every run (e.g. a timestamp) makes the crates after it rebuild whenever it runs: fix the build script
* without `ca-derivations`, the crates after a run that keeps all files keep the whole workspace too (they rebuild on every edit anyway)
* not covered yet, they keep the whole workspace: path packages outside the workspace, the crates depending on them, and the exported build system (`write-nix-buildsystem`, which can pass `content_addressed = true` to `cargo_build_caller.nix` itself)
* `tests-libnix/src-lists/run.sh` tests it with a minimal workspace per case (run by hand)

## Requirements

* nix with the `nix-command` and `flakes` features, a running nix-daemon and the sandbox enabled (the defaults on NixOS)
* Linux; developed and tested on x86_64-linux
* `rustc` of the same version as the cargo (currently 1.99.0), the devshell and flake provide both
* `nix-prefetch-git` in `PATH` only for vendored git dependencies (`cargo vendor`, part of the devshell); other git dependencies come from cargo's own checkout (nixcloud/cargo#10)

# Supported subcommands and features 🧰

With `CARGO_BACKEND=nix`, the build-related subcommands go through nix; all others are plain cargo. Details and the state of development are in [README-DEV.md](README-DEV.md).

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
| `cargo:` directives of build scripts | ⚠️ | parsed by build-rs-libnix; `cargo::` syntax, generic metadata, `rustc-flags` and the target-specific `rustc-link-arg-*` are not supported yet, see [build scripts and build-rs-libnix](#build-scripts-and-build-rs-libnix) |
| system libraries, environment variables | ✅ | per crate in `Cargo.dependencies.nix`, see [Injecting dependencies](#injecting-dependencies) |
| git dependencies | ✅ | downloaded once, by cargo, and added to the nix store as the `pkgs.fetchgit` output (submodules included); vendored ones need `nix-prefetch-git` |
| vendored sources, source replacement | ✅ | |
| `--offline` | ✅ | crates.io is served from the store tarballs of `Cargo.lock`, so the build system can be generated inside a nix build (IFD) |
| `--release` | ✅ | profile options (`lto`, `codegen-units`, `panic`, …) are passed on, but untested |
| GC roots | ✅ | per selection of units in `target/<profile>/nix/gc`, the 8 most recent are kept; what a build no longer uses is deleted, also what failed builds left and what was still running (the next build); `cargo clean` removes them |
| cargo-like output | ✅ | nix logs are shown in cargo's format |
| other registries | ❌ | only crates.io; others fail when the build system is generated |
| incremental builds / fingerprints | ⚠️ | the workspace's crates are rebuilt only when a file rustc read changed, see [file lists](#file-lists-of-the-workspaces-crates); changed crates are compiled from scratch (once, with all files; the first unrelated change after that compiles them with their file list), so iterating is slower than with cargo (legacy) ([#3](https://github.com/nixcloud/cargo/issues/3)) |
| cross-compilation, `--target` (e.g. wasm) | ❓ | untested, known failures (wasm) |
| platforms | ❓ | developed and tested on x86_64-linux only, Darwin is untested |
| toolchain | ⚠️ | `rustc` and `cargo` must have the same version (currently 1.99.0); rustc ≥ 1.90 links with its bundled lld, which bypasses nix's linker wrapper, so the units are built with a wrapped rustc passing `-C linker-features=-lld` |

## Regression tests

[test.nix](test.nix) builds the projects of [#18](https://github.com/nixcloud/cargo/issues/18) at pinned revisions with this cargo and runs their binaries; `tests-libnix/run.sh` writes a `RESULTS.md`. Currently all 31 projects pass with rustc 1.99.0 (2026-10-20), among them [grok-build](https://github.com/xai-org/grok-build) (~1600 units; `tikv-jemalloc-sys` uses `cargo:rustc-link-arg`, supported since build-rs-libnix 0.1.12) and rust-analyzer (release 2026-10-19; the older pin of the 1.87 line doesn't compile with rustc 1.99). union was removed: it needs a nightly rustc (`#![feature]`). codex, leptos, mdBook, sniffnet, starship, typst and wasmtime are still pinned to their last release before they needed a rustc newer than 1.87; they can move to newer revisions now. The 1.87 line passes 30 of 31, see [rust-1.87.0-libnix](https://github.com/nixcloud/cargo/tree/rust-1.87.0-libnix). Some projects need a `Cargo.dependencies.nix`, see [tests-libnix](tests-libnix).

# Using cargo (libnix)

The releases of every supported toolchain are served by the flake of [master-libnix](https://github.com/nixcloud/cargo/tree/master-libnix), with 1.99 as the default; its README shows how to use them from a devshell, a flake or traditional nix code:

```bash
nix develop github:nixcloud/cargo              # libnix-1.99.0+v1; `cargo +1.87 build` for libnix-1.87.0+v4
nix develop github:nixcloud/cargo#rust-1_87    # only libnix-1.87.0+v4
```

## Developing this branch

The [flake.nix](flake.nix) of this branch is for development:

* `nix develop` in a checkout: cargo `libnix-1.99.0+v1`, rustc 1.99.0, rustfmt, clippy, and `CARGO_BACKEND=nix`; nix mode pins its own rustc, so building this repository with its own cargo needs `CARGO_BACKEND=legacy`
* `cargo-libnix-git-head-via-ifd`: the working tree, built through its generated nix build system (IFD), with `libnix-1.99.0+v1` as generator
* `cargo-libnix-git-revision-via-ifd`: a pinned commit of `rust-1.87.0-libnix`, with `libnix-1.87.0+v4` as generator
* [test.nix](test.nix) and `tests-libnix/run.sh` build the regression tests with `cargo-libnix-git-head-via-ifd`, see [Regression tests](#regression-tests)

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

More examples are in [Cargo.dependencies.nix](Cargo.dependencies.nix) (the one of cargo itself) and in [tests-libnix](tests-libnix).

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

1. `cargo_build_caller.nix` is self-contained: it pins its own nixpkgs and rustc/cargo 1.99.0 (from fenix, without `rust-src`, which would end up in the runtime closure of every binary), so build artifacts can be shared between machines, and reads `Cargo.dependencies.nix` from `project_root`. It takes `system` and `project_root` (default: its own directory)
2. `derivations/default.nix` is for flakes and other nix code: you pass `pkgs`, `rustc`, `cargo`, `external_crate_dependencies` and `project_root` yourself, see [traditional nix code](https://github.com/nixcloud/cargo/tree/master-libnix#3-traditional-nix-code) and the [flake.nix](https://github.com/nixcloud/cargo/blob/master-libnix/flake.nix) of master-libnix

Both return an attribute set with a derivation per unit (e.g. `cargo-0_100_0-bin-463824861cef8abc`) and `target`, which links all root units like _target/&lt;profile&gt;_.

# Branches and releases 🌿

cargo (libnix) does not follow every upstream cargo release, only selected Rust toolchains. Each supported toolchain is a patch stack on top of upstream's release of that toolchain, in a branch of its own.

| branch | what it is |
|---|---|
| [`master-libnix`](https://github.com/nixcloud/cargo/tree/master-libnix) | the user README and the [flake.nix](https://github.com/nixcloud/cargo/blob/master-libnix/flake.nix) serving the releases; no code |
| [`rust-1.99.0-libnix`](https://github.com/nixcloud/cargo/tree/rust-1.99.0-libnix) (this branch) | the main line, on the newest supported toolchain: new features, `README-DEV.md`, `test.nix`; pull requests go here |
| [`rust-1.87.0-libnix`](https://github.com/nixcloud/cargo/tree/rust-1.87.0-libnix) | maintenance branch of the 1.87 line |
| `master` | upstream cargo, untouched |

The naming follows upstream: cargo has a release branch per toolchain (`rust-1.87.0`, `rust-1.99.0`) and tags the cargo crate version (`0.88.0` is the cargo of Rust 1.87.0, `0.100.0` the one of Rust 1.99.0).

Releases are tags named after the toolchain plus a libnix revision: `libnix-1.87.0+v1`, `libnix-1.87.0+v2`, … Each release has a tarball of its generated nix build system on the [releases](https://github.com/nixcloud/cargo/releases) page. The tags stay valid no matter what happens to the branches; flakes and nix code should pin a tag, a release tarball or a commit of `master-libnix`, not a version branch.

## releasing

1. bump [LIBNIX_RELEASE](LIBNIX_RELEASE) on the branch, e.g. to `v2`, and commit; `cargo --version` shows it (`cargo 1.99.0 +libnix v2`, `libnix: 1.99.0+v2` in `cargo -vV`)
2. tag that commit `libnix-<toolchain>+` plus the file's content, e.g. `libnix-1.99.0+v2`, and attach the tarball of `cargo build --release write-nix-buildsystem`
3. on `master-libnix`, add a `release { … }` for it to [flake.nix](https://github.com/nixcloud/cargo/blob/master-libnix/flake.nix) and point its line in `lines` to it (and `defaultLine`, for a new toolchain); `nix flake check` runs every line's cargo with its rustc

## supporting a new toolchain

1. base on upstream's release of that toolchain (the cargo crate tag, e.g. `0.100.0`, or the `rust-<version>` branch), not on an upstream `master` commit, so the upstream backports are included
2. rebase the libnix patch stack of the current main line onto it, in a new `rust-<version>-libnix` branch; squashing the stack into a few logical patches first (nix backend, daemon/runner, templates, write-nix-buildsystem, crate store/GC roots, flake) keeps the conflicts manageable and `git diff <upstream tag>..` readable
3. once cargo builds itself with `CARGO_BACKEND=nix` and the example projects work, the new branch is the main line and the previous one a maintenance branch
4. reset [LIBNIX_RELEASE](LIBNIX_RELEASE) to `v1`, tag the first release of the new line, e.g. `libnix-1.99.0+v1`, and add it to `master-libnix` as the default

## maintenance branches

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

* https://github.com/nixcloud/cargo - intended as a PR to incorporate nix into cargo; the code is in the `rust-<version>-libnix` branches, this one is the main line (see [Branches and releases](#branches-and-releases-))
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
