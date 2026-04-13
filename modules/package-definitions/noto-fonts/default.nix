# noto-fonts package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "noto-fonts";

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
