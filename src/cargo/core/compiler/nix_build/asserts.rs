use regex::Regex;

pub fn assert_valid_nix_attr_name(name: String) -> String {
    //println!("Nix attr name: '{}'", name);
    // This regex matches valid unquoted Nix attribute names
    let valid_nix_attr = Regex::new(r"^[a-zA-Z_][a-zA-Z0-9'_-]*$").unwrap();
    assert!(
        valid_nix_attr.is_match(name.as_str()),
        "Invalid Nix attribute name: `{}`",
        name
    );
    name
}

pub fn assert_valid_nix_file_name(name: String) -> String {
    //println!("Nix file name: '{}'", name);
    // This regex matches valid unquoted Nix file names
    let valid_nix_file = Regex::new(r"^[a-zA-Z_][a-zA-Z0-9'\._+-]*$").unwrap();
    assert!(
        valid_nix_file.is_match(name.as_str()),
        "Invalid Nix file name: `{}`",
        name
    );
    name
}

pub fn assert_escapes(input: &str) -> &str {
    let mut errors = Vec::new();

    for (line_num, line) in input.lines().enumerate() {
        let mut in_single_quotes = false;
        let mut chars = line.char_indices().peekable();

        while let Some((i, c)) = chars.next() {
            match c {
                '\'' => in_single_quotes = !in_single_quotes,
                '(' | ')' if !in_single_quotes => {
                    errors.push((line_num + 1, i + 1, c, line.to_string()));
                }
                _ => {}
            }
        }
    }

    if !errors.is_empty() {
        for (line, col, ch, content) in &errors {
            eprintln!(
                "Unquoted '{}' at line {}, column {}:\n  {}",
                ch, line, col, content
            );
        }
        panic!("assert_escapes: Found parentheses outside of single quotes. All '(' and ')' must be inside single quotes in rustc arguments. Probably a missing compiler::escape_args usage.");
    }
    input
}

#[cfg(test)]
mod tests {
    use super::assert_escapes;

    #[test]
    fn test_valid_quoted_parentheses() {
        let input = r#"
            --cfg 'feature="std"'
            --check-cfg 'cfg(test)'
        "#;
        assert_escapes(input); // should pass
    }

    #[test]
    #[should_panic]
    fn test_invalid_unquoted_parentheses() {
        let input = r#"
            --check-cfg cfg(loom)
        "#;
        assert_escapes(input); // should panic
    }

    #[test]
    fn test_mixed_valid_lines() {
        let input = r#"
            --cfg 'feature="serde"'
            --check-cfg 'cfg(feature, values("a", "b"))'
        "#;
        assert_escapes(input); // should pass
    }

    #[test]
    #[should_panic]
    fn test_unquoted_open_and_close() {
        let input = r#"
            --bad-cfg foo(bar
            --another-bad baz)
        "#;
        assert_escapes(input);
    }
}
