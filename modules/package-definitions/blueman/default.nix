# blueman package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "blueman";

  metadata = presets.linuxDesktopHost "desktop-component";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/blueman.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/blueman.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/blueman.nix;
      system = null;
    };
  };
}
