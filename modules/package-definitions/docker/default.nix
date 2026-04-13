# docker package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "docker";

  metadata = presets.crossPlatformSystemHost "package";

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
