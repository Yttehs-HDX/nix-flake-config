# obs-studio package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "obs-studio";

  metadata = presets.darwinHintManual "gui";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/obs-studio.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/obs-studio.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/obs-studio.nix;
      system = null;
    };
  };
}
