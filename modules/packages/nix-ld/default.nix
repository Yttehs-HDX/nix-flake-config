# nix-ld package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
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
      system = ./nixos.nix;
    };
    nix-darwin = {
      home = null;
      system = null;
    };
  };
}
