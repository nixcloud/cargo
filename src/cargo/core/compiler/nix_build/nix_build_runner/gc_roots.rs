//! GC roots of nix mode builds (nixcloud/cargo#4). Each profile has `target/<profile>/nix/gc` (`nix-test/gc` for
//! `cargo test`), whose links are named after the store objects they point to (see `README` below, which is
//! written into the directory):
//! - `create-symlinks`: the script the symlinks in target/<profile> come from
//! - `retained-paths-units-crates-toolchain-deps`: the file listing every unit output, crate tarball, the
//!   toolchain and the external dependencies of the last successful build; its references keep them alive. It
//!   also names the rustdoc and linker of the units, for the doc tests cargo runs
//! - `<name>.drv`: the evaluated derivation of each
//!
//! When the retained paths move on, whatever the old file listed and the new one doesn't is deleted from the
//! store, unless something else (another project, a running process) still uses it. `cargo clean` does the same
//! for everything.
use super::daemon::{self, Daemon};
use super::event::Event;
use std::collections::{HashMap, HashSet};
use std::path::{Path, PathBuf};
use std::sync::mpsc::Sender;

/// The script that creates the symlinks in target/<profile> (attribute `target` of cargo_build_caller.nix).
pub const CREATE_SYMLINKS: &str = "create-symlinks";
/// The list of retained paths (attribute `cargo-libnix-retained-paths-units-crates-toolchain-deps`).
pub const RETAINED_PATHS: &str = "retained-paths-units-crates-toolchain-deps";
/// The attribute of cargo_build_caller.nix that builds the list of retained paths; also its store name.
pub const RETAINED_PATHS_ATTR: &str = "cargo-libnix-retained-paths-units-crates-toolchain-deps";
/// Where nix-instantiate puts its roots (`.eval`, `.eval-2`) until they are renamed.
pub const EVAL_ROOT: &str = ".eval";

const README: &str = "\
GC roots of this profile's nix build, maintained by cargo (libnix). The links keep their store paths alive
until the next build replaces them, so nix-collect-garbage doesn't remove them.

create-symlinks
    the script that creates the symlinks in target/<profile> (crate outputs, binaries)
create-symlinks.drv
    its derivation, the evaluated build system
retained-paths-units-crates-toolchain-deps
    a file listing every store path the build used: the unit outputs (crates, build scripts), the crate
    sources (.crate tarballs), the toolchain and the external dependencies from Cargo.dependencies.nix, then
    (`# rustdoc`, `# linker`) the tools cargo runs on the unit outputs for doc tests
retained-paths-units-crates-toolchain-deps.drv
    its derivation

After a successful build, the paths the previous list had but the new one doesn't are deleted from the nix
store, unless something else still uses them. `cargo clean` removes this directory and deletes the paths of
the list the same way. Other entries in this directory are removed by cargo.
";

/// Writes the README and removes everything in `gc_dir` that isn't one of cargo's roots.
pub fn prepare_dir(gc_dir: &Path) -> std::io::Result<()> {
    std::fs::create_dir_all(gc_dir)?;
    let known = [
        "README".to_string(),
        CREATE_SYMLINKS.to_string(),
        format!("{CREATE_SYMLINKS}.drv"),
        RETAINED_PATHS.to_string(),
        format!("{RETAINED_PATHS}.drv"),
    ];
    for entry in std::fs::read_dir(gc_dir)?.flatten() {
        if !known.iter().any(|k| entry.file_name() == k.as_str()) {
            let path = entry.path();
            if entry.file_type()?.is_dir() {
                std::fs::remove_dir_all(path)?;
            } else {
                std::fs::remove_file(path)?;
            }
        }
    }
    if std::fs::read_to_string(gc_dir.join("README")).ok().as_deref() != Some(README) {
        std::fs::write(gc_dir.join("README"), README)?;
    }
    Ok(())
}

/// The list of retained paths `gc_dir` points to, then the store paths it lists. Empty without one.
pub fn rooted_paths(gc_dir: &Path) -> Vec<String> {
    let Ok(file) = std::fs::read_link(gc_dir.join(RETAINED_PATHS)) else { return Vec::new() };
    let mut paths = vec![file.to_string_lossy().into_owned()];
    if let Ok(text) = std::fs::read_to_string(&file) {
        paths.extend(text.lines().filter(|l| l.starts_with("/nix/store/")).map(String::from));
    }
    paths
}

/// What a successful build produced, from the list of retained paths `gc_dir` points to.
#[derive(Debug, Default)]
pub struct BuildOutputs {
    /// store path of each derivation output by name (for units: their nix attribute name)
    pub paths: HashMap<String, PathBuf>,
    /// the rustdoc of the toolchain the units were built with
    pub rustdoc: Option<PathBuf>,
    /// the C compiler that linked them
    pub linker: Option<PathBuf>,
}

pub fn build_outputs(gc_dir: &Path) -> BuildOutputs {
    let mut outputs = BuildOutputs::default();
    let Ok(file) = std::fs::read_link(gc_dir.join(RETAINED_PATHS)) else { return outputs };
    let Ok(text) = std::fs::read_to_string(&file) else { return outputs };
    for line in text.lines() {
        if let Some(tool) = line.strip_prefix("# rustdoc ") {
            outputs.rustdoc = Some(PathBuf::from(tool));
        } else if let Some(tool) = line.strip_prefix("# linker ") {
            outputs.linker = Some(PathBuf::from(tool));
        } else if let Some(base) = line.strip_prefix("/nix/store/") {
            // `<hash>-<name>`
            if let Some((_, name)) = base.split_once('-') {
                outputs.paths.insert(name.to_string(), PathBuf::from(line));
            }
        }
    }
    outputs
}

/// `cargo clean`: what the gc dirs below `dir` (`<profile>/nix/gc`, `<profile>/nix-test/gc` of `cargo test`,
/// `<triple>/<profile>/nix/gc`) keep alive, collected before `dir` is removed. The `.drv` roots are left to
/// nix-collect-garbage.
pub fn rooted_below(dir: &Path) -> Vec<String> {
    fn walk(dir: &Path, depth: usize, out: &mut Vec<String>) {
        let in_nix_dir = dir.parent().and_then(|p| p.file_name()).is_some_and(|n| n == "nix" || n == "nix-test");
        if dir.file_name().is_some_and(|n| n == "gc") && in_nix_dir {
            out.extend(rooted_paths(dir));
            if let Ok(result) = std::fs::read_link(dir.join(CREATE_SYMLINKS)) {
                out.push(result.to_string_lossy().into_owned());
            }
            return;
        }
        let Ok(entries) = std::fs::read_dir(dir) else { return };
        for entry in entries.flatten() {
            // symlinks (to the store) aren't followed
            if depth > 0 && entry.file_type().is_ok_and(|t| t.is_dir()) {
                walk(&entry.path(), depth - 1, out);
            }
        }
    }
    let mut out = Vec::new();
    walk(dir, 4, &mut out);
    out
}

/// `delete_unused` on a connection of its own.
pub fn delete_unused_now(paths: Vec<String>) -> daemon::Result<(usize, u64)> {
    let (tx, _rx) = std::sync::mpsc::channel();
    let mut d = Daemon::connect(&tx)?;
    delete_unused(&mut d, paths, &tx)
}

/// Points `gc_dir/<name>` at `target` and registers it as a GC root, like `nix build --out-link`.
pub fn set_root(d: &mut Daemon, gc_dir: &Path, name: &str, target: &str, tx: &Sender<Event>) -> daemon::Result<()> {
    let link = gc_dir.join(name);
    match std::fs::remove_file(&link) {
        Err(e) if e.kind() != std::io::ErrorKind::NotFound => return Err(e.into()),
        _ => {}
    }
    std::os::unix::fs::symlink(target, &link)?;
    d.add_indirect_root(&link.to_string_lossy(), tx)
}

/// Deletes those of `paths` that nothing outside of `paths` keeps alive. Returns how many were deleted and the
/// bytes freed. Best effort: paths that turn out to be alive are left alone.
pub fn delete_unused(d: &mut Daemon, paths: Vec<String>, tx: &Sender<Event>) -> daemon::Result<(usize, u64)> {
    let mut candidates: Vec<String> = Vec::new();
    for p in paths {
        if !candidates.contains(&p) && Path::new(&p).exists() {
            candidates.push(p);
        }
    }
    // Deleting specific paths only deletes referrers that are deleted too, so some referrers join:
    // - a source (no deriver, e.g. the project's filterSource copy) is referenced by the `.drv`s of its units,
    //   and those by further `.drv`s
    // - a list of retained paths nothing roots anymore (its target dir was removed by hand) is dead, but would
    //   keep everything it lists
    let roots: HashSet<String> = d.find_roots(tx)?.into_iter().collect();
    let dead_list = |r: &str| r.ends_with(&format!("-{RETAINED_PATHS_ATTR}")) && !roots.contains(r);
    let mut sizes: HashMap<String, u64> = HashMap::new();
    let mut i = 0;
    while i < candidates.len() {
        let p = candidates[i].clone();
        i += 1;
        let Some((deriver, size)) = d.query_path_info(&p, tx)? else { continue };
        sizes.insert(p.clone(), size);
        let source = p.ends_with(".drv") || deriver.is_empty();
        for r in d.query_referrers(&p, tx)? {
            if ((source && r.ends_with(".drv")) || dead_list(&r)) && !candidates.contains(&r) {
                candidates.push(r);
            }
        }
    }
    // A path referenced by anything that isn't deleted with it stays; that can make its references stay too.
    let mut referrers = Vec::with_capacity(candidates.len());
    for p in &candidates {
        referrers.push(d.query_referrers(p, tx)?);
    }
    let mut keep: HashSet<usize> = HashSet::new();
    loop {
        let deleted: HashSet<&str> =
            candidates.iter().enumerate().filter(|(i, _)| !keep.contains(i)).map(|(_, p)| p.as_str()).collect();
        let before = keep.len();
        for (i, refs) in referrers.iter().enumerate() {
            if !keep.contains(&i) && refs.iter().any(|r| !deleted.contains(r.as_str())) {
                keep.insert(i);
            }
        }
        if keep.len() == before {
            break;
        }
    }
    let mut todo: Vec<String> =
        candidates.into_iter().enumerate().filter(|(i, _)| !keep.contains(i)).map(|(_, p)| p).collect();
    // Roots referrers don't show (another profile's `result`, a running process): the daemon stops at the first
    // such path, so set it aside and go on with the rest. A path can also be alive only until others are gone
    // (a source whose `.drv`s live as long as their outputs, with keep-derivations), so what was set aside is
    // tried again as long as that deletes something.
    // A failed request may have deleted some paths already, so what was deleted is what is gone (the count
    // without the `.drv`s).
    let all = todo.clone();
    let mut alive: Vec<String> = Vec::new();
    for _ in 0..32 {
        if todo.is_empty() {
            break;
        }
        match d.delete_paths(&todo, tx) {
            Ok((deleted, _)) => {
                alive.retain(|p| Path::new(p).exists());
                if deleted.is_empty() || alive.is_empty() {
                    break;
                }
                todo = std::mem::take(&mut alive);
            }
            Err(daemon::Error::Daemon(msg)) => {
                let Some(i) = todo.iter().position(|p| msg.contains(p.as_str())) else { break };
                alive.push(todo.remove(i));
                todo.retain(|p| Path::new(p).exists());
            }
            Err(e) => return Err(e),
        }
    }
    let gone: Vec<&String> = all.iter().filter(|p| !Path::new(p).exists()).collect();
    let count = gone.iter().filter(|p| !p.ends_with(".drv")).count();
    let bytes = gone.iter().map(|p| sizes.get(*p).copied().unwrap_or(0)).sum();
    Ok((count, bytes))
}
