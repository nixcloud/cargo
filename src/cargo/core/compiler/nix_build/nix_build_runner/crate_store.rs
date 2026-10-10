//! crates.io crates in the Nix store (nixcloud/cargo#24): in nix mode cargo never downloads a `.crate`
//! itself. Each one lives in the store under the path the generated build system's `fetchurl` produces,
//! `crate-<name>-<version>.tar.gz` with the flat sha256 from Cargo.lock, so it is fetched once and shared.
//! Missing ones are fetched by the nix-daemon in one request (substituted from a binary cache if possible).
use super::daemon::{BuildOptions, Daemon};
use super::event::Event;
use super::logone;
use crate::core::resolver::Resolve;
use crate::core::PackageId;
use crate::core::shell::Verbosity;
use crate::util::{CargoResult, GlobalContext};
use cargo_util::Sha256;
use std::collections::{BTreeSet, HashSet};
use std::io::IsTerminal;
use std::path::Path;
use std::sync::mpsc;

const STORE_DIR: &str = "/nix/store";

/// The `.crate` of a crates.io package, as the fixed-output path `fetchurl` would produce.
pub struct CrateTarball {
    /// `crate-serde-1.0.218.tar.gz`
    pub name: String,
    pub url: String,
    /// sha256, hex, from Cargo.lock
    pub checksum: String,
    pub store_path: String,
}

impl CrateTarball {
    pub fn new(pkg: PackageId, checksum: &str) -> CrateTarball {
        let (krate, version) = (pkg.name(), pkg.version());
        let name = format!("crate-{krate}-{version}.tar.gz");
        CrateTarball {
            url: format!("https://crates.io/api/v1/crates/{krate}/{version}/download"),
            checksum: checksum.to_string(),
            store_path: fixed_output_path(&name, checksum),
            name,
        }
    }

    /// The same derivation `import <nix/fetchurl.nix> { url; sha256; name; }` instantiates.
    fn derivation(&self) -> String {
        let (out, hash) = (&self.store_path, &self.checksum);
        let env = [
            ("builder", "builtin:fetchurl"),
            ("executable", ""),
            ("impureEnvVars", "http_proxy https_proxy ftp_proxy all_proxy no_proxy"),
            ("name", self.name.as_str()),
            ("out", out.as_str()),
            ("outputHash", hash.as_str()),
            ("outputHashAlgo", "sha256"),
            ("outputHashMode", "flat"),
            ("preferLocalBuild", "1"),
            ("system", "builtin"),
            ("unpack", ""),
            ("url", self.url.as_str()),
            ("urls", self.url.as_str()),
        ];
        let env: Vec<String> = env.iter().map(|(k, v)| format!("({},{})", aterm(k), aterm(v))).collect();
        format!(
            "Derive([(\"out\",{},\"sha256\",{})],[],[],\"builtin\",\"builtin:fetchurl\",[],[{}])",
            aterm(out),
            aterm(hash),
            env.join(",")
        )
    }
}

/// Store path of a flat, sha256 fixed-output file: Nix's makeFixedOutputPath, as
/// `nix-store --print-fixed-path sha256 <hex> <name>` prints it.
pub fn fixed_output_path(name: &str, sha256_hex: &str) -> String {
    let inner = Sha256::new().update(format!("fixed:out:sha256:{sha256_hex}:").as_bytes()).finish_hex();
    let fingerprint = format!("output:out:sha256:{inner}:{STORE_DIR}:{name}");
    let hash = Sha256::new().update(fingerprint.as_bytes()).finish();
    let mut compressed = [0u8; 20];
    for (i, b) in hash.iter().enumerate() {
        compressed[i % 20] ^= b;
    }
    format!("{STORE_DIR}/{}-{name}", nix32(&compressed))
}

/// Nix's base-32 encoding (no e, o, u, t), most significant digit first.
fn nix32(bytes: &[u8]) -> String {
    const ALPHABET: &[u8; 32] = b"0123456789abcdfghijklmnpqrsvwxyz";
    let len = (bytes.len() * 8 - 1) / 5 + 1;
    (0..len)
        .rev()
        .map(|n| {
            let (i, j) = (n * 5 / 8, n * 5 % 8);
            let lo = bytes[i] >> j;
            let hi = if i + 1 < bytes.len() { (bytes[i + 1] as u16) << (8 - j) } else { 0 };
            ALPHABET[((lo as u16 | hi) & 0x1f) as usize] as char
        })
        .collect()
}

/// An ATerm string literal, as in `.drv` files.
fn aterm(s: &str) -> String {
    let mut out = String::with_capacity(s.len() + 2);
    out.push('"');
    for c in s.chars() {
        match c {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            c => out.push(c),
        }
    }
    out.push('"');
    out
}

/// Makes sure the `.crate` of every crates.io package in `ids` is in the Nix store, so the registry source
/// can read it from there (sources/registry/download.rs). Only crates that are missing need the daemon.
pub fn fetch_crates(gctx: &GlobalContext, ids: &BTreeSet<PackageId>, resolve: &Resolve) -> CargoResult<()> {
    let mut missing = Vec::new();
    for &id in ids.iter().filter(|id| id.source_id().is_crates_io()) {
        let checksum = resolve.checksums().get(&id).cloned().flatten().ok_or_else(|| {
            anyhow::format_err!(
                "`{id}` has no checksum in Cargo.lock, which nix mode needs to fetch it into the nix store \
                 (regenerate Cargo.lock)"
            )
        })?;
        let tarball = CrateTarball::new(id, &checksum);
        if !Path::new(&tarball.store_path).exists() {
            missing.push(tarball);
        }
    }
    if missing.is_empty() {
        return Ok(());
    }
    gctx.shell().status("Fetching", format!("{} crate(s) into the nix store", missing.len()))?;

    let (tx, rx) = mpsc::channel();
    let color = std::io::stderr().is_terminal();
    let verbose = gctx.shell().verbosity() == Verbosity::Verbose;
    let renderer = std::thread::spawn(move || logone::run(rx, color, HashSet::new(), false, verbose));
    let result = (|| -> CargoResult<Vec<String>> {
        let mut d = Daemon::connect(&tx).map_err(|e| {
            anyhow::format_err!("nix mode fetches crates into the nix store and needs the nix-daemon for it: {e}")
        })?;
        let jobs = std::thread::available_parallelism().map_or(1, |n| n.get() as u64);
        d.set_options(&BuildOptions { keep_going: true, max_jobs: jobs }, &tx)?;
        let mut drvs = Vec::with_capacity(missing.len());
        for tarball in &missing {
            let drv = d.add_text_to_store(&format!("{}.drv", tarball.name), &tarball.derivation(), &tx)?;
            // logone shows where a download is written to (`-v`)
            let outputs = vec![("out".to_string(), Some(tarball.store_path.clone()))];
            let _ = tx.send(Event::Outputs { drv: drv.clone(), outputs });
            drvs.push(drv);
        }
        let mut failed = Vec::new();
        for r in d.build_paths_with_results(&drvs, &tx)? {
            if !r.status.is_success() {
                failed.push(format!("{}: {:?}", r.drv, r.status));
            }
            let _ = tx.send(Event::BuildResult { drv: r.drv, status: r.status, error_msg: r.error_msg });
        }
        Ok(failed)
    })();
    drop(tx);
    renderer.join().map_err(|e| anyhow::format_err!("logone thread panicked: {:?}", e))?;

    let failed = result?;
    if !failed.is_empty() {
        anyhow::bail!("failed to fetch crates into the nix store:\n  {}", failed.join("\n  "));
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn fixed_output_path_matches_nix() {
        // nix-store --print-fixed-path sha256 <checksum> crate-serde-1.0.218.tar.gz
        assert_eq!(
            fixed_output_path(
                "crate-serde-1.0.218.tar.gz",
                "e8dfc9d19bdbf6d17e22319da49161d5d0108e4188e8b680aef6299eed22df60"
            ),
            "/nix/store/6xcwgasqdhpc0djyr5m06vgbp8bpnqfq-crate-serde-1.0.218.tar.gz"
        );
    }
}
