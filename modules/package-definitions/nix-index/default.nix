# nix-index package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "nix-index";

  metadata = presets.crossPlatformUserPackage "environment";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/nix-index.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/nix-index.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/nix-index.nix;
      system = null;
    };
  };
}
