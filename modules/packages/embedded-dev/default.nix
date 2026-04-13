# Embedded-dev package definition
{ lib }:
let taxonomy = import ../../package-governance/taxonomy.nix;
in {
  packageId = "embedded-dev";

  metadata = {
    kind = "integration-heavy";
    owner = taxonomy.owners.user;
    allowedHostKinds = [ "nixos" ];
    allowedTargets = [ taxonomy.targets.nixosHome ];
    requiresDesktop = false;
    missingStrategy = taxonomy.missingStrategies.hintManual;
    unsupportedReason =
      "This package currently relies on NixOS-side integration and is not implemented on this backend.";
    unsupportedSuggestion =
      "Use a NixOS backend for automatic setup, or configure the toolchain manually.";
  };

  # Phase 1: preserve legacy behavior (no projector output)
  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = null;
    };
    nix-darwin = {
      home = null;
      system = null;
    };
  };
}
