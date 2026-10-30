// reads input.txt with std::fs (no rerun-if-changed): the run gets its package's directory as its list
fn main() {
    let input = std::fs::read_to_string("input.txt").unwrap();
    let out = std::env::var("OUT_DIR").unwrap();
    std::fs::write(format!("{out}/gen.rs"), format!("pub const INPUT: &str = {:?};", input.trim())).unwrap();
}
