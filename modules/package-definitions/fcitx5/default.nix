# fcitx5 package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "fcitx5";

  metadata = presets.linuxDesktopUser "desktop-input-method";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/fcitx5.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/fcitx5.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/fcitx5.nix;
      system = null;
    };
  };
}
