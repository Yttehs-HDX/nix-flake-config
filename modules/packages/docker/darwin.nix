{ definition, ... }:
{ lib, pkgs, ... }:
let ignoredStorageDriver = definition.settings ? storageDriver;
in {
  environment.systemPackages = [ pkgs.docker pkgs.docker-compose ];

  warnings = [
    "Package `docker` on nix-darwin installs the Docker CLI and Compose plugin only. Run Docker Desktop, Colima, or another macOS container runtime separately for daemon support."
  ] ++ lib.optionals ignoredStorageDriver [
    "Package `docker` ignores `settings.storageDriver` on nix-darwin because the backend does not manage the Docker daemon there."
  ];
}
