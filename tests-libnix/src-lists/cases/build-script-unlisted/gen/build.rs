// lists only build.rs, but reads version.txt: with only the listed files its output differs (no version.txt)
fn main() {
    println!("cargo:rerun-if-changed=build.rs");
    let version = std::fs::read_to_string("version.txt").unwrap_or_default();
    let out = std::env::var("OUT_DIR").unwrap();
    std::fs::write(format!("{out}/gen.rs"), format!("pub const INPUT: &str = {:?};", version.trim())).unwrap();
}
