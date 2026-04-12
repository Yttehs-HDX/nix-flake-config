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

  system = { stateVersion = "25.11"; };

  hardware = { modules = [ ./hardware-configuration.nix ]; };

  packages = {
    asusctl = { };
    bluetooth = { };
    blueman = { };
    docker.settings.storageDriver = "btrfs";
    firewall = { };
    networking = { };
    nix-ld = { };
    nvidia.settings = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
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
}
