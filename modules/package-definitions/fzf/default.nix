# Fzf package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "fzf";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/fzf.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/fzf.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/fzf.nix;
      system = null;
    };
  };
}
