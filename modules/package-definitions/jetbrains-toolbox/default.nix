# jetbrains-toolbox package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "jetbrains-toolbox";

  metadata = presets.darwinHintManual "gui";

  backends = {
    home-manager = {
      home =
        ../../projection/backends/home-manager/packages/jetbrains-toolbox.nix;
      system = null;
    };
    nixos = {
      home =
        ../../projection/backends/home-manager/packages/jetbrains-toolbox.nix;
      system = null;
    };
    nix-darwin = {
      home =
        ../../projection/backends/home-manager/packages/jetbrains-toolbox.nix;
      system = null;
    };
  };
}
