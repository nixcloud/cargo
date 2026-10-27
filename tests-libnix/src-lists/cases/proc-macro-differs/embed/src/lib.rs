use proc_macro::TokenStream;

/// file_len!("config.txt"): the length of the file, at compile time
#[proc_macro]
pub fn file_len(input: TokenStream) -> TokenStream {
    let name = input.to_string().trim_matches('"').to_string();
    let path = format!("{}/{name}", std::env::var("CARGO_MANIFEST_DIR").unwrap());
    // reads the file without telling rustc, and without the file it silently gives 0
    let text = std::fs::read_to_string(&path).unwrap_or_default();
    format!("{}usize", text.len()).parse().unwrap()
}
