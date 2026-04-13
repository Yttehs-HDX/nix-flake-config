# Git package definition
{ lib }:
let presets = import ../../package-governance/presets.nix;
in {
  packageId = "git";

  # Metadata - determines catalog entries and visibility/support rules
  metadata = presets.crossPlatformUserPackage "package";

  # Backend implementation references
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
