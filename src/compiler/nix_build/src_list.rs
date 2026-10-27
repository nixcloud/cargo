//! Minimal sources for the workspace's own crates (nixcloud/cargo#3: root units, the compile of their build
//! scripts, and with content-addressed runs the crates after a build script run).
//!
//! A unit of a workspace member gets the whole workspace as its `src`, so editing a README rebuilds every one of
//! them. rustc lists the files a compile reads in the dep-info file (`--emit=dep-info`), which lands in the
//! unit's `$out`. Cargo keeps that list (with a hash of each file) in `<profile>/nix/src-lists/<attr>.json`, and
//! the next build gives the unit only those files: the same files with the same contents are the same store path,
//! so nothing rebuilds.
//!
//! A unit is dirty when it has no list, a listed file changed or is gone, or a unit it depends on is dirty
//! (macros of a dependency decide which files a crate reads). A dirty unit is built once, with all files, and
//! its dep-info file gives the new list (`SrcList::Pending`). It stays on all files while that build is the
//! current one; once it would be rebuilt with all files (another file of the workspace changed), it gets its list
//! instead (`SrcList::Files`). That output is compared with the one built with all files when only the src
//! differs between both derivations (`same_but_src`): if it differs or fails, a file was read without rustc
//! knowing (e.g. by a proc macro using `std::fs` instead of `include_bytes!`), and the unit keeps all files
//! (`SrcList::Full`).
//!
//! A build script's compile (`build.rs build`) is a rustc call like any other and gets a list the same way. Its
//! run (`build.rs run`) keeps all files and runs on every edit. With the nix feature ca-derivations
//! (`content_addressed`, nixcloud/cargo#20) the runs of the workspace are content-addressed: they are built first
//! (`Gate`), and their output path is recorded (`SrcList::Output`) for the units after them, which get lists like
//! any other. A new output makes them dirty (it can change which files they read); the same output resolves them
//! to what they were. Without it, the crates after a run keep all files.
//!
//! Not covered: exports (`write-nix-buildsystem`), path packages outside the workspace. They keep the whole
//! workspace as their `src`.

use crate::compiler::nix_build::deps::FIXED_OUT_DIR;
use crate::compiler::{CompileMode, Unit};
use crate::util::CargoResult;
use cargo_util::Sha256;
use serde::{Deserialize, Serialize};
use std::collections::{BTreeMap, BTreeSet, HashMap};
use std::path::{Component, Path, PathBuf};

/// What cargo knows about the files of a unit.
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq)]
#[serde(rename_all = "snake_case")]
pub enum SrcList {
    /// the files rustc read (relative to the workspace root) with their sha256; the unit is built with them
    Files(Vec<ListedFile>),
    /// the files rustc read when the unit was built with all files, and that build: the unit stays on all files
    /// while that build is the current one, and gets its list once it would be rebuilt (another file changed)
    Pending(Pending),
    /// the unit keeps all files, for this reason (e.g. it reads a file outside of the workspace)
    Full(String),
    /// a content-addressed build script run of the workspace: its output path when the units after it got their
    /// lists. Another one means its output changed, and so may the files they read (e.g. generated code
    /// `include!`ing a file), so they are dirty
    Output(String),
}

#[derive(Serialize, Deserialize, Clone, Debug, PartialEq)]
pub struct Pending {
    pub files: Vec<ListedFile>,
    /// the drv and `out` path of the build with all files, which the first build with the list is compared with
    pub drv: String,
    pub out: String,
}

#[derive(Serialize, Deserialize, Clone, Debug, PartialEq)]
pub struct ListedFile {
    pub path: String,
    pub sha256: String,
}

/// Whether a unit gets minimal sources at all: the rustc calls of workspace members, including the compile of a
/// build script (`CompileMode::Build` of its custom-build target), not its run (`RunCustomBuild`).
pub fn in_scope(unit: &Unit, is_root: bool) -> bool {
    is_root && matches!(unit.mode, CompileMode::Build | CompileMode::Test | CompileMode::Check { .. })
}

/// `[package.metadata.libnix] src = "full"`: the package's units always get all files (for proc macros that
/// read files without telling rustc, which the comparison can't catch when the result doesn't change).
pub fn opted_out(unit: &Unit) -> bool {
    unit.pkg
        .manifest()
        .custom_metadata()
        .and_then(|m| m.get("libnix"))
        .and_then(|l| l.get("src"))
        .and_then(|s| s.as_str())
        == Some("full")
}

/// The lists of one build system (`target/<profile>/nix` or `nix-test`).
pub struct SrcLists {
    dir: PathBuf,
    /// the workspace root, which `project_root` points to
    root: PathBuf,
    lists: HashMap<String, SrcList>,
}

impl SrcLists {
    pub fn load(nix_base_dir: &Path, root: &Path) -> SrcLists {
        let dir = nix_base_dir.join("src-lists");
        let mut lists = HashMap::new();
        if let Ok(entries) = std::fs::read_dir(&dir) {
            for entry in entries.flatten() {
                let path = entry.path();
                let Some(attr) = path.file_name().and_then(|n| n.to_str()).and_then(|n| n.strip_suffix(".json"))
                else {
                    continue;
                };
                // an unreadable list is no list: the unit is built with all files and gets a new one
                if let Some(list) = std::fs::read(&path).ok().and_then(|b| serde_json::from_slice(&b).ok()) {
                    lists.insert(attr.to_string(), list);
                }
            }
        }
        SrcLists { dir, root: root.to_path_buf(), lists }
    }

    pub fn get(&self, attr: &str) -> Option<&SrcList> {
        self.lists.get(attr)
    }

    pub fn set(&mut self, attr: &str, list: SrcList) -> CargoResult<()> {
        std::fs::create_dir_all(&self.dir)?;
        std::fs::write(self.dir.join(format!("{attr}.json")), serde_json::to_vec_pretty(&list)?)?;
        self.lists.insert(attr.to_string(), list);
        Ok(())
    }

    /// The unit has a list of files and none of them changed.
    pub fn is_clean(&self, attr: &str) -> bool {
        match self.lists.get(attr) {
            // a symlink's target is listed too (`link_targets`), also after the link was changed
            Some(SrcList::Files(files) | SrcList::Pending(Pending { files, .. })) => files.iter().all(|f| {
                hash_file(&self.root.join(&f.path)).is_some_and(|h| h == f.sha256)
                    && link_targets(&self.root, &f.path)
                        .is_ok_and(|t| t.iter().all(|t| files.iter().any(|f| f.path == *t)))
            }),
            Some(SrcList::Full(_)) => true,
            // a run is checked against its output path once it's built (`Gate`)
            Some(SrcList::Output(_)) | None => false,
        }
    }

    /// The list from the dep-info file of an output built with all files (`out`).
    pub fn list_from_output(&self, out: &Path) -> CargoResult<SrcList> {
        let mut dep_files = Vec::new();
        for entry in std::fs::read_dir(out)?.flatten() {
            let path = entry.path();
            if path.extension().is_some_and(|e| e == "d") && path.is_file() {
                dep_files.push(path);
            }
        }
        if dep_files.is_empty() {
            return Ok(SrcList::Full(format!("no dep-info file in {}", out.display())));
        }
        let mut deps = BTreeSet::new();
        for d in dep_files {
            deps.extend(parse_dep_info(&std::fs::read_to_string(&d)?));
        }
        let src_name = self.root.file_name().and_then(|n| n.to_str()).unwrap_or_default().to_string();
        let mut files = Vec::new();
        for dep in deps {
            let rel = match root_relative(&dep, &src_name, &self.root) {
                Ok(Some(rel)) => rel,
                Ok(None) => continue,
                Err(reason) => return Ok(SrcList::Full(reason)),
            };
            let Some(sha256) = hash_file(&self.root.join(&rel)) else {
                return Ok(SrcList::Full(format!("reads {rel}, which is gone")));
            };
            let targets = match link_targets(&self.root, &rel) {
                Ok(targets) => targets,
                Err(reason) => return Ok(SrcList::Full(reason)),
            };
            for path in std::iter::once(rel).chain(targets) {
                if !files.iter().any(|f: &ListedFile| f.path == path) {
                    files.push(ListedFile { path, sha256: sha256.clone() });
                }
            }
        }
        Ok(SrcList::Files(files))
    }
}

fn hash_file(path: &Path) -> Option<String> {
    if !path.is_file() {
        return None;
    }
    Sha256::new().update_path(path).ok().map(|h| h.finish_hex())
}

/// The prerequisites of all rules of a Makefile-style dep-info file, as rustc writes it: `target: dep dep …`,
/// spaces in paths escaped as `\ `, `# env-dep:…` and similar comments.
pub fn parse_dep_info(text: &str) -> Vec<String> {
    let mut deps = Vec::new();
    for line in text.lines() {
        if line.starts_with('#') || line.trim().is_empty() {
            continue;
        }
        // the target ends at the first unescaped `: ` (or a `:` at the end of the line)
        let mut rest = None;
        let bytes = line.as_bytes();
        for i in 0..bytes.len() {
            if bytes[i] == b':' && (i == 0 || bytes[i - 1] != b'\\') && (i + 1 == bytes.len() || bytes[i + 1] == b' ') {
                rest = Some(&line[i + 1..]);
                break;
            }
        }
        let Some(rest) = rest else { continue };
        let mut cur = String::new();
        let mut chars = rest.chars().peekable();
        while let Some(c) = chars.next() {
            match c {
                '\\' if chars.peek() == Some(&' ') => {
                    cur.push(' ');
                    chars.next();
                }
                ' ' => {
                    if !cur.is_empty() {
                        deps.push(std::mem::take(&mut cur));
                    }
                }
                c => cur.push(c),
            }
        }
        if !cur.is_empty() {
            deps.push(cur);
        }
    }
    deps
}

/// A path of the dep-info file relative to the workspace root; `None` for store paths (other units, `OUT_DIR`),
/// which are inputs of the derivation anyway. `Err`: the unit has to keep all files.
///
/// Relative paths start from the workspace root (the builder runs rustc there, like cargo). Absolute ones are in the
/// builder's copy of the workspace, `<build dir>/<src_name>/…` (e.g. via `env!("CARGO_MANIFEST_DIR")`).
pub fn root_relative(dep: &str, src_name: &str, root: &Path) -> Result<Option<String>, String> {
    let path = Path::new(dep);
    // the fixed OUT_DIR of a crate after a build script run (deps::FIXED_OUT_DIR): the run's output, an input
    if path.starts_with("/nix/store") || path.components().any(|c| c.as_os_str() == FIXED_OUT_DIR) {
        return Ok(None);
    }
    let joined = if path.is_absolute() {
        let comps: Vec<_> = path.components().collect();
        let found = (1..comps.len()).find_map(|i| {
            if comps[i - 1].as_os_str() != src_name || i == comps.len() {
                return None;
            }
            let rel: PathBuf = comps[i..].iter().collect();
            root.join(&rel).is_file().then_some(rel)
        });
        found.ok_or_else(|| format!("reads {dep}, which isn't in the workspace"))?
    } else {
        path.to_path_buf()
    };
    let mut normal = PathBuf::new();
    for c in joined.components() {
        match c {
            Component::CurDir => {}
            Component::ParentDir => {
                if !normal.pop() {
                    return Err(format!("reads {dep}, which isn't in the workspace"));
                }
            }
            Component::Normal(n) => normal.push(n),
            Component::RootDir | Component::Prefix(_) => {
                return Err(format!("reads {dep}, which isn't in the workspace"));
            }
        }
    }
    let rel = normal.to_str().ok_or_else(|| format!("reads {dep}, a path that isn't UTF-8"))?;
    Ok(Some(rel.to_string()))
}

/// The paths a listed file `rel` (relative to `root`) resolves through when it, or a directory above it, is a
/// symlink, up to the file itself. rustc lists the symlink, and the minimal `src` copies it as it is
/// (`builtins.path`), so its target has to be in there too (atuin: `src/command/CONTRIBUTORS ->
/// ../../../../CONTRIBUTORS`). A target outside of the workspace is an error.
fn link_targets(root: &Path, rel: &str) -> Result<Vec<String>, String> {
    let outside = || format!("reads {rel}, a symlink to outside of the workspace");
    let mut targets = Vec::new();
    let mut path = PathBuf::from(rel);
    'resolve: for _ in 0..40 {
        let comps: Vec<Component<'_>> = path.components().collect();
        let mut prefix = PathBuf::new();
        for (i, c) in comps.iter().enumerate() {
            prefix.push(c);
            let Ok(link) = std::fs::read_link(root.join(&prefix)) else { continue };
            let target = if link.is_absolute() {
                let canonical = root.canonicalize().ok();
                let rel = link.strip_prefix(root).ok().or_else(|| link.strip_prefix(canonical.as_ref()?).ok());
                rel.ok_or_else(outside)?.to_path_buf()
            } else {
                prefix.parent().unwrap_or(Path::new("")).join(link)
            };
            let rest: PathBuf = comps[i + 1..].iter().collect();
            path = normalize(&target.join(rest)).ok_or_else(outside)?;
            let s = path.to_str().ok_or_else(|| format!("reads {rel}, through a path that isn't UTF-8"))?;
            targets.push(s.to_string());
            continue 'resolve;
        }
        return Ok(targets);
    }
    Err(format!("reads {rel}, through too many symlinks"))
}

/// `path` without `.` and `..`, if it stays relative and below where it starts.
fn normalize(path: &Path) -> Option<PathBuf> {
    let mut normal = PathBuf::new();
    for c in path.components() {
        match c {
            Component::CurDir => {}
            Component::ParentDir => {
                if !normal.pop() {
                    return None;
                }
            }
            Component::Normal(n) => normal.push(n),
            Component::RootDir | Component::Prefix(_) => return None,
        }
    }
    (!normal.as_os_str().is_empty()).then_some(normal)
}

/// The nix code of a minimal `src`: the listed files, their directories and the crate's directory (the builder
/// changes into it). `fn.src_minimal` (default.nix) copies them like `fn.project_src` (all files) does, under
/// the same name, so the builder sees the same paths.
pub fn minimal_src(files: &[ListedFile], crate_dir: &Path) -> String {
    let mut allowed = BTreeSet::new();
    let add_dirs = |p: &Path, allowed: &mut BTreeSet<String>| {
        for a in p.ancestors() {
            if !a.as_os_str().is_empty() {
                allowed.insert(a.to_string_lossy().into_owned());
            }
        }
    };
    add_dirs(crate_dir, &mut allowed);
    for f in files {
        add_dirs(Path::new(&f.path), &mut allowed);
    }
    let entries: Vec<String> = allowed.iter().map(|p| format!("      {}", nix_string(p))).collect();
    format!("    src = fn.src_minimal project_root [\n{}\n    ];\n", entries.join("\n"))
}

fn nix_string(s: &str) -> String {
    // a JSON string is a Nix string, except for `${`
    serde_json::to_string(s).unwrap().replace("${", "\\${")
}

/// Store paths in the text of a .drv file.
fn store_paths(text: &str) -> BTreeSet<String> {
    let re = regex::Regex::new(r"/nix/store/[0-9a-z]{32}-[A-Za-z0-9+._?=-]+").unwrap();
    re.find_iter(text).map(|m| m.as_str().to_string()).collect()
}

/// The name of a store path, without its hash.
fn store_name(p: &str) -> &str {
    p.get("/nix/store/".len() + 33..).unwrap_or_default()
}

/// A .drv file (`Derive([outputs],[input drvs],[input srcs],…)`) with its input drvs and srcs sorted again: they
/// are sorted by path, which changes when paths are rewritten.
fn sorted_inputs(text: &str) -> String {
    let Some(body) = text.strip_prefix("Derive(") else { return text.to_string() };
    // the top-level lists and their elements, outside of strings
    let (mut lists, mut depth, mut in_str, mut escaped, mut start) = (Vec::new(), 0, false, false, 0);
    for (i, c) in body.char_indices() {
        if in_str {
            match c {
                _ if escaped => escaped = false,
                '\\' => escaped = true,
                '"' => in_str = false,
                _ => {}
            }
            continue;
        }
        match c {
            '"' => in_str = true,
            '[' | '(' => {
                if depth == 0 {
                    start = i;
                }
                depth += 1;
            }
            ']' | ')' => {
                depth -= 1;
                if depth == 0 {
                    lists.push((start, i + 1));
                    if lists.len() == 3 {
                        break;
                    }
                }
            }
            _ => {}
        }
    }
    let [_, drvs, srcs] = lists[..] else { return text.to_string() };
    let sort = |list: &str| -> String {
        let inner = &list[1..list.len() - 1];
        let mut items: Vec<&str> = Vec::new();
        let (mut depth, mut in_str, mut escaped, mut start) = (0, false, false, 0);
        for (i, c) in inner.char_indices() {
            if in_str {
                match c {
                    _ if escaped => escaped = false,
                    '\\' => escaped = true,
                    '"' => in_str = false,
                    _ => {}
                }
                continue;
            }
            match c {
                '"' => in_str = true,
                '[' | '(' => depth += 1,
                ']' | ')' => depth -= 1,
                ',' if depth == 0 => {
                    items.push(&inner[start..i]);
                    start = i + 1;
                }
                _ => {}
            }
        }
        if !inner.is_empty() {
            items.push(&inner[start..]);
        }
        items.sort();
        format!("[{}]", items.join(","))
    };
    format!(
        "Derive({}{}{}{}{}",
        &body[..drvs.0],
        sort(&body[drvs.0..drvs.1]),
        &body[drvs.1..srcs.0],
        sort(&body[srcs.0..srcs.1]),
        &body[srcs.1..]
    )
}

/// The `out` path a .drv file declares (empty for a content-addressed one).
fn drv_out(text: &str) -> String {
    let re = regex::Regex::new(r#"^Derive\(\[\("out","([^"]*)""#).unwrap();
    re.captures(text).map(|c| c[1].to_string()).unwrap_or_default()
}

/// Whether the derivations `old` and `new` (paths of .drv files, read with `read`) are the same except for
/// `same` (store paths of `old` that count as those of `new`: the units that got their list in the same build,
/// and their outputs), their own output path and, with `own_src`, their own src (a non-derivation input of the
/// same name: all files or the list). The other inputs are the same then (dependencies, flags, env), so their
/// outputs have to be the same too. A helper derivation that differs only through `same` (e.g. the directory of
/// a unit's libraries) is the same, a dependency whose src changed isn't. `same` gets the pairs found.
pub fn same_but_src(
    old: &str,
    new: &str,
    own_src: bool,
    same: &mut Vec<(String, String)>,
    read: &dyn Fn(&str) -> Option<String>,
) -> bool {
    if old == new {
        return true;
    }
    let (Some(a), Some(b)) = (read(old), read(new)) else { return false };
    let (pa, pb) = (store_paths(&a), store_paths(&b));
    let (out_a, out_b) = (drv_out(&a), drv_out(&b));
    let known = |p: &String, same: &[(String, String)]| same.iter().any(|(o, _)| o == p);
    // derivations of the same name that differ: helpers depending on `same`, or a changed dependency
    for p in pa.difference(&pb).filter(|p| p.ends_with(".drv")) {
        if known(p, same) {
            continue;
        }
        let Some(q) = pb.difference(&pa).find(|q| store_name(q) == store_name(p)) else { return false };
        if !same_but_src(p, q, false, same, read) {
            return false;
        }
    }
    let mut rewrites: Vec<(String, String)> = same.clone();
    rewrites.push((out_a.clone(), out_b.clone()));
    if own_src {
        for p in pa.difference(&pb).filter(|p| !p.ends_with(".drv") && !known(p, same)) {
            if let Some(q) = pb.difference(&pa).find(|q| !q.ends_with(".drv") && store_name(q) == store_name(p)) {
                rewrites.push((p.clone(), q.clone()));
            }
        }
    }
    let mut a = a;
    for (o, n) in rewrites.iter().filter(|(o, _)| !o.is_empty()) {
        a = a.replace(o.as_str(), n);
    }
    if sorted_inputs(&a) != sorted_inputs(&b) {
        return false;
    }
    same.push((old.to_string(), new.to_string()));
    same.push((out_a, out_b));
    true
}

/// Whether the derivation `new` (a .drv, read with `read`), with inputs from content-addressed derivations, is
/// rebuilt whatever their outputs are, compared with the earlier `old`: a store path of `old` other than its
/// own output (its src, the output of an input-addressed dependency) isn't in `new`. Their own outputs are
/// placeholders until nix resolves them while building, and the drvs change with every new run of them.
pub fn rebuilt_anyway(old: &str, new: &str, read: &dyn Fn(&str) -> Option<String>) -> bool {
    if old == new {
        return false;
    }
    let (Some(a), Some(b)) = (read(old), read(new)) else { return false };
    let (pa, pb, out_a) = (store_paths(&a), store_paths(&b), drv_out(&a));
    pa.difference(&pb).any(|p| !p.ends_with(".drv") && *p != out_a)
}

/// Compares the output `a` built with all files with the output `b` built with the list. `rewrites`: the store
/// hashes of `a` (and of the units it references) with those of `b`, which differ while the contents are the
/// same. With `-C incremental`, the names of the object files in an rlib carry a random part, also inside other
/// members (`lib.rmeta-link`): those of `a` are paired with those of `b` and rewritten too. Returns the first
/// difference.
pub fn compare_outputs(a: &Path, b: &Path, rewrites: &[(String, String)]) -> Result<(), String> {
    let (fa, fb) = (files_below(a), files_below(b));
    if let Some(only) = fa.symmetric_difference(&fb).next() {
        return Err(format!("{} is only in one of the outputs", only.display()));
    }
    let rewriter = Rewriter::new(rewrites);
    for rel in fa {
        let (pa, pb) = (a.join(&rel), b.join(&rel));
        let read = |p: &Path| -> Result<Vec<u8>, String> {
            match std::fs::read_link(p) {
                Ok(t) => Ok(t.into_os_string().into_encoded_bytes()),
                Err(_) => std::fs::read(p).map_err(|e| format!("{}: {e}", p.display())),
            }
        };
        let (da, db) = (rewriter.apply(read(&pa)?), read(&pb)?);
        let same = match (ar_members(&da), ar_members(&db)) {
            (Some(ma), Some(mb)) => same_archives(ma, mb),
            _ => da == db,
        };
        if !same {
            return Err(format!("{} differs", rel.display()));
        }
    }
    Ok(())
}

/// The members of two archives, paired by their names without the random part of incremental object files.
fn same_archives(ma: Vec<(String, Vec<u8>)>, mb: Vec<(String, Vec<u8>)>) -> bool {
    let keyed = |m: &[(String, Vec<u8>)], key: fn(&str) -> String| -> Option<BTreeMap<String, usize>> {
        let mut map = BTreeMap::new();
        for (i, (name, _)) in m.iter().enumerate() {
            if map.insert(key(name), i).is_some() {
                return None;
            }
        }
        Some(map)
    };
    let (ka, kb) = match (keyed(&ma, object_key), keyed(&mb, object_key)) {
        (Some(ka), Some(kb)) => (ka, kb),
        // the names without their random part aren't unique: by full name
        _ => match (keyed(&ma, str::to_string), keyed(&mb, str::to_string)) {
            (Some(ka), Some(kb)) => (ka, kb),
            _ => return false,
        },
    };
    if !ka.keys().eq(kb.keys()) {
        return false;
    }
    let names: Vec<(String, String)> = ka
        .iter()
        .map(|(k, i)| (ma[*i].0.clone(), mb[kb[k]].0.clone()))
        .filter(|(x, y)| x != y && x.len() == y.len())
        .collect();
    let rewriter = Rewriter::new(&names);
    ka.iter().all(|(k, i)| rewriter.apply(ma[*i].1.clone()) == mb[kb[k]].1)
}

/// `<crate>-<hash>.<cgu>.<random>.rcgu.o` without `<random>`; other names as they are.
fn object_key(name: &str) -> String {
    match name.strip_suffix(".rcgu.o") {
        Some(stem) => {
            let parts: Vec<&str> = stem.split('.').collect();
            if parts.len() >= 3 { parts[..parts.len() - 1].join(".") + ".rcgu.o" } else { name.to_string() }
        }
        None => name.to_string(),
    }
}

fn files_below(dir: &Path) -> BTreeSet<PathBuf> {
    fn walk(base: &Path, dir: &Path, out: &mut BTreeSet<PathBuf>) {
        let Ok(entries) = std::fs::read_dir(dir) else { return };
        for entry in entries.flatten() {
            let path = entry.path();
            if entry.file_type().is_ok_and(|t| t.is_dir()) {
                walk(base, &path, out);
            } else if let Ok(rel) = path.strip_prefix(base) {
                out.insert(rel.to_path_buf());
            }
        }
    }
    let mut out = BTreeSet::new();
    walk(dir, dir, &mut out);
    out
}

/// Replaces strings by others of the same length in one pass over the data. One pass per pair would read the data
/// once per pair: for cargo's lib, 572 MB once for each of its ~256 object files' names.
struct Rewriter {
    /// all `from`s, as alternatives; `None` if there is nothing to replace
    re: Option<regex::bytes::Regex>,
    to: HashMap<Vec<u8>, Vec<u8>>,
}

impl Rewriter {
    fn new(rewrites: &[(String, String)]) -> Rewriter {
        let pairs: Vec<&(String, String)> = rewrites.iter().filter(|(from, to)| from != to).collect();
        let pattern = pairs.iter().map(|(from, _)| regex::escape(from)).collect::<Vec<_>>().join("|");
        let re = (!pairs.is_empty()).then(|| {
            regex::bytes::RegexBuilder::new(&pattern)
                .unicode(false)
                .size_limit(1 << 28)
                .build()
                .expect("an alternation of escaped literals is a valid regex")
        });
        let to = pairs.iter().map(|(from, to)| (from.as_bytes().to_vec(), to.as_bytes().to_vec())).collect();
        Rewriter { re, to }
    }

    fn apply(&self, mut data: Vec<u8>) -> Vec<u8> {
        let Some(re) = &self.re else { return data };
        let at: Vec<(usize, usize)> = re.find_iter(&data).map(|m| (m.start(), m.end())).collect();
        for (start, end) in at {
            let to = &self.to[&data[start..end]];
            debug_assert_eq!(to.len(), end - start);
            data[start..end].copy_from_slice(to);
        }
        data
    }
}


/// The members of an `ar` archive (GNU or BSD format) by name, without the symbol and name tables, whose contents
/// depend on the member names and offsets. `None` if it isn't an archive.
fn ar_members(data: &[u8]) -> Option<Vec<(String, Vec<u8>)>> {
    let mut rest = data.strip_prefix(b"!<arch>\n")?;
    let mut long_names: &[u8] = &[];
    let mut members = Vec::new();
    while rest.len() >= 60 {
        let (header, after) = rest.split_at(60);
        let raw = std::str::from_utf8(&header[..16]).ok()?.trim_end();
        let size: usize = std::str::from_utf8(&header[48..58]).ok()?.trim().parse().ok()?;
        let body = after.get(..size)?;
        rest = after.get(size + size % 2..).unwrap_or_default();
        if raw == "//" {
            long_names = body;
            continue;
        }
        if matches!(raw, "/" | "/SYM64/") {
            continue;
        }
        let (name, body) = if let Some(len) = raw.strip_prefix("#1/") {
            // BSD: the name is the first `len` bytes of the body
            let len: usize = len.parse().ok()?;
            let name = String::from_utf8_lossy(body.get(..len)?).trim_end_matches('\0').to_string();
            (name, body.get(len..)?)
        } else if let Some(offset) = raw.strip_prefix('/').and_then(|o| o.parse::<usize>().ok()) {
            // GNU: `/<offset>` into the name table, the name ends with `/\n`
            let tail = long_names.get(offset..)?;
            let end = memchr::memmem::find(tail, b"/\n").unwrap_or(tail.len());
            (String::from_utf8_lossy(&tail[..end]).into_owned(), body)
        } else {
            (raw.strip_suffix('/').unwrap_or(raw).to_string(), body)
        };
        if name.starts_with("__.SYMDEF") {
            continue;
        }
        members.push((name, body.to_vec()));
    }
    Some(members)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn dep_info() {
        let text = "/nix/store/x-a/a-1.d: src/lib.rs src/my\\ file.rs ../README.md\n\nsrc/lib.rs:\n# env-dep:FOO=bar\n";
        assert_eq!(parse_dep_info(text), ["src/lib.rs", "src/my file.rs", "../README.md"]);
    }

    #[test]
    fn relative() {
        let root = Path::new("/nonexistent/ws");
        let r = |dep| root_relative(dep, "ws", root);
        assert_eq!(r("lib/src/lib.rs"), Ok(Some("lib/src/lib.rs".to_string())));
        assert_eq!(r("lib/src/../data.txt"), Ok(Some("lib/data.txt".to_string())));
        assert_eq!(r("/nix/store/abc-x/out.rs"), Ok(None));
        assert!(r("lib/../../etc/passwd").is_err());
        // absolute, but the file isn't there
        assert!(r("/build/ws/src/lib.rs").is_err());
    }

    #[test]
    fn minimal() {
        let files = [ListedFile { path: "crates/a/src/lib.rs".into(), sha256: String::new() }];
        let src = minimal_src(&files, Path::new("crates/a"));
        assert!(src.contains("\"crates\"\n") && src.contains("\"crates/a\"\n") && src.contains("\"crates/a/src/lib.rs\""));
    }

    #[test]
    fn ar() {
        let member = |name: &str, body: &[u8]| {
            let mut m = format!("{name:<16}{:<12}{:<6}{:<6}{:<8}{:<10}`\n", 0, 0, 0, 644, body.len()).into_bytes();
            m.extend_from_slice(body);
            if body.len() % 2 == 1 {
                m.push(b'\n');
            }
            m
        };
        let archive = |members: &[Vec<u8>]| [b"!<arch>\n".to_vec(), members.concat()].concat();
        // the object names differ only in the random part, also where the link member names them
        let a = archive(&[member("/", b"sym-a"), member("a.c.r1.rcgu.o/", b"abc"), member("m/", b"ref a.c.r1.rcgu.o")]);
        let b = archive(&[member("/", b"sym-bb"), member("a.c.r2.rcgu.o/", b"abc"), member("m/", b"ref a.c.r2.rcgu.o")]);
        let c = archive(&[member("a.c.r2.rcgu.o/", b"abd"), member("m/", b"ref a.c.r2.rcgu.o")]);
        let same = |x: &[u8], y: &[u8]| same_archives(ar_members(x).unwrap(), ar_members(y).unwrap());
        assert!(same(&a, &b));
        assert!(!same(&a, &c));
    }

    #[test]
    fn rewrites() {
        let data = b"/nix/store/aaaa-x/lib /nix/store/aaaa-x".to_vec();
        let r = Rewriter::new(&[("aaaa".into(), "bbbb".into())]);
        assert_eq!(r.apply(data), b"/nix/store/bbbb-x/lib /nix/store/bbbb-x");
        // several pairs in one pass, regex metacharacters taken literally, unchanged pairs ignored
        let names = [
            ("a-1.cgu.x9.rcgu.o".to_string(), "a-1.cgu.y8.rcgu.o".to_string()),
            ("a-1.cgu2.q1.rcgu.o".to_string(), "a-1.cgu2.r2.rcgu.o".to_string()),
            ("same".to_string(), "same".to_string()),
        ];
        let data = b"a-1.cgu.x9.rcgu.o a-1.cgu2.q1.rcgu.o a-1Xcgu.x9.rcgu.o same".to_vec();
        assert_eq!(Rewriter::new(&names).apply(data), b"a-1.cgu.y8.rcgu.o a-1.cgu2.r2.rcgu.o a-1Xcgu.x9.rcgu.o same");
        assert_eq!(Rewriter::new(&[]).apply(b"x".to_vec()), b"x");
    }

    #[test]
    fn same_but_src_ignores_the_src_and_switched_units() {
        let p = |c: char, name: &str| format!("/nix/store/{}-{name}", c.to_string().repeat(32));
        // a drv: its out, input drvs, input srcs and an env
        let drv = |out: &str, drvs: &[String], srcs: &[String], env: &str| {
            let d: Vec<String> = drvs.iter().map(|d| format!(r#"("{d}",["out"])"#)).collect();
            let s: Vec<String> = srcs.iter().map(|s| format!(r#""{s}""#)).collect();
            format!(r#"Derive([("out","{out}","","")],[{}],[{}],"x86_64-linux","bash",[],[("ENV","{env}"),("out","{out}")])"#, d.join(","), s.join(","))
        };
        let mut files: HashMap<String, String> = HashMap::new();
        // lib (switched: a → b), the dir of app's libraries (a helper with lib's output), app with all files (o)
        // and with its list (n)
        files.insert(p('a', "lib.drv"), drv(&p('a', "lib"), &[], &[p('s', "src")], "1"));
        files.insert(p('b', "lib.drv"), drv(&p('b', "lib"), &[], &[p('m', "src")], "1"));
        files.insert(p('c', "dir.drv"), drv(&p('c', "dir"), &[p('a', "lib.drv")], &[], &p('a', "lib")));
        files.insert(p('d', "dir.drv"), drv(&p('d', "dir"), &[p('b', "lib.drv")], &[], &p('b', "lib")));
        files.insert(p('o', "app.drv"), drv(&p('o', "app"), &[p('a', "lib.drv"), p('c', "dir.drv")], &[p('s', "src")], &p('c', "dir")));
        files.insert(p('n', "app.drv"), drv(&p('n', "app"), &[p('b', "lib.drv"), p('d', "dir.drv")], &[p('t', "src")], &p('d', "dir")));
        // lib with another src that didn't get its list in this build: a changed dependency
        files.insert(p('e', "lib.drv"), drv(&p('e', "lib"), &[], &[p('x', "src")], "1"));
        files.insert(p('f', "dir.drv"), drv(&p('f', "dir"), &[p('e', "lib.drv")], &[], &p('e', "lib")));
        files.insert(p('g', "app.drv"), drv(&p('g', "app"), &[p('e', "lib.drv"), p('f', "dir.drv")], &[p('t', "src")], &p('f', "dir")));
        // app with another env
        files.insert(p('h', "app.drv"), drv(&p('h', "app"), &[p('b', "lib.drv"), p('d', "dir.drv")], &[p('t', "src")], "other"));
        let read = |path: &str| files.get(path).cloned();
        let lib_switched = || vec![(p('a', "lib.drv"), p('b', "lib.drv")), (p('a', "lib"), p('b', "lib"))];

        assert!(same_but_src(&p('o', "app.drv"), &p('n', "app.drv"), true, &mut lib_switched(), &read));
        // lib not switched: its new drv is a changed dependency
        assert!(!same_but_src(&p('o', "app.drv"), &p('n', "app.drv"), true, &mut vec![], &read));
        assert!(!same_but_src(&p('o', "app.drv"), &p('g', "app.drv"), true, &mut lib_switched(), &read));
        assert!(!same_but_src(&p('o', "app.drv"), &p('h', "app.drv"), true, &mut lib_switched(), &read));
        // the rewritten input drvs in another order (sorted by path): lib z, dir y
        let mut files = files.clone();
        files.insert(p('z', "lib.drv"), drv(&p('z', "lib"), &[], &[p('m', "src")], "1"));
        files.insert(p('y', "dir.drv"), drv(&p('y', "dir"), &[p('z', "lib.drv")], &[], &p('z', "lib")));
        files.insert(p('w', "app.drv"), drv(&p('w', "app"), &[p('y', "dir.drv"), p('z', "lib.drv")], &[p('t', "src")], &p('y', "dir")));
        let read2 = |path: &str| files.get(path).cloned();
        let lib_z = || vec![(p('a', "lib.drv"), p('z', "lib.drv")), (p('a', "lib"), p('z', "lib"))];
        assert!(same_but_src(&p('o', "app.drv"), &p('w', "app.drv"), true, &mut lib_z(), &read2));
        // the src of a dependency isn't its own src
        assert!(!same_but_src(&p('a', "lib.drv"), &p('b', "lib.drv"), false, &mut vec![], &read));
        assert!(same_but_src(&p('a', "lib.drv"), &p('b', "lib.drv"), true, &mut vec![], &read));
    }

    #[test]
    fn rebuilt_anyway_only_for_other_inputs_than_the_runs() {
        let p = |c: char, name: &str| format!("/nix/store/{}-{name}", c.to_string().repeat(32));
        // a crate after a content-addressed run: no out path, the run's output is a placeholder
        let drv = |drvs: &[String], srcs: &[String]| {
            let d: Vec<String> = drvs.iter().map(|d| format!(r#"("{d}",["out"])"#)).collect();
            let s: Vec<String> = srcs.iter().map(|s| format!(r#""{s}""#)).collect();
            format!(r#"Derive([("out","","","")],[{}],[{}],"x86_64-linux","bash",[],[("RUN","/1placeholder"),("out","/1out")])"#, d.join(","), s.join(","))
        };
        let mut files: HashMap<String, String> = HashMap::new();
        files.insert(p('o', "app.drv"), drv(&[p('a', "run.drv"), p('l', "lib.drv")], &[p('s', "src")]));
        // another run (its drv changes with every new run)
        files.insert(p('r', "app.drv"), drv(&[p('b', "run.drv"), p('l', "lib.drv")], &[p('s', "src")]));
        // another src
        files.insert(p('n', "app.drv"), drv(&[p('b', "run.drv"), p('l', "lib.drv")], &[p('t', "src")]));
        // the output of an input-addressed dependency
        files.insert(p('d', "app.drv"), drv(&[p('a', "run.drv"), p('l', "lib.drv")], &[p('s', "src"), p('x', "dep")]));
        files.insert(p('e', "app.drv"), drv(&[p('a', "run.drv"), p('l', "lib.drv")], &[p('s', "src"), p('y', "dep")]));
        let read = |path: &str| files.get(path).cloned();

        assert!(!rebuilt_anyway(&p('o', "app.drv"), &p('o', "app.drv"), &read));
        assert!(!rebuilt_anyway(&p('o', "app.drv"), &p('r', "app.drv"), &read));
        assert!(rebuilt_anyway(&p('o', "app.drv"), &p('n', "app.drv"), &read));
        assert!(rebuilt_anyway(&p('d', "app.drv"), &p('e', "app.drv"), &read));
        // unknown: built, and checked afterwards
        assert!(!rebuilt_anyway(&p('o', "app.drv"), &p('q', "app.drv"), &read));
    }
}
