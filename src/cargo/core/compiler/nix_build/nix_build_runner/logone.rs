//! logone rewrite (from nix-daemon-client-example): a thread that consumes typed `Event`s and renders them
//! cargo-style on stderr.
//!
//! Differences to logone 0.2.9:
//! - Input is `Event` (no `@nix` text parsing, no regex on Nix messages, no global statics).
//! - Every build that isn't one of cargo's own units is shown (`Building openssl-3.4.1`); units announce
//!   themselves with `@cargo` type 0 (`Compiling`).
//! - Success/failure comes from the daemon's BuildResult, not from guessing on stop/msg text.
//! - Status line: `[ 51 Done | 613 Expected | 8 Running | 0 Failed ] fiat-crypto, jiff (×2), libc (build.rs build)`
//!
//! Not yet: verbose/errors levels, `@cargo` type 1, timing per build.
use super::event::{store_name, Activity, ActivityId, Event, Status};
use super::status_line::StatusLine;
use serde::Deserialize;
use std::collections::{HashMap, HashSet};
use std::sync::mpsc::{Receiver, RecvTimeoutError};
use std::time::{Duration, Instant};

struct Act {
    parent: ActivityId,
    activity: Activity,
    log: Vec<String>,
    phase: Option<String>,
    /// Set once the builder sent `@cargo` type 0.
    crate_label: Option<String>,
    /// Set once `@cargo` type 2/3 printed rustc diagnostics or build.rs output; a failure then needs no log.
    diagnostics: bool,
}

/// The builder's own structured messages, from the generated cargo toolchain (logone README).
#[derive(Deserialize)]
struct CargoMsg {
    #[serde(rename = "type")]
    kind: u64,
    #[serde(default)]
    crate_name: String,
    #[serde(default)]
    crate_type: String,
    #[serde(default)]
    rustc_messages: Vec<Rendered>,
    #[serde(default)]
    messages: Vec<String>,
}

#[derive(Deserialize)]
struct Rendered {
    /// missing on `$message_type: artifact` entries
    #[serde(default)]
    rendered: Option<String>,
}

/// Nix's own counters: resProgress on the daemon worker's actBuilds activity (Worker::updateProgress).
/// Its done/running are not used: done overcounts on 2.34 (see `refresh_status`).
#[derive(Default)]
struct Progress {
    expected: u64,
    failed: u64,
}

pub struct LogOne {
    color: bool,
    /// Derivation names of cargo's own units (see `run`).
    units: HashSet<String>,
    t0: Instant,
    acts: HashMap<ActivityId, Act>,
    build_by_drv: HashMap<String, ActivityId>,
    /// Build activities that started and haven't stopped, in start order.
    running: Vec<ActivityId>,
    /// Build activities that stopped (built or failed)
    stopped: u64,
    progress: Progress,
    /// QueryMissing willBuild count
    planned: u64,
    bar: StatusLine,
    /// STDERR_NEXT messages starting with `error:`; shown at the end only if no BuildResult explains them.
    held_errors: Vec<String>,
    counts: HashMap<&'static str, usize>,
    failed: usize,
    /// DependencyFailed units, shown in one line before the summary
    skipped: Vec<String>,
    interrupted: bool,
}

/// Renders until every `Sender` is dropped, then prints the summary.
/// `units`: derivation names cargo generated itself (crates, build scripts, the create-symlinks aggregate);
/// they get no `Building` line.
pub fn run(rx: Receiver<Event>, color: bool, units: HashSet<String>) {
    let mut l = LogOne {
        color,
        units,
        t0: Instant::now(),
        acts: HashMap::new(),
        build_by_drv: HashMap::new(),
        running: Vec::new(),
        stopped: 0,
        progress: Progress::default(),
        planned: 0,
        bar: StatusLine::new(color),
        held_errors: Vec::new(),
        counts: HashMap::new(),
        failed: 0,
        skipped: Vec::new(),
        interrupted: false,
    };
    // The timeout picks up status changes that the redraw throttle skipped while no further events came in.
    loop {
        match rx.recv_timeout(Duration::from_millis(100)) {
            Ok(ev) => l.handle(ev),
            Err(RecvTimeoutError::Timeout) => {}
            Err(RecvTimeoutError::Disconnected) => break,
        }
        l.refresh_status();
    }
    l.bar.clear();
    l.finish();
}

impl LogOne {
    fn handle(&mut self, ev: Event) {
        match ev {
            Event::EvalError { file, msg } => {
                self.label("error", &format!("failed to evaluate {file}"), true);
                self.out(&self.ansi(&msg));
                self.failed += 1;
            }
            Event::Evaluated { elapsed } => {
                self.label("Evaluated", &format!("target in {:.1}s", elapsed.as_secs_f64()), false);
            }
            Event::Error { msg } => {
                self.label("error", &self.ansi(&msg), true);
                self.failed += 1;
            }
            Event::Plan { will_build, will_substitute, download_size } => {
                self.planned = will_build.len() as u64;
                if !will_build.is_empty() || !will_substitute.is_empty() {
                    let msg = format!(
                        "{} derivation(s) to build, {} path(s) to fetch ({:.1} MiB)",
                        will_build.len(),
                        will_substitute.len(),
                        download_size as f64 / (1 << 20) as f64
                    );
                    self.label("Planning", &msg, false);
                }
            }
            Event::Start { id, parent, activity, text: _ } => {
                match &activity {
                    Activity::Build { drv } => {
                        let name = store_name(drv);
                        if let Some(krate) = crate_tarball(name) {
                            self.label("Downloading", &krate, false);
                        } else if !self.units.contains(name) {
                            self.label("Building", name, false);
                        }
                        self.build_by_drv.insert(drv.clone(), id);
                        self.running.push(id);
                    }
                    Activity::Substitute { path } => {
                        let name = crate_tarball(store_name(path)).unwrap_or_else(|| store_name(path).to_string());
                        self.label("Downloading", &name, false);
                        // substituted dependencies aren't requested, so no BuildResult counts them
                        *self.counts.entry("fetched").or_default() += 1;
                    }
                    _ => {}
                }
                self.acts.insert(id, Act { parent, activity, log: Vec::new(), phase: None, crate_label: None, diagnostics: false });
            }
            Event::Stop { id } => {
                // The stop carries no status (FINDINGS Q4); the outcome arrives as BuildResult.
                if let Some(i) = self.running.iter().position(|r| *r == id) {
                    self.running.remove(i);
                    self.stopped += 1;
                }
            }
            Event::Log { id, line } => {
                let Some(build) = self.build_ancestor(id) else { return };
                match line.strip_prefix("@cargo ").map(serde_json::from_str::<CargoMsg>) {
                    Some(Ok(m)) => self.cargo(build, m),
                    _ => self.acts.get_mut(&build).unwrap().log.push(line),
                }
            }
            Event::Phase { id, phase } => {
                if let Some(b) = self.build_ancestor(id) {
                    self.acts.get_mut(&b).unwrap().phase = Some(phase);
                }
            }
            Event::Progress { id, expected, failed, .. } => {
                // actCopyPaths (substitutions) reports progress too; the status line counts builds only.
                if matches!(self.acts.get(&id).map(|a| &a.activity), Some(Activity::Builds)) {
                    self.progress = Progress { expected, failed };
                }
            }
            Event::Message { text } => {
                if strip_ansi(&text).starts_with("error:") {
                    self.held_errors.push(text);
                } else {
                    self.out(&self.ansi(&text));
                }
            }
            Event::BuildResult { drv, status, error_msg } => self.result(&drv, status, &error_msg),
            Event::Outputs { .. } => {} // not rendered yet
            Event::Interrupted => self.interrupted = true,
        }
    }

    fn cargo(&mut self, build: ActivityId, m: CargoMsg) {
        let label = if m.crate_type.is_empty() { m.crate_name } else { format!("{} {}", m.crate_name, m.crate_type) };
        match m.kind {
            0 => {
                self.label("Compiling", &label, false);
                self.acts.get_mut(&build).unwrap().crate_label = Some(label);
            }
            2 | 3 => {
                // rustc diagnostics (type 2) / build.rs output (type 3): shown right away, like cargo
                let rendered = m.rustc_messages.iter().filter_map(|r| r.rendered.as_ref());
                for r in rendered.chain(&m.messages) {
                    self.out(self.ansi(r).trim_end_matches('\n'));
                    self.acts.get_mut(&build).unwrap().diagnostics = true;
                }
            }
            _ => {}
        }
    }

    fn result(&mut self, drv: &str, status: Status, error_msg: &str) {
        // A drv downstream of a content-addressed one (script_build_run) is built as its *resolved* drv, which
        // we didn't request. When that build fails, the requested drv only gets DependencyFailed with
        // `build of resolved derivation '<resolved>' failed`: attribute it to the resolved drv's build activity
        // by its exact path, as a failure of this unit rather than a skip.
        if status == Status::DependencyFailed {
            let resolved = self.build_by_drv.keys().find(|d| d.as_str() != drv && error_msg.contains(d.as_str()));
            if let Some(resolved) = resolved.cloned() {
                *self.counts.entry("failed").or_default() += 1;
                self.failed += 1;
                return self.failure(&resolved, "", error_msg);
            }
        }
        let key = match status {
            Status::Built => "built",
            Status::Substituted => "fetched",
            Status::AlreadyValid | Status::ResolvesToAlreadyValid => "fresh",
            Status::DependencyFailed => "skipped",
            _ => "failed",
        };
        *self.counts.entry(key).or_default() += 1;
        if status.is_success() {
            return;
        }
        self.failed += 1;
        if status == Status::DependencyFailed {
            let name = store_name(drv);
            match unit_name(name) {
                Some(unit) if self.units.contains(name) => self.skipped.push(unit.to_string()),
                // cargo's helpers (create-symlinks, rustc-linker-arguments-dir) carry no unit hash
                None if self.units.contains(name) => {}
                _ => self.skipped.push(name.to_string()),
            }
            return;
        }
        self.failure(drv, &format!(": {status:?}"), error_msg);
    }

    /// `error failed to build `name` in phase `build`<suffix>` + the build's log (or Nix's message without one)
    fn failure(&mut self, drv: &str, suffix: &str, error_msg: &str) {
        let act = self.build_by_drv.get(drv).and_then(|id| self.acts.get(id));
        let what = act.and_then(|a| a.crate_label.clone()).unwrap_or_else(|| store_name(drv).to_string());
        let phase = act.and_then(|a| a.phase.as_deref()).map(|p| format!(" in phase `{p}`")).unwrap_or_default();
        // no activity or no output: Nix's own message is all we have
        let body = match act {
            // the diagnostics are on screen already; the log only repeats them
            Some(a) if a.diagnostics => None,
            Some(a) if !a.log.is_empty() => {
                Some(a.log.iter().map(|l| format!("  {}", self.ansi(l))).collect::<Vec<_>>().join("\n"))
            }
            _ => Some(self.ansi(error_msg)),
        };
        self.label("error", &format!("failed to build `{what}`{phase}{suffix}"), true);
        if let Some(body) = body {
            self.out(&body);
        }
    }

    /// Ctrl-C dropped the connection, so no BuildResults came. The only failure signal left is Nix's
    /// `error: Cannot build '<drv>'` text: attribute it to our build activity by its exact drv path
    /// (no regex on the wording) and render it like a BuildResult failure.
    fn finish_interrupted(&mut self) {
        for m in std::mem::take(&mut self.held_errors) {
            let drv = self.build_by_drv.keys().find(|d| m.contains(d.as_str())).cloned();
            match drv {
                Some(drv) => self.failure(&drv, " (before the interrupt)", &m),
                None => self.out(&self.ansi(&m)),
            }
        }
        let running: Vec<String> = self
            .running
            .iter()
            .filter_map(|id| self.acts.get(id))
            .filter_map(|a| match (&a.crate_label, &a.activity) {
                (Some(l), _) => Some(l.clone()),
                (None, Activity::Build { drv }) => Some(store_name(drv).to_string()),
                _ => None,
            })
            .collect();
        if !running.is_empty() {
            self.label("Cancelled", &running.join(", "), true);
        }
        self.label("Interrupted", &format!("after {:.1}s", self.t0.elapsed().as_secs_f64()), true);
    }

    fn finish(&mut self) {
        if self.interrupted {
            return self.finish_interrupted();
        }
        if self.failed == 0 {
            for m in std::mem::take(&mut self.held_errors) {
                self.out(&self.ansi(&m));
            }
        }
        if !self.skipped.is_empty() {
            let msg = format!("{} (a dependency failed)", self.skipped.join(", "));
            self.label("Skipped", &msg, true);
        }
        let c = |k| self.counts.get(k).copied().unwrap_or(0);
        let detail = format!(
            "{} built, {} fetched, {} fresh, {} failed, {} skipped in {:.1}s",
            c("built"),
            c("fetched"),
            c("fresh"),
            c("failed"),
            c("skipped"),
            self.t0.elapsed().as_secs_f64()
        );
        self.label(if self.failed == 0 { "Finished" } else { "Failed" }, &detail, self.failed != 0);
    }

    /// `[ 51 Done | 613 Expected | 8 Running | 0 Failed ] fiat-crypto, jiff (×2), libc (build.rs build)`
    fn refresh_status(&mut self) {
        if self.running.is_empty() && self.planned == 0 && self.progress.expected == 0 {
            self.bar.clear();
            return;
        }
        // running builds by name, first-start order; a crate shows its `@cargo` label once it has one
        let mut names: Vec<(&str, usize)> = Vec::new();
        for a in self.running.iter().filter_map(|id| self.acts.get(id)) {
            let name = match (&a.crate_label, &a.activity) {
                (Some(l), _) => l.as_str(),
                (None, Activity::Build { drv }) => unit_name(store_name(drv)).unwrap_or(store_name(drv)),
                _ => continue,
            };
            match names.iter_mut().find(|(n, _)| *n == name) {
                Some((_, k)) => *k += 1,
                None => names.push((name, 1)),
            }
        }
        let names = names.into_iter().map(|(n, k)| match crate_tarball(n) {
            Some(t) => (t, k),
            None => (n.to_string(), k),
        });
        let names: Vec<String> =
            names.into_iter().map(|(n, k)| if k > 1 { format!("{n} (×{k})") } else { n.to_string() }).collect();
        let p = &self.progress;
        let failed = if p.failed > 0 { format!("\x1b[1;31m{} Failed\x1b[0m", p.failed) } else { "0 Failed".into() };
        // Nix's expected grows while the worker discovers goals and is off by one once builds finish
        // (2.34: [5 done, 6 expected] for 5 builds, `nix build` shows the same); QueryMissing is the real total.
        let expected = if self.planned > 0 { self.planned } else { p.expected };
        // Nix's done overcounts on 2.34 (63 done for 51 builds), so done/running come from the build activities:
        // exactly one start and one stop per build (R7). Nix's done excludes failures, ours does too.
        let done = self.stopped.saturating_sub(p.failed);
        let mut line = format!("[ {done} Done | {expected} Expected | {} Running | {failed} ]", self.running.len());
        if !names.is_empty() {
            line = format!("{line} {}", names.join(", "));
        }
        self.bar.set(line);
        self.bar.refresh();
    }

    /// Nearest ancestor (or self) that is a build activity (R6).
    fn build_ancestor(&self, mut id: ActivityId) -> Option<ActivityId> {
        while let Some(a) = self.acts.get(&id) {
            if matches!(a.activity, Activity::Build { .. }) {
                return Some(id);
            }
            id = a.parent;
        }
        None
    }

    /// All output goes through here, so the status line is cleared before and redrawn after.
    fn out(&mut self, s: &str) {
        self.bar.println(s);
    }

    /// cargo-style right-aligned label
    fn label(&mut self, label: &str, msg: &str, error: bool) {
        let line = if self.color {
            let c = if error { "31" } else { "32" };
            format!("\x1b[1;{c}m{label:>12}\x1b[0m {msg}")
        } else {
            format!("{label:>12} {msg}")
        };
        self.out(&line);
    }

    /// Raw lines keep their ANSI (R13); strip only when not printing to a terminal.
    fn ansi(&self, s: &str) -> String {
        if self.color { s.to_string() } else { strip_ansi(s) }
    }
}

fn strip_ansi(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    let mut it = s.chars();
    while let Some(c) = it.next() {
        if c == '\x1b' {
            if it.next() == Some('[') {
                // CSI: parameters until a final byte in @..~
                for c in it.by_ref() {
                    if ('@'..='~').contains(&c) {
                        break;
                    }
                }
            }
        } else {
            out.push(c);
        }
    }
    out
}

/// `good-0_1_0-178d2104a13cdae4` -> `good-0_1_0`: a generated unit's drv name without its 16-hex unit hash
fn unit_name(name: &str) -> Option<&str> {
    let (unit, hash) = name.rsplit_once('-')?;
    (hash.len() == 16 && hash.bytes().all(|b| b.is_ascii_hexdigit())).then_some(unit)
}

/// `crate-serde-1.0.229.tar.gz` (the crates.io fetchurl in nix_code.rs) -> `serde 1.0.229`
fn crate_tarball(name: &str) -> Option<String> {
    let (krate, version) = name.strip_prefix("crate-")?.strip_suffix(".tar.gz")?.rsplit_once('-')?;
    Some(format!("{krate} {version}"))
}
