# GitHub CLI package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "gh";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/gh.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/gh.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/gh.nix;
      system = null;
    };
  };
}
