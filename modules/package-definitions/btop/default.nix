# Btop package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "btop";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/btop.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/btop.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/btop.nix;
      system = null;
    };
  };
}
