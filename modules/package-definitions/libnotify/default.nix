# libnotify package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "libnotify";

  metadata = presets.linuxDesktopUser "desktop-component";

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
