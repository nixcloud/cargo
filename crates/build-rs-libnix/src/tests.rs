#[cfg(test)]
mod tests {
    use crate::handle_content;
    use std::env;
    use std::fs;
    use std::io::Write;
    use tempfile::NamedTempFile;

    #[test]
    fn test_rustc_cfg_output() {
        let mut temp = NamedTempFile::new().unwrap();
        writeln!(
            temp,
            "cargo:rustc-cfg=freebsd11\ncargo:rustc-cfg=libc_const_extern_fn"
        )
        .unwrap();

        let content = fs::read_to_string(temp.path()).unwrap();
        let output = handle_content(content).unwrap();
        assert_eq!(
            output.rustc_arguments.join(" ").trim(),
            "--cfg 'freebsd11' --cfg 'libc_const_extern_fn'"
        );
    }

    #[test]
    fn test_output1() {
        let content = fs::read_to_string("test/output1").unwrap();
        let output = handle_content(content).unwrap();
        assert_eq!(
            output.rustc_arguments.join(" ").trim(),
            "--cfg 'libc_const_extern_fn' --cfg 'freebsd11' --check-cfg 'cfg(espidf_time32)' --check-cfg 'cfg(target_arch,values(\"mips64r6\"))'"
        );
    }

    #[test]
    fn test_output2() {
        let content = fs::read_to_string("test/output2").unwrap();
        let output = handle_content(content).unwrap();
        assert_eq!(
            output.rustc_arguments.join(" ").trim(),
            "--check-cfg 'cfg(fast_arithmetic, values(\"32\", \"64\"))' --cfg 'fast_arithmetic=\"64\"'"
        );
    }

    #[test]
    fn test_output3() {
        let content = fs::read_to_string("test/output3").unwrap();
        let output = handle_content(content).unwrap();
        assert_eq!(
            output.rustc_arguments.join(" ").trim(),
            "-l 'static=sqlite3' -L \"native=$out\""
        );
        assert_eq!(
            output.rustc_propagated_arguments.join(" ").trim(),
            "-L 'native=${rust-embed-8_6_0-50d2bdadc507cf36}'"
        );
    }

    #[test]
    fn test_output4() {
        let content = fs::read_to_string("test/output4").unwrap();
        let err = handle_content(content).unwrap_err();
        assert!(err.to_string().contains("cargo:fail here"));
    }

    #[test]
    fn test_output5() {
        unsafe {
            env::set_var("CARGO_MANIFEST_LINKS", "MYCRATE");
        }
        let content = fs::read_to_string("test/output5").unwrap();
        let output = handle_content(content).unwrap();
        assert_eq!(
            output.rustc_arguments.join(" ").trim(),
            "--check-cfg 'cfg(openssl)' --check-cfg 'cfg(libressl)' --check-cfg 'cfg(boringssl)' --check-cfg 'cfg(libressl250)' --check-cfg 'cfg(libressl251)' --check-cfg 'cfg(libressl252)' --check-cfg 'cfg(libressl261)' --check-cfg 'cfg(libressl270)' --check-cfg 'cfg(libressl271)' --check-cfg 'cfg(libressl273)' --check-cfg 'cfg(libressl280)' --check-cfg 'cfg(libressl281)' --check-cfg 'cfg(libressl291)' --check-cfg 'cfg(libressl310)' --check-cfg 'cfg(libressl321)' --check-cfg 'cfg(libressl332)' --check-cfg 'cfg(libressl340)' --check-cfg 'cfg(libressl350)' --check-cfg 'cfg(libressl360)' --check-cfg 'cfg(libressl361)' --check-cfg 'cfg(libressl370)' --check-cfg 'cfg(libressl380)' --check-cfg 'cfg(libressl381)' --check-cfg 'cfg(libressl382)' --check-cfg 'cfg(libressl390)' --check-cfg 'cfg(libressl400)' --check-cfg 'cfg(libressl410)' --check-cfg 'cfg(ossl101)' --check-cfg 'cfg(ossl102)' --check-cfg 'cfg(ossl102f)' --check-cfg 'cfg(ossl102h)' --check-cfg 'cfg(ossl110)' --check-cfg 'cfg(ossl110f)' --check-cfg 'cfg(ossl110g)' --check-cfg 'cfg(ossl110h)' --check-cfg 'cfg(ossl111)' --check-cfg 'cfg(ossl111b)' --check-cfg 'cfg(ossl111c)' --check-cfg 'cfg(ossl111d)' --check-cfg 'cfg(ossl300)' --check-cfg 'cfg(ossl310)' --check-cfg 'cfg(ossl320)' --check-cfg 'cfg(ossl330)' --check-cfg 'cfg(ossl340)' -L \"native=$out\" -l 'ssl' -l 'crypto' --cfg 'osslconf=\"OPENSSL_NO_SSL3_METHOD\"' --cfg 'openssl' --cfg 'ossl340' --cfg 'ossl330' --cfg 'ossl320' --cfg 'ossl300' --cfg 'ossl101' --cfg 'ossl102' --cfg 'ossl102f' --cfg 'ossl102h' --cfg 'ossl110' --cfg 'ossl110f' --cfg 'ossl110g' --cfg 'ossl110h' --cfg 'ossl111' --cfg 'ossl111b' --cfg 'ossl111c' --cfg 'ossl111d'"
        );
        assert_eq!(
            output.rustc_propagated_arguments.join(" ").trim(),
            "-L 'native=/nix/store/byx7ahs386pskh8d5sdkrkpscfz9yyjp-openssl-3.4.1/lib'"
        );
        assert_eq!(
            output.environment_variables.join("\n").trim(),
            "DEP_MYCRATE_CONF='OPENSSL_NO_SSL3_METHOD'\nDEP_MYCRATE_VERSION_NUMBER='30400010'\nDEP_MYCRATE_INCLUDE='/nix/store/k0699a27nkj4c2xn67bjcpfa08nqn9l4-openssl-3.4.1-dev/include'"
        );
    }

    #[test]
    fn test_output6() {
        let content = fs::read_to_string("test/output6").unwrap();
        let output = handle_content(content).unwrap();
    }

    #[test]
    fn test_output7() {
        unsafe {
            env::set_var("CARGO_MANIFEST_LINKS", "MYCRATE");
        }
        let content = fs::read_to_string("test/output7").unwrap();
        let output = handle_content(content).unwrap();
        assert_eq!(
            output.rustc_arguments.join(" ").trim(),
            "-L \"native=$out\" -l 'sqlite3'"
        );
        assert_eq!(
            output.rustc_propagated_arguments.join(" ").trim(),
            "-L 'native=/nix/store/yfjzkkkyxcalyj7l1n4d4y6s81i65hmy-sqlite-3.48.0/lib'"
        );
        assert_eq!(output.environment_variables.join("\n").trim(), "");
        assert_eq!(
            output.rustc_link_arg_benches.join(" ").trim(),
            "-C link-arg='-rdynamic'"
        );
    }
}
