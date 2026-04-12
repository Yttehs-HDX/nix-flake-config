# unrar package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "unrar";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/unrar.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/unrar.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/unrar.nix;
      system = null;
    };
  };
}
