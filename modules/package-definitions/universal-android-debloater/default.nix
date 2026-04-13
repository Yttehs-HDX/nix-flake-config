# universal-android-debloater package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "universal-android-debloater";

  metadata = presets.darwinHintManual "gui";

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
