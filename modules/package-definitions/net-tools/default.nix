# net-tools package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "net-tools";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/net-tools.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/net-tools.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/net-tools.nix;
      system = null;
    };
  };
}
