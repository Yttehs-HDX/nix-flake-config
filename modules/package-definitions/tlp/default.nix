# tlp package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "tlp";

  metadata = presets.linuxSystemHost "service";

  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ../../projection/backends/nixos/packages/tlp.nix;
    };
    nix-darwin = {
      home = null;
      system = null;
    };
  };
}
