# unzip package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "unzip";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/unzip.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/unzip.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/unzip.nix;
      system = null;
    };
  };
}
