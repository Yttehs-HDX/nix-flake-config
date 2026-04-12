# Git package definition
{ lib }:
let
  presets = import ../../packages/presets.nix;
in
{
  packageId = "git";

  # Metadata - determines catalog entries and visibility/support rules
  metadata = presets.crossPlatformUserPackage "package";

  # Backend implementation references
  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/git.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/git.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/git.nix;
      system = null;
    };
  };
}
