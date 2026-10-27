use proc_macro::TokenStream;

/// file_len!("config.txt"): the length of the file, at compile time
#[proc_macro]
pub fn file_len(input: TokenStream) -> TokenStream {
    let name = input.to_string().trim_matches('"').to_string();
    let path = format!("{}/{name}", std::env::var("CARGO_MANIFEST_DIR").unwrap());
    // tells rustc about the file: include_bytes! puts it into the .d
    let text = std::fs::read_to_string(&path).unwrap();
    format!("{{ const _: &[u8] = include_bytes!({path:?}); {}usize }}", text.len()).parse().unwrap()
}
