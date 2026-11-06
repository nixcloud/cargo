// compiles c/hello.c for the target into libhello_c.a; clang is a cross compiler for every target it knows, so
// no C toolchain per target is needed (HELLO_C_CLANG, HELLO_C_AR override clang, llvm-ar)
use std::env;
use std::path::PathBuf;
use std::process::Command;

fn run(cmd: &mut Command) {
    let status = cmd.status().unwrap_or_else(|e| panic!("{cmd:?}: {e}"));
    assert!(status.success(), "{cmd:?}: {status}");
}

fn main() {
    let out = PathBuf::from(env::var("OUT_DIR").unwrap());
    let src = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap()).join("c/hello.c");
    let target = env::var("TARGET").unwrap();
    let clang = env::var("HELLO_C_CLANG").unwrap_or_else(|_| "clang".into());
    let ar = env::var("HELLO_C_AR").unwrap_or_else(|_| "llvm-ar".into());

    let mut cc = Command::new(clang);
    // clang knows riscv64, not rustc's riscv64gc: rv64gc with the lp64d (double float) ABI of the rust target
    match target.strip_prefix("riscv64gc-") {
        Some(rest) => cc.arg(format!("--target=riscv64-{rest}")).args(["-march=rv64gc", "-mabi=lp64d"]),
        None => cc.arg(format!("--target={target}")),
    };
    // the musl binaries are static-pie; PIC on wasm would need dynamic linking
    if !target.starts_with("wasm32") {
        cc.arg("-fPIC");
    }
    let obj = out.join("hello.o");
    run(cc.args(["-ffreestanding", "-O2", "-c"]).arg(&src).arg("-o").arg(&obj));
    run(Command::new(ar).arg("crs").arg(out.join("libhello_c.a")).arg(&obj));

    println!("cargo:rustc-link-search=native={}", out.display());
    println!("cargo:rustc-link-lib=static=hello_c");
    println!("cargo:rerun-if-changed=c/hello.c");
}
