# poppler-utils package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "poppler-utils";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/poppler-utils.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/poppler-utils.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/poppler-utils.nix;
      system = null;
    };
  };
}
