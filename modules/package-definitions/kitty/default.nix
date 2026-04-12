# Kitty package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "kitty";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/kitty.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/kitty.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/kitty.nix;
      system = null;
    };
  };
}
