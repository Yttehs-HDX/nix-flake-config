# swww package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "swww";

  metadata = presets.linuxDesktopUser "desktop-component";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/swww.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/swww.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/swww.nix;
      system = null;
    };
  };
}
