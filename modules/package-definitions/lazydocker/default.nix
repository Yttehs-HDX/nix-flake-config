# Lazydocker package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "lazydocker";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/lazydocker.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/lazydocker.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/lazydocker.nix;
      system = null;
    };
  };
}
