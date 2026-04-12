# swaylock-effects package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "swaylock-effects";

  metadata = presets.linuxDesktopUser "theme-consumer";

  backends = {
    home-manager = {
      home =
        ../../projection/backends/home-manager/packages/swaylock-effects.nix;
      system = null;
    };
    nixos = {
      home =
        ../../projection/backends/home-manager/packages/swaylock-effects.nix;
      system = null;
    };
    nix-darwin = {
      home =
        ../../projection/backends/home-manager/packages/swaylock-effects.nix;
      system = null;
    };
  };
}
