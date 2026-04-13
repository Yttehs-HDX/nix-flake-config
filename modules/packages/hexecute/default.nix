# hexecute package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "hexecute";

  metadata = presets.crossPlatformUserPackage "custom";

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
