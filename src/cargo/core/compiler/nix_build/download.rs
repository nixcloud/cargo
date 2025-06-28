use crate::util::CargoResult;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::process::{Command, Output};

// {
//     "url": "https://github.com/slowtec/rust-embed",
//     "rev": "774f20132552a5a7c9a274651b26a66268877cc1",
//     "date": "2023-12-08T20:43:07+05:30",
//     "path": "/nix/store/pidhz85yvccxd47lrvi2vg1iilizm9zz-rust-embed",
//     "sha256": "0ycky9mmbljz85siy2nxq21wv7njxlxdrdz7bkm08df9fm8db8p9",
//     "hash": "sha256-6aLVUHXJNQTqXOe33Drt0p7Ng8DdCh91QV/SVWvyk3k=",
//     "fetchLFS": false,
//     "fetchSubmodules": false,
//     "deepClone": false,
//     "leaveDotGit": false
// }

#[derive(Debug, Serialize, Deserialize)]
pub struct CargoMetadata {
    pub url: String,
    pub rev: String,
    pub date: String,
    pub path: String,
    pub hash: String,
    pub sha256: String,
}

fn run_command(args: Vec<String>) -> CargoResult<Output> {
    let output = Command::new("nix-prefetch-git").args(args).output()?;
    if !output.status.success() {
        return Err(anyhow::anyhow!("Command execution failed").into());
    }
    Ok(output)
}

pub fn download_git_for_metadata(
    url: &String,
    rev: &String,
    branch: &String,
) -> CargoResult<CargoMetadata> {
    println!("Starting git download to extract the sha256");
    let args = vec![
        String::from("--url"),
        url.to_string(),
        String::from("--rev"),
        rev.to_string(),
        String::from("--branch-name"),
        branch.to_string(),
        String::from("--sparse-checkout"),
    ];
    println!("{:?}", &args);
    let output = run_command(args)?;
    let json: Value = serde_json::from_slice(&output.stdout)?;

    Ok(CargoMetadata {
        url: json["url"].as_str().unwrap_or_default().to_string(),
        rev: json["rev"].as_str().unwrap_or_default().to_string(),
        date: json["date"].as_str().unwrap_or_default().to_string(),
        path: json["path"].as_str().unwrap_or_default().to_string(),
        hash: json["hash"].as_str().unwrap_or_default().to_string(),
        sha256: json["sha256"].as_str().unwrap_or_default().to_string(),
    })
}
