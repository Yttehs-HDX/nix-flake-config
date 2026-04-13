# pipes-rs package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "pipes-rs";

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
