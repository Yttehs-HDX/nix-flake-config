# seahorse package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "seahorse";

  metadata = presets.linuxDesktopUser "gui";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/seahorse.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/seahorse.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/seahorse.nix;
      system = null;
    };
  };
}
