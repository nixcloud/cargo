{pkgs, lib ? pkgs.lib} :
pkgs.rustPlatform.buildRustPackage {
    pname = "build-rs-libnix";
    version = "0.1.10";
    src = ./.;
   
    #cargoBuildFlags = ["-p" "build-rs-libnix"];

    cargoLock = {
        lockFile = ./Cargo.lock;
    };
    
    doCheck = false;

    nativeBuildInputs = [ ];
    buildInputs = with pkgs; [ openssl pkg-config ];

    meta = with lib; {
        description = "xxx";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
        platforms = platforms.all;
    };
}