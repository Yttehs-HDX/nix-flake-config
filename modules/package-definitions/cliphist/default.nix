# cliphist package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "cliphist";

  metadata = presets.linuxDesktopUser "desktop-component";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/cliphist.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/cliphist.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/cliphist.nix;
      system = null;
    };
  };
}
