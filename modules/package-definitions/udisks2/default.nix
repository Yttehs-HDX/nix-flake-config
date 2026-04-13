# udisks2 package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "udisks2";

  metadata = presets.linuxDesktopUser "service";

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
