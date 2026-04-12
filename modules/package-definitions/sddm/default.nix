# sddm package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "sddm";

  metadata = presets.linuxDesktopSystemHost "desktop-component";

  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ../../projection/backends/nixos/packages/sddm.nix;
    };
    nix-darwin = {
      home = null;
      system = null;
    };
  };
}
