# generated from rustc-call.nix.handlebars using cargo (manual edits won't be persistent)
{ pkgs, fn, cargo, rustc, deps, project_root, build_parser, cargo-0_88_0-script_build-cfc654fccb259515 }: with deps;
  pkgs.stdenv.mkDerivation rec {
    name = "cargo-0_88_0-script_build_run-f5d51778f22880c0";
    meta.cargo_crate_info = {
      name = "cargo";
      version = "0.88.0";
      crate_hash = "f5d51778f22880c0";
    };
    buildInputs = [] ++ fn.inject meta.cargo_crate_info;
    env = fn.inject_envs meta.cargo_crate_info;

    passthru.rust_crate_libraries = [];
    passthru.rust_crate_parent = [cargo-0_88_0-script_build-cfc654fccb259515];
    passthru.rust_script_build_run = [curl-sys-0_4_80_plus_curl-8_12_1-db5fbe1d9680c71f libgit2-sys-0_18_0_plus_1_9_0-86c4b3f8f5bf526a];
    phases = "";

    src = pkgs.lib.fileset.toSource rec {
      root = project_root;
      fileset = fn.relativeFileset project_root [
        "src/etc/man/cargo-add.1"
        "src/etc/man/cargo-bench.1"
        "src/etc/man/cargo-build.1"
        "src/etc/man/cargo-check.1"
        "src/etc/man/cargo-clean.1"
        "src/etc/man/cargo-doc.1"
        "src/etc/man/cargo-fetch.1"
        "src/etc/man/cargo-fix.1"
        "src/etc/man/cargo-generate-lockfile.1"
        "src/etc/man/cargo-help.1"
        "src/etc/man/cargo-info.1"
        "src/etc/man/cargo-init.1"
        "src/etc/man/cargo-install.1"
        "src/etc/man/cargo-locate-project.1"
        "src/etc/man/cargo-login.1"
        "src/etc/man/cargo-logout.1"
        "src/etc/man/cargo-metadata.1"
        "src/etc/man/cargo-new.1"
        "src/etc/man/cargo-owner.1"
        "src/etc/man/cargo-package.1"
        "src/etc/man/cargo-pkgid.1"
        "src/etc/man/cargo-publish.1"
        "src/etc/man/cargo-remove.1"
        "src/etc/man/cargo-report.1"
        "src/etc/man/cargo-run.1"
        "src/etc/man/cargo-rustc.1"
        "src/etc/man/cargo-rustdoc.1"
        "src/etc/man/cargo-search.1"
        "src/etc/man/cargo-test.1"
        "src/etc/man/cargo-tree.1"
        "src/etc/man/cargo-uninstall.1"
        "src/etc/man/cargo-update.1"
        "src/etc/man/cargo-vendor.1"
        "src/etc/man/cargo-version.1"
        "src/etc/man/cargo-yank.1"
        "src/etc/man/cargo.1"
        "src/doc/man/generated_txt/cargo-add.txt"
        "src/doc/man/generated_txt/cargo-bench.txt"
        "src/doc/man/generated_txt/cargo-build.txt"
        "src/doc/man/generated_txt/cargo-check.txt"
        "src/doc/man/generated_txt/cargo-clean.txt"
        "src/doc/man/generated_txt/cargo-doc.txt"
        "src/doc/man/generated_txt/cargo-fetch.txt"
        "src/doc/man/generated_txt/cargo-fix.txt"
        "src/doc/man/generated_txt/cargo-generate-lockfile.txt"
        "src/doc/man/generated_txt/cargo-help.txt"
        "src/doc/man/generated_txt/cargo-info.txt"
        "src/doc/man/generated_txt/cargo-init.txt"
        "src/doc/man/generated_txt/cargo-install.txt"
        "src/doc/man/generated_txt/cargo-locate-project.txt"
        "src/doc/man/generated_txt/cargo-login.txt"
        "src/doc/man/generated_txt/cargo-logout.txt"
        "src/doc/man/generated_txt/cargo-metadata.txt"
        "src/doc/man/generated_txt/cargo-new.txt"
        "src/doc/man/generated_txt/cargo-owner.txt"
        "src/doc/man/generated_txt/cargo-package.txt"
        "src/doc/man/generated_txt/cargo-pkgid.txt"
        "src/doc/man/generated_txt/cargo-publish.txt"
        "src/doc/man/generated_txt/cargo-remove.txt"
        "src/doc/man/generated_txt/cargo-report.txt"
        "src/doc/man/generated_txt/cargo-run.txt"
        "src/doc/man/generated_txt/cargo-rustc.txt"
        "src/doc/man/generated_txt/cargo-rustdoc.txt"
        "src/doc/man/generated_txt/cargo-search.txt"
        "src/doc/man/generated_txt/cargo-test.txt"
        "src/doc/man/generated_txt/cargo-tree.txt"
        "src/doc/man/generated_txt/cargo-uninstall.txt"
        "src/doc/man/generated_txt/cargo-update.txt"
        "src/doc/man/generated_txt/cargo-vendor.txt"
        "src/doc/man/generated_txt/cargo-version.txt"
        "src/doc/man/generated_txt/cargo-yank.txt"
        "src/doc/man/generated_txt/cargo.txt"
      ];
    };

    # src = pkgs.lib.fileset.toSource {
    #   root = /home/nixos/cargo;
    #   fileset = pkgs.lib.fileset.unions [
    #     /home/nixos/cargo/Cargo.toml
    #     /home/nixos/cargo/Cargo.lock
    #     /home/nixos/cargo/src/etc/man/cargo-vendor.1
    #     /home/nixos/cargo/src/etc/man/cargo-doc.1
    #     /home/nixos/cargo/src/etc/man/cargo-info.1
    #     /home/nixos/cargo/src/etc/man/cargo-install.1
    #     /home/nixos/cargo/src/etc/man/cargo-tree.1
    #     /home/nixos/cargo/src/etc/man/cargo-help.1
    #     /home/nixos/cargo/src/etc/man/cargo-yank.1
    #     /home/nixos/cargo/src/etc/man/cargo-run.1
    #     /home/nixos/cargo/src/etc/man/cargo-clean.1
    #     /home/nixos/cargo/src/etc/man/cargo-package.1
    #     /home/nixos/cargo/src/etc/man/cargo-rustc.1
    #     /home/nixos/cargo/src/etc/man/cargo-owner.1
    #     /home/nixos/cargo/src/etc/man/cargo-check.1
    #     /home/nixos/cargo/src/etc/man/cargo-add.1
    #     /home/nixos/cargo/src/etc/man/cargo-fix.1
    #     /home/nixos/cargo/src/etc/man/cargo-locate-project.1
    #     /home/nixos/cargo/src/etc/man/cargo-logout.1
    #     /home/nixos/cargo/src/etc/man/cargo-uninstall.1
    #     /home/nixos/cargo/src/etc/man/cargo-test.1
    #     /home/nixos/cargo/src/etc/man/cargo-pkgid.1
    #     /home/nixos/cargo/src/etc/man/cargo-init.1
    #     /home/nixos/cargo/src/etc/man/cargo-login.1
    #     /home/nixos/cargo/src/etc/man/cargo.1
    #     /home/nixos/cargo/src/etc/man/cargo-search.1
    #     /home/nixos/cargo/src/etc/man/cargo-remove.1
    #     /home/nixos/cargo/src/etc/man/cargo-bench.1
    #     /home/nixos/cargo/src/etc/man/cargo-update.1
    #     /home/nixos/cargo/src/etc/man/cargo-fetch.1
    #     /home/nixos/cargo/src/etc/man/cargo-generate-lockfile.1
    #     /home/nixos/cargo/src/etc/man/cargo-publish.1
    #     /home/nixos/cargo/src/etc/man/cargo-build.1
    #     /home/nixos/cargo/src/etc/man/cargo-metadata.1
    #     /home/nixos/cargo/src/etc/man/cargo-report.1
    #     /home/nixos/cargo/src/etc/man/cargo-rustdoc.1
    #     /home/nixos/cargo/src/etc/man/cargo-version.1
    #     /home/nixos/cargo/src/etc/man/cargo-new.1
    #     /home/nixos/cargo/src/etc/man
    #     /home/nixos/cargo/src/etc/_cargo
    #     /home/nixos/cargo/src/etc/cargo.bashcomp.sh
    #     /home/nixos/cargo/src/doc
    #     /home/nixos/cargo/src/doc/contrib
    #     /home/nixos/cargo/src/doc/contrib/src
    #     /home/nixos/cargo/src/doc/contrib/src/design.md
    #     /home/nixos/cargo/src/doc/contrib/src/process
    #     /home/nixos/cargo/src/doc/contrib/src/process/security.md
    #     /home/nixos/cargo/src/doc/contrib/src/process/rfc.md
    #     /home/nixos/cargo/src/doc/contrib/src/process/release.md
    #     /home/nixos/cargo/src/doc/contrib/src/process/unstable.md
    #     /home/nixos/cargo/src/doc/contrib/src/process/working-on-cargo.md
    #     /home/nixos/cargo/src/doc/contrib/src/process/index.md
    #     /home/nixos/cargo/src/doc/contrib/src/implementation
    #     /home/nixos/cargo/src/doc/contrib/src/implementation/formatting.md
    #     /home/nixos/cargo/src/doc/contrib/src/implementation/debugging.md
    #     /home/nixos/cargo/src/doc/contrib/src/implementation/console.md
    #     /home/nixos/cargo/src/doc/contrib/src/implementation/architecture.md
    #     /home/nixos/cargo/src/doc/contrib/src/implementation/packages.md
    #     /home/nixos/cargo/src/doc/contrib/src/implementation/schemas.md
    #     /home/nixos/cargo/src/doc/contrib/src/implementation/subcommands.md
    #     /home/nixos/cargo/src/doc/contrib/src/implementation/filesystem.md
    #     /home/nixos/cargo/src/doc/contrib/src/implementation/index.md
    #     /home/nixos/cargo/src/doc/contrib/src/team.md
    #     /home/nixos/cargo/src/doc/contrib/src/issues.md
    #     /home/nixos/cargo/src/doc/contrib/src/SUMMARY.md
    #     /home/nixos/cargo/src/doc/contrib/src/tests
    #     /home/nixos/cargo/src/doc/contrib/src/tests/profiling.md
    #     /home/nixos/cargo/src/doc/contrib/src/tests/writing.md
    #     /home/nixos/cargo/src/doc/contrib/src/tests/running.md
    #     /home/nixos/cargo/src/doc/contrib/src/tests/crater.md
    #     /home/nixos/cargo/src/doc/contrib/src/tests/index.md
    #     /home/nixos/cargo/src/doc/contrib/src/index.md
    #     /home/nixos/cargo/src/doc/contrib/book.toml
    #     /home/nixos/cargo/src/doc/contrib/README.md
    #     /home/nixos/cargo/src/doc/theme
    #     /home/nixos/cargo/src/doc/theme/favicon.png
    #     /home/nixos/cargo/src/doc/theme/head.hbs
    #     /home/nixos/cargo/src/doc/src
    #     /home/nixos/cargo/src/doc/src/reference
    #     /home/nixos/cargo/src/doc/src/reference/future-incompat-report.md
    #     /home/nixos/cargo/src/doc/src/reference/source-replacement.md
    #     /home/nixos/cargo/src/doc/src/reference/semver.md
    #     /home/nixos/cargo/src/doc/src/reference/registry-index.md
    #     /home/nixos/cargo/src/doc/src/reference/build-script-examples.md
    #     /home/nixos/cargo/src/doc/src/reference/overriding-dependencies.md
    #     /home/nixos/cargo/src/doc/src/reference/environment-variables.md
    #     /home/nixos/cargo/src/doc/src/reference/manifest.md
    #     /home/nixos/cargo/src/doc/src/reference/credential-provider-protocol.md
    #     /home/nixos/cargo/src/doc/src/reference/timings.md
    #     /home/nixos/cargo/src/doc/src/reference/features-examples.md
    #     /home/nixos/cargo/src/doc/src/reference/workspaces.md
    #     /home/nixos/cargo/src/doc/src/reference/unstable.md
    #     /home/nixos/cargo/src/doc/src/reference/running-a-registry.md
    #     /home/nixos/cargo/src/doc/src/reference/cargo-targets.md
    #     /home/nixos/cargo/src/doc/src/reference/external-tools.md
    #     /home/nixos/cargo/src/doc/src/reference/resolver.md
    #     /home/nixos/cargo/src/doc/src/reference/lints.md
    #     /home/nixos/cargo/src/doc/src/reference/build-cache.md
    #     /home/nixos/cargo/src/doc/src/reference/build-scripts.md
    #     /home/nixos/cargo/src/doc/src/reference/rust-version.md
    #     /home/nixos/cargo/src/doc/src/reference/features.md
    #     /home/nixos/cargo/src/doc/src/reference/profiles.md
    #     /home/nixos/cargo/src/doc/src/reference/publishing.md
    #     /home/nixos/cargo/src/doc/src/reference/config.md
    #     /home/nixos/cargo/src/doc/src/reference/registry-web-api.md
    #     /home/nixos/cargo/src/doc/src/reference/pkgid-spec.md
    #     /home/nixos/cargo/src/doc/src/reference/registries.md
    #     /home/nixos/cargo/src/doc/src/reference/registry-authentication.md
    #     /home/nixos/cargo/src/doc/src/reference/specifying-dependencies.md
    #     /home/nixos/cargo/src/doc/src/reference/index.md
    #     /home/nixos/cargo/src/doc/src/getting-started
    #     /home/nixos/cargo/src/doc/src/getting-started/first-steps.md
    #     /home/nixos/cargo/src/doc/src/getting-started/installation.md
    #     /home/nixos/cargo/src/doc/src/getting-started/index.md
    #     /home/nixos/cargo/src/doc/src/images
    #     /home/nixos/cargo/src/doc/src/images/cargo-concurrency-over-time.png
    #     /home/nixos/cargo/src/doc/src/images/org-level-acl.png
    #     /home/nixos/cargo/src/doc/src/images/build-info.png
    #     /home/nixos/cargo/src/doc/src/images/winapi-features.svg
    #     /home/nixos/cargo/src/doc/src/images/auth-level-acl.png
    #     /home/nixos/cargo/src/doc/src/images/build-unit-time.png
    #     /home/nixos/cargo/src/doc/src/images/Cargo-Logo-Small.png
    #     /home/nixos/cargo/src/doc/src/appendix
    #     /home/nixos/cargo/src/doc/src/appendix/glossary.md
    #     /home/nixos/cargo/src/doc/src/appendix/git-authentication.md
    #     /home/nixos/cargo/src/doc/src/commands
    #     /home/nixos/cargo/src/doc/src/commands/cargo-update.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-fix.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-remove.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-package.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-rustdoc.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-metadata.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-fetch.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-yank.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-build.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-vendor.md
    #     /home/nixos/cargo/src/doc/src/commands/deprecated-and-removed.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-test.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-version.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-install.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-run.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-add.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-pkgid.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-new.md
    #     /home/nixos/cargo/src/doc/src/commands/package-commands.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-owner.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-clippy.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-help.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-fmt.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-clean.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-info.md
    #     /home/nixos/cargo/src/doc/src/commands/publishing-commands.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-uninstall.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-bench.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-tree.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-search.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-generate-lockfile.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-report.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-miri.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-locate-project.md
    #     /home/nixos/cargo/src/doc/src/commands/build-commands.md
    #     /home/nixos/cargo/src/doc/src/commands/general-commands.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-rustc.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-doc.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-login.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-check.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-publish.md
    #     /home/nixos/cargo/src/doc/src/commands/manifest-commands.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-logout.md
    #     /home/nixos/cargo/src/doc/src/commands/index.md
    #     /home/nixos/cargo/src/doc/src/commands/cargo-init.md
    #     /home/nixos/cargo/src/doc/src/CHANGELOG.md
    #     /home/nixos/cargo/src/doc/src/SUMMARY.md
    #     /home/nixos/cargo/src/doc/src/faq.md
    #     /home/nixos/cargo/src/doc/src/index.md
    #     /home/nixos/cargo/src/doc/src/guide
    #     /home/nixos/cargo/src/doc/src/guide/continuous-integration.md
    #     /home/nixos/cargo/src/doc/src/guide/creating-a-new-project.md
    #     /home/nixos/cargo/src/doc/src/guide/tests.md
    #     /home/nixos/cargo/src/doc/src/guide/why-cargo-exists.md
    #     /home/nixos/cargo/src/doc/src/guide/project-layout.md
    #     /home/nixos/cargo/src/doc/src/guide/working-on-an-existing-project.md
    #     /home/nixos/cargo/src/doc/src/guide/dependencies.md
    #     /home/nixos/cargo/src/doc/src/guide/cargo-home.md
    #     /home/nixos/cargo/src/doc/src/guide/cargo-toml-vs-cargo-lock.md
    #     /home/nixos/cargo/src/doc/src/guide/index.md
    #     /home/nixos/cargo/src/doc/book.toml
    #     /home/nixos/cargo/src/doc/man
    #     /home/nixos/cargo/src/doc/man/cargo-update.md
    #     /home/nixos/cargo/src/doc/man/cargo-fix.md
    #     /home/nixos/cargo/src/doc/man/cargo-remove.md
    #     /home/nixos/cargo/src/doc/man/cargo-package.md
    #     /home/nixos/cargo/src/doc/man/cargo-rustdoc.md
    #     /home/nixos/cargo/src/doc/man/cargo-metadata.md
    #     /home/nixos/cargo/src/doc/man/cargo-fetch.md
    #     /home/nixos/cargo/src/doc/man/cargo-yank.md
    #     /home/nixos/cargo/src/doc/man/cargo-build.md
    #     /home/nixos/cargo/src/doc/man/cargo-vendor.md
    #     /home/nixos/cargo/src/doc/man/includes
    #     /home/nixos/cargo/src/doc/man/includes/options-output-format.md
    #     /home/nixos/cargo/src/doc/man/includes/section-options-common.md
    #     /home/nixos/cargo/src/doc/man/includes/options-index.md
    #     /home/nixos/cargo/src/doc/man/includes/description-one-target.md
    #     /home/nixos/cargo/src/doc/man/includes/options-targets-lib-bin.md
    #     /home/nixos/cargo/src/doc/man/includes/options-targets.md
    #     /home/nixos/cargo/src/doc/man/includes/section-exit-status.md
    #     /home/nixos/cargo/src/doc/man/includes/options-test.md
    #     /home/nixos/cargo/src/doc/man/includes/options-release.md
    #     /home/nixos/cargo/src/doc/man/includes/section-package-selection.md
    #     /home/nixos/cargo/src/doc/man/includes/options-registry.md
    #     /home/nixos/cargo/src/doc/man/includes/options-lockfile-path.md
    #     /home/nixos/cargo/src/doc/man/includes/options-target-triple.md
    #     /home/nixos/cargo/src/doc/man/includes/options-target-dir.md
    #     /home/nixos/cargo/src/doc/man/includes/options-profile-legacy-check.md
    #     /home/nixos/cargo/src/doc/man/includes/section-environment.md
    #     /home/nixos/cargo/src/doc/man/includes/options-future-incompat.md
    #     /home/nixos/cargo/src/doc/man/includes/section-features.md
    #     /home/nixos/cargo/src/doc/man/includes/options-manifest-path.md
    #     /home/nixos/cargo/src/doc/man/includes/options-keep-going.md
    #     /home/nixos/cargo/src/doc/man/includes/options-jobs.md
    #     /home/nixos/cargo/src/doc/man/includes/options-profile.md
    #     /home/nixos/cargo/src/doc/man/includes/options-targets-bin-auto-built.md
    #     /home/nixos/cargo/src/doc/man/includes/options-timings.md
    #     /home/nixos/cargo/src/doc/man/includes/options-new.md
    #     /home/nixos/cargo/src/doc/man/includes/section-options-package.md
    #     /home/nixos/cargo/src/doc/man/includes/options-display.md
    #     /home/nixos/cargo/src/doc/man/includes/options-message-format.md
    #     /home/nixos/cargo/src/doc/man/includes/options-token.md
    #     /home/nixos/cargo/src/doc/man/includes/options-locked.md
    #     /home/nixos/cargo/src/doc/man/includes/options-ignore-rust-version.md
    #     /home/nixos/cargo/src/doc/man/includes/description-install-root.md
    #     /home/nixos/cargo/src/doc/man/cargo-test.md
    #     /home/nixos/cargo/src/doc/man/cargo-version.md
    #     /home/nixos/cargo/src/doc/man/cargo-install.md
    #     /home/nixos/cargo/src/doc/man/cargo-run.md
    #     /home/nixos/cargo/src/doc/man/cargo-add.md
    #     /home/nixos/cargo/src/doc/man/cargo-pkgid.md
    #     /home/nixos/cargo/src/doc/man/generated_txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-install.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-package.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-run.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-publish.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-login.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-remove.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-help.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-update.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-init.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-metadata.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-pkgid.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-rustdoc.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-uninstall.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-build.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-locate-project.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-info.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-new.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-owner.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-tree.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-rustc.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-vendor.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-fetch.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-fix.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-doc.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-logout.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-yank.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-version.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-search.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-test.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-clean.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-bench.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-add.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-report.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-generate-lockfile.txt
    #     /home/nixos/cargo/src/doc/man/generated_txt/cargo-check.txt
    #     /home/nixos/cargo/src/doc/man/cargo-new.md
    #     /home/nixos/cargo/src/doc/man/cargo-owner.md
    #     /home/nixos/cargo/src/doc/man/cargo-help.md
    #     /home/nixos/cargo/src/doc/man/cargo-clean.md
    #     /home/nixos/cargo/src/doc/man/cargo-info.md
    #     /home/nixos/cargo/src/doc/man/cargo-uninstall.md
    #     /home/nixos/cargo/src/doc/man/cargo-bench.md
    #     /home/nixos/cargo/src/doc/man/cargo-tree.md
    #     /home/nixos/cargo/src/doc/man/cargo-search.md
    #     /home/nixos/cargo/src/doc/man/cargo-generate-lockfile.md
    #     /home/nixos/cargo/src/doc/man/cargo-report.md
    #     /home/nixos/cargo/src/doc/man/cargo-locate-project.md
    #     /home/nixos/cargo/src/doc/man/cargo-rustc.md
    #     /home/nixos/cargo/src/doc/man/cargo-doc.md
    #     /home/nixos/cargo/src/doc/man/cargo-login.md
    #     /home/nixos/cargo/src/doc/man/cargo-check.md
    #     /home/nixos/cargo/src/doc/man/cargo-publish.md
    #     /home/nixos/cargo/src/doc/man/cargo.md
    #     /home/nixos/cargo/src/doc/man/cargo-logout.md
    #     /home/nixos/cargo/src/doc/man/cargo-init.md
    #     /home/nixos/cargo/src/doc/README.md
    #   ];
    # };
    unpackPhase = "";

    RUSTC = "${rustc}/bin/rustc";
    CARGO = "${cargo}/bin/cargo";

    CARGO_CFG_FEATURE = "";
    CARGO_CFG_PANIC = "unwind";
    CARGO_CFG_TARGET_ABI = "";
    CARGO_CFG_TARGET_ARCH = "x86_64";
    CARGO_CFG_TARGET_ENDIAN = "little";
    CARGO_CFG_TARGET_ENV = "gnu";
    CARGO_CFG_TARGET_FAMILY = "unix";
    CARGO_CFG_TARGET_FEATURE = "fxsr,sse,sse2";
    CARGO_CFG_TARGET_HAS_ATOMIC = "16,32,64,8,ptr";
    CARGO_CFG_TARGET_OS = "linux";
    CARGO_CFG_TARGET_POINTER_WIDTH = "64";
    CARGO_CFG_TARGET_VENDOR = "unknown";
    CARGO_CFG_UNIX = "";
    CARGO_ENCODED_RUSTFLAGS = "";
    CARGO_MANIFEST_DIR = "./";
    CARGO_MANIFEST_PATH = "./Cargo.toml";
    CARGO_PKG_AUTHORS = "";
    CARGO_PKG_DESCRIPTION = "Cargo, a package manager for Rust.
";
    CARGO_PKG_HOMEPAGE = "https://doc.rust-lang.org/cargo/index.html";
    CARGO_PKG_LICENSE = "MIT OR Apache-2.0";
    CARGO_PKG_LICENSE_FILE = "";
    CARGO_PKG_NAME = "cargo";
    CARGO_PKG_README = "README.md";
    CARGO_PKG_REPOSITORY = "https://github.com/rust-lang/cargo";
    CARGO_PKG_RUST_VERSION = "1.85";
    CARGO_PKG_VERSION = "0.88.0";
    CARGO_PKG_VERSION_MAJOR = "0";
    CARGO_PKG_VERSION_MINOR = "88";
    CARGO_PKG_VERSION_PATCH = "0";
    CARGO_PKG_VERSION_PRE = "";
    DEBUG = "true";
    HOST = "x86_64-unknown-linux-gnu";
    NUM_JOBS = "8";
    OPT_LEVEL = "0";
    PROFILE = "debug";
    RUSTC_WORKSPACE_WRAPPER = "";
    RUSTC_WRAPPER = "";
    RUSTDOC = "rustdoc";
    RUSTFLAGS = "";
    TARGET = "x86_64-unknown-linux-gnu";

    buildPhase = ''
      export CARGO_MANIFEST_DIR=$(realpath $PWD/$CARGO_MANIFEST_DIR)
      export CARGO_MANIFEST_PATH=$(realpath $PWD/$CARGO_MANIFEST_PATH)

      mkdir -p $out/nix
      export OUT_DIR=$out
      export INC_DIR=$(${pkgs.mktemp}/bin/mktemp -d)

      echo -e "\e[92mCompiling\e[0m cargo-0_88_0-script_build_run-f5d51778f22880c0"
      echo "@cargo { \"type\":0, \"crate_name\":\"cargo\", \"id\":\"cargo-0_88_0-script_build_run-f5d51778f22880c0\" }"
      for file in ${fn.environment_variables passthru.rust_script_build_run}; do
        if [ -f $file ]; then
          set -a
            while read -r line; do
              echo -e "\033[38;5;208m$line\033[0m"
            done < "$file"
            source $file
            set +a
        fi
      done
      build_script_build_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${ cargo-0_88_0-script_build-cfc654fccb259515 }/build_script_build > $OUT_DIR/nix/build_script_build.out 2> $build_script_build_output_lines
      build_script_build_exit_value=$?
      set +x -e
      if [ "$build_script_build_exit_value" -ne 0 ]; then
          output=$(${pkgs.jq}/bin/jq -c -n \
              --arg crate_name "cargo" \
              --arg notice "There was an error executing build_script_build in file: '/home/nixos/cargo/target/debug/nix/derivations/cargo-0.88.0-script_build_run-f5d51778f22880c0.nix':" \
              --arg exit_code "$build_script_build_exit_value" \
              --rawfile msg $build_script_build_output_lines \
              '{type: 3, crate_name: $crate_name, exit_code: ($exit_code|tonumber), messages: [ $notice, $msg ] }')
          printf '@cargo %s\n' "$output"
          cat "$build_script_build_output_lines"
          exit $build_script_build_exit_value
      fi

      #cat $OUT_DIR/nix/build_script_build.out
      #exit 1
      
      build_parser_output_lines=$(${pkgs.mktemp}/bin/mktemp)
      set -x +e
      ${build_parser}/bin/cargo-build_script_build-parser $OUT_DIR/nix/build_script_build.out --out-path $out/nix write-results 2> $build_parser_output_lines
      build_parser_exit_value=$?
      set +x -e
      if [ "$build_parser_exit_value" -ne 0 ]; then
          output=$(${pkgs.jq}/bin/jq -c -n \
              --arg crate_name "cargo" \
              --arg notice "There was an error executing build_parser in file: '/home/nixos/cargo/target/debug/nix/derivations/cargo-0.88.0-script_build_run-f5d51778f22880c0.nix':" \
              --arg exit_code "$build_parser_exit_value" \
              --rawfile msg $build_parser_output_lines \
              '{type: 3, crate_name: $crate_name, exit_code: ($exit_code|tonumber), messages: [ $notice, $msg ] }')
          printf '@cargo %s\n' "$output"
          cat $build_parser_output_lines
          exit $build_parser_exit_value
      fi
      echo "@cargo {\"type\": 3, \"crate_name\": \"cargo\", \"exit_code\": 0, \"messages\": []}"
    '';

}
