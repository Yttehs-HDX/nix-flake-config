# network-manager package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "network-manager";

  metadata = presets.linuxDesktopUser "service";

  backends = {
    home-manager = {
      home =
        ../../projection/backends/home-manager/packages/network-manager.nix;
      system = null;
    };
    nixos = {
      home =
        ../../projection/backends/home-manager/packages/network-manager.nix;
      system = null;
    };
    nix-darwin = {
      home =
        ../../projection/backends/home-manager/packages/network-manager.nix;
      system = null;
    };
  };
}
