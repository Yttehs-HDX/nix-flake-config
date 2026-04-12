# grimblast package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "grimblast";

  metadata = presets.linuxDesktopUser "desktop-component";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/grimblast.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/grimblast.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/grimblast.nix;
      system = null;
    };
  };
}
