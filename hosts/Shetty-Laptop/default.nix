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

  packages = {
    asusctl = { };
    bluetooth = { };
    docker.settings.storageDriver = "btrfs";
    firewall = { };
    grub = { };
    locale = { };
    networking = { };
    nix-ld = { };
    nvidia = { };
    pipewire = { };
    refind = { };
    rog-control-center = { };
    sddm = { };
    supergfxctl = { };
    tlp = { };
    waydroid = { };
    virt-manager = { };
    wireshark.settings.package = "qt";
    zram = { };
  };

  policy = { };
}
