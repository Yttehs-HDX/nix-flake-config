# udisks2 package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "udisks2";

  metadata = presets.linuxDesktopUser "service";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/udisks2.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/udisks2.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/udisks2.nix;
      system = null;
    };
  };
}
