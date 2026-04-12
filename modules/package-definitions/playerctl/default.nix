# playerctl package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "playerctl";

  metadata = presets.linuxDesktopUser "desktop-component";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/playerctl.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/playerctl.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/playerctl.nix;
      system = null;
    };
  };
}
