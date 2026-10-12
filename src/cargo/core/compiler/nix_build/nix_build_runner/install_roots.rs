//! nix mode `cargo install` / `cargo uninstall`. An installed binary stays in the store, it links against store
//! paths (glibc, the libraries of `Cargo.dependencies.nix`), so its closure has to stay alive:
//!
//! ```text
//! <root>/                                  ~/.cargo, --root, CARGO_INSTALL_ROOT
//! ├── .crates.toml / .crates2.json        cargo's install records, unchanged
//! ├── nix/install/
//! │   └── ripgrep-15.1.0-<hash>/
//! │       └── rg  ->  /nix/store/…-ripgrep-15_1_0-bin-…          GC root
//! └── bin/
//!     └── rg  ->  ../nix/install/ripgrep-15.1.0-<hash>/rg/bin/rg
//! ```
//!
//! A root per binary, in a directory per package (cargo tracks one install per package id). The `bin/` links go
//! through the roots, so a removed root shows as a dangling link rather than one into a path the next GC deletes.
//! The crate sources and crate builds of the install are not rooted: like `~/.cargo/registry` they are shared,
//! `nix-collect-garbage` removes them.
use super::daemon::Daemon;
use super::gc_roots;
use crate::core::PackageId;
use crate::util::hex::short_hash;
use crate::util::CargoResult;
use anyhow::{anyhow, Context as _};
use cargo_util::paths;
use std::fs;
use std::path::{Path, PathBuf};

const STORE_DIR: &str = "/nix/store";
/// Below the install root.
const INSTALL_DIR: &str = "nix/install";

/// `ripgrep-15.1.0-<hash>`: the directory of the roots of a package's binaries.
pub fn package_dir_name(pkg: PackageId) -> String {
    format!("{}-{}-{}", pkg.name(), pkg.version(), short_hash(&pkg.to_string()))
}

/// Roots the store paths of `bins` (name, its file in the target dir: a link into the store) in
/// `<root>/nix/install/<dir_name>/<name>` and creates the links to them in `staging`, from where the caller moves
/// them into `<root>/bin`.
pub fn link_binaries(root: &Path, dir_name: &str, bins: &[(&str, &Path)], staging: &Path) -> CargoResult<()> {
    let dir = root.join(INSTALL_DIR).join(dir_name);
    paths::create_dir_all(&dir)?;
    let (tx, _rx) = std::sync::mpsc::channel();
    let mut d = Daemon::connect(&tx)?;
    for &(name, src) in bins {
        let file = fs::canonicalize(src).with_context(|| format!("failed to resolve `{}`", src.display()))?;
        let (store_path, rest) =
            split_store_path(&file).ok_or_else(|| anyhow!("`{}` is not in the nix store", file.display()))?;
        gc_roots::set_root(&mut d, &dir, name, &store_path.to_string_lossy(), &tx)
            .with_context(|| format!("failed to root `{}`", store_path.display()))?;
        let link = Path::new("..").join(INSTALL_DIR).join(dir_name).join(name).join(rest);
        std::os::unix::fs::symlink(&link, staging.join(name))?;
    }
    Ok(())
}

/// `/nix/store/<hash>-<name>/bin/rg` → (`/nix/store/<hash>-<name>`, `bin/rg`)
fn split_store_path(file: &Path) -> Option<(PathBuf, PathBuf)> {
    let rel = file.strip_prefix(STORE_DIR).ok()?;
    let mut components = rel.components();
    let object = components.next()?;
    Some((Path::new(STORE_DIR).join(object), components.as_path().to_path_buf()))
}

/// Removes the roots in `<root>/nix/install` that no link in `<root>/bin` goes through anymore (uninstalled,
/// replaced, deleted by hand) and tries to delete their closures; whatever is still used elsewhere stays. Returns
/// the number of store paths deleted and the bytes freed, `None` if no root was removed.
pub fn prune(root: &Path) -> CargoResult<Option<(usize, u64)>> {
    let install = root.join(INSTALL_DIR);
    let Ok(dirs) = fs::read_dir(&install) else {
        return Ok(None);
    };
    let bin = root.join("bin");
    let mut unrooted = Vec::new();
    for dir in dirs {
        let dir = dir?;
        for entry in fs::read_dir(dir.path())? {
            let entry = entry?;
            let through = Path::new("..").join(INSTALL_DIR).join(dir.file_name()).join(entry.file_name());
            if fs::read_link(bin.join(entry.file_name())).is_ok_and(|target| target.starts_with(&through)) {
                continue;
            }
            if let Ok(target) = fs::read_link(entry.path()) {
                unrooted.push(target.to_string_lossy().into_owned());
            }
            paths::remove_file(entry.path())?;
        }
        // only if empty
        let _ = fs::remove_dir(dir.path());
    }
    if unrooted.is_empty() {
        return Ok(None);
    }
    Ok(Some(gc_roots::delete_unused_closure_now(unrooted)?))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn splits_store_paths() {
        let (object, rest) = split_store_path(Path::new("/nix/store/abc-rg-bin/bin/rg")).unwrap();
        assert_eq!(object, Path::new("/nix/store/abc-rg-bin"));
        assert_eq!(rest, Path::new("bin/rg"));
        assert!(split_store_path(Path::new("/usr/bin/rg")).is_none());
    }
}
