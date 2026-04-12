# Hello package definition
# Note: hello supports both home and system scopes (used in tests for both)
{ lib }:
let
  presets = import ../../packages/presets.nix;
  taxonomy = import ../../packages/taxonomy.nix;
in
{
  packageId = "hello";

  # Metadata - cross-platform package available in both home and system scopes
  metadata = {
    kind = "package";
    owner = taxonomy.owners.host;
    allowedHostKinds = taxonomy.allHostKinds;
    allowedTargets = taxonomy.allTargets;
    requiresDesktop = false;
    missingStrategy = taxonomy.missingStrategies.notApplicable;
  };

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
