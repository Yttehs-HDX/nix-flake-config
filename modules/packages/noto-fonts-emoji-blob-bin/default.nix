# noto-fonts-emoji-blob-bin package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "noto-fonts-emoji-blob-bin";

  metadata = presets.crossPlatformUserPackage "theme-consumer";

  backends = {
    home-manager = {
      home = ./home.nix;
      system = null;
    };
    nixos = {
      home = ./home.nix;
      system = null;
    };
    nix-darwin = {
      home = ./home.nix;
      system = null;
    };
  };
}
