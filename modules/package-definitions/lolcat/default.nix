# lolcat package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "lolcat";

  metadata = presets.crossPlatformUserPackage "package";

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
