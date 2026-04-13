# rog-control-center package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "rog-control-center";

  metadata = presets.linuxSystemHost "service";

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
