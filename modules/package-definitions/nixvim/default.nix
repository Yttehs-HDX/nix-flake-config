# nixvim package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "nixvim";

  metadata = presets.crossPlatformUserPackage "integration-heavy";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/nixvim.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/nixvim.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/nixvim.nix;
      system = null;
    };
  };
}
