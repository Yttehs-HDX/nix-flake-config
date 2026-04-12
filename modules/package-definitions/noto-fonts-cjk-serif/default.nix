# noto-fonts-cjk-serif package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "noto-fonts-cjk-serif";

  metadata = presets.crossPlatformUserPackage "theme-consumer";

  backends = {
    home-manager = {
      home =
        ../../projection/backends/home-manager/packages/noto-fonts-cjk-serif.nix;
      system = null;
    };
    nixos = {
      home =
        ../../projection/backends/home-manager/packages/noto-fonts-cjk-serif.nix;
      system = null;
    };
    nix-darwin = {
      home =
        ../../projection/backends/home-manager/packages/noto-fonts-cjk-serif.nix;
      system = null;
    };
  };
}
