# waydroid package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "waydroid";

  metadata = presets.linuxSystemHost "service";

  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ../../projection/backends/nixos/packages/waydroid.nix;
    };
    nix-darwin = {
      home = null;
      system = null;
    };
  };
}
