# nix-index package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "nix-index";

  metadata = presets.crossPlatformUserPackage "environment";

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
