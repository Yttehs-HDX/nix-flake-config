# krita package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "krita";

  metadata = presets.darwinHintManual "gui";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/krita.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/krita.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/krita.nix;
      system = null;
    };
  };
}
