use std::fs;
use std::fs::File;
use std::io::Write;
use std::path::{Path, PathBuf};
use crate::util::{CargoResult, Filesystem};

pub fn create_nix_filepath(
    out_directory: &Filesystem,
    file_name: &String,
    is_root: bool,
) -> CargoResult<(PathBuf, PathBuf)> {
    let rel_dir: PathBuf = if is_root {
        PathBuf::new()
    } else {
        PathBuf::from("deps")
    };
    let base_dir = out_directory.clone().join(rel_dir.clone());
    base_dir.create_dir()?;
    let file_path = base_dir.join(file_name).into_path_unlocked();
    Ok((rel_dir.join(file_name), file_path))
}

pub fn write_nix_file(file_path: PathBuf, content: &String) -> CargoResult<()> {
    let mut file = File::create(&file_path)?;
    writeln!(file, "{}", content)?;
    Ok(())
}

pub fn ensure_managed_directory(dir: &Path) -> CargoResult<PathBuf> {
    if dir.exists() {
        if !dir.is_dir() {
            return Err(anyhow::anyhow!("Path exists but is not a directory: {:?}", dir));
        }

        // Check if directory is empty
        let mut entries = fs::read_dir(dir)?;

        if entries.next().is_none() {
            // empty dir - create marker file
            let marker = dir.join(".cargo-libnix-managed");
            fs::write(&marker, "")?;
            return Ok(dir.to_path_buf());
        }

        // If not empty, check for the managed file
        let marker = dir.join(".cargo-libnix-managed");
        if marker.exists() {
            Ok(dir.to_path_buf())
        } else {
            Err(anyhow::anyhow!("directory '{}' exists but is not managed by us: missing \".cargo-libnix-managed\"", &dir.display()))
        }
    } else {
        // create the directory and marker file
        fs::create_dir_all(dir)?;
        let marker = dir.join(".cargo-libnix-managed");
        fs::write(&marker, "")?;
        Ok(dir.to_path_buf())
    }
}

pub fn ensure_garbage_collected_directory(dir: &Path) -> CargoResult<PathBuf> {
    let dir = ensure_managed_directory(dir)?;

    let keep_paths = [".cargo-libnix-managed", "gc"];
    for entry in fs::read_dir(&dir)? {
        let entry = entry?;
        let path = entry.path();
        let file_name = entry.file_name();
        let relative = file_name.to_string_lossy();

        // Remove if not in keep_paths list
        if !keep_paths.contains(&relative.as_ref()) {
            if path.is_dir() {
                fs::remove_dir_all(&path)?;
            } else {
                fs::remove_file(&path)?;
            }
        }
    }
    Ok(dir)
}
