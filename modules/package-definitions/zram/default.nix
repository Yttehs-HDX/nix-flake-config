# zram package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "zram";

  metadata = presets.linuxSystemHost "service";

  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ../../projection/backends/nixos/packages/zram.nix;
    };
    nix-darwin = {
      home = null;
      system = null;
    };
  };
}
