# osu-lazer-bin package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "osu-lazer-bin";

  metadata = presets.darwinHintManual "gui";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/osu-lazer-bin.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/osu-lazer-bin.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/osu-lazer-bin.nix;
      system = null;
    };
  };
}
