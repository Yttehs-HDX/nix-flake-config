# android-tools package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "android-tools";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ./home.nix;
      system = null;
    };
    nixos = {
      home = ./home.nix;
      system = ./nixos.nix;
    };
    nix-darwin = {
      home = ./home.nix;
      system = null;
    };
  };
}
