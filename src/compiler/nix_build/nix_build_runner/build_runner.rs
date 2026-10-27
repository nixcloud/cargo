//! Builds the generated build system over the nix-daemon protocol (see FINDINGS.md / INTEGRATION.md):
//! `nix-instantiate` evaluates `target`, then ONE BuildPathsWithResults request builds it together with every
//! derivation it needs. The daemon client runs on the calling thread, logone renders its `Event`s on another.
use super::daemon::{self, BuildOptions, Daemon, PathResult};
use super::event::{store_name, Event, Status};
use super::gc_roots;
use super::logone;
use cargo_util_terminal::Verbosity;
use crate::util::Filesystem;
use crate::util::{CargoResult, GlobalContext};
use std::collections::{HashMap, HashSet};
use std::io::IsTerminal;
use std::path::Path;
use std::process::Command;
use std::sync::mpsc::{self, Sender};
use std::time::{Duration, Instant};

pub struct NixBuild {}

/// The environment `nix-instantiate` keeps; everything else is cleared.
const ENV_PASSTHROUGH: &[&str] = &[
    "PATH",
    "HOME",
    "XDG_CACHE_HOME",
    "NIX_SSL_CERT_FILE",
    "SSL_CERT_FILE",
    "NIX_REMOTE",
    "http_proxy",
    "https_proxy",
    "all_proxy",
    "no_proxy",
    "HTTP_PROXY",
    "HTTPS_PROXY",
    "ALL_PROXY",
    "NO_PROXY",
];

/// Whether the build script runs of the workspace are content-addressed (`content_addressed` of
/// cargo_build_caller.nix, nixcloud/cargo#20): when nix has the experimental feature `ca-derivations` enabled
/// (`nix config show`, with the environment `nix-instantiate` gets), or as `CARGO_LIBNIX_CA=1`/`0` says, e.g.
/// when the daemon's configuration differs from the client's.
pub fn content_addressed() -> bool {
    static CA: std::sync::OnceLock<bool> = std::sync::OnceLock::new();
    *CA.get_or_init(|| match std::env::var("CARGO_LIBNIX_CA").as_deref() {
        Ok("1") => true,
        Ok("0") => false,
        _ => {
            let mut cmd = Command::new("nix");
            cmd.args(["config", "show", "experimental-features"]).env_clear();
            for var in ENV_PASSTHROUGH {
                if let Some(v) = std::env::var_os(var) {
                    cmd.env(var, v);
                }
            }
            cmd.output()
                .is_ok_and(|o| o.status.success() && String::from_utf8_lossy(&o.stdout).split_whitespace().any(|f| f == "ca-derivations"))
        }
    })
}

/// The `out` paths `query_derivation_output_map` didn't know before the build: a content-addressed derivation,
/// and every one depending on it, has its output path only once it's built.
fn query_unknown_outputs(
    d: &mut Daemon,
    outputs: &mut HashMap<String, Vec<(String, Option<String>)>>,
    tx: &Sender<Event>,
) -> daemon::Result<()> {
    for (drv, map) in outputs.iter_mut() {
        if map.iter().any(|(_, p)| p.is_none()) {
            *map = d.query_derivation_output_map(drv, tx)?;
        }
    }
    Ok(())
}

/// Adds the outputs of `drvs` that are known now to `built` of `slot` (`gc_roots::record_built`): after
/// building, also those of content-addressed derivations and the ones after them, which have no path before.
fn record_outputs(d: &mut Daemon, slot: &Path, drvs: &[String], tx: &Sender<Event>) -> daemon::Result<()> {
    let mut paths = Vec::new();
    for drv in drvs {
        paths.extend(d.query_derivation_output_map(drv, tx)?.into_iter().filter_map(|(_, p)| p));
    }
    if let Err(e) = gc_roots::record_built(slot, paths) {
        let _ = tx.send(Event::Message { text: format!("warning: could not record the built store paths: {e}") });
    }
    Ok(())
}

/// Derivations built before everything else (src_list.rs: the content-addressed build script runs of the
/// workspace). `check` gets their `out` paths (by name) and returns what restarts the build instead (e.g. the
/// units after a run whose output changed); nothing means the build goes on with the same evaluation.
///
/// `after`: derivations (by name) the restart check of the caller would object to building, but which come
/// after a gate derivation: their drv changes with every new run even when its output is the same, and nix
/// tells only while building whether they resolve to an existing output. So they restart the build before it
/// only when `rebuilt` (name, drv) knows they are rebuilt whatever the outputs of the gate are (another input
/// changed), and after it if they were really built (`Status::Built`).
pub struct Gate<'a> {
    pub attrs: Vec<String>,
    pub check: &'a mut dyn FnMut(&HashMap<String, String>) -> Vec<String>,
    pub after: HashSet<String>,
    pub rebuilt: &'a dyn Fn(&str, &str) -> bool,
}

/// The derivations of `gate.after` that were built, not resolved to an existing output.
fn rebuilt_after_gate(results: &[PathResult], gate: &Gate<'_>) -> Vec<String> {
    results
        .iter()
        .filter(|r| r.status == Status::Built && gate.after.contains(store_name(&r.drv)))
        .map(|r| store_name(&r.drv).to_string())
        .collect()
}

/// Builds the gate's derivations `drvs` (what they need, too) and runs its check. `restart` as for `run`: what
/// they need includes units too (a build script's compile).
fn run_gate(
    d: &mut Daemon,
    slot: &Path,
    drvs: &[String],
    gate: &mut Gate<'_>,
    restart: &dyn Fn(&str) -> bool,
    tx: &Sender<Event>,
) -> Result<(), Failure> {
    if drvs.is_empty() {
        return Ok(());
    }
    let daemon_err = |e: daemon::Error| {
        let _ = tx.send(Event::Error { msg: e.to_string() });
        Failure::Daemon
    };
    let missing = d.query_missing(drvs, tx).map_err(daemon_err)?;
    check_restart(&missing.will_build, &|d| restart(store_name(d)), tx)?;
    if !missing.will_build.is_empty() || !missing.will_substitute.is_empty() {
        let mut request = drvs.to_vec();
        request.extend(missing.will_build.iter().filter(|p| !drvs.contains(p)).cloned().collect::<Vec<_>>());
        let will_build = missing.will_build.clone();
        let _ = tx.send(Event::Plan {
            will_build: missing.will_build,
            will_substitute: missing.will_substitute,
            download_size: missing.download_size,
        });
        let results = d.build_paths_with_results(&request, tx).map_err(daemon_err)?;
        // also when it failed: what it built is deleted after the next successful build
        record_outputs(d, slot, &will_build, tx).map_err(daemon_err)?;
        let all_ok = results.iter().all(|r| r.status.is_success());
        let failed = failed_names(&results);
        for PathResult { drv, status, error_msg } in results {
            let _ = tx.send(Event::BuildResult { drv, status, error_msg });
        }
        if !all_ok {
            return Err(Failure::Build(failed));
        }
    }
    let mut outs = HashMap::new();
    for drv in drvs {
        let map = d.query_derivation_output_map(drv, tx).map_err(daemon_err)?;
        if let Some(out) = map.into_iter().find(|(name, _)| name == "out").and_then(|(_, p)| p) {
            outs.insert(store_name(drv).to_string(), out);
        }
    }
    let restart = (gate.check)(&outs);
    if restart.is_empty() {
        return Ok(());
    }
    let _ = tx.send(Event::Restart);
    Err(Failure::Restart(restart))
}

/// Why `run` failed; logone has already shown the details.
enum Failure {
    Eval,
    Daemon,
    /// the derivations (by name) that failed themselves, not because a dependency did
    Build(Vec<String>),
    /// derivations (by name) the restart check of the caller objected to, before anything was built
    Restart(Vec<String>),
    /// the check of the caller on the outputs failed
    Verify(anyhow::Error),
}

/// A derivation `verify` gets, with its `out` path.
pub struct Built {
    pub drv: String,
    pub out: String,
}

/// What a build did: built, or nothing, because the derivations named would have been built, which the caller
/// doesn't expect (src_list.rs: a unit still built with all files that would be rebuilt gets its list instead).
pub enum Outcome<T> {
    Done(T),
    Restart(Vec<String>),
}

impl NixBuild {
    /// `units`: derivation names of the generated units, so logone prints `Building` only for other derivations.
    /// `target_dir`: where the symlinks to the results go. `selection`: the root units, one per line; each
    /// selection has GC roots of its own (see `gc_roots`). `restart`: whether a derivation (by name) that would
    /// be built cancels the build. `verify`: checks the derivations built and those of `want` (by name, with their
    /// drv and `out` path; `want` also when nix had them already) before anything
    /// is rooted, deleted or symlinked; an error leaves the previous build as it was. `gate`: built first, see
    /// `Gate`. `want`: attributes of units whose output the caller needs (src_list.rs: for their file lists).
    /// Returns the outputs of the build.
    pub fn build<'gctx>(
        nix_base_dir: Filesystem,
        gctx: &'gctx GlobalContext,
        keep_going: bool,
        jobs: u32,
        units: HashSet<String>,
        target_dir: &Path,
        selection: &str,
        restart: &dyn Fn(&str) -> bool,
        verify: &mut dyn FnMut(&HashMap<String, Built>) -> CargoResult<()>,
        generated: Duration,
        gate: &mut Gate<'_>,
        want: &[String],
    ) -> CargoResult<Outcome<gc_roots::BuildOutputs>> {
        let base = nix_base_dir.into_path_unlocked();
        let caller = base.join("cargo_build_caller.nix");
        gctx.shell().status("Evaluating", caller.display())?;

        let (tx, rx) = mpsc::channel();
        let color = std::io::stderr().is_terminal();
        let verbose = gctx.shell().verbosity() == Verbosity::Verbose;
        let renderer = std::thread::spawn(move || logone::run(rx, color, units, true, verbose));
        let opts = BuildOptions { keep_going, max_jobs: u64::from(jobs) };
        let gc_dir = base.join("gc");
        let slot = gc_dir.join(crate::util::hex::short_hash(&selection));
        let run_start = Instant::now();
        let mut eval = None;
        let result = run(&caller, &gc_dir, &slot, selection, &opts, restart, verify, gate, want, &tx, &mut eval);
        let ran = run_start.elapsed();
        // `tx` is gone after this, so logone drains the channel, prints the summary and returns.
        drop(tx);
        renderer
            .join()
            .map_err(|e| anyhow::format_err!("logone thread panicked: {:?}", e))?;
        // a failed evaluation took the whole run; otherwise the build is the rest of it (store queries, GC roots,
        // the build itself)
        let (eval, build) = match eval {
            Some(eval) => (eval, Some(ran.saturating_sub(eval))),
            None => (ran, None),
        };
        let stats = || print_stats(gctx, generated, eval, build);

        let out = match result {
            Ok((out, (count, bytes))) => {
                if count > 0 {
                    let freed = format!("{:.1}", crate::util::HumanBytes(bytes));
                    gctx.shell().status("Removed", format!("{count} unused store path(s), {freed}"))?;
                }
                out
            }
            Err(Failure::Restart(names)) => return Ok(Outcome::Restart(names)),
            Err(e) => {
                stats();
                return Err(failure_error(e, &caller));
            }
        };
        let outputs = gc_roots::build_outputs(&slot);
        let activation_script = format!("{out}/bin/create-symlinks");
        gctx.shell().verbose(|s| {
            s.status("Symlink", format!("Symlinking results using '{activation_script}'"))
        })?;
        let status = Command::new(&activation_script)
            .arg(target_dir)
            .status()
            .map_err(|e| anyhow::format_err!("failed to execute {activation_script}: {e}"))?;
        if !status.success() {
            anyhow::bail!("{activation_script} failed: {status}");
        }
        stats();
        Ok(Outcome::Done(outputs))
    }

}

fn failure_error(f: Failure, caller: &Path) -> anyhow::Error {
    match f {
        Failure::Eval => anyhow::format_err!("could not evaluate {}", caller.display()),
        Failure::Daemon => anyhow::format_err!("could not build target (nix-daemon)"),
        Failure::Build(failed) => BuildFailed { failed }.into(),
        Failure::Restart(names) => anyhow::format_err!("unexpected rebuild of {}", names.join(", ")),
        Failure::Verify(e) => e,
    }
}

/// The store paths each of `paths` references (`nix-store -q --references`).
pub fn references(paths: &[String]) -> CargoResult<HashMap<String, Vec<String>>> {
    let (tx, _rx) = mpsc::channel();
    let mut d = Daemon::connect(&tx).map_err(|e| anyhow::format_err!("nix-daemon: {e}"))?;
    let mut refs = HashMap::new();
    for p in paths {
        let r = d.query_references(p, &tx).map_err(|e| anyhow::format_err!("nix-daemon: {e}"))?;
        refs.insert(p.clone(), r.unwrap_or_default());
    }
    Ok(refs)
}

/// The derivations of `will_build` `restart` objects to (by name); logone gets no summary then.
fn check_restart(will_build: &[String], restart: &dyn Fn(&str) -> bool, tx: &Sender<Event>) -> Result<(), Failure> {
    let names: Vec<String> = will_build.iter().filter(|d| restart(d)).map(|d| store_name(d).to_string()).collect();
    if names.is_empty() {
        return Ok(());
    }
    let _ = tx.send(Event::Restart);
    Err(Failure::Restart(names))
}


/// The closing line of every build: how long each step took and cargo as a whole, from its start. "other" is the
/// rest: resolving and planning before the generation, symlinking the results after the build.
fn print_stats(gctx: &GlobalContext, generated: Duration, eval: Duration, build: Option<Duration>) {
    let total = gctx.invocation_instant().elapsed();
    let other = total.saturating_sub(generated + eval + build.unwrap_or_default());
    let s = |d: Duration| format!("{:.1}s", d.as_secs_f64());
    let build = build.map_or("-".to_string(), s);
    let mut shell = gctx.shell();
    if shell.verbosity() == Verbosity::Quiet {
        return;
    }
    let color = shell.err_supports_color();
    // (name, 256-color code, time)
    let steps = [("generation", 81, s(generated)), ("evaluation", 213, s(eval)), ("build", 156, build), ("other", 221, s(other))];
    let line = if color {
        let steps: Vec<String> = steps
            .iter()
            .map(|(name, c, t)| format!("\x1b[38;5;{c}m●\x1b[0m \x1b[2m{name}\x1b[0m \x1b[1;38;5;{c}m{t}\x1b[0m"))
            .collect();
        format!("{} \x1b[2m│\x1b[0m \x1b[1mΣ\x1b[0m \x1b[2mtotal\x1b[0m \x1b[1m{}\x1b[0m", steps.join(" \x1b[2m│\x1b[0m "), s(total))
    } else {
        let steps: Vec<String> = steps.iter().map(|(name, _, t)| format!("● {name} {t}")).collect();
        format!("{} │ Σ total {}", steps.join(" │ "), s(total))
    };
    let _ = shell.status("Status", line);
}

/// Evaluates and builds `target` and the retained paths; returns the `out` path of `target`, rooted at
/// `slot/create-symlinks`, and the store paths of the previous build this one doesn't use anymore, which are deleted
/// (count, bytes; see `gc_roots`).
#[allow(clippy::too_many_arguments)]
fn run(
    caller: &Path,
    gc_dir: &Path,
    slot: &Path,
    selection: &str,
    opts: &BuildOptions,
    restart: &dyn Fn(&str) -> bool,
    verify: &mut dyn FnMut(&HashMap<String, Built>) -> CargoResult<()>,
    gate: &mut Gate<'_>,
    want: &[String],
    tx: &Sender<Event>,
    eval: &mut Option<Duration>,
) -> Result<(String, (usize, u64)), Failure> {
    let extra: Vec<String> = gate.attrs.iter().chain(want).cloned().collect();
    let (target, roots, mut gate_drvs) = instantiate(caller, gc_dir, slot, selection, &extra, tx, eval)?;
    let want_drvs = gate_drvs.split_off(gate.attrs.len());
    let daemon_err = |e: daemon::Error| {
        let _ = tx.send(Event::Error { msg: e.to_string() });
        Failure::Daemon
    };
    let mut d = Daemon::connect(tx).map_err(daemon_err)?;
    d.set_options(opts, tx).map_err(daemon_err)?;
    // the roots of the layout before slots become a slot of their own
    gc_roots::adopt_unslotted(&mut d, gc_dir, tx).map_err(daemon_err)?;
    // nix-instantiate's roots get the names of what they point to; the new ones are registered first, so the
    // drvs are rooted all the time
    for (name, drv, eval_root) in [
        (gc_roots::CREATE_SYMLINKS, &target, gc_roots::EVAL_ROOT.to_string()),
        (gc_roots::RETAINED_PATHS, &roots, format!("{}-2", gc_roots::EVAL_ROOT)),
    ] {
        gc_roots::set_root(&mut d, slot, &format!("{name}.drv"), drv, tx).map_err(daemon_err)?;
        let _ = std::fs::remove_file(slot.join(eval_root));
    }
    // the gate's runs first: when their outputs change what comes after them, nothing else is built
    run_gate(&mut d, slot, &gate_drvs, gate, restart, tx)?;

    // `target` only depends on the crates, and op 46 answers only for requested paths (FINDINGS Q3): request
    // everything that will build, so every crate and non-crate dependency gets its own BuildResult.
    let missing = d.query_missing(&[target.clone(), roots.clone()], tx).map_err(daemon_err)?;
    let after = |d: &str| gate.after.contains(store_name(d)) && (gate.rebuilt)(store_name(d), d);
    check_restart(&missing.will_build, &|d| restart(store_name(d)) || after(d), tx)?;
    let mut request = vec![target.clone(), roots.clone()];
    request.extend(missing.will_build.iter().filter(|p| !request.contains(p)).cloned().collect::<Vec<_>>());
    // One round trip per drv, before building, so failed and skipped drvs have their paths too.
    let mut outputs = HashMap::new();
    for drv in &request {
        let map = d.query_derivation_output_map(drv, tx).map_err(daemon_err)?;
        let _ = tx.send(Event::Outputs { drv: drv.clone(), outputs: map.clone() });
        outputs.insert(drv.clone(), map);
    }
    // what this attempt builds, recorded before it does: what no list keeps afterwards (a failed build's
    // outputs, helpers) is deleted after the next successful build
    let to_build: Vec<String> = missing
        .will_build
        .iter()
        .filter_map(|drv| outputs.get(drv))
        .flat_map(|m| m.iter().filter_map(|(_, p)| p.clone()))
        .collect();
    if let Err(e) = gc_roots::record_built(slot, to_build) {
        let _ = tx.send(Event::Message { text: format!("warning: could not record the built store paths: {e}") });
    }
    // after a content-addressed run, the paths are known only after building
    let deferred: Vec<String> = missing
        .will_build
        .iter()
        .filter(|drv| outputs.get(*drv).is_some_and(|m| m.iter().any(|(_, p)| p.is_none())))
        .cloned()
        .collect();
    let _ = tx.send(Event::Plan {
        will_build: missing.will_build,
        will_substitute: missing.will_substitute,
        download_size: missing.download_size,
    });

    let results = d.build_paths_with_results(&request, tx).map_err(daemon_err)?;
    record_outputs(&mut d, slot, &deferred, tx).map_err(daemon_err)?;
    let target_ok = results.iter().any(|r| r.drv == target && r.status.is_success());
    let all_ok = results.iter().all(|r| r.status.is_success());
    let failed = failed_names(&results);
    let rebuilt = rebuilt_after_gate(&results, gate);
    for PathResult { drv, status, error_msg } in results {
        let _ = tx.send(Event::BuildResult { drv, status, error_msg });
    }
    if !(target_ok && all_ok) {
        return Err(Failure::Build(failed));
    }
    // after a run whose output is the same: built anyway, so its inputs changed in another way too
    if !rebuilt.is_empty() {
        let _ = tx.send(Event::Restart);
        return Err(Failure::Restart(rebuilt));
    }
    query_unknown_outputs(&mut d, &mut outputs, tx).map_err(daemon_err)?;
    for drv in &want_drvs {
        if !outputs.contains_key(drv) {
            let map = d.query_derivation_output_map(drv, tx).map_err(daemon_err)?;
            outputs.insert(drv.clone(), map);
        }
    }
    let built: HashMap<String, Built> = outputs
        .iter()
        .filter_map(|(drv, m)| {
            let out = m.iter().find(|(name, _)| name == "out").and_then(|(_, p)| p.clone())?;
            Some((store_name(drv).to_string(), Built { drv: drv.clone(), out }))
        })
        .collect();
    verify(&built).map_err(Failure::Verify)?;

    let out_of = |drv: &String| {
        outputs
            .get(drv)
            .and_then(|m| m.iter().find(|(name, _)| name == "out"))
            .and_then(|(_, path)| path.clone())
            .ok_or_else(|| daemon_err(daemon::Error::Daemon(format!("{drv} has no `out` path"))))
    };
    let (out, roots_out) = (out_of(&target)?, out_of(&roots)?);
    // like `nix build --out-link`: keeps the outputs create-symlinks points to alive
    gc_roots::set_root(&mut d, slot, gc_roots::CREATE_SYMLINKS, &out, tx).map_err(daemon_err)?;
    // everything this build used stays alive; what only the previous build of this selection used goes, and so
    // do the least recently built selections beyond `MAX_SLOTS` (paths other selections use stay, see
    // `delete_unused`)
    let mut old = gc_roots::rooted_paths(slot);
    old.extend(gc_roots::built_paths(slot));
    gc_roots::set_root(&mut d, slot, gc_roots::RETAINED_PATHS, &roots_out, tx).map_err(daemon_err)?;
    // the drvs of the gate and of `want`: their outputs are among the retained paths now
    for i in 0..gate_drvs.len() + want_drvs.len() {
        let _ = std::fs::remove_file(slot.join(format!("{}-{}", gc_roots::EVAL_ROOT, i + 3)));
    }
    old.extend(gc_roots::evict(gc_dir, slot));
    let new: HashSet<String> = gc_roots::rooted_paths(slot).into_iter().chain([out.clone()]).collect();
    let stale: Vec<String> = old.into_iter().filter(|p| !new.contains(p)).collect();
    // the daemon's GC chatter (`deleting unused links...`) isn't shown
    let (quiet, _rx) = mpsc::channel();
    let removed = gc_roots::delete_unused(&mut d, stale.clone(), &quiet).unwrap_or_else(|e| {
        let _ = tx.send(Event::Message { text: format!("warning: could not delete unused store paths: {e}") });
        (0, 0)
    });
    // what is still in use (e.g. the cargo binary that ran this build) is tried again after the next build;
    // what another selection lists goes with that one's list
    let others = gc_roots::other_slots_paths(gc_dir, slot);
    let retry: Vec<String> = stale.into_iter().filter(|p| !others.contains(p)).collect();
    if let Err(e) = gc_roots::keep_built(slot, &retry) {
        let _ = tx.send(Event::Message { text: format!("warning: could not record the built store paths: {e}") });
    }
    Ok((out, removed))
}

/// The argument of `instantiate`'s expression that holds the path of `cargo_build_caller.nix`.
const CALLER_ARG: &str = "cargo_libnix_caller";

/// `nix-instantiate` prints the drvs of `target` and of the retained paths (`gc_roots::RETAINED_PATHS_ATTR`).
/// `--add-root` makes them GC roots (`slot/.eval`, `slot/.eval-2`, renamed by `run`), so they can't be
/// collected between evaluation and build. With `--add-root` Nix prints the roots instead of the drvs, so they
/// are resolved.
/// `gate`: more attributes, whose drvs are returned third (rooted as `.eval-3`, …, removed after the build).
fn instantiate(
    caller: &Path,
    gc_dir: &Path,
    slot: &Path,
    selection: &str,
    gate: &[String],
    tx: &Sender<Event>,
    eval: &mut Option<Duration>,
) -> Result<(String, String, Vec<String>), Failure> {
    let file = caller.display().to_string();
    gc_roots::prepare_dir(gc_dir, slot, selection).map_err(|e| {
        let _ = tx.send(Event::EvalError { file: file.clone(), msg: format!("{}: {e}", gc_dir.display()) });
        Failure::Eval
    })?;
    let attrs: Vec<&str> =
        ["target", gc_roots::RETAINED_PATHS_ATTR].into_iter().chain(gate.iter().map(String::as_str)).collect();
    let t0 = Instant::now();
    let mut drvs = instantiate_attrs(caller, &attrs, &slot.join(gc_roots::EVAL_ROOT), tx)?;
    *eval = Some(t0.elapsed());
    let gate_drvs = drvs.split_off(2);
    let [target, roots] = <[String; 2]>::try_from(drvs).map_err(|d| {
        let msg = format!("nix-instantiate printed {} derivations, expected 2", d.len());
        let _ = tx.send(Event::EvalError { file, msg });
        Failure::Eval
    })?;
    Ok((target, roots, gate_drvs))
}

/// The drvs of `attrs` of `caller`, in their order, rooted at `root` (and `root-2`, … for more than one).
fn instantiate_attrs(caller: &Path, attrs: &[&str], root: &Path, tx: &Sender<Event>) -> Result<Vec<String>, Failure> {
    let file = caller.display().to_string();
    let eval_err = |msg: String| {
        let _ = tx.send(Event::EvalError { file: file.clone(), msg });
        Failure::Eval
    };
    // one call of the caller for all of them: nix-instantiate calls the caller (a function) once per `-A`, so
    // `-A target -A <retained paths>` evaluated everything twice (and printed its `trace:`s twice). The other
    // arguments (`--arg`) are passed on to the caller
    let selected: Vec<String> = attrs.iter().map(|a| format!(r#"c."{a}""#)).collect();
    let expr = format!(
        r#"{{ {CALLER_ARG}, ... }}@args: let c = import (/. + {CALLER_ARG}) (removeAttrs args [ "{CALLER_ARG}" ]); in [ {} ]"#,
        selected.join(" ")
    );
    let mut cmd = Command::new("nix-instantiate");
    cmd.arg("--expr").arg(expr).arg("--argstr").arg(CALLER_ARG).arg(caller);
    cmd.arg("--add-root").arg(root).env_clear();
    if content_addressed() {
        cmd.args(["--arg", "content_addressed", "true", "--extra-experimental-features", "ca-derivations"]);
    }
    // Evaluation fetches (builtins.fetchTarball) run in this process, not in the daemon, so it needs the CA
    // certificates, proxies and its cache dir; PATH so `nix-instantiate` is found where it is installed.
    for var in ENV_PASSTHROUGH {
        if let Some(v) = std::env::var_os(var) {
            cmd.env(var, v);
        }
    }
    let t0 = Instant::now();
    let out = cmd
        .output()
        .map_err(|e| eval_err(format!("failed to execute nix-instantiate: {e}")))?;
    let stderr = String::from_utf8_lossy(&out.stderr);
    if !out.status.success() {
        return Err(eval_err(stderr.trim_end().to_string()));
    }
    // `trace: …` and warnings from a successful evaluation
    for line in stderr.lines() {
        let _ = tx.send(Event::Message { text: line.to_string() });
    }
    let stdout = String::from_utf8_lossy(&out.stdout);
    let mut drvs = Vec::new();
    for printed in stdout.lines() {
        let drv = std::fs::canonicalize(printed)
            .map_err(|e| eval_err(format!("nix-instantiate printed `{printed}`: {e}")))?;
        let drv = drv.to_string_lossy().into_owned();
        if !drv.ends_with(".drv") {
            return Err(eval_err(format!("nix-instantiate printed `{printed}`, not a derivation")));
        }
        drvs.push(drv);
    }
    if drvs.len() != attrs.len() {
        return Err(eval_err(format!("nix-instantiate printed {} derivations, expected {}", drvs.len(), attrs.len())));
    }
    let _ = tx.send(Event::Evaluated { elapsed: t0.elapsed() });
    Ok(drvs)
}

/// `could not compile target`, with the derivations (by name) that failed themselves.
#[derive(Debug)]
pub struct BuildFailed {
    pub failed: Vec<String>,
}

impl std::fmt::Display for BuildFailed {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "could not compile target")
    }
}

impl std::error::Error for BuildFailed {}

fn failed_names(results: &[PathResult]) -> Vec<String> {
    results
        .iter()
        .filter(|r| !r.status.is_success() && r.status != super::event::Status::DependencyFailed)
        .map(|r| store_name(&r.drv).to_string())
        .collect()
}
