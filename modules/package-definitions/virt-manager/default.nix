# virt-manager package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "virt-manager";

  metadata = presets.linuxSystemHost "package";

  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ../../projection/backends/nixos/packages/virt-manager.nix;
    };
    nix-darwin = {
      home = null;
      system = null;
    };
  };
}
