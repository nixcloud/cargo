//! git dependencies in the Nix store (nixcloud/cargo#10): cargo already clones a git dependency to resolve the unit
//! graph (`~/.cargo/git/checkouts/<repo>/<rev>/`, submodules included). That checkout, without `.git` and cargo's
//! `.cargo-ok` markers, is exactly what `pkgs.fetchgit { fetchSubmodules = true; }` produces, so it is added to the
//! store under the fetchgit output path (recursive sha256, a fixed-output path) and `nix build` doesn't fetch it
//! again. The repository is downloaded once, by cargo, instead of once more by nix-prefetch-git on every build.
use crate::compiler::nix_build::nix_build_runner::crate_store::nix32;
use crate::util::{CargoResult, GlobalContext};
use anyhow::{anyhow, Context as _};
use cargo_util::Sha256;
use std::collections::HashMap;
use std::fs;
use std::io::Read;
use std::os::unix::fs::PermissionsExt;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::Mutex;

const STORE_DIR: &str = "/nix/store";

/// A git checkout of cargo's, as the fixed-output path `pkgs.fetchgit` produces.
#[derive(Clone, Debug)]
pub struct GitStoreSource {
    /// `serde-49d098d`, the name fetchgit derives from the url and the rev
    pub name: String,
    /// `sha256-…`, the NAR hash of the checkout
    pub hash: String,
    pub store_path: String,
}

/// One per checkout and cargo run: every unit of a git package (lib, build script, its run) shares it.
static SOURCES: Mutex<Option<HashMap<PathBuf, GitStoreSource>>> = Mutex::new(None);

/// The checkout directory (`~/.cargo/git/checkouts/<repo>/<rev>`) `pkg_root` is in, if it is in one.
pub fn checkout_root(gctx: &GlobalContext, pkg_root: &Path) -> Option<PathBuf> {
    let checkouts = gctx.git_checkouts_path();
    let rel = pkg_root.strip_prefix(checkouts.as_path_unlocked()).ok()?;
    let mut parts = rel.components();
    let (repo, rev) = (parts.next()?, parts.next()?);
    Some(checkouts.as_path_unlocked().join(repo).join(rev))
}

/// Makes sure the checkout at `root` is in the store, under the path fetchgit gives `url` at `rev`.
pub fn git_source_in_store(root: &Path, url: &str, rev: &str) -> CargoResult<GitStoreSource> {
    let mut sources = SOURCES.lock().unwrap();
    if let Some(s) = sources.get_or_insert_with(HashMap::new).get(root) {
        return Ok(s.clone());
    }
    let name = fetchgit_name(url, rev);
    let mut nar = Sha256::new();
    write_nar(&mut nar, root).with_context(|| format!("hashing the git checkout {}", root.display()))?;
    let digest = nar.finish();
    let source = GitStoreSource {
        store_path: recursive_fixed_output_path(&name, &hex(&digest)),
        hash: format!("sha256-{}", base64(&digest)),
        name,
    };
    if !Path::new(&source.store_path).exists() {
        add_to_store(root, &source)?;
    }
    sources.get_or_insert_with(HashMap::new).insert(root.to_path_buf(), source.clone());
    Ok(source)
}

/// The name nixpkgs' fetchgit uses by default: the repository's name and the short rev (`itoa-e2766b8`).
fn fetchgit_name(url: &str, rev: &str) -> String {
    let base = url.trim_end_matches('/').rsplit('/').next().unwrap_or("source");
    let base = base.strip_suffix(".git").unwrap_or(base);
    let base: String = base
        .chars()
        .map(|c| if c.is_ascii_alphanumeric() || "+-._?=".contains(c) { c } else { '-' })
        .collect();
    format!("{}-{}", base.trim_start_matches('.'), &rev[..rev.len().min(7)])
}

/// Left out of the NAR at every depth: git's metadata (fetchgit removes it, submodules included) and the marker
/// cargo writes into every checkout and submodule.
fn skipped(name: &std::ffi::OsStr) -> bool {
    name == ".git" || name == ".cargo-ok"
}

/// The NAR serialisation of `path` (Nix's `nix-store --dump`), into `out`.
fn write_nar(out: &mut Sha256, path: &Path) -> std::io::Result<()> {
    nar_str(out, b"nix-archive-1");
    nar_node(out, path)
}

fn nar_node(out: &mut Sha256, path: &Path) -> std::io::Result<()> {
    let meta = fs::symlink_metadata(path)?;
    nar_str(out, b"(");
    nar_str(out, b"type");
    if meta.file_type().is_symlink() {
        nar_str(out, b"symlink");
        nar_str(out, b"target");
        nar_str(out, fs::read_link(path)?.as_os_str().as_encoded_bytes());
    } else if meta.is_dir() {
        nar_str(out, b"directory");
        let mut entries: Vec<_> = fs::read_dir(path)?
            .map(|e| e.map(|e| e.file_name()))
            .collect::<Result<_, _>>()?;
        entries.retain(|n| !skipped(n));
        entries.sort_by(|a, b| a.as_encoded_bytes().cmp(b.as_encoded_bytes()));
        for name in entries {
            nar_str(out, b"entry");
            nar_str(out, b"(");
            nar_str(out, b"name");
            nar_str(out, name.as_encoded_bytes());
            nar_str(out, b"node");
            nar_node(out, &path.join(&name))?;
            nar_str(out, b")");
        }
    } else {
        nar_str(out, b"regular");
        if meta.permissions().mode() & 0o100 != 0 {
            nar_str(out, b"executable");
            nar_str(out, b"");
        }
        nar_str(out, b"contents");
        out.update(&meta.len().to_le_bytes());
        let mut file = fs::File::open(path)?;
        let mut buf = vec![0u8; 64 * 1024];
        let mut len = 0u64;
        loop {
            let n = file.read(&mut buf)?;
            if n == 0 {
                break;
            }
            out.update(&buf[..n]);
            len += n as u64;
        }
        if len != meta.len() {
            return Err(std::io::Error::other(format!("{} changed while hashing", path.display())));
        }
        out.update(&[0u8; 8][..(8 - (len % 8) as usize) % 8]);
    }
    nar_str(out, b")");
    Ok(())
}

/// A NAR string: its length (u64, little endian), the bytes, zero padding to 8 bytes.
fn nar_str(out: &mut Sha256, s: &[u8]) {
    out.update(&(s.len() as u64).to_le_bytes());
    out.update(s);
    out.update(&[0u8; 8][..(8 - s.len() % 8) % 8]);
}

/// Store path of a recursive (NAR) sha256 fixed-output path without references: Nix's makeFixedOutputPath, as
/// `nix-store --print-fixed-path --recursive sha256 <hex> <name>` prints it.
fn recursive_fixed_output_path(name: &str, sha256_hex: &str) -> String {
    let fingerprint = format!("source:sha256:{sha256_hex}:{STORE_DIR}:{name}");
    let hash = Sha256::new().update(fingerprint.as_bytes()).finish();
    let mut compressed = [0u8; 20];
    for (i, b) in hash.iter().enumerate() {
        compressed[i % 20] ^= b;
    }
    format!("{STORE_DIR}/{}-{name}", nix32(&compressed))
}

/// Copies the checkout without the skipped files to a temporary `<name>` directory and adds it with
/// `nix-store --add-fixed --recursive`, which must give the path computed from the hash.
fn add_to_store(root: &Path, source: &GitStoreSource) -> CargoResult<()> {
    let tmp = tempfile::tempdir()?;
    let copy = tmp.path().join(&source.name);
    copy_filtered(root, &copy).with_context(|| format!("copying the git checkout {}", root.display()))?;
    let output = Command::new("nix-store")
        .args(["--add-fixed", "--recursive", "sha256"])
        .arg(&copy)
        .output()
        .context("failed to run `nix-store --add-fixed`")?;
    if !output.status.success() {
        return Err(anyhow!(
            "`nix-store --add-fixed --recursive sha256 {}` failed: {}",
            copy.display(),
            String::from_utf8_lossy(&output.stderr).trim()
        )
        .into());
    }
    let added = String::from_utf8_lossy(&output.stdout).trim().to_string();
    if added != source.store_path {
        return Err(anyhow!(
            "the git checkout {} was added to the store as {added}, but fetchgit expects {} (NAR hash mismatch)",
            root.display(),
            source.store_path
        )
        .into());
    }
    Ok(())
}

fn copy_filtered(from: &Path, to: &Path) -> std::io::Result<()> {
    let meta = fs::symlink_metadata(from)?;
    if meta.file_type().is_symlink() {
        std::os::unix::fs::symlink(fs::read_link(from)?, to)
    } else if meta.is_dir() {
        fs::create_dir(to)?;
        for entry in fs::read_dir(from)? {
            let name = entry?.file_name();
            if !skipped(&name) {
                copy_filtered(&from.join(&name), &to.join(&name))?;
            }
        }
        Ok(())
    } else {
        fs::copy(from, to).map(|_| ())
    }
}

fn hex(bytes: &[u8]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}

fn base64(bytes: &[u8]) -> String {
    const ALPHABET: &[u8; 64] = b"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    let mut out = String::new();
    for chunk in bytes.chunks(3) {
        let n = chunk.iter().enumerate().fold(0u32, |n, (i, b)| n | (*b as u32) << (16 - 8 * i));
        for i in 0..4 {
            if i <= chunk.len() {
                out.push(ALPHABET[(n >> (18 - 6 * i) & 0x3f) as usize] as char);
            } else {
                out.push('=');
            }
        }
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn fetchgit_name_like_nixpkgs() {
        let rev = "e2766b868e4ac1ae2bf5bea1ac43d4c0da23b899";
        assert_eq!(fetchgit_name("https://github.com/dtolnay/itoa", rev), "itoa-e2766b8");
        assert_eq!(fetchgit_name("https://github.com/dtolnay/itoa.git/", rev), "itoa-e2766b8");
    }

    #[test]
    fn recursive_fixed_output_path_matches_nix() {
        // nix-prefetch-git --url https://github.com/dtolnay/itoa --rev e2766b86… printed this path and
        // sha256-7be7w9eSbX6d6nb6zaTNvp8gt8pxYdAQLGaaKfaUUns=, which is this hex
        let hex = "edb7bbc3d7926d7e9dea76facda4cdbe9f20b7ca7161d0102c669a29f694527b";
        assert_eq!(
            recursive_fixed_output_path("itoa-e2766b8", hex),
            "/nix/store/bmmd66w7p264wsabif8n0lb403gaisaf-itoa-e2766b8"
        );
    }

    #[test]
    fn base64_like_sri() {
        assert_eq!(base64(b""), "");
        assert_eq!(base64(b"f"), "Zg==");
        assert_eq!(base64(b"fo"), "Zm8=");
        assert_eq!(base64(b"foo"), "Zm9v");
    }
}
