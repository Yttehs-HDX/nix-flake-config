# Hello package definition
{ lib }:
let
  presets = import ../../packages/presets.nix;
in
{
  packageId = "hello";

  # Metadata for catalog derivation
  metadata = presets.crossPlatformUserPackage "package";

  # Backend implementation references
  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/hello.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/hello.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/hello.nix;
      system = null;
    };
  };
}
