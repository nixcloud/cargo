pub struct NixBuild {}

impl NixBuild {
    pub fn build() -> Result<(), String> {
        let output = std::process::Command::new("nix-build")
            .arg("--version")
            .output();

        match output {
            Ok(o) => {
                if o.status.success() {
                    println!("{}", String::from_utf8_lossy(&o.stdout));
                } else {
                    //Err(String::from_utf8_lossy(&o.stderr).into_owned())
                }
                //    return Err(format!("Failed to execute nix-build"))
            }
            Err(e) => println!("Failed to execute nix-build: {}", e),
        }
        Ok(())
    }
}
