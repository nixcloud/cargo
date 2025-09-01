use serde::{Deserialize, Serialize};
use std::collections::HashMap;

pub mod build_result_parser;
pub mod build_runner;

pub use build_runner::NixBuild;

#[derive(Debug, Deserialize, Serialize, PartialEq)]
pub struct BuildRecord {
    #[serde(rename = "drvPath", default)]
    pub drv_path: Option<String>,
    pub outputs: HashMap<String, String>,
    #[serde(rename = "startTime", default)]
    pub start_time: Option<u64>,
    #[serde(rename = "stopTime", default)]
    pub stop_time: Option<u64>,
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