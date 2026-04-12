# xdg package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "xdg";

  metadata = presets.crossPlatformUserPackage "environment";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/xdg.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/xdg.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/xdg.nix;
      system = null;
    };
  };
}
