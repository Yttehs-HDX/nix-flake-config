# hexecute package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "hexecute";

  metadata = presets.crossPlatformUserPackage "custom";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/hexecute.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/hexecute.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/hexecute.nix;
      system = null;
    };
  };
}
