# nixfmt-classic package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "nixfmt-classic";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/nixfmt-classic.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/nixfmt-classic.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/nixfmt-classic.nix;
      system = null;
    };
  };
}
