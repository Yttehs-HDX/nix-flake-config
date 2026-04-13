# seahorse package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "seahorse";

  metadata = presets.linuxDesktopUser "gui";

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
