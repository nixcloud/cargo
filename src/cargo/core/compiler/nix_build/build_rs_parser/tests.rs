#[cfg(test)]
mod tests {
    use crate::Command;
    use std::fs;
    use std::io::Write;
    use tempfile::NamedTempFile;
    use crate::handle_content;

    #[test]
    fn test_rustc_cfg_output() {
        let mut temp = NamedTempFile::new().unwrap();
        writeln!(
            temp,
            "cargo:rustc-cfg=freebsd11\ncargo:rustc-cfg=libc_const_extern_fn"
        )
        .unwrap();

        let content = fs::read_to_string(temp.path()).unwrap();
        let output = handle_content(Command::RustcArguments, content).unwrap();
        assert_eq!(
            output.trim(),
            "--cfg=freebsd11 --cfg=libc_const_extern_fn"
        );
    }

    // #[test]
    // fn test_rustc_check_cfg_output() {
    //     let mut temp = NamedTempFile::new().unwrap();
    //     writeln!(
    //         temp,
    //         "cargo:rustc-check-cfg=cfg(espidf_time32)\ncargo:rustc-check-cfg=cfg(libc_ctest)"
    //     )
    //     .unwrap();

    //     let content = fs::read_to_string(temp.path()).unwrap();
    //     let output = handle_content(Command::RustcArguments, content).unwrap();
    //     assert_eq!(
    //         output.trim(),
    //         "--check-cfg='cfg(espidf_time32)' --check-cfg='cfg(libc_ctest)'"
    //     );
    // }

    // #[test]
    // fn test_mixed_content() {
    //     let mut temp = NamedTempFile::new().unwrap();
    //     writeln!(
    //         temp,
    //         "cargo:rustc-cfg=freebsd11\n\
    //          cargo:rustc-check-cfg=cfg(libc_ctest)\n\
    //          cargo:rustc-cfg=libc_const_extern_fn\n\
    //          cargo:rustc-check-cfg=cfg(target_arch,values(\"mips64r6\"))
    //          cargo:rustc-env=VAR=VALUE"
    //     )
    //     .unwrap();

    //     let content = fs::read_to_string(temp.path()).unwrap();

    //     let output = handle_content(Command::RustcArguments, content.clone()).unwrap();
    //     assert_eq!(
    //         output.trim(),
    //         "--cfg='freebsd11' --check-cfg='cfg(libc_ctest)' --cfg='libc_const_extern_fn' --check-cfg='cfg(target_arch,values(\"mips64r6\"))'"
    //     );

    //     let output = handle_content(Command::EnvironmentVariables, content).unwrap();

    //     assert_eq!(
    //         output.trim(),
    //         "VAR=VALUE"
    //     );
    // }
}
