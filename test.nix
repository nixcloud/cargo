# Regression tests (nixcloud/cargo#18): builds third party projects with the cargo (libnix) of this checkout.
#
# For each project, cargo (libnix) built from this working tree (flake output cargo-libnix-git-head-via-ifd)
# writes the nix build system of the pinned revision (IFD), which is then built with the same rustc/cargo
# version the generator runs with (1.99), like cargo_build_caller.nix does.
#
#   nix-build test.nix -A fd.smoke                # one project: its root units (`cargo build`), binaries run
#   nix-build test.nix -A fd.target               # only build the root units
#   nix-build test.nix -A fd.generated            # only the generated build system
#   nix-build test.nix -A all --keep-going        # everything
#   tests-libnix/run.sh [project...]              # one by one, with a log each and RESULTS.md
#
# Projects that need system libraries get tests-libnix/<name>/Cargo.dependencies.nix; by default the one of this
# repository (openssl-sys).
{ system ? builtins.currentSystem
, flake ? builtins.getFlake "git+file://${toString ./.}"
, pkgs ? flake.inputs.nixpkgs.legacyPackages.${system}
, cargo-libnix ? flake.packages.${system}.cargo-libnix-git-head-via-ifd
, rustc ? flake.packages.${system}.rustc_1_99_nix_ld
, cargo ? flake.packages.${system}.cargo_1_99_vanilla_pin
}:
let
  lib = pkgs.lib;

  projects = {
    atuin = { owner = "atuinsh"; repo = "atuin"; rev = "53acf850f37d8cc8ffdcfebd7a73343f8dc339b6"; };
    axum = { owner = "tokio-rs"; repo = "axum"; rev = "05de165de2245dcd685c96dc78d67150ce8679fe"; };
    bat = { owner = "sharkdp"; repo = "bat"; rev = "4e84e838a32e3b326a3d1f9e2cd4c879597ad74d"; };
    # rust-v0.0.2506060849 (2025-06-06); 246f5065 needs rustc 1.88
    codex = { owner = "openai"; repo = "codex"; rev = "5fc3c3023d9f179fb416b2722d1434bac278e916"; subdir = "codex-rs"; };
    coreutils = { owner = "uutils"; repo = "coreutils"; rev = "44e0bba5ec95fcca0c4fc01e7aa815afc377cbb3"; };
    delta = { owner = "dandavison"; repo = "delta"; rev = "acd758f7a08df6c2ac5542a2c5a4034c664a9ed8"; };
    eza = { owner = "eza-community"; repo = "eza"; rev = "58b98cfa542fdd6ac5bba8fb13f077e9f6fd1f5b"; };
    fd = { owner = "sharkdp"; repo = "fd"; rev = "7f58e8f7064346ffe569563b657fe92f24830e6a"; };
    fuse-rs = { owner = "zargony"; repo = "fuse-rs"; rev = "39fde4a5c47ce370d228ac190f950bd835db7f47"; };
    # main (2025-09-29, 1.0.45); the TUI binary only (README: `cargo build -p xai-grok-pager-bin --release`; release
    # embeds the rg/fd its build scripts would download, see its Cargo.dependencies.nix). 1457 units, rust-version 1.94
    grok-build = { owner = "xai-org"; repo = "grok-build"; rev = "2bdd1d6a6369de0e8c68132ea4539e9abd9e14a8"; cargoFlags = [ "-p" "xai-grok-pager-bin" "--release" ]; };
    just = { owner = "casey"; repo = "just"; rev = "5732ee083a58c534804d184acbdede11d1bbaac5"; };
    # v0.8.2 (2025-05-06); dd507168 needs rustc 1.88
    leptos = { owner = "leptos-rs"; repo = "leptos"; rev = "2ee4444bb44310e73e908b98ccd2b353f534da01"; };
    lightningcss = { owner = "parcel-bundler"; repo = "lightningcss"; rev = "400f705e63e139c326f480aed11e1416f5a3a61f"; };
    # v0.4.51 (2025-05-26); cc78fb4f needs rustc 1.88
    mdBook = { owner = "rust-lang"; repo = "mdBook"; rev = "f93b2675ffde5bf22a108a9d65725b65d5b153d4"; };
    nix-installer = { owner = "DeterminateSystems"; repo = "nix-installer"; rev = "d2feb9836f5af7085ba84388d59a38f8998f65dc"; };
    nushell = { owner = "nushell"; repo = "nushell"; rev = "1aa2ed1947a0b891398558fcf4e4289849cc5a1d"; };
    ripgrep = { owner = "BurntSushi"; repo = "ripgrep"; rev = "0a88cccd5188074de96f54a4b6b44a63971ac157"; };
    rust-analyzer = { owner = "rust-lang"; repo = "rust-analyzer"; rev = "cd12ef8547d3a760461b5361cb81ca4084197232"; };
    rustpad = { owner = "ekzhang"; repo = "rustpad"; rev = "54e4a9383c84d7317af42a7ddb177ce8bcba058d"; };
    RustPython = { owner = "RustPython"; repo = "RustPython"; rev = "1abaf87abe241da7a9836bd387f2aee33a1d6378"; };
    sd = { owner = "chmln"; repo = "sd"; rev = "87d1ba5b3401329a07c1874e49a822026e1cbf3f"; };
    # v1.4.0 (2025-06-27); 7290ba22 needs rustc 1.88
    sniffnet = { owner = "GyulyVGC"; repo = "sniffnet"; rev = "069a7bd314483e7639c7078d47c77a9308832715"; };
    # v1.23.0 (2025-04-27); 37b6225a needs rustc 1.89
    starship = { owner = "starship"; repo = "starship"; rev = "661c8a2c1cc43b1c0ba1f034ee1dd17442cce815"; };
    synapse = { owner = "Luminarys"; repo = "synapse"; rev = "f2a55724d5571d2b438294f691b7b6f262510c47"; };
    todo = { owner = "sioodmy"; repo = "todo"; rev = "02a002153a4536a15a9fd3b5ddbeed93aff80780"; };
    tokio = { owner = "tokio-rs"; repo = "tokio"; rev = "df73fa21884f65ac4f5556ec72814cefed94897f"; };
    trunk = { owner = "trunk-rs"; repo = "trunk"; rev = "f1ee3d4032cb939b8513d1d8fabfcb84ce46d811"; };
    # v0.13.1 (2025-03-07); 9f3a9e72 needs rustc 1.89
    typst = { owner = "typst"; repo = "typst"; rev = "8ace67d942a4b8c6b9d95b73b3a39f5d0259c7b2"; };
    # main (2025-06-14, no release tags); c68c3b2d needs rustc 1.90. Fails either way: union pins nightly-2025-03-28 (#![feature])
    union = { owner = "unionlabs"; repo = "union"; rev = "64d943d04294c6c4637b22082c9feee88ce8be13"; };
    # a database backend is required (README: `cargo build --features sqlite`)
    vaultwarden = { owner = "dani-garcia"; repo = "vaultwarden"; rev = "5d84f17600e179280e44c391b92ee9eecc2b7cdc"; cargoFlags = [ "--features" "sqlite" ]; };
    # v33.0.0 (2025-05-20); ecd1cb3d needs rustc 1.90
    wasmtime = { owner = "bytecodealliance"; repo = "wasmtime"; rev = "4ce8232ab9ac86bcb299ed670593ed26f69e63df"; };
    yew = { owner = "yewstack"; repo = "yew"; rev = "2019f4577cbdcd389b34973fdec3164be3af941a"; };
  };

  # pinned revision -> generated build system (IFD) -> root units
  buildProject = name: p:
    let
      src = builtins.fetchGit {
        url = "https://github.com/${p.owner}/${p.repo}";
        inherit (p) rev;
        shallow = true;
        submodules = p.submodules or false;
      };
      subdir = p.subdir or "";
      project_root = if subdir == "" then src else "${src}/${subdir}";
      # tests-libnix/<name>: a Cargo.lock for projects without one, a Cargo.dependencies.nix for system libraries
      extra = ./tests-libnix + "/${name}";
      ownLock = builtins.pathExists (extra + "/Cargo.lock");
      lockFile = if ownLock then extra + "/Cargo.lock" else "${project_root}/Cargo.lock";

      lock = builtins.fromTOML (builtins.readFile lockFile);
      crateTarballs = map (c: pkgs.fetchurl {
          name = "crate-${c.name}-${c.version}.tar.gz";
          url = "https://crates.io/api/v1/crates/${c.name}/${c.version}/download";
          # lockfile v1: checksums in [metadata]
          sha256 = c.checksum or lock.metadata."checksum ${c.name} ${c.version} (${c.source})";
        })
        (builtins.filter (c: (c.source or "") == "registry+https://github.com/rust-lang/crates.io-index") lock.package);

      # git dependencies: the generator runs in the sandbox, so cargo gets them as a vendored source
      # (importCargoLock), and libnix's `nix-prefetch-git` (for the hash of the `pkgs.fetchgit` it writes, and the
      # checkout to find a package in) is answered from checkouts made during evaluation. Shallow, with submodules
      # like pkgs.fetchgit: with their hashes importCargoLock fetches the same `pkgs.fetchgit` as the build
      gitPackages = lib.concatMap (c:
        let m = builtins.match "git\\+([^?#]*)(\\?[^#]*)?#(.*)" (c.source or "");
        in lib.optional (m != null) (c // { url = builtins.elemAt m 0; rev = builtins.elemAt m 2; })) lock.package;
      gitSources = lib.unique (map (c: { inherit (c) url rev; }) gitPackages);
      checkout = g: builtins.fetchGit { inherit (g) url rev; shallow = true; submodules = true; };
      # only the git packages: crates.io ones come from crateTarballs, and a crate both from crates.io and git
      # (same name and version) would collide in the vendor directory
      vendor = pkgs.rustPlatform.importCargoLock {
        lockFileContents = "version = ${toString (lock.version or 1)}\n" + lib.concatMapStrings (c: ''

          [[package]]
          name = "${c.name}"
          version = "${c.version}"
          source = "${c.source}"
        '') gitPackages;
        outputHashes = lib.listToAttrs (map (c: lib.nameValuePair "${c.name}-${c.version}" (checkout c).narHash) gitPackages);
      };
      prefetchGit = pkgs.writeShellScriptBin "nix-prefetch-git" ''
        while [ $# -gt 0 ]; do
          case $1 in --url) url=$2; shift ;; --rev) rev=$2; shift ;; esac
          shift
        done
        case "$url $rev" in
        ${lib.concatMapStrings (g:
          let
            narHash = (checkout g).narHash;
            sha256 = builtins.convertHash { hash = narHash; toHashFormat = "nix32"; };
          in ''
            "${g.url} ${g.rev}") echo '{"url": "${g.url}", "rev": "${g.rev}", "sha256": "${sha256}", "hash": "${narHash}", "path": "${checkout g}", "date": ""}' ;;
          '') gitSources}
          *) echo "nix-prefetch-git (test.nix): $url $rev is not a git source of Cargo.lock" >&2; exit 1 ;;
        esac
      '';

      generated = pkgs.runCommand "cargo-nix-generated-${name}" {
        inherit crateTarballs;
        nativeBuildInputs = [ cargo-libnix rustc ] ++ lib.optional (gitSources != [ ]) prefetchGit;
      } ''
        export HOME=$TMPDIR CARGO_BACKEND=nix
        ${lib.optionalString (gitSources != [ ]) ''
          mkdir -p $HOME/.cargo
          { echo '[source.vendored-sources]'
            echo 'directory = "${vendor}"'
            sed -n '/^\[source."git+/,$p' ${vendor}/.cargo/config.toml
          } > $HOME/.cargo/config.toml
        ''}
        cp -r ${src} project && chmod -R u+w project && cd project/${subdir}
        ${lib.optionalString ownLock "cp ${lockFile} Cargo.lock"}
        ${cargo-libnix}/bin/cargo build --offline ${lib.escapeShellArgs (p.cargoFlags or [ ])} write-nix-buildsystem --out-dir $out
      '';

      dependencies = if builtins.pathExists (extra + "/Cargo.dependencies.nix") then extra + "/Cargo.dependencies.nix" else ./Cargo.dependencies.nix;
      external_crate_dependencies = import dependencies { inherit pkgs; };
      units = import "${generated}/derivations/default.nix" {
        inherit pkgs project_root external_crate_dependencies rustc cargo;
      };

      # the binaries of the root units (`<crate>-<version>-bin-<hash>`)
      bins = lib.attrValues (lib.filterAttrs (n: v: lib.hasInfix "-bin-" n && lib.isDerivation v) units);
      # a working binary: each runs `--version` (or `--help`). Exit code 0 is ok, so is a usage error (some tools
      # want a subcommand or an environment variable) and still running after 10s (a server ignoring arguments);
      # a panic (101), not being able to execute (126, 127: e.g. missing libraries) or a signal (> 128) is not
      smoke = pkgs.runCommand "cargo-libnix-smoke-${name}" { } ''
        export HOME=$TMPDIR
        mkdir -p $out
        ok=1
        for bin in ${lib.concatMapStringsSep " " (b: "${b}/bin/*") bins}; do
          [ -x "$bin" ] || continue
          rc=0; msg=$(timeout 10 "$bin" --version 2>&1 </dev/null) || rc=$?
          if [ $rc != 0 ] && [ $rc != 124 ]; then
            rc=0; msg=$(timeout 10 "$bin" --help 2>&1 </dev/null) || rc=$?
          fi
          if [ $rc = 0 ]; then
            echo "ok $(basename "$bin"): $(echo "$msg" | head -1)" >> $out/smoke.txt
          elif [ $rc = 124 ]; then
            echo "ok (still running after 10s) $(basename "$bin"): $(echo "$msg" | head -1)" >> $out/smoke.txt
          elif [ $rc = 101 ] || [ $rc -ge 126 ]; then
            echo "FAILED (exit $rc) $(basename "$bin"): $(echo "$msg" | head -3)" >> $out/smoke.txt
            ok=0
          else
            echo "ok (exit $rc) $(basename "$bin"): $(echo "$msg" | head -1)" >> $out/smoke.txt
          fi
        done
        [ -f $out/smoke.txt ] || echo "no binaries" > $out/smoke.txt
        cat $out/smoke.txt
        ln -s ${units.target} $out/target
        [ $ok = 1 ]
      '';
    in
    { inherit src generated units smoke; inherit (units) target; };

  built = lib.mapAttrs buildProject projects;
in
built // {
  all = pkgs.linkFarm "cargo-libnix-tests" (lib.mapAttrsToList (name: p: { inherit name; path = p.smoke; }) built);
  # for tests-libnix/run.sh
  inherit projects;
}
