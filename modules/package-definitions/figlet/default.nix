# Figlet package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "figlet";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/figlet.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/figlet.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/figlet.nix;
      system = null;
    };
  };
}
