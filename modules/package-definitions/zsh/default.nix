# Zsh package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "zsh";

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
