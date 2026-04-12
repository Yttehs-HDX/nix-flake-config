# kdeconnect package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "kdeconnect";

  metadata = presets.linuxDesktopUser "service";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/kdeconnect.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/kdeconnect.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/kdeconnect.nix;
      system = null;
    };
  };
}
