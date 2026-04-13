# nix-features package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "nix-features";

  metadata = presets.crossPlatformSystemHost "service";

  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ./nixos.nix;
    };
    nix-darwin = {
      home = null;
      system = ./darwin.nix;
    };
  };
}
