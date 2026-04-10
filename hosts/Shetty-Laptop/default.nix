{
  enable = true;

  meta = {
    displayName = "Shetty Laptop";
    description = "Primary NixOS laptop.";
    tags = [ "laptop" "desktop" ];
  };

  backend.type = "nixos";

  platform.system = "x86_64-linux";

  capabilities = {
    system.enable = true;
    home.enable = true;
    desktop.enable = true;
    userManagement.enable = true;
  };

  roles = [ "laptop" "desktop" ];

  system = { stateVersion = "25.11"; };

  hardware = { modules = [ ./hardware-configuration.nix ]; };

  networking = { };
  security = { };
  desktop = { };

  software = {
    docker.settings.storageDriver = "btrfs";
    nix-ld = { };
    wireshark.settings.package = "qt";
  };

  policy = { };
}
