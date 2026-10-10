//! Builds the generated build system over the nix-daemon protocol (see FINDINGS.md / INTEGRATION.md):
//! `nix-instantiate` evaluates `target`, then ONE BuildPathsWithResults request builds it together with every
//! derivation it needs. The daemon client runs on the calling thread, logone renders its `Event`s on another.
use super::daemon::{self, BuildOptions, Daemon, PathResult};
use super::event::Event;
use super::logone;
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
    pub fn build<'gctx>(
        nix_base_dir: Filesystem,
        gctx: &'gctx GlobalContext,
        keep_going: bool,
        jobs: u32,
        units: HashSet<String>,
    ) -> CargoResult<()> {
        let base = nix_base_dir.into_path_unlocked();
        let caller = base.join("cargo_build_caller.nix");
        gctx.shell().status("Evaluating", caller.display())?;

        let (tx, rx) = mpsc::channel();
        let color = std::io::stderr().is_terminal();
        let renderer = std::thread::spawn(move || logone::run(rx, color, units));
        let opts = BuildOptions { keep_going, max_jobs: u64::from(jobs) };
        let result = run(&caller, &base.join("gc"), &opts, &tx);
        // `tx` is gone after this, so logone drains the channel, prints the summary and returns.
        drop(tx);
        renderer
            .join()
            .map_err(|e| anyhow::format_err!("logone thread panicked: {:?}", e))?;

        let out = match result {
            Ok(out) => out,
            Err(Failure::Eval) => anyhow::bail!("could not evaluate {}", caller.display()),
            Err(Failure::Daemon) => anyhow::bail!("could not build target (nix-daemon)"),
            Err(Failure::Build) => anyhow::bail!("could not compile target"),
        };
        let activation_script = format!("{out}/bin/create-symlinks");
        gctx.shell().verbose(|s| {
            s.status("Symlink", format!("Symlinking results using '{activation_script}'"))
        })?;
        let status = Command::new(&activation_script)
            .status()
            .map_err(|e| anyhow::format_err!("failed to execute {activation_script}: {e}"))?;
        if !status.success() {
            anyhow::bail!("{activation_script} failed: {status}");
        }
        Ok(())
    }
}

/// Evaluates and builds `target`; returns its `out` path, rooted at `gc_dir/result`.
fn run(caller: &Path, gc_dir: &Path, opts: &BuildOptions, tx: &Sender<Event>) -> Result<String, Failure> {
    let target = instantiate(caller, gc_dir, tx)?;
    let daemon_err = |e: daemon::Error| {
        let _ = tx.send(Event::Error { msg: e.to_string() });
        Failure::Daemon
    };
    let mut d = Daemon::connect(tx).map_err(daemon_err)?;
    d.set_options(opts, tx).map_err(daemon_err)?;

    // `target` only depends on the crates, and op 46 answers only for requested paths (FINDINGS Q3): request
    // everything that will build, so every crate and non-crate dependency gets its own BuildResult.
    let missing = d.query_missing(&[target.clone()], tx).map_err(daemon_err)?;
    let mut request = vec![target.clone()];
    request.extend(missing.will_build.iter().filter(|p| **p != target).cloned());
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
    // `target` depends on content-addressed build script runs, so its path is only known after the build
    let mut out = None;
    for PathResult { drv, status, error_msg, outputs } in results {
        if drv == target {
            out = outputs.into_iter().find(|(name, _)| name == "out").map(|(_, path)| path);
        }
        let _ = tx.send(Event::BuildResult { drv, status, error_msg });
    }
    if !(target_ok && all_ok) {
        return Err(Failure::Build);
    }

    let out = out
        .or_else(|| {
            let map = outputs.get(&target)?;
            map.iter().find(|(name, _)| name == "out").and_then(|(_, path)| path.clone())
        })
        .ok_or_else(|| daemon_err(daemon::Error::Daemon(format!("{target} has no `out` path"))))?;
    // like `nix build --out-link gc/result`: keeps the outputs create-symlinks points to alive
    let link = gc_dir.join("result");
    let link_err = |e: std::io::Error| daemon_err(daemon::Error::Io(e));
    match std::fs::remove_file(&link) {
        Err(e) if e.kind() != std::io::ErrorKind::NotFound => return Err(link_err(e)),
        _ => {}
    }
    std::os::unix::fs::symlink(&out, &link).map_err(link_err)?;
    d.add_indirect_root(&link.to_string_lossy(), tx).map_err(daemon_err)?;
    Ok(out)
}

/// `nix-instantiate` prints the drv of `target`. `--add-root` makes it a GC root (`gc_dir/target.drv`) until the
/// next build, so it can't be collected between evaluation and build. With `--add-root` Nix prints the root
/// instead of the drv, so it is resolved.
fn instantiate(caller: &Path, gc_dir: &Path, tx: &Sender<Event>) -> Result<String, Failure> {
    let root = gc_dir.join("target.drv");
    let file = caller.display().to_string();
    let eval_err = |msg: String| {
        let _ = tx.send(Event::EvalError { file: file.clone(), msg });
        Failure::Eval
    };
    let mut cmd = Command::new("nix-instantiate");
    cmd.arg(caller).arg("-A").arg("target").arg("--add-root").arg(&root).env_clear();
    // script_build_run units are `__contentAddressed`; the daemon needs the feature in its nix.conf too
    cmd.arg("--extra-experimental-features").arg("ca-derivations");
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
    let printed = String::from_utf8_lossy(&out.stdout);
    let printed = printed.lines().next().unwrap_or_default();
    let drv = std::fs::canonicalize(printed)
        .map_err(|e| eval_err(format!("nix-instantiate printed `{printed}`: {e}")))?;
    let drv = drv.to_string_lossy().into_owned();
    if !drv.ends_with(".drv") {
        return Err(eval_err(format!("nix-instantiate printed `{printed}`, not a derivation")));
    }
    let _ = tx.send(Event::Evaluated { elapsed: t0.elapsed() });
    Ok(drv)
}
