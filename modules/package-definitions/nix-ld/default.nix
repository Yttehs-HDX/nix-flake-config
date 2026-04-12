# nix-ld package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "nix-ld";

  metadata = presets.linuxSystemHost "package";

  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ../../projection/backends/nixos/packages/nix-ld.nix;
    };
    nix-darwin = {
      home = null;
      system = null;
    };
  };
}
