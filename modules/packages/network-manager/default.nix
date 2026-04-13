# network-manager package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "network-manager";

  metadata = presets.linuxDesktopUser "service";

  backends = {
    home-manager = {
      home = ./home.nix;
      system = null;
    };
    nixos = {
      home = ./home.nix;
      system = null;
    };
    nix-darwin = {
      home = ./home.nix;
      system = null;
    };
  };
}
