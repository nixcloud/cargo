use crate::util::CargoResult;
use crate::util::GlobalContext;
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
    let output = Command::new("nix-prefetch-git")
        .args(&args)
        .output();

    let output = match output {
        Ok(o) => o,
        Err(e) => {
            return Err(anyhow::anyhow!(
                "Failed to spawn 'nix-prefetch-git {}': {}",
                args.join(" "),
                e
            )
            .into());
        }
    };

    if !output.status.success() {
        return Err(anyhow::anyhow!(
            "Command 'nix-prefetch-git {}' failed with exit code {:?}",
            args.join(" "),
            output.status.code()
        )
        .into());
    }

    Ok(output)
}

pub fn download_git_for_metadata<'gctx>(
    url: &String,
    rev: &String,
    branch: &String,
    gctx: &'gctx GlobalContext,
) -> CargoResult<CargoMetadata> {
let mut args = vec![
        String::from("--url"),
        url.to_string(),
        String::from("--rev"),
        rev.to_string(),
    ];
    if !branch.is_empty() {
        args.push(String::from("--branch-name"));
        args.push(branch.to_string());
    }
    args.push(String::from("--sparse-checkout"));

    gctx.shell()
        .verbose(|s| s.status("Downloading git", &args.join(" ")))?;

    let output = match run_command(args) {
        Ok(out) => out,
        Err(e) => return Err(anyhow::anyhow!("Failed to run nix-prefetch-git: {}", e)),
    };
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
