//! Builds the generated build system over the nix-daemon protocol (see FINDINGS.md / INTEGRATION.md):
//! `nix-instantiate` evaluates `target`, then ONE BuildPathsWithResults request builds it together with every
//! derivation it needs. The daemon client runs on the calling thread, logone renders its `Event`s on another.
use super::daemon::{self, BuildOptions, Daemon, PathResult};
use super::event::Event;
use super::gc_roots;
use super::logone;
use crate::core::shell::Verbosity;
use crate::util::Filesystem;
use crate::util::{CargoResult, GlobalContext};
use std::collections::{HashMap, HashSet};
use std::io::IsTerminal;
use std::path::Path;
use std::process::Command;
use std::sync::mpsc::{self, Sender};
use std::time::Instant;

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

/// Why `run` failed; logone has already shown the details.
enum Failure {
    Eval,
    Daemon,
    Build,
}


impl NixBuild {
    /// `units`: derivation names of the generated units, so logone prints `Building` only for other derivations.
    /// `target_dir`: where the symlinks to the results go. `selection`: the root units, one per line; each
    /// selection has GC roots of its own (see `gc_roots`). Returns the outputs of the build.
    pub fn build<'gctx>(
        nix_base_dir: Filesystem,
        gctx: &'gctx GlobalContext,
        keep_going: bool,
        jobs: u32,
        units: HashSet<String>,
        target_dir: &Path,
        selection: &str,
    ) -> CargoResult<gc_roots::BuildOutputs> {
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
        let result = run(&caller, &gc_dir, &slot, selection, &opts, &tx);
        // `tx` is gone after this, so logone drains the channel, prints the summary and returns.
        drop(tx);
        renderer
            .join()
            .map_err(|e| anyhow::format_err!("logone thread panicked: {:?}", e))?;

        let out = match result {
            Ok((out, (count, bytes))) => {
                if count > 0 {
                    let freed = format!("{:.1}", crate::util::HumanBytes(bytes));
                    gctx.shell().status("Removed", format!("{count} unused store path(s), {freed}"))?;
                }
                out
            }
            Err(Failure::Eval) => anyhow::bail!("could not evaluate {}", caller.display()),
            Err(Failure::Daemon) => anyhow::bail!("could not build target (nix-daemon)"),
            Err(Failure::Build) => anyhow::bail!("could not compile target"),
        };
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
        Ok(gc_roots::build_outputs(&slot))
    }
}

/// Evaluates and builds `target` and the retained paths; returns the `out` path of `target`, rooted at
/// `slot/create-symlinks`, and the store paths of the previous build this one doesn't use anymore, which are deleted
/// (count, bytes; see `gc_roots`).
fn run(caller: &Path, gc_dir: &Path, slot: &Path, selection: &str, opts: &BuildOptions, tx: &Sender<Event>) -> Result<(String, (usize, u64)), Failure> {
    let (target, roots) = instantiate(caller, gc_dir, slot, selection, tx)?;
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

    // `target` only depends on the crates, and op 46 answers only for requested paths (FINDINGS Q3): request
    // everything that will build, so every crate and non-crate dependency gets its own BuildResult.
    let missing = d.query_missing(&[target.clone(), roots.clone()], tx).map_err(daemon_err)?;
    let mut request = vec![target.clone(), roots.clone()];
    request.extend(missing.will_build.iter().filter(|p| !request.contains(p)).cloned().collect::<Vec<_>>());
    // One round trip per drv, before building, so failed and skipped drvs have their paths too.
    let mut outputs = HashMap::new();
    for drv in &request {
        let map = d.query_derivation_output_map(drv, tx).map_err(daemon_err)?;
        let _ = tx.send(Event::Outputs { drv: drv.clone(), outputs: map.clone() });
        outputs.insert(drv.clone(), map);
    }
    let _ = tx.send(Event::Plan {
        will_build: missing.will_build,
        will_substitute: missing.will_substitute,
        download_size: missing.download_size,
    });

    let results = d.build_paths_with_results(&request, tx).map_err(daemon_err)?;
    let target_ok = results.iter().any(|r| r.drv == target && r.status.is_success());
    let all_ok = results.iter().all(|r| r.status.is_success());
    for PathResult { drv, status, error_msg } in results {
        let _ = tx.send(Event::BuildResult { drv, status, error_msg });
    }
    if !(target_ok && all_ok) {
        return Err(Failure::Build);
    }

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
    gc_roots::set_root(&mut d, slot, gc_roots::RETAINED_PATHS, &roots_out, tx).map_err(daemon_err)?;
    old.extend(gc_roots::evict(gc_dir, slot));
    let new: HashSet<String> = gc_roots::rooted_paths(slot).into_iter().chain([out.clone()]).collect();
    let stale: Vec<String> = old.into_iter().filter(|p| !new.contains(p)).collect();
    // the daemon's GC chatter (`deleting unused links...`) isn't shown
    let (quiet, _rx) = mpsc::channel();
    let removed = gc_roots::delete_unused(&mut d, stale, &quiet).unwrap_or_else(|e| {
        let _ = tx.send(Event::Message { text: format!("warning: could not delete unused store paths: {e}") });
        (0, 0)
    });
    Ok((out, removed))
}

/// `nix-instantiate` prints the drvs of `target` and of the retained paths (`gc_roots::RETAINED_PATHS_ATTR`).
/// `--add-root` makes them GC roots (`slot/.eval`, `slot/.eval-2`, renamed by `run`), so they can't be
/// collected between evaluation and build. With `--add-root` Nix prints the roots instead of the drvs, so they
/// are resolved.
fn instantiate(caller: &Path, gc_dir: &Path, slot: &Path, selection: &str, tx: &Sender<Event>) -> Result<(String, String), Failure> {
    let root = slot.join(gc_roots::EVAL_ROOT);
    let file = caller.display().to_string();
    let eval_err = |msg: String| {
        let _ = tx.send(Event::EvalError { file: file.clone(), msg });
        Failure::Eval
    };
    gc_roots::prepare_dir(gc_dir, slot, selection).map_err(|e| eval_err(format!("{}: {e}", gc_dir.display())))?;
    let mut cmd = Command::new("nix-instantiate");
    cmd.arg(caller).args(["-A", "target", "-A", gc_roots::RETAINED_PATHS_ATTR]).arg("--add-root").arg(&root).env_clear();
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
    let [target, roots] = <[String; 2]>::try_from(drvs)
        .map_err(|d| eval_err(format!("nix-instantiate printed {} derivations, expected 2", d.len())))?;
    let _ = tx.send(Event::Evaluated { elapsed: t0.elapsed() });
    Ok((target, roots))
}
