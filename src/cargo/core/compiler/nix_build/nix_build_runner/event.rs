//! The contract between a log *source* (today: the daemon client) and logone (the renderer).
//! Everything is decoded once from the wire into these types; nothing is re-serialised to text.

pub type ActivityId = u64;

#[allow(dead_code)] // not every field is rendered by the MVP logone yet
#[derive(Debug, Clone)]
pub enum Event {
    /// Evaluation failed (R2): reported before any build starts.
    EvalError { file: String, msg: String },
    /// Evaluation succeeded after `elapsed` (nix-instantiate's wall time).
    Evaluated { elapsed: std::time::Duration },
    /// A failure outside any build: the nix-daemon connection, the protocol, the GC root.
    Error { msg: String },
    /// QueryMissing (op 40) answer, before the build starts.
    Plan { will_build: Vec<String>, will_substitute: Vec<String>, download_size: u64 },
    Start { id: ActivityId, parent: ActivityId, activity: Activity, text: String },
    Stop { id: ActivityId },
    /// resBuildLogLine (101) and resPostBuildLogLine (107). ANSI kept (R13).
    Log { id: ActivityId, line: String },
    /// resSetPhase (104)
    Phase { id: ActivityId, phase: String },
    /// resProgress (105) on actBuilds/actCopyPaths
    Progress { id: ActivityId, done: u64, expected: u64, running: u64, failed: u64 },
    /// STDERR_NEXT: a message without an activity (R12).
    Message { text: String },
    /// One per requested DerivedPath, from BuildPathsWithResults (op 46).
    BuildResult { drv: String, status: Status, error_msg: String },
    /// QueryDerivationOutputMap (op 41), before the build: output name -> store path (`None`: content-addressed,
    /// known only after building).
    Outputs { drv: String, outputs: Vec<(String, Option<String>)> },
    /// Ctrl-C: the connection is dropped, no BuildResults will follow.
    /// TODO: not sent yet; cargo has no Ctrl-C handler, so the process just dies (and the daemon cancels).
    #[allow(dead_code)]
    Interrupted,
}

/// Activity types (Nix logging.hh) with their positional fields decoded.
#[allow(dead_code)]
#[derive(Debug, Clone)]
pub enum Activity {
    /// actBuild 105: fields [drvPath, machine, curRound, nrRounds]
    Build { drv: String },
    /// actSubstitute 108: fields [storePath, substituter]
    Substitute { path: String },
    /// actFileTransfer 101: fields [uri]
    FileTransfer { uri: String },
    /// actBuilds 104: the worker's build counters arrive as Progress results on it
    Builds,
    /// actCopyPaths 103: the same for substitutions
    CopyPaths,
    Other { kind: u64 },
}

/// BuildResult status as sent on the wire (Nix 2.34 build-result.hh, values 0–14).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Status {
    Built,
    Substituted,
    AlreadyValid,
    PermanentFailure,
    InputRejected,
    OutputRejected,
    TransientFailure,
    CachedFailure,
    TimedOut,
    MiscFailure,
    DependencyFailed,
    LogLimitExceeded,
    NotDeterministic,
    ResolvesToAlreadyValid,
    NoSubstituters,
    Unknown(u64),
}

impl Status {
    pub fn from_wire(n: u64) -> Status {
        use Status::*;
        const ALL: [Status; 15] = [
            Built, Substituted, AlreadyValid, PermanentFailure, InputRejected, OutputRejected, TransientFailure,
            CachedFailure, TimedOut, MiscFailure, DependencyFailed, LogLimitExceeded, NotDeterministic,
            ResolvesToAlreadyValid, NoSubstituters,
        ];
        ALL.get(n as usize).copied().unwrap_or(Unknown(n))
    }

    pub fn is_success(self) -> bool {
        matches!(self, Status::Built | Status::Substituted | Status::AlreadyValid | Status::ResolvesToAlreadyValid)
    }
}

/// `/nix/store/<hash>-openssl-3.4.1.drv` -> `openssl-3.4.1`
pub fn store_name(path: &str) -> &str {
    let base = path.rsplit('/').next().unwrap_or(path);
    let base = base.strip_suffix(".drv").unwrap_or(base);
    base.split_once('-').map_or(base, |(_, name)| name)
}
