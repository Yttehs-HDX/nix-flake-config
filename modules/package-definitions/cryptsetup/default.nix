# cryptsetup package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "cryptsetup";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/cryptsetup.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/cryptsetup.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/cryptsetup.nix;
      system = null;
    };
  };
}
