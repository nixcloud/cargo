//! GC roots of nix mode builds (nixcloud/cargo#4). Each profile has `target/<profile>/nix/gc` (`nix-test/gc` for
//! `cargo test`). Every selection of root units (`cargo build`, `cargo run --bin a`, `cargo test -p x`, other
//! features, …) has a slot `gc/<key>` of its own, whose links are named after the store objects they point to
//! (see `README` below, which is written into the directory):
//! - `create-symlinks`: the script the symlinks in target/<profile> come from
//! - `retained-paths-units-crates-toolchain-deps`: the file listing every unit output, crate tarball, the
//!   toolchain and the external dependencies of the last successful build of this selection; its references
//!   keep them alive. It also names the rustdoc and linker of the units, for the doc tests cargo runs
//! - `<name>.drv`: the evaluated derivation of each
//! - `selection`: the root units, for humans
//!
//! When the retained paths of a slot move on, whatever its old file listed and the new one doesn't is deleted
//! from the store, unless something else (another slot, another project, a running process) still uses it. So
//! building a subset doesn't delete what the full build uses. The `MAX_SLOTS` most recently built selections are
//! kept; the least recently built one beyond that is removed with its paths. `cargo clean` does the same for
//! everything.
use super::daemon::{self, Daemon};
use super::event::Event;
use std::collections::{HashMap, HashSet};
use std::path::{Path, PathBuf};
use std::sync::mpsc::Sender;
use std::time::SystemTime;

/// The script that creates the symlinks in target/<profile> (attribute `target` of cargo_build_caller.nix).
pub const CREATE_SYMLINKS: &str = "create-symlinks";
/// The list of retained paths (attribute `cargo-libnix-retained-paths-units-crates-toolchain-deps`).
pub const RETAINED_PATHS: &str = "retained-paths-units-crates-toolchain-deps";
/// The attribute of cargo_build_caller.nix that builds the list of retained paths; also its store name.
pub const RETAINED_PATHS_ATTR: &str = "cargo-libnix-retained-paths-units-crates-toolchain-deps";
/// Where nix-instantiate puts its roots (`.eval`, `.eval-2`) until they are renamed.
pub const EVAL_ROOT: &str = ".eval";
/// The root units of a slot, one per line.
pub const SELECTION: &str = "selection";
/// How many selections keep their store paths.
pub const MAX_SLOTS: usize = 8;

const README: &str = "\
GC roots of this profile's nix build, maintained by cargo (libnix). The links keep their store paths alive,
so nix-collect-garbage doesn't remove them.

Each selection of root units (`cargo build`, `cargo run --bin a`, `cargo test -p x`, other features, ...)
has a directory of its own, named after a hash of the selection:

<key>/selection
    the root units of the selection
<key>/create-symlinks
    the script that creates the symlinks in target/<profile> (crate outputs, binaries)
<key>/create-symlinks.drv
    its derivation, the evaluated build system
<key>/retained-paths-units-crates-toolchain-deps
    a file listing every store path the last build of the selection used: the unit outputs (crates, build
    scripts), the crate sources (.crate tarballs), the toolchain and the external dependencies from
    Cargo.dependencies.nix, then (`# rustdoc`, `# linker`) the tools cargo runs on the unit outputs for doc tests
<key>/retained-paths-units-crates-toolchain-deps.drv
    its derivation

After a successful build, the paths the selection's previous list had but the new one doesn't are deleted from
the nix store, unless something else (another selection) still uses them. The 8 most recently built selections
are kept; the directory of the least recently built one beyond that is removed and its paths are deleted the
same way. `cargo clean` removes this directory and deletes the paths of all lists. Other entries in this
directory are removed by cargo.
";

/// The links of a slot.
fn slot_entries() -> [String; 5] {
    [
        SELECTION.to_string(),
        CREATE_SYMLINKS.to_string(),
        format!("{CREATE_SYMLINKS}.drv"),
        RETAINED_PATHS.to_string(),
        format!("{RETAINED_PATHS}.drv"),
    ]
}

fn remove_entry(entry: &std::fs::DirEntry) -> std::io::Result<()> {
    if entry.file_type()?.is_dir() {
        std::fs::remove_dir_all(entry.path())
    } else {
        std::fs::remove_file(entry.path())
    }
}

/// Writes the README and the selection of `slot`, and removes everything in `gc_dir` and `slot` that isn't one
/// of cargo's roots. The links of the layout before slots (directly in `gc_dir`) are left for
/// `adopt_unslotted`.
pub fn prepare_dir(gc_dir: &Path, slot: &Path, selection: &str) -> std::io::Result<()> {
    std::fs::create_dir_all(slot)?;
    let mut known = slot_entries().to_vec();
    known.push("README".to_string());
    for entry in std::fs::read_dir(gc_dir)?.flatten() {
        let slot_dir = entry.file_type()?.is_dir() && entry.path().join(SELECTION).exists();
        if !slot_dir && entry.path() != slot && !known.iter().any(|k| entry.file_name() == k.as_str()) {
            remove_entry(&entry)?;
        }
    }
    for entry in std::fs::read_dir(slot)?.flatten() {
        if !slot_entries().iter().any(|k| entry.file_name() == k.as_str()) {
            remove_entry(&entry)?;
        }
    }
    if std::fs::read_to_string(gc_dir.join("README")).ok().as_deref() != Some(README) {
        std::fs::write(gc_dir.join("README"), README)?;
    }
    std::fs::write(slot.join(SELECTION), selection)
}

/// The list of retained paths `dir` (a slot) points to, then the store paths it lists. Empty without one.
pub fn rooted_paths(dir: &Path) -> Vec<String> {
    let Ok(file) = std::fs::read_link(dir.join(RETAINED_PATHS)) else { return Vec::new() };
    let mut paths = vec![file.to_string_lossy().into_owned()];
    if let Ok(text) = std::fs::read_to_string(&file) {
        paths.extend(text.lines().filter(|l| l.starts_with("/nix/store/")).map(String::from));
    }
    paths
}

/// `rooted_paths` and the output of `create-symlinks` of `dir`.
fn slot_paths(dir: &Path) -> Vec<String> {
    let mut paths = rooted_paths(dir);
    if let Ok(result) = std::fs::read_link(dir.join(CREATE_SYMLINKS)) {
        paths.push(result.to_string_lossy().into_owned());
    }
    paths
}

/// The slot of the roots of the layout before slots.
pub const UNSLOTTED: &str = "unslotted";

/// Moves the roots of the layout before slots (directly in `gc_dir`) into a slot of their own, which is evicted
/// like any other.
pub fn adopt_unslotted(d: &mut Daemon, gc_dir: &Path, tx: &Sender<Event>) -> daemon::Result<()> {
    let slot = gc_dir.join(UNSLOTTED);
    let mut adopted = false;
    for name in slot_entries() {
        let link = gc_dir.join(&name);
        let Ok(target) = std::fs::read_link(&link) else { continue };
        if !adopted {
            std::fs::create_dir_all(&slot)?;
            std::fs::write(slot.join(SELECTION), "(built before each selection had GC roots of its own)\n")?;
            adopted = true;
        }
        // the new root first, so the path is rooted all the time; it keeps the time of the old one, which is when
        // the slot was built (see `last_built`)
        let mtime = std::fs::symlink_metadata(&link).map(|m| filetime::FileTime::from_last_modification_time(&m));
        set_root(d, &slot, &name, &target.to_string_lossy(), tx)?;
        if let Ok(t) = mtime {
            let _ = filetime::set_symlink_file_times(slot.join(&name), t, t);
        }
        let _ = std::fs::remove_file(&link);
    }
    Ok(())
}

/// When the slot `dir` was built last: its list of retained paths is replaced by each successful build.
fn last_built(dir: &Path) -> SystemTime {
    std::fs::symlink_metadata(dir.join(RETAINED_PATHS))
        .or_else(|_| std::fs::symlink_metadata(dir))
        .and_then(|m| m.modified())
        .unwrap_or(SystemTime::UNIX_EPOCH)
}

/// Removes the least recently built slots of `gc_dir` beyond `MAX_SLOTS` (never `current`) and returns what they
/// kept alive, to be deleted like the paths a slot stopped using.
pub fn evict(gc_dir: &Path, current: &Path) -> Vec<String> {
    let Ok(entries) = std::fs::read_dir(gc_dir) else { return Vec::new() };
    let mut slots: Vec<(SystemTime, PathBuf)> = entries
        .flatten()
        .filter(|e| e.file_type().is_ok_and(|t| t.is_dir()))
        .map(|e| e.path())
        .filter(|p| p != current)
        .map(|p| (last_built(&p), p))
        .collect();
    // newest first; the current slot is one of the MAX_SLOTS
    slots.sort_by(|a, b| b.0.cmp(&a.0));
    let mut paths = Vec::new();
    for (_, dir) in slots.into_iter().skip(MAX_SLOTS - 1) {
        paths.extend(slot_paths(&dir));
        let _ = std::fs::remove_dir_all(&dir);
    }
    paths
}

/// What a successful build produced, from the list of retained paths `dir` (a slot) points to.
#[derive(Debug, Default)]
pub struct BuildOutputs {
    /// store path of each derivation output by name (for units: their nix attribute name)
    pub paths: HashMap<String, PathBuf>,
    /// the rustdoc of the toolchain the units were built with
    pub rustdoc: Option<PathBuf>,
    /// the C compiler that linked them
    pub linker: Option<PathBuf>,
}

pub fn build_outputs(dir: &Path) -> BuildOutputs {
    let mut outputs = BuildOutputs::default();
    let Ok(file) = std::fs::read_link(dir.join(RETAINED_PATHS)) else { return outputs };
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
/// `<triple>/<profile>/nix/gc`) keep alive in all their slots, collected before `dir` is removed. The `.drv` roots
/// are left to nix-collect-garbage.
pub fn rooted_below(dir: &Path) -> Vec<String> {
    fn walk(dir: &Path, depth: usize, out: &mut Vec<String>) {
        let in_nix_dir = dir.parent().and_then(|p| p.file_name()).is_some_and(|n| n == "nix" || n == "nix-test");
        if dir.file_name().is_some_and(|n| n == "gc") && in_nix_dir {
            // the layout before slots
            out.extend(slot_paths(dir));
            let Ok(entries) = std::fs::read_dir(dir) else { return };
            for entry in entries.flatten() {
                if entry.file_type().is_ok_and(|t| t.is_dir()) {
                    out.extend(slot_paths(&entry.path()));
                }
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

/// [`delete_unused`] for `paths` and everything they reference (their closure).
pub fn delete_unused_closure_now(paths: Vec<String>) -> daemon::Result<(usize, u64)> {
    let (tx, _rx) = std::sync::mpsc::channel();
    let mut d = Daemon::connect(&tx)?;
    let mut closure = Vec::new();
    let mut seen = HashSet::new();
    let mut todo = paths;
    while let Some(p) = todo.pop() {
        if !seen.insert(p.clone()) {
            continue;
        }
        if let Some(references) = d.query_references(&p, &tx)? {
            todo.extend(references);
            closure.push(p);
        }
    }
    delete_unused(&mut d, closure, &tx)
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
    // - a list of retained paths or a create-symlinks script nothing roots anymore (its target dir was removed by
    //   hand, or was temporary like `cargo install`'s) is dead, but would keep everything it references
    let roots: HashSet<String> = d.find_roots(tx)?.into_iter().collect();
    let dead_list = |r: &str| {
        (r.ends_with(&format!("-{RETAINED_PATHS_ATTR}")) || r.ends_with(&format!("-{CREATE_SYMLINKS}")))
            && !roots.contains(r)
    };
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

#[cfg(test)]
mod tests {
    use super::*;
    use std::os::unix::fs::symlink;

    /// A slot built at `time` (seconds), its links pointing to `/nix/store/<name>-*`.
    fn slot(gc_dir: &Path, name: &str, time: i64) -> PathBuf {
        let dir = gc_dir.join(name);
        std::fs::create_dir_all(&dir).unwrap();
        std::fs::write(dir.join(SELECTION), format!("{name}\n")).unwrap();
        symlink(format!("/nix/store/{name}-list"), dir.join(RETAINED_PATHS)).unwrap();
        symlink(format!("/nix/store/{name}-create-symlinks"), dir.join(CREATE_SYMLINKS)).unwrap();
        let t = filetime::FileTime::from_unix_time(time, 0);
        filetime::set_symlink_file_times(dir.join(RETAINED_PATHS), t, t).unwrap();
        dir
    }

    #[test]
    fn prepare_dir_keeps_slots_and_removes_the_rest() {
        let tmp = tempfile::tempdir().unwrap();
        let gc = tmp.path();
        let other = slot(gc, "other", 1);
        std::fs::write(gc.join("junk"), "").unwrap();
        std::fs::create_dir(gc.join("not-a-slot")).unwrap();
        symlink("/nix/store/x-list", gc.join(RETAINED_PATHS)).unwrap();
        let current = gc.join("current");
        std::fs::create_dir(&current).unwrap();
        std::fs::write(current.join(".eval"), "").unwrap();

        prepare_dir(gc, &current, "a\nb\n").unwrap();

        assert!(other.join(RETAINED_PATHS).symlink_metadata().is_ok());
        assert!(!gc.join("junk").exists());
        assert!(!gc.join("not-a-slot").exists());
        assert!(!current.join(".eval").exists());
        assert_eq!(std::fs::read_to_string(current.join(SELECTION)).unwrap(), "a\nb\n");
        assert!(gc.join("README").exists());
        // left for adopt_unslotted
        assert!(gc.join(RETAINED_PATHS).symlink_metadata().is_ok());
    }

    #[test]
    fn evict_removes_the_least_recently_built_slots() {
        let tmp = tempfile::tempdir().unwrap();
        let gc = tmp.path();
        for i in 0..MAX_SLOTS + 1 {
            slot(gc, &format!("s{i}"), 1000 + i as i64);
        }
        // the current slot counts as built now even if its list is the oldest
        let current = slot(gc, "current", 1);

        let mut evicted = evict(gc, &current);
        evicted.sort();

        assert_eq!(
            evicted,
            ["s0-create-symlinks", "s0-list", "s1-create-symlinks", "s1-list"].map(|p| format!("/nix/store/{p}"))
        );
        let mut left: Vec<String> =
            std::fs::read_dir(gc).unwrap().map(|e| e.unwrap().file_name().into_string().unwrap()).collect();
        left.sort();
        assert_eq!(left.len(), MAX_SLOTS);
        assert!(left.contains(&"current".to_string()));
        assert!(!left.contains(&"s0".to_string()) && !left.contains(&"s1".to_string()));
        assert!(evict(gc, &current).is_empty());
    }
}
