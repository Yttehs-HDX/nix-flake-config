# noto-fonts package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "noto-fonts";

  metadata = presets.crossPlatformUserPackage "theme-consumer";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/noto-fonts.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/noto-fonts.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/noto-fonts.nix;
      system = null;
    };
  };
}
