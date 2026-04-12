# google-chrome package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "google-chrome";

  metadata = presets.darwinHintManual "gui";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/google-chrome.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/google-chrome.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/google-chrome.nix;
      system = null;
    };
  };
}
