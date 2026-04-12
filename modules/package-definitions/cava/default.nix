# cava package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "cava";

  metadata = presets.crossPlatformUserPackage "theme-consumer";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/cava.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/cava.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/cava.nix;
      system = null;
    };
  };
}
