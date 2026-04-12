# universal-android-debloater package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "universal-android-debloater";

  metadata = presets.darwinHintManual "gui";

  backends = {
    home-manager = {
      home =
        ../../projection/backends/home-manager/packages/universal-android-debloater.nix;
      system = null;
    };
    nixos = {
      home =
        ../../projection/backends/home-manager/packages/universal-android-debloater.nix;
      system = null;
    };
    nix-darwin = {
      home =
        ../../projection/backends/home-manager/packages/universal-android-debloater.nix;
      system = null;
    };
  };
}
