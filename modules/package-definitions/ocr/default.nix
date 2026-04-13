# ocr package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "ocr";

  metadata = presets.linuxDesktopUser "custom";

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
