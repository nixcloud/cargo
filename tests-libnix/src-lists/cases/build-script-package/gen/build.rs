// reads input.txt with std::fs and prints no rerun-if-*: cargo runs it again when a file of its package changes
fn main() {
    let input = std::fs::read_to_string("input.txt").unwrap();
    let out = std::env::var("OUT_DIR").unwrap();
    std::fs::write(format!("{out}/gen.rs"), format!("pub const INPUT: &str = {:?};", input.trim())).unwrap();
}
