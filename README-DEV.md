# WARNING

This is an unofficial fork of Cargo — not endorsed by the Rust Project.

This fork is intended as a PR to contribute this to the official cargo project and to engineer the solution and to get feedback on the work from the nix community.

# State of development

This documentation is mainly for me and used during development.

The road to get cargo (libnix) to where cargo (legacy) is 'is set' but still a long one. 

It is not only technical problems which have to be solved, some problems are of discipline and social reach like https://github.com/nixcloud/cargo/issues/5.

The main goals should be:
* get all issues tagged with 'upstream' in https://github.com/nixcloud/cargo/issues done
* improve iterative build speed
* automate the release workflow

## Related issues

* https://github.com/nixcloud/cargo/issues

## Related experiments

```
build-rs-example         - a very simple build.rs usage to test cargo (libnix) or logone with
cargo-lib-only-example   - a very simple lib only crate to test cargo (libnix) with
nix-script-experiments   - IDF cargo(libnix), toSource experiments and release.nix to check how cargo (libnix) can be used from nix easily
```

https://github.com/qknight/cargo-experiments

## What works great

* 'cargo build' internally calls 'nix build' (dynamically generates nix expressions)
  * crate dependencies (serde, fmt, ...) are:
    * downloaded into /nix/store
    * built into /nix/store
  * sandboxing for all builds
  * full build.rs support using `build-rs-libnix` helper tool
  * generates on static set of nix expressions for build
  * reuse of crate downloads and crate build artifacts between projects
* advanced cargo like logging in nix with using `logone`
  * based on a new @cargo protocol (i.e. enhanced @nix protocol) - true story
* improved GC
    * toolchain (cargo/rustc) managed from nix
    * intermediate artefacts (crates.io libraries downloads): ~/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/getrandom-0.3.1/ has been moved to the /nix/store
    * intermediate artefacts (crates.io libraries builds with different feature sets): target/debug/deps has been moved to the /nix/store
    * however, registry clone is still at ~/.cargo/registry
* Cargo.dependencies.nix per crate for custom buildInputs `dependencies` and `environment variables`
* support for build system export:
  * `cargo build write-nix-buildsystem --out-dir /tmp/nix --url https://github.com/nixcloud/cargo/archive/refs/tags/1.83-test-release.tar.gz --hash 1h5j1kl7q7mysa943gvd4c8ih8yxx4igqrx4akv9ixf4zf411b8l`
* full flake and nixpkgs support

## What still requires love

### high prio

until 1.may 2026

* release libnix-1.89.0 tag

* no .fingerprint support yet, so no fast iteration on builds, __LOTS__ of unnecessary recompiles
  * https://github.com/nixcloud/cargo/issues/3

  * started to play with  --extra-sandbox-paths /tmp/sandbox-file
    https://github.com/NixOS/nix/issues/6115

    * fix the generated build system for root crates to write into /tmp/out and after build copy /tmp/out/* to $out
    
        /home/nixos/cargo/src/cargo/core/compiler/mod.rs:1238 opt(cmd, "-C", "incremental=$INC_DIR", None);
        $(if [ -d /incremental-target ]; then echo "-C incremental=/incremental-target"; fi) \

    * add conditional "--option extra-sandbox-paths '/incremental-target=/cargo-incremental-target'" if path exists and premissions are good
    
        time nix build target --file nix/cargo_build_caller.nix --out-link /home/nixos/cargo/target/debug/nix/gc/result --option extra-sandbox-paths '/incremental-target=/cargo-incremental-target' --json --log-format internal-json 2>&1 | ~/logone/target/debug/logone --json --level errors

  * add `rustc` file-list (--emit=dep-info) generator for for root crates (experimental)

* write cargo summary post on blog with new things added
  * compiles more software
  * improved build.rs handling
  * build-rs-libnix as build-script-build interpreter
  * releases (which can be mixed with fenix)
  * build system export feature
  * environment variables mixins into crates
  * logone improvements
    * show build type: (build.rs, ...)
  * huge progress in build.rs understanding
    * mention GH issue on OUT_DIR vs. BUILD_OUT_DIR
    * mention multiple build.rs files and that they got it right form the start
    * mention 'permission' concept
  * official release
  * incremental build results
  * outlook

### mid prio

* refactor
  * crates/cargo-util/src/process_builder.rs writes to /tmp/out: for legacy runs more obvious
    * also add check to nix backend (only write with legacy)
  * replace colored (introduced by qknight) with color-print = "0.3.7"

* logone
  * rework --json --mode cargo (both as defaults)
  * see if i can do better error machting so it can be also used to develop with nix build from shell

* figure a way to sync flake and cargo_build_caller.nix builds so they share their artifacts for builds (right now they have different nixpkgs and similar)

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

* rewrite with nuenv for nixpkgs and flakes to get rid of bash

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
  * using this passthru-test it shows that if this line is present:
    ${fn.rustc_propagated_arguments passthru.rust_crate_libraries} \
    then the build will not parallel, but if it is commented out, it will

    1. rustc_propagated_arguments = rust_crate_libraries: lib.replaceStrings ["\n"] [""] (builtins.concatStringsSep " " (map (crate:
    2.   if builtins.pathExists "${crate}/nix/rustc-propagated-arguments" then
    3.    builtins.readFile "${crate}/nix/rustc-propagated-arguments"
    4.  else
    5.    ""
    6.  ) (allCollectedInputs rust_crate_libraries)));

    if line 2+3 is replaced by "" it is fast, so it blocks because of the pathExists/readFile

    solution ideas:
    * replace builtins.pathExists/builtins.readFile and built the rustc command from bash. i tried this for a while but
      ran in into the problem with empty spaces ' ':
        proc-macro2> Compiling proc-macro2-1_0_97-script_build-b0e673af67401d13
        proc-macro2> @cargo { "type":0, "crate_name":"proc-macro2", "crate_type":"(build.rs build)", "id":"proc-macro2-1_0_97-script_build-b0e673af67401d13" }
        proc-macro2> +++ /nix/store/h1c2imj0dpfyyfrd0i6195xznqxcar8x-rust-stable-2025-08-07/bin/rustc --crate-name build_script_build --edition=2021 build.rs --error-format=json --json=diagnostic-rendered-ansi,artifacts,future-incompat --crate-type bin --emit=dep-info,link -C embed-bitcode=no --cfg 'feature="default"' --cfg 'feature="proc-macro"' --check-cfg 'cfg(docsrs,test)' --check-cfg 'cfg(feature, values("default", "nightly", "proc-macro", "span-locations"))' -C metadata=800301207300bbac -C extra-filename=-b0e673af67401d13 --out-dir /nix/store/rdjqd65zqgxkydyb4nl217423539nqn2-proc-macro2-1_0_97-script_build-b0e673af67401d13 -L dependency=/nix/store/46wmzlzs30vcq83wbm1q516cpd0p0zqx-rustc-linker-arguments-dir/deps collect_rustc_propagated_arguments ' ' --cap-lints allow
        proc-macro2> +++ rustc_exit_value=1
        proc-macro2> +++ set +x -e
        proc-macro2> error: multiple input filenames provided (first two filenames are `build.rs` and `collect_rustc_propagated_arguments`)
        proc-macro2> 

      doing this with bash is hard  

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
    [0] run                  Run a binary or example of the local package
    [0] doc                  Build a package's documentation
    [0] test                 Execute all unit and integration tests and build examples of a local package
    [0] check                Check a local package and all of its dependencies for errors
    
    # less common commands (which require backend adaptions)

    [0] clean                Remove artifacts that cargo has generated in the past
    [0] install              Install a Rust binary
    [0] uninstall            Remove a Rust binary
    [0] rustdoc              Build a package's documentation, using specified custom flags.
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
    [0] means unsupported feature, contains a section which prints an error when running anyways in 'nix' mode
    [ ] not supported yet, but command won't tell you but at times fail strangely
    [!] no changes were required, using vanilla cargo



# fail stories

```
######################### build.rs writing system directories ###########################################################
fish-shell           | x |   | WANTS TO READ ./target directory of sorts
        Compiling fish (build.rs run)
        There was an error executing build_script_build in file: '/home/nixos/tests-boss-level/fish-shell/target/debug/nix/derivations/fish-4.3.3-script_build_run-f9b6f9c52c054310.nix':

        thread 'main' panicked at build.rs:16:33:
        called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: "No such file or directory" }
        note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace

        bulid.rs:
            rsconf::set_env_value(
                "FISH_RESOLVED_BUILD_DIR",
                // If set by CMake, this might include symlinks. Since we want to compare this to the
                // dir fish is executed in we need to canonicalize it.
                canonicalize(fish_build_dir()).to_str().unwrap(),
            );
        crates/build-helper/src/lib.rs
          fn cargo_target_dir() -> Cow<'static, Path> {
              option_env!("CARGO_TARGET_DIR")
                  .map(|d| Cow::Borrowed(Path::new(d)))
                  .unwrap_or(Cow::Owned(workspace_root().join("target")))
          }
          pub fn fish_build_dir() -> Cow<'static, Path> {
            option_env!("FISH_CMAKE_BINARY_DIR")
                .map(|d| Cow::Borrowed(Path::new(d)))
                .unwrap_or(cargo_target_dir())
         }
         it probably writes
         src/builtins/status.rs:        #[folder = "$FISH_RESOLVED_BUILD_DIR/fish-docs/man/man1"]
         src/common.rs:pub const BUILD_DIR: &str = env!("FISH_RESOLVED_BUILD_DIR");


######################### c compiler errors #############################################################################


uv                   | ? |   |    Compiling tikv-jemalloc-sys (build.rs run)
        There was an error executing build_script_build in file: '/home/nixos/tests/uv/target/debug/nix/derivations/deps/tikv-jemalloc-sys-0.6.0_plus_5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7-script_build_run-cf70c08376fe7468.nix':
        In file included from /nix/store/gi4cz4ir3zlwhf1azqfgxqdnczfrwsr7-glibc-2.40-66-dev/include/bits/libc-header-start.h:33,
                        from /nix/store/gi4cz4ir3zlwhf1azqfgxqdnczfrwsr7-glibc-2.40-66-dev/include/math.h:27,
                        from include/jemalloc/internal/jemalloc_internal_decls.h:4,
                        from include/jemalloc/internal/jemalloc_preamble.h:5,
                        from src/arena.c:1:
        /nix/store/gi4cz4ir3zlwhf1azqfgxqdnczfrwsr7-glibc-2.40-66-dev/include/features.h:422:4: warning: #warning _FORTIFY_SOURCE requires compiling with optimization (-O) [-Wcpp]
          422 | #  warning _FORTIFY_SOURCE requires compiling with optimization (-O)
              |    ^~~~~~~
        In file included from /nix/store/gi4cz4ir3zlwhf1azqfgxqdnczfrwsr7-glibc-2.40-66-de
rust                 |   |   |    Compiling smallvec
        error[E0554]: `#![feature]` may not be used on the stable release channel
          --> src/lib.rs:96:37
            96 | #![cfg_attr(feature = "may_dangle", feature(dropck_eyepatch))]

  

######################### system libs #############################################################################

servo                | + |   | (no targets, it is a library + bin called servo)
  `cargo build` compiles:
  export LIBCLANG_PATH="/nix/store/xid2z20mcf5ylgpl5w3jbd1bsh7zk4iv-clang-19.1.7-lib/lib"
  buildInputs = python3 uv fontconfig udev libclang clang pkg-config (maybe openssl)

    Compiling servoshell-0_0_4-script_build_run-e0dfd29ff683efe3
    thread 'main' panicked at ports/servoshell/build.rs:38:10:
    called `Option::unwrap()` on a `None` value

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
    xim-parser> Running phase: buildPhase
      xim-parser> realpath: /nix/store/12mvii9qcmcxwhjj6bm20ngz3lz456q3-xim-rs-16f35a2/xim-parser/./xim-parser/Cargo.toml: No such file or directory
      xim-parser> /nix/store/s3w5m3spa1g71hx0yb82lvk6394j3w5j-stdenv-linux/setup: line 1843: cd: /nix/store/12mvii9qcmcxwhjj6bm20ngz3lz456q3-xim-rs-16f35a2/xim-parser/xim-parser: No such file or directory    


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

tauri          2.9.5 |   |   | 
       > Compiling glib-sys-0_18_1-script_build_run-47789649bd661bd9
       >
       > thread 'main' (23) panicked at build-rs-libnix/src/lib.rs:182:71:
       > called `Result::unwrap()` on an `Err` value: NotPresent
       > note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace

    glib-sys> Compiling glib-sys-0_18_1-script_build_run-47789649bd661bd9
                // https://rurust.github.io/cargo-docs-ru/build-script.html#the-links-manifest-key
                // cargo:include=/build/libsqlite3-sys-0.31.0/sqlite3
                // DEP_{}_INCLUDE='value'
                "include" => {
                    let links = std::env::var("CARGO_MANIFEST_LINKS").unwrap().envify();
                    let key = format!("DEP_{}_INCLUDE", links);
                    environment_variables.push(format!("{}='{}'", key, arg))
                },
    seems CARGO_MANIFEST_LINKS was not set... so what now             


influxdb             | ? |   | 
   Compiling proc-macro2
      error: linking with `cc` failed: exit status: 1
        |
        = note:  "cc" "-m64" "/build/rustcwQmWHJ/symbols.o" "<3 object files omitted>" "-Wl,--as-needed" "-Wl,-Bstatic" "<sysroot>/lib/rustlib/x86_64-unknown-linux-gnu/lib/{libstd-*,libpanic_unwind-*,libobject-*,libmemchr-*,libaddr2line-*,libgimli-*,librustc_demangle-*,libstd_detect-*,libhashbrown-*,librustc_std_workspace_alloc-*,libminiz_oxide-*,libadler2-*,libunwind-*,libcfg_if-*,liblibc-*,librustc_std_workspace_core-*,liballoc-*,libcore-*,libcompiler_builtins-*}.rlib" "-Wl,-Bdynamic" "-lgcc_s" "-lutil" "-lrt" "-lpthread" "-lm" "-ldl" "-lc" "-L" "/build/rustcwQmWHJ/raw-dylibs" "-Wl,--eh-frame-hdr" "-Wl,-z,noexecstack" "-L" "<sysroot>/lib/rustlib/x86_64-unknown-linux-gnu/lib" "-o" "/nix/store/71r81vqx67srsq3xp39wxwn5mj4gkmkf-proc-macro2-1_0_104-script_build-ce509221ad1d58e7/build_script_build-ce509221ad1d58e7" "-Wl,--gc-sections" "-pie" "-Wl,-z,relro,-z,now" "-nodefaultlibs" "-fuse-ld=lld" "-Wl,--no-rosegment"
        = note: some arguments are omitted. use `--verbose` to show all linker arguments
        = note: collect2: fatal error: cannot find 'ld'
                compilation terminated.
meilisearch          | x |   | 
        Compiling benchmarks (build.rs run)
        There was an error executing build_script_build in file: '/home/nixos/tests/meilisearch/target/debug/nix/derivations/benchmarks-1.32.2-script_build_run-d1113bf5e5b02ba4.nix':
        downloading: https://milli-benchmarks.fra1.digitaloceanspaces.com/datasets/smol-songs.csv.gz
        Error: error sending request for url (https://milli-benchmarks.fra1.digitaloceanspaces.com/datasets/smol-songs.csv.gz)

        Caused by:
            0: client error (Connect)
            1: dns error
            2: failed to lookup address information: Temporary failure in name resolution

ka4h2        v0.0.30 | x |   |    
    Compiling ka4h2 error: couldn't read `src/pages/../../target/markdown/datenschutz.html`: No such file or directory (os error 2)
      --> src/pages/datenschutz.rs:3:29
      3 | const ABOUT_DE_HTML: &str = include_str!("../../target/markdown/datenschutz.html");
        |                             ^^^^^^^^^^^^^^
      
helix                |   |   | helix-term/build.rs:5:26:\nFailed to fetch tree-sitter grammars: 277 grammars failed to fetch


bevy                 |   |   | fails to create build system (target)

egui                 | x |   | 

        Compiling atspi-proxies
      error[E0433]: failed to resolve: could not find `zvariant` in the list of imported crates
        --> src/device_event_controller.rs:37:69
        |
      37 | #[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize, Deserialize, Type)]
        |                                                                     ^^^^ could not find `zvariant` in the list of imported crates
        |
        = note: this error originates in the derive macro `Type` (in Nightly builds, run with -Z macro-backtrace for more info)  

########################  package cargo (with libnix backend) ########################################

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
