#[cfg(test)]
mod tests {
    use std::fs;
    use tempfile::tempdir;
    //use core::compiler::nix_build::nix_files::ensure_managed_directory;

    #[test]
    fn test_no_directory() -> Result<(), Box<dyn std::error::Error>> {
        // Create a temp directory parent and a path for a non-existent subdir
        let temp_dir = tempdir()?;
        let non_existent_dir = temp_dir.path().join("nonexistent");

        // Directory does not exist, function should create it and marker file
        let result = ensure_managed_directory(&non_existent_dir)?;
        assert_eq!(result, non_existent_dir);
        assert!(non_existent_dir.exists());
        assert!(non_existent_dir.join(".cargo-libnix-managed").exists());

        Ok(())
    }

    #[test]
    fn test_directory_exists_with_marker() -> Result<(), Box<dyn std::error::Error>> {
        // Create a temp directory and add the marker file
        let temp_dir = tempdir()?;
        let dir_path = temp_dir.path();

        let marker = dir_path.join(".cargo-libnix-managed");
        fs::write(&marker, "")?;

        // Call ensure_managed_directory should succeed and return the dir path
        let result = ensure_managed_directory(dir_path)?;
        assert_eq!(result, dir_path.to_path_buf());

        Ok(())
    }

    #[test]
    fn test_directory_exists_without_marker() -> Result<(), Box<dyn std::error::Error>> {
        // Create a temp directory without marker but with another file or folder
        let temp_dir = tempdir()?;
        let dir_path = temp_dir.path();

        // Create a dummy file to ensure directory is non-empty
        fs::write(dir_path.join("dummy.txt"), "content")?;

        // Call should return an error about missing marker
        let result = ensure_managed_directory(dir_path);
        assert!(result.is_err());
        assert_eq!(
            result.unwrap_err(),
            "directory exists but is not managed by us: missing \".cargo-libnix-managed\""
        );

        Ok(())
    }

    #[test]
    fn test_directory_exists_empty_creates_marker() -> Result<(), Box<dyn std::error::Error>> {
        // Create an empty temp directory
        let temp_dir = tempdir()?;
        let dir_path = temp_dir.path();

        // Call should create marker file since it is empty
        let result = ensure_managed_directory(dir_path)?;
        assert_eq!(result, dir_path.to_path_buf());
        assert!(dir_path.join(".cargo-libnix-managed").exists());

        Ok(())
    }
}