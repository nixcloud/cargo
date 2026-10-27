mod asserts;
mod download;
mod git_store;
mod deps;
mod src_list;
mod tests;
pub mod nix_files;
pub mod nix_code;
pub mod nix_build_runner;
mod templates;

use cargo_util::ProcessBuilder;
use indoc::indoc;
use std::collections::{BTreeMap, BTreeSet, HashMap, HashSet};
use std::fs::File;
use std::io::Write;
use std::path::{Path, PathBuf};
use std::fs;

use asserts::assert_escapes;
use deps::{Dependencies, handle_dynamic_crate_aspects};
use nix_files::{create_nix_filepath, write_nix_file};
use nix_code::{IndentationExt, bins_in_store, cargo_crate_info, create_nix_name, generate_environment_variables, generate_unpack_phase, generate_src};
use crate::compiler::nix_build::nix_build_runner::{
    content_addressed, references, BuildFailed, Built, Gate, NixBuild, Outcome,
};
use crate::compiler::nix_build::nix_build_runner::event::store_name as event_store_name;
use src_list::{SrcList, SrcLists};
pub use crate::compiler::nix_build::nix_build_runner::gc_roots::BuildOutputs;
use crate::compiler::nix_build::nix_files::ensure_garbage_collected_directory;
use crate::compiler::unit_graph::UnitGraph;
use crate::compiler::Unit;
use crate::compiler::{BuildContext, BuildRunner, CompileMode, FileFlavor};
use crate::workspace::Workspace;
use crate::workspace::TargetKind;
use crate::util::{CargoResult, Filesystem, GlobalContext};

#[derive(Clone, Debug)]
pub struct NixBuildOptions {
    pub out_dir: PathBuf,
    /// `None`: the workspace's path crates are taken from `project_root`, a local directory (relative to
    /// `out_dir` by default, overridable when importing the build system, e.g. via IFD).
    pub remote_src: Option<RemoteSrc>,
}

/// Tarball the workspace's path crates are fetched from (`--url`/`--hash`).
#[derive(Clone, Debug)]
pub struct RemoteSrc {
    pub url: String,
    pub hash: String,
}

#[derive(Debug)]
struct DefaultNixEntry {
    name: String,
    rel_file_path: PathBuf,
    is_root: bool,
}

#[derive(Debug, Eq, PartialEq)]
pub enum NixNameMode {
    AttributeName,
    FileName,
}

pub fn kind_string(tk: &TargetKind) -> String {
    match tk {
        TargetKind::Lib(_) => {
            "".to_string() // default, so we leave it empty
        }
        TargetKind::ExampleLib(_) => "-example_lib".to_string(),
        TargetKind::Bin => "-bin".to_string(),
        TargetKind::CustomBuild => "-script_build".to_string(),
        TargetKind::Test => "-test".to_string(),
        TargetKind::Bench => "-bench".to_string(),
        TargetKind::ExampleBin => "-example_bin".to_string(),
    }
}

pub fn mode_string(mode: &CompileMode) -> &str {
    match mode {
        CompileMode::Test => "-test",
        CompileMode::Build => "", // default, so we leave it empty
        CompileMode::Check { test: _ } => "-check",
        CompileMode::Doc => "-doc",
        CompileMode::Doctest => "-doc_test",
        CompileMode::Docscrape => "-doc_scrape",
        CompileMode::RunCustomBuild => "_run",
    }
}


// FIXME refactor this, we probably can use CompileMode::Build instead now
#[derive(Debug, Clone, Hash, PartialEq, Eq, PartialOrd, Ord)]
enum CrateBuildType {
    LibBuild,
    ScriptBuild,
    ScriptBuildRun,
    BinBuild,
    /// a test harness (`cargo test`): unit tests of a lib, bin, example or bench, or an integration test
    TestBuild,
    /// an example binary, built by `cargo test` (and `cargo build --examples`)
    ExampleBuild,
    Other,
}

fn crate_build_type(unit: &Unit) -> CrateBuildType {
    let target_kind: &TargetKind = unit.target.kind();
    let compile_mode: CompileMode = unit.mode;

    if compile_mode == CompileMode::Test {
        CrateBuildType::TestBuild
    } else if compile_mode == CompileMode::Build && *target_kind == TargetKind::ExampleBin {
        CrateBuildType::ExampleBuild
    } else if compile_mode == CompileMode::Build && matches!(*target_kind, TargetKind::Lib(_)) {
        CrateBuildType::LibBuild
    } else if compile_mode == CompileMode::Build && *target_kind == TargetKind::CustomBuild {
        CrateBuildType::ScriptBuild
    } else if compile_mode == CompileMode::RunCustomBuild && *target_kind == TargetKind::CustomBuild
    {
        CrateBuildType::ScriptBuildRun
    } else if compile_mode == CompileMode::Build && *target_kind == TargetKind::Bin {
        CrateBuildType::BinBuild
    } else {
        CrateBuildType::Other
    }
}

struct SymlinkedTargets {
    attribute_name: String,
    script: String,
}

pub struct NixBuildRunner {}

/// The build system as generated, for building it.
struct Generated {
    nix_base_dir: Filesystem,
    /// derivation names of the generated units and their helpers, for logone
    unit_drv_names: HashSet<String>,
    /// how long writing it took
    duration: std::time::Duration,
}

/// A root unit with minimal sources (src_list.rs).
struct ListedUnit {
    /// the package's directory, relative to the workspace root
    crate_dir: PathBuf,
    /// the units with minimal sources it depends on, also indirectly
    deps: BTreeSet<String>,
}

impl<'a, 'gctx> NixBuildRunner {
    /// Generates the build system and builds it; returns its outputs, or `None` if it was only written
    /// (write-nix-buildsystem).
    pub fn build(build_runner: &BuildRunner<'a, 'gctx>) -> CargoResult<Option<BuildOutputs>> {
        let gctx = build_runner.bcx.gctx;
        if gctx.write_nix_buildsystem_options.get().unwrap_or(&None).is_some() {
            Self::generate(build_runner, &HashMap::new())?;
            return Ok(None);
        }
        Self::build_with_src_lists(build_runner).map(Some)
    }

    /// The root units that get minimal sources: workspace members compiled (also their build scripts, not their
    /// runs), with a list that isn't `Full`, not opted out, and depending on no path unit that keeps all files.
    /// Those rebuild on every edit (build script runs, path packages outside the workspace), so would their
    /// dependents. With content-addressed runs (`content_addressed`) a run of the workspace keeps all files but
    /// doesn't count as such: its output decides (`SrcList::Output`), and it is in the `deps` of the units after
    /// it. Returns those runs too.
    fn listed_units(
        build_runner: &BuildRunner<'a, 'gctx>,
        lists: &SrcLists,
    ) -> (BTreeMap<String, ListedUnit>, BTreeSet<String>) {
        fn visit<'a, 'gctx>(
            unit: &Unit,
            build_runner: &BuildRunner<'a, 'gctx>,
            lists: &SrcLists,
            memo: &mut HashMap<Unit, (bool, BTreeSet<String>)>,
            listed: &mut BTreeMap<String, ListedUnit>,
            runs: &mut BTreeSet<String>,
        ) -> (bool, BTreeSet<String>) {
            if let Some(r) = memo.get(unit) {
                return r.clone();
            }
            let bcx = &build_runner.bcx;
            let mut tainted = false;
            let mut deps = BTreeSet::new();
            for dep in bcx.unit_graph.get(unit).map(|d| d.as_slice()).unwrap_or_default() {
                let (t, d) = visit(&dep.unit, build_runner, lists, memo, listed, runs);
                tainted |= t;
                deps.extend(d);
            }
            let pkg = unit.pkg.package_id();
            let is_root = bcx.ws.members().any(|m| m.package_id() == pkg);
            let attr = create_nix_name(unit, build_runner, NixNameMode::AttributeName, false);
            if is_root && unit.mode == CompileMode::RunCustomBuild && content_addressed() {
                // what the units after it get is its output, not its inputs: a changed build script that writes
                // the same output changes nothing after it
                runs.insert(attr.clone());
                let r = (false, BTreeSet::from([attr]));
                memo.insert(unit.clone(), r.clone());
                return r;
            }
            let crate_dir = unit.pkg.root().strip_prefix(bcx.ws.root()).ok().map(Path::to_path_buf);
            let listed_self = !tainted
                && crate_dir.is_some()
                && src_list::in_scope(unit, is_root)
                && !src_list::opted_out(unit)
                && !matches!(lists.get(&attr), Some(SrcList::Full(_)));
            if listed_self {
                listed.insert(attr.clone(), ListedUnit { crate_dir: crate_dir.unwrap(), deps: deps.clone() });
                deps.insert(attr);
            }
            let r = (tainted || (pkg.source_id().is_path() && !listed_self), deps);
            memo.insert(unit.clone(), r.clone());
            r
        }
        let mut memo = HashMap::new();
        let mut listed = BTreeMap::new();
        let mut runs = BTreeSet::new();
        for (_, unit) in build_runner.raw_process_builder.lock().unwrap().iter() {
            visit(unit, build_runner, lists, &mut memo, &mut listed, &mut runs);
        }
        (listed, runs)
    }

    /// The gate check (`Gate`): the units with a list after a run (`runs`) whose output isn't the recorded one;
    /// the dirty ones already get new lists. `outs` are the runs' outputs now, kept in `seen` for recording them
    /// after the build (`SrcList::Output`), `changed_runs` the runs that changed.
    fn changed_after_runs(
        listed: &BTreeMap<String, ListedUnit>,
        lists: &SrcLists,
        dirty: &BTreeSet<String>,
        outs: &HashMap<String, String>,
        seen: &mut HashMap<String, String>,
        changed_runs: &mut Vec<String>,
    ) -> Vec<String> {
        seen.extend(outs.iter().map(|(a, o)| (a.clone(), o.clone())));
        let changed: BTreeSet<&String> = outs
            .iter()
            .filter(|(a, o)| !matches!(lists.get(a), Some(SrcList::Output(r)) if r == *o))
            .map(|(a, _)| a)
            .collect();
        let units: Vec<String> = listed
            .iter()
            .filter(|(a, u)| !dirty.contains(*a) && u.deps.iter().any(|d| changed.contains(d)))
            .map(|(a, _)| a.clone())
            .collect();
        if !units.is_empty() {
            *changed_runs = changed.into_iter().cloned().collect();
        }
        units
    }

    /// Adds the units that depend on a dirty one.
    fn propagate_dirty(listed: &BTreeMap<String, ListedUnit>, dirty: &mut BTreeSet<String>) {
        let more: Vec<String> = listed
            .iter()
            .filter(|(a, u)| !dirty.contains(*a) && u.deps.iter().any(|d| dirty.contains(d)))
            .map(|(a, _)| a.clone())
            .collect();
        dirty.extend(more);
    }

    /// The minimal `src` of the units `on_list`, from their lists.
    fn minimal_srcs(
        listed: &BTreeMap<String, ListedUnit>,
        lists: &SrcLists,
        on_list: &BTreeSet<String>,
    ) -> HashMap<String, String> {
        on_list
            .iter()
            .filter_map(|a| match lists.get(a) {
                Some(SrcList::Files(files) | SrcList::Pending(src_list::Pending { files, .. })) => {
                    Some((a.clone(), src_list::minimal_src(files, &listed[a].crate_dir)))
                }
                _ => None,
            })
            .collect()
    }

    /// `cargo build` with minimal sources for the root units (src_list.rs). A dirty unit is built with all files,
    /// and its dep-info file gives its list (`SrcList::Pending`). It stays on all files while that build is the
    /// current one; once it would be rebuilt with all files (another file of the workspace changed), it gets
    /// its list instead, and that output is compared with the one built with all files.
    fn build_with_src_lists(build_runner: &BuildRunner<'a, 'gctx>) -> CargoResult<BuildOutputs> {
        let bcx = &build_runner.bcx;
        let gctx = bcx.gctx;
        let (keep_going, jobs) = (bcx.build_config.keep_going, bcx.build_config.jobs);
        let target_dir = bcx.ws.target_dir().into_path_unlocked();
        let selection = Self::selection(build_runner);

        let base = Self::nix_base_dir(build_runner, &None).into_path_unlocked();
        let mut lists = SrcLists::load(&base, bcx.ws.root());
        let (listed, runs) = Self::listed_units(build_runner, &lists);
        let mut dirty: BTreeSet<String> = listed.keys().filter(|a| !lists.is_clean(a)).cloned().collect();
        Self::propagate_dirty(&listed, &mut dirty);
        // the units with a pending list that get it in this build
        let mut switch: BTreeSet<String> = BTreeSet::new();
        let mut generation = std::time::Duration::ZERO;
        // the outputs of the content-addressed runs (`runs`) in this build, recorded once it succeeded
        let mut run_outs: HashMap<String, String> = HashMap::new();
        let run_attrs: Vec<String> = runs.iter().cloned().collect();
        // a unit after such a run: its drv is a new one with every new run (`Gate::after`)
        let after_run = |name: &str| listed.get(name).is_some_and(|u| u.deps.iter().any(|d| runs.contains(d)));

        if !dirty.is_empty() {
            gctx.shell().status(
                "Nix",
                format!("{} unit(s) changed: building them with all files, for their file lists", dirty.len()),
            )?;
            gctx.shell().verbose(|s| s.status("Changed", dirty.iter().cloned().collect::<Vec<_>>().join(", ")))?;
        }
        for _ in 0..5 {
            // a pending list that isn't switched to: the unit is built with all files as before
            let waiting = |name: &str| {
                listed.contains_key(name)
                    && !dirty.contains(name)
                    && !switch.contains(name)
                    && matches!(lists.get(name), Some(SrcList::Pending(_)))
            };
            let on_list: BTreeSet<String> = listed
                .keys()
                .filter(|a| !dirty.contains(*a))
                .filter(|a| switch.contains(*a) || matches!(lists.get(a), Some(SrcList::Files(_))))
                .cloned()
                .collect();
            let generated = Self::generate(build_runner, &Self::minimal_srcs(&listed, &lists, &on_list))?;
            generation += generated.duration;
            // a waiting unit that would be rebuilt gets its list instead
            let restart = |name: &str| waiting(name) && !after_run(name);
            let after: HashSet<String> = listed.keys().filter(|a| waiting(a) && after_run(a)).cloned().collect();
            let mut changed_runs = Vec::new();
            let mut check = |outs: &HashMap<String, String>| {
                Self::changed_after_runs(&listed, &lists, &dirty, outs, &mut run_outs, &mut changed_runs)
            };
            // one of `after` whose src or input-addressed dependency changed: rebuilt whatever the runs' outputs
            let read = |p: &str| std::fs::read_to_string(p).ok();
            let rebuilt = |name: &str, drv: &str| {
                matches!(lists.get(name), Some(SrcList::Pending(p)) if src_list::rebuilt_anyway(&p.drv, drv, &read))
            };
            let mut gate = Gate { attrs: run_attrs.clone(), check: &mut check, after, rebuilt: &rebuilt };
            // the dirty units for their lists, the switched ones for the comparison
            let want: Vec<String> = dirty.iter().chain(&switch).cloned().collect();
            let mut built_units: HashMap<String, Built> = HashMap::new();
            let mut mismatches: Vec<String> = Vec::new();
            let mut verify = |built: &HashMap<String, Built>| -> CargoResult<()> {
                mismatches = Self::compare_with_all_files(&lists, &switch, built)?;
                built_units = want
                    .iter()
                    .filter_map(|a| built.get(a).map(|b| (a.clone(), Built { drv: b.drv.clone(), out: b.out.clone() })))
                    .collect();
                if mismatches.is_empty() { Ok(()) } else { anyhow::bail!("the outputs differ") }
            };
            let outcome = NixBuild::build(
                generated.nix_base_dir,
                gctx,
                keep_going,
                jobs,
                generated.unit_drv_names,
                &target_dir,
                &selection,
                &restart,
                &mut verify,
                generation,
                &mut gate,
                &want,
            );
            if !mismatches.is_empty() {
                for m in &mismatches {
                    let (attr, diff) = m.split_once(": ").unwrap_or((m, ""));
                    let reason = format!(
                        "built with only the files rustc listed, it differs from the build with all files ({diff}): a \
                         file was read without rustc knowing (e.g. by a proc macro using std::fs instead of \
                         include_bytes!), or the build isn't reproducible"
                    );
                    gctx.shell().warn(format!("{attr} keeps all files: {reason}"))?;
                    lists.set(attr, SrcList::Full(reason))?;
                    switch.remove(attr);
                }
                continue;
            }
            // units that fail with their list only: built with all files instead
            if let Err(e) = &outcome {
                let failed = e.downcast_ref::<BuildFailed>().map(|f| f.failed.clone()).unwrap_or_default();
                if !failed.is_empty() && failed.iter().all(|n| on_list.contains(n)) {
                    for attr in &failed {
                        if switch.remove(attr) {
                            // built with all files before, with the same files: the list is incomplete
                            let reason = "compiles with all files, but fails with only the files rustc listed: a \
                                          file was read without rustc knowing (e.g. by a proc macro using std::fs \
                                          instead of include_bytes!)"
                                .to_string();
                            gctx.shell().warn(format!("{attr} keeps all files: {reason}"))?;
                            lists.set(attr, SrcList::Full(reason))?;
                        } else {
                            gctx.shell().status("Nix", format!("{attr} fails with its file list: building it with all files"))?;
                            dirty.insert(attr.clone());
                        }
                    }
                    Self::propagate_dirty(&listed, &mut dirty);
                    continue;
                }
            }
            match outcome? {
                Outcome::Restart(names) => {
                    if changed_runs.is_empty() {
                        gctx.shell().status(
                            "Nix",
                            format!("{} would be rebuilt: building with the files rustc listed from now on", names.join(", ")),
                        )?;
                        let (waited, other): (Vec<String>, Vec<String>) = names.into_iter().partition(|n| waiting(n));
                        switch.extend(waited);
                        dirty.extend(other);
                        Self::propagate_dirty(&listed, &mut dirty);
                        // a waiting unit after a switched one is rebuilt anyway (another dependency); found out only
                        // while building when it comes after a content-addressed run, so built twice then
                        let after_switched: Vec<String> = listed
                            .iter()
                            .filter(|(a, u)| {
                                !dirty.contains(*a)
                                    && !switch.contains(*a)
                                    && matches!(lists.get(a), Some(SrcList::Pending(_)))
                                    && u.deps.iter().any(|d| switch.contains(d))
                            })
                            .map(|(a, _)| a.clone())
                            .collect();
                        switch.extend(after_switched);
                    } else {
                        Self::restart(gctx, &listed, &mut dirty, names, &changed_runs)?;
                    }
                }
                Outcome::Done(outputs) => {
                    for attr in &dirty {
                        let Some(b) = built_units.get(attr) else { continue };
                        let list = match lists.list_from_output(Path::new(&b.out))? {
                            SrcList::Files(files) => {
                                SrcList::Pending(src_list::Pending { files, drv: b.drv.clone(), out: b.out.clone() })
                            }
                            list => list,
                        };
                        if let SrcList::Full(reason) = &list {
                            gctx.shell().status("Nix", format!("{attr} keeps all files: {reason}"))?;
                        }
                        lists.set(attr, list)?;
                    }
                    for attr in &switch {
                        if let Some(SrcList::Pending(p)) = lists.get(attr) {
                            let files = p.files.clone();
                            lists.set(attr, SrcList::Files(files))?;
                        }
                    }
                    // the lists of the units after the runs are for these outputs now
                    for (attr, out) in &run_outs {
                        lists.set(attr, SrcList::Output(out.clone()))?;
                    }
                    return Ok(outputs);
                }
            }
        }
        anyhow::bail!("the units with file lists kept changing between builds")
    }

    fn restart(
        gctx: &GlobalContext,
        listed: &BTreeMap<String, ListedUnit>,
        dirty: &mut BTreeSet<String>,
        names: Vec<String>,
        changed_runs: &[String],
    ) -> CargoResult<()> {
        gctx.shell().status(
            "Nix",
            format!("the output of {} changed: building {} with all files, for new file lists", changed_runs.join(", "), names.join(", ")),
        )?;
        dirty.extend(names);
        Self::propagate_dirty(listed, dirty);
        Ok(())
    }

    /// Compares the output of each unit in `switch`, built with its list for the first time, with its output
    /// built with all files (`SrcList::Pending`), when only the src differs between both derivations
    /// (`src_list::same_but_src`) and the earlier output is still there. Returns `<attr>: <difference>` for those
    /// that differ.
    fn compare_with_all_files(
        lists: &SrcLists,
        switch: &BTreeSet<String>,
        built: &HashMap<String, Built>,
    ) -> CargoResult<Vec<String>> {
        let mut pairs = Vec::new();
        // a dependency that got its list in this build too: compared itself, so it counts as the same
        let mut same: Vec<(String, String)> = Vec::new();
        for attr in switch {
            let (Some(SrcList::Pending(p)), Some(b)) = (lists.get(attr), built.get(attr)) else { continue };
            same.extend([(p.drv.clone(), b.drv.clone()), (p.out.clone(), b.out.clone())]);
            if p.out != b.out && Path::new(&p.out).exists() {
                pairs.push((attr.clone(), p.clone(), b.out.clone(), b.drv.clone()));
            }
        }
        if pairs.is_empty() {
            return Ok(Vec::new());
        }
        // a dependency rebuilt in between, or another flag or env, changes the output for other reasons than the src
        let read = |p: &str| std::fs::read_to_string(p).ok();
        pairs.retain(|(_, p, _, drv)| {
            // all but the unit itself
            let mut same: Vec<(String, String)> = same.iter().filter(|(o, _)| *o != p.drv && *o != p.out).cloned().collect();
            src_list::same_but_src(&p.drv, drv, true, &mut same, &read)
        });
        if pairs.is_empty() {
            return Ok(Vec::new());
        }
        let all: Vec<String> = pairs.iter().flat_map(|(_, p, b, _)| [p.out.clone(), b.clone()]).collect();
        let refs = references(&all)?;
        let hash = |p: &str| p.strip_prefix("/nix/store/").and_then(|p| p.get(..32)).map(String::from);
        let mut mismatches = Vec::new();
        for (attr, p, b, _) in &pairs {
            let a = &p.out;
            // the store paths of the earlier build in the output, by name, are those of this one
            let mut rewrites = vec![(hash(a), hash(b))];
            let by_name = |p: &String| -> HashMap<String, Vec<String>> {
                let mut m: HashMap<String, Vec<String>> = HashMap::new();
                for r in &refs[p] {
                    m.entry(event_store_name(r).to_string()).or_default().push(r.clone());
                }
                m
            };
            let (ra, rb) = (by_name(a), by_name(b));
            for (name, pa) in &ra {
                if let (Some(pb), [pa]) = (rb.get(name), pa.as_slice()) {
                    if let [pb] = pb.as_slice() {
                        if pa != pb {
                            rewrites.push((hash(pa), hash(pb)));
                        }
                    }
                }
            }
            let rewrites: Vec<(String, String)> =
                rewrites.into_iter().filter_map(|(x, y)| Some((x?, y?))).collect();
            if let Err(diff) = src_list::compare_outputs(Path::new(a), Path::new(b), &rewrites) {
                mismatches.push(format!("{attr}: {diff}"));
            }
        }
        Ok(mismatches)
    }

    /// The root units without versions and hashes: rebuilding the same selection after an edit or a dependency
    /// update replaces its GC roots, another selection (`cargo run --bin a`) gets its own.
    fn selection(build_runner: &BuildRunner<'a, 'gctx>) -> String {
        let mut selection: Vec<String> = build_runner
            .bcx
            .roots
            .iter()
            .map(|u| {
                let features = u.features.iter().map(|f| f.as_str()).collect::<Vec<_>>().join(",");
                let kind = match u.kind {
                    crate::compiler::CompileKind::Host => "host".to_string(),
                    crate::compiler::CompileKind::Target(t) => t.short_name().to_string(),
                };
                format!(
                    "{} {} {} {:?} {kind} [{features}]",
                    u.pkg.name(),
                    u.target.kind().description(),
                    u.target.name(),
                    u.mode
                )
            })
            .collect();
        selection.sort();
        selection.dedup();
        selection.join("\n") + "\n"
    }

    /// `target/<profile>/nix` (`nix-test` for `cargo test`), or the --out-dir of write-nix-buildsystem.
    fn nix_base_dir(build_runner: &BuildRunner<'a, 'gctx>, write_nix_buildsystem_options: &Option<NixBuildOptions>) -> Filesystem {
        let bcx = &build_runner.bcx;
        match write_nix_buildsystem_options {
            Some(o) => Filesystem::new(o.out_dir.clone()),
            None => {
                // files in target/nix should created if new, update if existent and deleted if not used anymore
                let target_dir: Filesystem = bcx.ws.target_dir();
                // `cargo test` builds other units (test harnesses, dev-dependencies) than `cargo build`: with a
                // build system and GC roots of its own, neither deletes the store paths of the other
                let dir_name = if bcx.build_config.intent.is_any_test() { "nix-test" } else { "nix" };
                target_dir.join(Self::requested_profile(build_runner)).join(dir_name)
            }
        }
    }

    // FIXME is this limitation required? can't we just support all profiles?
    fn requested_profile(build_runner: &BuildRunner<'a, 'gctx>) -> &'static str {
        if build_runner.bcx.build_config.requested_profile == "release" { "release" } else { "debug" }
    }

    /// Writes the build system. `minimal_srcs`: the `src` of the units that get only their listed files.
    fn generate(
        build_runner: &BuildRunner<'a, 'gctx>,
        minimal_srcs: &HashMap<String, String>,
    ) -> CargoResult<Generated> {
        let generation_start = std::time::Instant::now();
        let bcx: &BuildContext<'a, 'gctx> = &build_runner.bcx;
        let workspace: &Workspace<'gctx> = build_runner.bcx.ws;
        let gctx: &'gctx GlobalContext = bcx.gctx;

        let unit_graph: &UnitGraph = &bcx.unit_graph;
        let requested_profile = Self::requested_profile(build_runner);

        let mut visited_units = BTreeSet::new();
        let mut all_nodes: Vec<DefaultNixEntry> = Vec::new();
        let all_units_with_process_builder: Vec<(ProcessBuilder, Unit)> =
            build_runner.raw_process_builder.lock().unwrap().clone();

        let mut symlinked_targets: Vec<SymlinkedTargets> = vec![];
        // derivation names of the generated units and their helpers (target.nix, default.nix), for logone
        let mut unit_drv_names: HashSet<String> =
            HashSet::from([
                "create-symlinks",
                "rustc-linker-arguments-dir",
                "cargo-libnix-retained-paths-units-crates-toolchain-deps",
            ].map(String::from));

        let write_nix_buildsystem_options: Option<NixBuildOptions> = gctx.write_nix_buildsystem_options.get().unwrap_or(&None).clone();
        if write_nix_buildsystem_options.is_some() && requested_profile != "release" {
            gctx.shell()
                .status(
                    "write-nix-buildsystem",
                    format!("\x1b[33mWarning\x1b[0m: requested_profile is '{}', not 'release'.", requested_profile).trim(),
                )
                .unwrap();
        }
        let nix_base_dir: Filesystem = Self::nix_base_dir(build_runner, &write_nix_buildsystem_options);

        let nix_base_dir_path = nix_base_dir.clone().into_path_unlocked();
        ensure_garbage_collected_directory(&nix_base_dir_path)?;

        let nix_derivations_dir = nix_base_dir.join("derivations");
        nix_derivations_dir.create_dir()?;

        gctx.shell()
            .status(
                "Nix",
                format!(
                    "Creating nix build system for {} cargo units.",
                    all_units_with_process_builder.len()
                ),
            )
        .unwrap();

        let lib_build_targets = deps::lib_build_targets(&all_units_with_process_builder, unit_graph);

        // by reference: a clone of the list copies each unit's process builder (args, env)
        for (process_builder, unit) in &all_units_with_process_builder {
            let unit = unit.clone();
            if visited_units.contains(&unit) {
                continue;
            }
            visited_units.insert(unit.clone());
            let pkg = unit.pkg.package_id();
            let is_root: bool = workspace.members().any(|member| member.package_id() == pkg);
            let is_run_custom_build: bool = unit.mode == CompileMode::RunCustomBuild;
            let crate_name: String = pkg.name().to_string();
            let crate_version: String = pkg.version().to_string();
            let nix_attribute_name: String =
                create_nix_name(&unit, build_runner, NixNameMode::AttributeName, false);
            gctx.shell()
                .verbose(|s| s.status("Generating", &nix_attribute_name))?;
            // the drv name is the attribute name (rustc-call.nix)
            unit_drv_names.insert(nix_attribute_name.clone());

            // let s = format!("unit.profile.incremental: {} {:?}", &nix_attribute_name, unit.profile.incremental);
            // println!("{s}");

            let src: String = match minimal_srcs.get(&nix_attribute_name) {
                Some(src) => src.clone(),
                None => generate_src(&unit, &crate_name, &crate_version, &gctx, &write_nix_buildsystem_options)?,
            };

            let deps: Dependencies = deps::create_unit_dependencies(
                &unit,
                &crate_name,
                &crate_version,
                unit_graph,
                build_runner,
                &lib_build_targets,
                &workspace,
            );

            if is_run_custom_build {
                Self::process_script_build_run(
                    &workspace,
                    &unit,
                    crate_name,
                    crate_version,
                    nix_attribute_name,
                    &process_builder,
                    is_root,
                    &mut all_nodes,
                    build_runner,
                    &deps,
                    &nix_derivations_dir,
                    &src,
                )?
            } else {
                Self::process_unit(
                    &workspace,
                    &unit,
                    crate_name,
                    crate_version,
                    nix_attribute_name,
                    &process_builder,
                    is_root,
                    &mut all_nodes,
                    build_runner,
                    &deps,
                    &nix_derivations_dir,
                    &mut symlinked_targets,
                    &requested_profile,
                    &src,
                )?
            }
        }

        // cargo_build_caller.nix //////////////////////////////////////////////////////////////////////////////////
        gctx.shell()
            .verbose(|s| s.status("Generating", "cargo_build_caller.nix"))?;
        // default of cargo_build_caller.nix's `project_root` argument, the directory path crates are built from
        let project_root: String = match &write_nix_buildsystem_options {
            // exported with --url/--hash: sources are fetched; it only holds the Cargo.dependencies.nix copy
            Some(NixBuildOptions { remote_src: Some(_), .. }) => ".".to_string(),
            // exported for the local checkout: the workspace root, relative to --out-dir; in normal
            // 'CARGO_BACKEND=nix cargo build' relative to <target-dir>/<profile>/nix (the target dir may be anywhere,
            // e.g. CARGO_TARGET_DIR)
            Some(NixBuildOptions { remote_src: None, .. }) | None => {
                relative_nix_path(&nix_base_dir_path, workspace.root())?
            }
        };

        let rendered = templates::render(
            templates::CARGO_BUILD_CALLER,
            &serde_json::json!({
                "project_root": project_root,
            }),
        )?;

        let cargo_build_caller_path = nix_base_dir
            .clone()
            .join("cargo_build_caller.nix")
            .into_path_unlocked();
        let mut file = File::create(&cargo_build_caller_path)?;
        write!(file, "{}", rendered)?;

        // build_rs_libnix.nix //////////////////////////////////////////////////////////////////////////////////

        gctx.shell().verbose(|s| s.status("Generating", "build_rs_libnix.nix"))?;

        let rendered = templates::render(
            templates::BUILD_RS_LIBNIX,
            &serde_json::json!({}),
        )?;

        let build_rs_libnix_path = nix_derivations_dir
            .clone()
            .join("build_rs_libnix.nix")
            .into_path_unlocked();
        let mut file = File::create(&build_rs_libnix_path)?;
        write!(file, "{}", rendered)?;

        // default.nix //////////////////////////////////////////////////////////////////////////////////
        gctx.shell()
            .verbose(|s| s.status("Generating", "default.nix"))?;

        all_nodes.sort_by(|a, b| a.name.cmp(&b.name));
        let nix_packages_deps = all_nodes
            .iter()
            .filter(|entry| !entry.is_root)
            .map(|entry| {
                format!(
                    "      {} = callPackage' ./{} {{ }};",
                    entry.name,
                    &entry.rel_file_path.display()
                )
            })
            .collect::<Vec<_>>()
            .join("\n");
        // Render default_nix_packages as `name = callPackage' ./relative_path {};`
        let nix_packages_root = all_nodes
            .iter()
            .filter(|entry| entry.is_root)
            .map(|entry| {
                format!(
                    "    {} = callPackage' ./{} {{ }};",
                    entry.name,
                    &entry.rel_file_path.display()
                )
            })
            .collect::<Vec<_>>()
            .join("\n");

        let rendered = templates::render(
            templates::DEFAULT,
            &serde_json::json!({
                "nix_packages_root": nix_packages_root,
                "nix_packages_deps": nix_packages_deps,
            }),
        )?;

        // nix/default.nix //////////////////////////////////////////////////////////////////////////////////
        gctx.shell()
            .verbose(|s| s.status("Generating", "nix/default.nix"))?;
        let default_nix_path = nix_derivations_dir
            .clone()
            .join("default.nix")
            .into_path_unlocked();
        let mut file = File::create(default_nix_path)?;
        write!(file, "{}", rendered)?;

        // target.nix //////////////////////////////////////////////////////////////////////////////////
        gctx.shell()
            .verbose(|s| s.status("Generating", "nix/target.nix"))?;
        let mut function_arguments_ = symlinked_targets
            .iter()
            .map(|t| t.attribute_name.clone())
            .collect::<Vec<String>>();
        let mut function_arguments: Vec<String> = vec!["pkgs".to_string()];
        function_arguments.append(&mut function_arguments_);

        let targets = symlinked_targets
            .iter()
            .map(|t| {
                t.script
                .indentation(2)
            })
            .collect::<Vec<String>>()
            .join("\n");

        let rendered = templates::render(
            templates::TARGET,
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "targets": targets,
            }),
        )?;
        let target_path = nix_derivations_dir
            .clone()
            .join("target.nix")
            .into_path_unlocked();
        let mut file = File::create(target_path)?;
        write!(file, "{}", rendered)?;
        let generated = generation_start.elapsed();
        gctx.shell()
            .status("Nix", format!("Created nix build system in {:.1}s", generated.as_secs_f64()))?;

        if write_nix_buildsystem_options.is_none() {
            return Ok(Generated { nix_base_dir, unit_drv_names, duration: generated });
        } else if write_nix_buildsystem_options.as_ref().is_some_and(|o| o.remote_src.is_none()) {
            // project_root is the workspace itself, so its Cargo.dependencies.nix is used in place
            gctx.shell().status(
                "write-nix-buildsystem",
                format!(
                    "Successfully exported build system to '{}', building from '{}'.",
                    nix_base_dir.display(),
                    workspace.root().display()
                ),
            )?;
        } else {
            let target_path: PathBuf = nix_base_dir
                .clone()
                .join("Cargo.dependencies.nix")
                .into_path_unlocked();
            match fs::copy("Cargo.dependencies.nix", target_path) {
                Ok(_) => {
                    let _ = gctx.shell().status("write-nix-buildsystem","Copied Cargo.dependencies.nix to out_dir");
                },
                Err(e) => {
                    gctx.shell().status(
                        "write-nix-buildsystem",
                        format!(
                            "Failed to copy Cargo.dependencies.nix to out_dir: {}",
                            e
                        ),
                    ).ok();
                }
            };
            gctx.shell()
            .status(
                    "write-nix-buildsystem",
                    format!(
                        "Successfully exported build system to '{}'.",
                        nix_base_dir.display()
                    ).trim(),
                )
            .unwrap();
        }
        Ok(Generated { nix_base_dir, unit_drv_names, duration: generated })
    }

    fn process_script_build_run(
        workspace: &Workspace<'gctx>,
        unit: &Unit,
        crate_name: String,
        crate_version: String,
        nix_attribute_name: String,
        process_builder: &ProcessBuilder,
        is_root: bool,
        all_nodes: &mut Vec<DefaultNixEntry>,
        build_runner: &BuildRunner<'a, 'gctx>,
        deps: &Dependencies,
        nix_derivations_dir: &Filesystem,
        src: &String,
    ) -> CargoResult<()> {
        let parent_full_name = match &deps.rust_crate_parent {
            Some(val) => val.nix_attribute_name.clone(),
            None => {
                println!("deps.rust_crate_parent must not be empty as we are in process_script_build_run!");
                std::process::abort(); // FIXME rewrite with proper error
            }
        };

        let unpack_phase: String = generate_unpack_phase(&unit, &crate_name, &crate_version)?;

        let file_name: String = create_nix_name(unit, build_runner, NixNameMode::FileName, false);
        let (rel_file_path, file_path) =
            create_nix_filepath(&nix_derivations_dir, &file_name, is_root)?;

        let environment_variables: String =
            generate_environment_variables(workspace, unit, process_builder, build_runner)?;

        let phases: Vec<&str> = vec!["unpackPhase", "buildPhase"];

        let mut rustc_arguments: Vec<String> = vec![];
        rustc_arguments.push(
            format!(indoc! {
            r#"
                rustc_arguments="";
            "#})
            .to_string()
            .indentation(2),
        );

        // relative to the build system's directory (target/<profile>/nix or --out-dir): an absolute path would be
        // part of the derivation, so the same crate's run (and everything depending on it) would be another
        // derivation in each project and target directory
        let filename_notice_build_script_build = format!(
            "There was an error executing build_script_build in file: '{}':",
            Path::new("derivations").join(&rel_file_path).display()
        );
        let filename_notice_build_parser = format!(
            "There was an error executing build_parser in file: '{}':",
            Path::new("derivations").join(&rel_file_path).display()
        );

        let command_line: String = templates::render(
            templates::BUILD_SCRIPT_RUN_COMMAND_LINE,
            &serde_json::json!({
                "parent_full_name": parent_full_name,
                "nix_attribute_name": nix_attribute_name,
                "filename_notice_build_script_build": filename_notice_build_script_build,
                "filename_notice_build_parser": filename_notice_build_parser,
            }),
        )?;

        let default_function_arguments: Vec<String> =
            vec!["pkgs", "fn", "cargo", "rustc", "deps", "project_root"]
                .iter()
                .map(|m| m.to_string())
                .collect();
        let root_deps: Vec<String> = deps
            .all_deps
            .iter()
            .filter(|dep| dep.is_root)
            .map(|m| m.nix_attribute_name.clone())
            .collect();
        let function_arguments: Vec<String> = [default_function_arguments, root_deps].concat();

        let additional_build_phase_arguments = handle_dynamic_crate_aspects(unit, &deps, false);

        let rendered = templates::render(
            templates::RUSTC_CALL,
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "nix_attribute_name": nix_attribute_name,
                "cargo_crate_info": cargo_crate_info(unit, build_runner)?,
                "nix_phases": phases.join(" "),
                "change_directory": "cd $CARGO_MANIFEST_DIR",
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "rust_crate_libraries": deps.rust_crate_libraries.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_crate_parent": deps.rust_crate_parent.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_script_build_run": deps.rust_script_build_run.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": additional_build_phase_arguments.join("\n"),
                "command_line": command_line,
                // only the workspace's runs: the others' inputs don't change, and every unit after a
                // content-addressed one has its output path only after the build
                "content_addressed": is_root,
            }),
        )?;

        write_nix_file(file_path, &rendered)?;

        all_nodes.push(DefaultNixEntry {
            name: create_nix_name(unit, build_runner, NixNameMode::AttributeName, false), // refactor into nix_attribute_name?
            rel_file_path,
            is_root,
        });

        Ok(())
    }

    fn process_unit(
        workspace: &Workspace<'gctx>,
        unit: &Unit,
        crate_name: String,
        crate_version: String,
        nix_attribute_name: String,
        process_builder: &ProcessBuilder,
        is_root: bool,
        all_nodes: &mut Vec<DefaultNixEntry>,
        build_runner: &BuildRunner<'a, 'gctx>,
        deps: &Dependencies,
        nix_derivations_dir: &Filesystem,
        symlinked_targets: &mut Vec<SymlinkedTargets>,
        requested_profile: &str,
        src: &String,
    ) -> CargoResult<()> {
        // println!("unit.target: {:?}", unit.target);
        // println!(
        //     "<<<<<<<<<<<<<<<<<<<<<< rustc {nix_attribute_name} <<<<<<<<<<<<<<<<<<<<<<",
        // );
        // //println!("{:#?}", process_builder);
        // println!("{:#?}", unit);
        // println!(">>>>>>>>>>>>>>>>>>>>>> /rustc >>>>>>>>>>>>>>>>>>>>>>\n");

        // let mut rust_crate_libraries: Vec<String> = vec![];

        let unpack_phase: String = generate_unpack_phase(&unit, &crate_name, &crate_version)?;

        let environment_variables: String =
            generate_environment_variables(workspace, unit, process_builder, build_runner)?;

        let process_builder = process_builder
            .get_args()
            .map(|arg| {
                let arg_str = arg.to_string_lossy();
                if arg_str.starts_with('-') {
                    format!(" \\\n        {}", arg_str)
                } else {
                    format!(" {}", arg_str)
                }
            })
            .collect::<String>();

        let create_symlink = if crate_build_type(&unit) == CrateBuildType::ScriptBuild {
            let meta = build_runner.files().metadata(&unit);
            let hash: String = meta.unit_id().to_string();

            format!(
                indoc! {r#"
                    ln -s $OUT_DIR/"$CARGO_CRATE_NAME"-{} $OUT_DIR/build_script_build
                "#},
                hash
            )
            .to_string()
            .indentation(3)
        } else {
            "".to_string()
        };

        let command_line: String = templates::render(
            templates::RUSTC_COMMAND_LINE,
            &serde_json::json!({
                "process_builder": assert_escapes(&process_builder),
                "nix_attribute_name": nix_attribute_name,
                "create_symlink": create_symlink,
                "crate_name": crate_name,
            }),
        )?;

        let default_function_arguments: Vec<String> = vec!["fn", "pkgs", "rustc", "cargo", "deps", "project_root"]
            .iter()
            .map(|m| m.to_string())
            .collect();
        let root_deps: Vec<String> = deps
            .all_deps
            .iter()
            .filter(|dep| dep.is_root)
            .map(|m| m.nix_attribute_name.clone())
            .collect();
        let function_arguments: Vec<String> = [default_function_arguments, root_deps].concat();

        // a workspace crate after a build script run: the same files give the same output (deps::FIXED_OUT_DIR)
        let fixed_out_dir = is_root && deps.rust_crate_parent.is_some();
        let mut additional_build_phase_arguments = handle_dynamic_crate_aspects(unit, &deps, fixed_out_dir);
        // tests find the binaries of their package next to themselves (`snapbox::cmd::cargo_bin`,
        // `assert_cmd`'s `cargo_bin`, which look beside `current_exe()`); that is the store path of the test
        if crate_build_type(&unit) == CrateBuildType::TestBuild {
            for (name, file) in bins_in_store(unit, build_runner) {
                additional_build_phase_arguments.push(format!("      ln -s {file} $out/{name}"));
            }
        }

        let mut phases: Vec<&str> = vec!["unpackPhase", "buildPhase"];
        let mut append: Vec<String> = vec![];

        if is_root && crate_build_type(&unit) == CrateBuildType::BinBuild {
            // instead of using fn link_targets() or fn link_or_copy() we built the names on the fly
            let meta = build_runner.files().metadata(&unit);
            let hash: String = meta.unit_id().to_string();
            let crate_name: String = unit.target.crate_name().to_string();
            let binary_name: String = unit.target.name().to_string(); // could also be binary_filename(), see manifest.rs
            let crate_name_with_hash = format!("{}-{}", crate_name, hash);
            phases.push("installPhase");
            append.push(
                format!(
                    indoc! {r#"
                      installPhase = ''
                        mkdir $out/bin
                        ln -s $out/{} $out/bin/{}
                      '';
                "#},
                    crate_name_with_hash, binary_name
                )
                .to_string()
                .indentation(4),
            );
            let attribute_name = create_nix_name(
                unit,
                build_runner,
                NixNameMode::AttributeName,
                false,
            );
            symlinked_targets.push(SymlinkedTargets {
                attribute_name: attribute_name.clone(),
                script: format!(
                    indoc! {
                    r#"
                      rm -f "$1"/{}/{}
                      ln -s ${{{}}}/bin/{} "$1"/{}/
                    "#},
                    requested_profile,
                    binary_name,
                    attribute_name,
                    binary_name,
                    requested_profile,
                )
                .to_string()
            });
        } else if is_root && crate_build_type(&unit) == CrateBuildType::LibBuild {
            // Support for [lib] only crates
            let meta = build_runner.files().metadata(&unit);
            let hash: String = meta.unit_id().to_string();
            let name: String = unit.target.name().to_string();

            let attribute_name = create_nix_name(
                unit,
                build_runner,
                NixNameMode::AttributeName,
                false,
            );

            // List the extensions and their prefixes. Adjust "lib" if needed.
            let exts = [("rlib", "lib"), ("so", "lib"), ("a", "lib"), ("rmeta", "lib"), ("d", "lib")];

            // Build the body of the script.
            let mut script_body = String::new();
            for (ext, prefix) in exts.iter() {
                let src_name = format!("{prefix}{name}-{hash}.{ext}");
                let dst_name = format!("{prefix}{name}.{ext}");
                script_body.push_str(&format!(
                    indoc! {
                    r#"
                        if [[ -f "${{{}}}/{}" ]]; then
                          ln -fs ${{{}}}/{} "$1"/{}/{}
                        fi
                    "#},
                    attribute_name, src_name, attribute_name, src_name, requested_profile, dst_name
                ));
            }

            symlinked_targets.push(SymlinkedTargets {
                attribute_name: attribute_name.clone(),
                script: script_body,
            });
        } else if is_root
            && matches!(crate_build_type(&unit), CrateBuildType::TestBuild | CrateBuildType::ExampleBuild)
        {
            // where cargo expects them: `cargo test` runs the test harnesses from target/<profile>/deps, examples
            // are in target/<profile>/examples
            let attribute_name = create_nix_name(unit, build_runner, NixNameMode::AttributeName, false);
            let target_dir = workspace.target_dir().into_path_unlocked();
            let mut script = String::new();
            for output in build_runner.outputs(unit)?.iter().filter(|o| o.flavor == FileFlavor::Normal) {
                let file = output.path.file_name().map(|f| f.to_string_lossy().into_owned()).unwrap_or_default();
                let dst = output.bin_dst().strip_prefix(&target_dir)?;
                let parent = dst.parent().unwrap_or(Path::new(""));
                script.push_str(&format!(
                    indoc! {r#"
                        mkdir -p "$1/{}"
                        ln -sfn ${{{}}}/{} "$1/{}"
                    "#},
                    parent.display(),
                    attribute_name,
                    file,
                    dst.display(),
                ));
            }
            symlinked_targets.push(SymlinkedTargets { attribute_name, script });
        }

        let rendered = templates::render(
            templates::RUSTC_CALL,
            &serde_json::json!({
                "function_arguments": function_arguments.join(", "),
                "nix_attribute_name": create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
                "cargo_crate_info": cargo_crate_info(unit, build_runner)?,
                "nix_phases": phases.join(" "),
                "crate_name": crate_name,
                "crate_version": crate_version,
                "src": src,
                "unpack_phase": unpack_phase,
                "change_directory": "",
                "rust_crate_libraries": deps.rust_crate_libraries.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_crate_parent": deps.rust_crate_parent.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "rust_script_build_run": deps.rust_script_build_run.iter().map(|m|m.nix_attribute_name.clone()).collect::<Vec<String>>().join(" "),
                "environment_variables": environment_variables,
                "additional_build_phase_arguments": additional_build_phase_arguments.join("\n"),
                "command_line": command_line.indentation(6),
                "append": append.join("\n"),
            }),
        )?;
        let file_name: String = create_nix_name(unit, build_runner, NixNameMode::FileName, false);
        let (rel_file_path, file_path) =
            create_nix_filepath(&nix_derivations_dir, &file_name, is_root)?;
        write_nix_file(file_path, &rendered)?;

        all_nodes.push(DefaultNixEntry {
            name: create_nix_name(unit, build_runner, NixNameMode::AttributeName, false),
            rel_file_path,
            is_root,
        });
        Ok(())
    }
}

/// `to` relative to `from` as a nix path literal without trailing slash (`..`, `../..`, `./sub`), so the
/// exported build system keeps working when the project is moved or checked out elsewhere.
fn relative_nix_path(from: &std::path::Path, to: &std::path::Path) -> CargoResult<String> {
    let (from, to) = (fs::canonicalize(from)?, fs::canonicalize(to)?);
    let rel = pathdiff::diff_paths(&to, &from)
        .ok_or_else(|| anyhow::format_err!("no relative path from {} to {}", from.display(), to.display()))?;
    let rel = rel.to_str().ok_or_else(|| anyhow::format_err!("non-UTF-8 path {}", rel.display()))?;
    if rel.contains(|c: char| c.is_whitespace() || c == '"' || c == '$') {
        anyhow::bail!("the path from {} to {} can't be a nix path literal: `{rel}`", from.display(), to.display());
    }
    Ok(match rel {
        "" => ".".to_string(),
        r if r.starts_with("..") => r.to_string(),
        r => format!("./{r}"),
    })
}
