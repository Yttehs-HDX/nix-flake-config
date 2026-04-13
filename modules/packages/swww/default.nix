# swww package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "swww";

  metadata = presets.linuxDesktopUser "desktop-component";

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
