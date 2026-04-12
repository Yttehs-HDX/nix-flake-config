# networking package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "networking";

  metadata = presets.crossPlatformSystemHost "service";

  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ../../projection/backends/nixos/packages/networking.nix;
    };
    nix-darwin = {
      home = null;
      system = ../../projection/backends/nix-darwin/packages/networking.nix;
    };
  };
}
