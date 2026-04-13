# fcitx5 package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "fcitx5";

  metadata = presets.linuxDesktopUser "desktop-input-method";

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
