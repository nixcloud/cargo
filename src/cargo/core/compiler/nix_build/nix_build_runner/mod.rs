use serde::{Deserialize, Serialize};
use std::collections::HashMap;

pub mod build_result_parser;
pub mod build_runner;

pub use build_runner::NixBuild;

/// Represents a build record from Nix build output
#[derive(Debug, Deserialize, Serialize, PartialEq)]
pub struct BuildRecord {
    #[serde(rename = "drvPath")]
    pub drv_path: String,
    pub outputs: HashMap<String, String>,
    #[serde(rename = "startTime")]
    pub start_time: u64,
    #[serde(rename = "stopTime")]
    pub stop_time: u64,
}

impl BuildRecord {
    /// Get the "out" output path if it exists
    pub fn get_out_path(&self) -> Option<&String> {
        self.outputs.get("out")
    }

    /// Check if the "out" output matches a specific path
    pub fn has_out_path(&self, expected_path: &str) -> bool {
        self.get_out_path()
            .map(|path| path == expected_path)
            .unwrap_or(false)
    }
}
