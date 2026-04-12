# bluetooth package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "bluetooth";

  metadata = presets.linuxSystemHost "service";

  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ../../projection/backends/nixos/packages/bluetooth.nix;
    };
    nix-darwin = {
      home = null;
      system = null;
    };
  };
}
