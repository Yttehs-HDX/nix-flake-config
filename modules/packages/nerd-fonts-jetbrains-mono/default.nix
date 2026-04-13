# nerd-fonts-jetbrains-mono package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "nerd-fonts-jetbrains-mono";

  metadata = presets.crossPlatformUserPackage "theme-consumer";

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
