# clash-verge-rev package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "clash-verge-rev";

  metadata = presets.darwinHintManual "integration-heavy";

  backends = {
    home-manager = {
      home = ./home.nix;
      system = null;
    };
    nixos = {
      home = ./home.nix;
      system = null;
    };
    nix-darwin = {
      home = ./home.nix;
      system = null;
    };
  };
}
