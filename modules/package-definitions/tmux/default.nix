# Tmux package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "tmux";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/tmux.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/tmux.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/tmux.nix;
      system = null;
    };
  };
}
