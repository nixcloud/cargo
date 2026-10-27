#[path = "build/helper.rs"]
mod helper;
fn main() { println!("cargo:rustc-env=GREETING={}", helper::greeting(include_str!("greeting.txt").trim())); }
