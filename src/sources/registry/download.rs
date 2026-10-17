//! Shared download logic between [`HttpRegistry`] and [`GitRegistry`].
//!
//! [`HttpRegistry`]: super::http_remote::HttpRegistry
//! [`GitRegistry`]: super::git_remote::GitRegistry

use crate::util::interning::InternedString;
use anyhow::Context as _;
use cargo_credential::Operation;
use cargo_util::Sha256;
use cargo_util::registry::crate_url;

use crate::sources::registry::MaybeLock;
use crate::sources::registry::RegistryConfig;
use crate::util::auth;
use crate::util::cache_lock::CacheLockMode;
use crate::util::errors::CargoResult;
use crate::compiler::nix_build::nix_build_runner::crate_store::{self, CrateTarball};
use crate::util::{BuildBackend, Filesystem, GlobalContext};
use crate::workspace::PackageId;
use crate::workspace::global_cache_tracker;
use std::fs::{self, File, OpenOptions};
use std::io::SeekFrom;
use std::io::prelude::*;
use std::str;

/// Checks if `pkg` is downloaded and ready under the directory at `cache_path`.
/// If not, returns a URL to download it from.
///
/// This is primarily called by [`RegistryData::download`](super::RegistryData::download).
pub(super) fn download(
    cache_path: &Filesystem,
    gctx: &GlobalContext,
    encoded_registry_name: InternedString,
    pkg: PackageId,
    checksum: &str,
    registry_config: RegistryConfig,
) -> CargoResult<MaybeLock> {
    if gctx.backend()? == BuildBackend::Nix && pkg.source_id().is_crates_io() {
        // nix mode never downloads a `.crate` itself: PackageSet::download_accessible fetched it into the
        // nix store, at the path the generated build system's fetchurl uses. A package downloaded on its own
        // (the one `cargo install` installs) is fetched there now
        let tarball = CrateTarball::new(pkg, checksum);
        if !std::path::Path::new(&tarball.store_path).exists() && gctx.network_allowed() {
            crate_store::fetch_tarballs(gctx, vec![CrateTarball::new(pkg, checksum)])?;
        }
        return File::open(&tarball.store_path).map(MaybeLock::Ready).with_context(|| {
            format!("`{pkg}` is not in the nix store at {} (nix mode doesn't download crates)", tarball.store_path)
        });
    }
    let path = cache_path.join(&pkg.tarball_name());
    let path = gctx.assert_package_cache_locked(CacheLockMode::DownloadExclusive, &path);

    // Attempt to open a read-only copy first to avoid an exclusive write
    // lock and also work with read-only filesystems. Note that we check the
    // length of the file like below to handle interrupted downloads.
    //
    // If this fails then we fall through to the exclusive path where we may
    // have to redownload the file.
    if let Ok(dst) = File::open(path) {
        let meta = dst.metadata()?;
        if meta.len() > 0 {
            gctx.deferred_global_last_use()?.mark_registry_crate_used(
                global_cache_tracker::RegistryCrate {
                    encoded_registry_name,
                    crate_filename: pkg.tarball_name().into(),
                    size: meta.len(),
                },
            );
            return Ok(MaybeLock::Ready(dst));
        }
    }

    let url = crate_url(
        &registry_config.dl,
        &*pkg.name(),
        &pkg.version().to_string(),
        checksum,
    );

    let authorization = if registry_config.auth_required {
        Some(auth::auth_token(
            gctx,
            &pkg.source_id(),
            None,
            Operation::Read,
            vec![],
            true,
        )?)
    } else {
        None
    };

    Ok(MaybeLock::Download {
        url,
        descriptor: pkg.to_string(),
        authorization: authorization,
    })
}

/// Verifies the integrity of `data` with `checksum` and persists it under the
/// directory at `cache_path`.
///
/// This is primarily called by [`RegistryData::finish_download`](super::RegistryData::finish_download).
pub(super) fn finish_download(
    cache_path: &Filesystem,
    gctx: &GlobalContext,
    encoded_registry_name: InternedString,
    pkg: PackageId,
    checksum: &str,
    data: &[u8],
) -> CargoResult<File> {
    // Verify what we just downloaded
    let actual = Sha256::new().update(data).finish_hex();
    if actual != checksum {
        anyhow::bail!("failed to verify the checksum of `{}`", pkg)
    }
    gctx.deferred_global_last_use()?.mark_registry_crate_used(
        global_cache_tracker::RegistryCrate {
            encoded_registry_name,
            crate_filename: pkg.tarball_name().into(),
            size: data.len() as u64,
        },
    );

    cache_path.create_dir()?;
    let path = cache_path.join(&pkg.tarball_name());
    let path = gctx.assert_package_cache_locked(CacheLockMode::DownloadExclusive, &path);
    let mut dst = OpenOptions::new()
        .create(true)
        .read(true)
        .write(true)
        .open(&path)
        .with_context(|| format!("failed to open `{}`", path.display()))?;
    let meta = dst.metadata()?;
    if meta.len() > 0 {
        return Ok(dst);
    }

    dst.write_all(data)?;
    dst.seek(SeekFrom::Start(0))?;
    Ok(dst)
}

/// Checks if a tarball of `pkg` has been already downloaded under the
/// directory at `cache_path`.
///
/// This is primarily called by [`RegistryData::is_crate_downloaded`](super::RegistryData::is_crate_downloaded).
pub(super) fn is_crate_downloaded(
    cache_path: &Filesystem,
    gctx: &GlobalContext,
    pkg: PackageId,
) -> bool {
    let path = cache_path.join(pkg.tarball_name());
    let path = gctx.assert_package_cache_locked(CacheLockMode::DownloadExclusive, &path);
    if let Ok(meta) = fs::metadata(path) {
        return meta.len() > 0;
    }
    false
}
