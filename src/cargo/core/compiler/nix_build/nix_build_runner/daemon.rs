//! nix-daemon worker-protocol client (sync), from nix-daemon-client-example.
//! Implements only what cargo needs: handshake, SetOptions (19), AddIndirectRoot (12), QueryMissing (40),
//! QueryDerivationOutputMap (41), BuildPathsWithResults (46), and the stderr loop, which decodes activity
//! messages directly into `Event`s. Wire format checked against Nix 2.34.8 (protocol 1.38).
use super::event::{Activity, ActivityId, Event, Status};
use std::fmt;
use std::io::{self, BufReader, BufWriter, Read, Write};
use std::os::unix::net::UnixStream;
use std::sync::mpsc::Sender;

pub const SOCKET: &str = "/nix/var/nix/daemon-socket/socket";
const WORKER_MAGIC_1: u64 = 0x6e697863;
const WORKER_MAGIC_2: u64 = 0x6478696f;
const PROTO: u64 = (1 << 8) | 38;
const STDERR_NEXT: u64 = 0x6f6c6d67;
const STDERR_READ: u64 = 0x64617461;
const STDERR_WRITE: u64 = 0x64617416;
const STDERR_LAST: u64 = 0x616c7473;
const STDERR_ERROR: u64 = 0x63787470;
const STDERR_START_ACTIVITY: u64 = 0x53545254;
const STDERR_STOP_ACTIVITY: u64 = 0x53544f50;
const STDERR_RESULT: u64 = 0x52534c54;
const OP_ADD_INDIRECT_ROOT: u64 = 12;
const OP_SET_OPTIONS: u64 = 19;
const OP_QUERY_MISSING: u64 = 40;
const OP_QUERY_DERIVATION_OUTPUT_MAP: u64 = 41;
const OP_BUILD_PATHS_WITH_RESULTS: u64 = 46;
const LVL_ERROR: u64 = 0;
const LVL_INFO: u64 = 3;

#[derive(Debug)]
pub enum Error {
    Io(io::Error),
    /// STDERR_ERROR from the daemon, or a protocol violation.
    Daemon(String),
}

impl From<io::Error> for Error {
    fn from(e: io::Error) -> Self {
        Error::Io(e)
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Error::Io(e) => write!(f, "nix-daemon i/o ({SOCKET}): {e}"),
            Error::Daemon(m) => f.write_str(m),
        }
    }
}

impl std::error::Error for Error {}

type Result<T> = std::result::Result<T, Error>;

pub struct BuildOptions {
    pub keep_going: bool,
    pub max_jobs: u64,
}

pub struct Missing {
    pub will_build: Vec<String>,
    pub will_substitute: Vec<String>,
    pub download_size: u64,
}

pub struct PathResult {
    pub drv: String,
    pub status: Status,
    pub error_msg: String,
}

enum Field {
    Int(u64),
    Str(String),
}

pub struct Daemon {
    r: BufReader<UnixStream>,
    w: BufWriter<UnixStream>,
}

impl Daemon {
    pub fn connect(tx: &Sender<Event>) -> Result<Daemon> {
        let stream = UnixStream::connect(SOCKET)?;
        let mut d = Daemon { r: BufReader::new(stream.try_clone()?), w: BufWriter::new(stream) };
        d.put(WORKER_MAGIC_1)?;
        d.put(PROTO)?;
        d.w.flush()?;
        if d.u64()? != WORKER_MAGIC_2 {
            return Err(Error::Daemon("bad nix-daemon magic".into()));
        }
        let theirs = d.u64()?;
        if theirs >> 8 != 1 || (theirs & 0xff) < 38 {
            return Err(Error::Daemon(format!(
                "nix-daemon protocol 1.{} unsupported (need 1.38, Nix >= 2.24)",
                theirs & 0xff
            )));
        }
        d.put(0)?; // our feature set: empty
        d.w.flush()?;
        for _ in 0..d.u64()? {
            d.string()?; // daemon features, unused
        }
        d.put(0)?; // obsolete cpu affinity
        d.put(0)?; // obsolete reserveSpace
        d.w.flush()?;
        let _version = d.string()?;
        let _trusted = d.u64()?; // 1 trusted, 2 not trusted, 0 unknown
        d.stderr_loop(tx)?;
        Ok(d)
    }

    pub fn set_options(&mut self, o: &BuildOptions, tx: &Sender<Event>) -> Result<()> {
        // keepFailed, keepGoing, tryFallback, verbosity, maxBuildJobs, maxSilentTime, useBuildHook(obsolete),
        // buildVerbosity, logType(obsolete), printBuildTrace(obsolete), buildCores, useSubstitutes, #overrides
        self.put(OP_SET_OPTIONS)?;
        for x in [0, o.keep_going as u64, 0, LVL_INFO, o.max_jobs, 0, 1, LVL_ERROR, 0, 0, 0, 1, 0] {
            self.put(x)?;
        }
        self.w.flush()?;
        self.stderr_loop(tx)
    }

    /// Registers the symlink `path` (absolute, outside the store) as a GC root, like `nix build --out-link`.
    pub fn add_indirect_root(&mut self, path: &str, tx: &Sender<Event>) -> Result<()> {
        self.put(OP_ADD_INDIRECT_ROOT)?;
        self.put_str(path)?;
        self.w.flush()?;
        self.stderr_loop(tx)?;
        self.u64()?; // always 1
        Ok(())
    }

    /// What would have to be built/substituted for `drvs` (including dependencies we didn't ask for).
    pub fn query_missing(&mut self, drvs: &[String], tx: &Sender<Event>) -> Result<Missing> {
        self.put(OP_QUERY_MISSING)?;
        self.put_derived_paths(drvs)?;
        self.w.flush()?;
        self.stderr_loop(tx)?;
        let will_build = self.strings()?;
        let will_substitute = self.strings()?;
        let _unknown = self.strings()?;
        let download_size = self.u64()?;
        let _nar_size = self.u64()?;
        Ok(Missing { will_build, will_substitute, download_size })
    }

    /// Output name -> store path of `drv`, known before building. `None`: not known until built (content-addressed).
    pub fn query_derivation_output_map(
        &mut self,
        drv: &str,
        tx: &Sender<Event>,
    ) -> Result<Vec<(String, Option<String>)>> {
        self.put(OP_QUERY_DERIVATION_OUTPUT_MAP)?;
        self.put_str(drv)?;
        self.w.flush()?;
        self.stderr_loop(tx)?;
        let mut outputs = Vec::new();
        for _ in 0..self.u64()? {
            let name = self.string()?;
            let path = self.string()?; // optional<StorePath>: "" = none
            outputs.push((name, Some(path).filter(|p| !p.is_empty())));
        }
        Ok(outputs)
    }

    /// ONE request for all `drvs`; activities stream into `tx` while the daemon builds.
    pub fn build_paths_with_results(&mut self, drvs: &[String], tx: &Sender<Event>) -> Result<Vec<PathResult>> {
        self.put(OP_BUILD_PATHS_WITH_RESULTS)?;
        self.put_derived_paths(drvs)?;
        self.put(0)?; // buildMode normal
        self.w.flush()?;
        self.stderr_loop(tx)?;

        let mut out = Vec::new();
        for _ in 0..self.u64()? {
            let path = self.string()?;
            let status = Status::from_wire(self.u64()?);
            let error_msg = self.string()?;
            // timesBuilt, isNonDeterministic, startTime, stopTime: always 0 from 2.34.8 (FINDINGS), skipped
            for _ in 0..4 {
                self.u64()?;
            }
            for _ in 0..2 {
                // cpuUser, cpuSystem: optional<microseconds>
                if self.u64()? == 1 {
                    self.u64()?;
                }
            }
            for _ in 0..self.u64()? {
                self.string()?; // DrvOutput id
                self.string()?; // Realisation (JSON)
            }
            let drv = path.strip_suffix("!*").unwrap_or(&path).to_string();
            out.push(PathResult { drv, status, error_msg });
        }
        Ok(out)
    }

    /// Reads STDERR_* messages until LAST; ERROR becomes Err.
    fn stderr_loop(&mut self, tx: &Sender<Event>) -> Result<()> {
        loop {
            let ev = match self.u64()? {
                STDERR_LAST => return Ok(()),
                STDERR_ERROR => return Err(Error::Daemon(self.error()?)),
                STDERR_NEXT => Event::Message { text: self.string()?.trim_end_matches('\n').to_string() },
                STDERR_START_ACTIVITY => {
                    let id = self.u64()?;
                    let _level = self.u64()?;
                    let kind = self.u64()?;
                    let text = self.string()?;
                    let fields = self.fields()?;
                    let parent = self.u64()?;
                    Event::Start { id, parent, activity: activity(kind, fields), text }
                }
                STDERR_STOP_ACTIVITY => Event::Stop { id: self.u64()? },
                STDERR_RESULT => {
                    let id = self.u64()?;
                    let kind = self.u64()?;
                    let fields = self.fields()?;
                    match result_event(id, kind, fields) {
                        Some(ev) => ev,
                        None => continue,
                    }
                }
                m @ (STDERR_READ | STDERR_WRITE) => {
                    return Err(Error::Daemon(format!("unexpected nix-daemon data request {m:x}")))
                }
                m => return Err(Error::Daemon(format!("unknown nix-daemon stderr message {m:x}"))),
            };
            // A dropped receiver only means nobody renders anymore; keep the protocol in sync.
            let _ = tx.send(ev);
        }
    }

    /// proto >= 1.26: type, level, name(unused), msg, havePos(0), traces[(havePos, msg)]
    fn error(&mut self) -> Result<String> {
        let _ty = self.string()?;
        let _level = self.u64()?;
        let _name = self.string()?;
        let mut msg = self.string()?;
        let _pos = self.u64()?;
        for _ in 0..self.u64()? {
            let _pos = self.u64()?;
            msg += &format!("\n  … {}", self.string()?);
        }
        Ok(msg)
    }

    // ---- wire primitives: u64 little endian, strings length-prefixed and padded to 8 bytes ----

    fn u64(&mut self) -> io::Result<u64> {
        let mut b = [0u8; 8];
        self.r.read_exact(&mut b)?;
        Ok(u64::from_le_bytes(b))
    }
    fn string(&mut self) -> io::Result<String> {
        let n = self.u64()? as usize;
        let mut b = vec![0u8; n + (8 - n % 8) % 8];
        self.r.read_exact(&mut b)?;
        b.truncate(n);
        Ok(String::from_utf8_lossy(&b).into_owned())
    }
    fn strings(&mut self) -> io::Result<Vec<String>> {
        let n = self.u64()?;
        let mut v = Vec::with_capacity(n as usize);
        for _ in 0..n {
            v.push(self.string()?);
        }
        Ok(v)
    }
    fn fields(&mut self) -> Result<Vec<Field>> {
        let n = self.u64()?;
        let mut v = Vec::with_capacity(n as usize);
        for _ in 0..n {
            v.push(match self.u64()? {
                0 => Field::Int(self.u64()?),
                1 => Field::Str(self.string()?),
                t => return Err(Error::Daemon(format!("unknown field type {t}"))),
            });
        }
        Ok(v)
    }
    fn put(&mut self, x: u64) -> io::Result<()> {
        self.w.write_all(&x.to_le_bytes())
    }
    fn put_str(&mut self, s: &str) -> io::Result<()> {
        self.put(s.len() as u64)?;
        self.w.write_all(s.as_bytes())?;
        self.w.write_all(&[0u8; 8][..(8 - s.len() % 8) % 8])
    }
    /// DerivedPath on the wire uses the legacy `<drv>!*` syntax; the daemon rejects `^*`.
    fn put_derived_paths(&mut self, drvs: &[String]) -> io::Result<()> {
        self.put(drvs.len() as u64)?;
        for d in drvs {
            self.put_str(&format!("{d}!*"))?;
        }
        Ok(())
    }
}

fn str_at(fields: &[Field], i: usize) -> String {
    match fields.get(i) {
        Some(Field::Str(s)) => s.clone(),
        _ => String::new(),
    }
}

fn int_at(fields: &[Field], i: usize) -> u64 {
    match fields.get(i) {
        Some(Field::Int(n)) => *n,
        _ => 0,
    }
}

fn activity(kind: u64, f: Vec<Field>) -> Activity {
    match kind {
        105 => Activity::Build { drv: str_at(&f, 0) },
        108 => Activity::Substitute { path: str_at(&f, 0) },
        101 => Activity::FileTransfer { uri: str_at(&f, 0) },
        103 => Activity::CopyPaths,
        104 => Activity::Builds,
        kind => Activity::Other { kind },
    }
}

fn result_event(id: ActivityId, kind: u64, f: Vec<Field>) -> Option<Event> {
    Some(match kind {
        101 | 107 => Event::Log { id, line: str_at(&f, 0) },
        104 => Event::Phase { id, phase: str_at(&f, 0) },
        105 => Event::Progress {
            id,
            done: int_at(&f, 0),
            expected: int_at(&f, 1),
            running: int_at(&f, 2),
            failed: int_at(&f, 3),
        },
        // FileLinked, UntrustedPath, CorruptedPath, SetExpected, FetchStatus: not rendered yet
        _ => return None,
    })
}
