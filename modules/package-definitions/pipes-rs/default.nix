# pipes-rs package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "pipes-rs";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/pipes-rs.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/pipes-rs.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/pipes-rs.nix;
      system = null;
    };
  };
}
