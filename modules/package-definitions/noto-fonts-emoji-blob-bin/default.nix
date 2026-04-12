# noto-fonts-emoji-blob-bin package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "noto-fonts-emoji-blob-bin";

  metadata = presets.crossPlatformUserPackage "theme-consumer";

  backends = {
    home-manager = {
      home =
        ../../projection/backends/home-manager/packages/noto-fonts-emoji-blob-bin.nix;
      system = null;
    };
    nixos = {
      home =
        ../../projection/backends/home-manager/packages/noto-fonts-emoji-blob-bin.nix;
      system = null;
    };
    nix-darwin = {
      home =
        ../../projection/backends/home-manager/packages/noto-fonts-emoji-blob-bin.nix;
      system = null;
    };
  };
}
