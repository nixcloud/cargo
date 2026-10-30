// lists input.txt and the directory assets: the run gets only those (and its package's directory)
fn main() {
    println!("cargo:rerun-if-changed=input.txt");
    println!("cargo::rerun-if-changed=assets");
    let input = std::fs::read_to_string("input.txt").unwrap();
    let assets = std::fs::read_dir("assets").unwrap().count();
    let out = std::env::var("OUT_DIR").unwrap();
    std::fs::write(format!("{out}/gen.rs"), format!("pub const INPUT: &str = \"{} {assets}\";", input.trim())).unwrap();
}
