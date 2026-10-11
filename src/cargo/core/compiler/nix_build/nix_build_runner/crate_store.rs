//! crates.io crates in the Nix store (nixcloud/cargo#24): in nix mode cargo never downloads a `.crate`
//! itself. Each one lives in the store under the path the generated build system's `fetchurl` produces,
//! `crate-<name>-<version>.tar.gz` with the flat sha256 from Cargo.lock, so it is fetched once and shared.
//! Missing ones are fetched by the nix-daemon in one request (substituted from a binary cache if possible).
use super::daemon::{BuildOptions, Daemon};
use super::event::Event;
use super::logone;
use crate::core::resolver::Resolve;
use crate::core::{PackageId, Workspace};
use crate::core::shell::Verbosity;
use crate::util::{CargoResult, GlobalContext};
use anyhow::Context as _;
use cargo_util::paths;
use cargo_util::Sha256;
use std::collections::{BTreeMap, BTreeSet, HashSet};
use std::fs::{self, File};
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

/// nix mode, offline (nixcloud/cargo#22's IFD sandbox): the resolver can't read the crates.io index, so
/// crates.io is served as a directory source unpacked from the store tarballs of the Cargo.lock entries
/// (sources/config.rs). The tarballs have to be in the store already, e.g. as inputs of the derivation.
/// Does nothing if `[source.crates-io]` is replaced (vendored) by configuration.
pub fn prepare_offline_registry(ws: &Workspace<'_>, resolve: &Resolve) -> CargoResult<()> {
    let gctx = ws.gctx();
    if gctx.get::<Option<String>>("source.crates-io.replace-with")?.is_some() {
        return Ok(());
    }
    let mut wanted = BTreeMap::new();
    let mut missing = Vec::new();
    for id in resolve.iter().filter(|id| id.source_id().is_crates_io()) {
        let Some(Some(checksum)) = resolve.checksums().get(&id) else {
            anyhow::bail!("`{id}` has no checksum in Cargo.lock, which nix mode needs (regenerate Cargo.lock)");
        };
        let tarball = CrateTarball::new(id, checksum);
        if !Path::new(&tarball.store_path).exists() {
            missing.push(format!("{} ({})", tarball.store_path, tarball.url));
        }
        wanted.insert(format!("{}-{}", id.name(), id.version()), tarball);
    }
    if !missing.is_empty() {
        anyhow::bail!(
            "nix mode {} reads crates.io crates from the nix store instead of the index, but {} of them \
             are missing (add them as inputs of the derivation, or build without {0} once):\n  {}",
            gctx.offline_flag().unwrap_or("--offline"),
            missing.len(),
            missing.join("\n  ")
        );
    }

    let dir = ws.target_dir().as_path_unlocked().join("nix-crates-io");
    paths::create_dir_all(&dir)?;
    // drop crates the lockfile doesn't have anymore (and leftovers of an interrupted unpack)
    for entry in fs::read_dir(&dir)? {
        let entry = entry?;
        let name = entry.file_name().to_string_lossy().into_owned();
        if !wanted.contains_key(&name) {
            paths::remove_dir_all(entry.path())?;
        }
    }
    for (dir_name, tarball) in &wanted {
        let dst = dir.join(dir_name);
        let cksum_file = dst.join(".cargo-checksum.json");
        let cksum = serde_json::json!({ "files": {}, "package": tarball.checksum }).to_string();
        if fs::read_to_string(&cksum_file).is_ok_and(|s| s == cksum) {
            continue;
        }
        if dst.exists() {
            paths::remove_dir_all(&dst)?;
        }
        let tmp = dir.join(format!(".unpack-{dir_name}"));
        paths::create_dir_all(&tmp)?;
        unpack(&tarball.store_path, dir_name, &tmp)
            .with_context(|| format!("failed to unpack {}", tarball.store_path))?;
        paths::write(tmp.join(dir_name).join(".cargo-checksum.json"), cksum)?;
        fs::rename(tmp.join(dir_name), &dst)?;
        paths::remove_dir_all(&tmp)?;
    }
    gctx.set_nix_crates_io_dir(dir);
    Ok(())
}

/// Unpacks a `.crate`, whose entries all live under `<prefix>/`, into `dst`.
fn unpack(tarball: &str, prefix: &str, dst: &Path) -> CargoResult<()> {
    let mut tar = tar::Archive::new(flate2::read::GzDecoder::new(File::open(tarball)?));
    tar.set_preserve_permissions(false);
    for entry in tar.entries()? {
        let mut entry = entry?;
        let path = entry.path()?.into_owned();
        if !path.starts_with(prefix) {
            anyhow::bail!("{path:?} isn't under {prefix:?}");
        }
        // the registry source's marker file, never part of the sources
        if path.file_name().is_some_and(|f| f == ".cargo-ok") {
            continue;
        }
        entry.unpack_in(dst)?;
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
