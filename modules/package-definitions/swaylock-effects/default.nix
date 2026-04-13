# swaylock-effects package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "swaylock-effects";

  metadata = presets.linuxDesktopUser "theme-consumer";

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
