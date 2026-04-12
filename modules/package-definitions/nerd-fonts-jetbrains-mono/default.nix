# nerd-fonts-jetbrains-mono package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "nerd-fonts-jetbrains-mono";

  metadata = presets.crossPlatformUserPackage "theme-consumer";

  backends = {
    home-manager = {
      home =
        ../../projection/backends/home-manager/packages/nerd-fonts-jetbrains-mono.nix;
      system = null;
    };
    nixos = {
      home =
        ../../projection/backends/home-manager/packages/nerd-fonts-jetbrains-mono.nix;
      system = null;
    };
    nix-darwin = {
      home =
        ../../projection/backends/home-manager/packages/nerd-fonts-jetbrains-mono.nix;
      system = null;
    };
  };
}
