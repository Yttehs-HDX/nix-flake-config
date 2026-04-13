# Neovim package definition
{ lib }:
let taxonomy = import ../../package-governance/taxonomy.nix;
in {
  packageId = "neovim";

  metadata = {
    kind = "integration-heavy";
    owner = taxonomy.owners.user;
    allowedHostKinds = [ "nixos" ];
    allowedTargets = [ taxonomy.targets.nixosHome ];
    requiresDesktop = false;
    missingStrategy = taxonomy.missingStrategies.hintManual;
    unsupportedReason =
      "Neovim default-editor integration is currently implemented only for NixOS backends.";
    unsupportedSuggestion =
      "Use a NixOS backend for automatic neovim default-editor setup, or use `packages.nixvim` for Home Manager-level editor configuration.";
  };

  # Phase 1: no dedicated projector yet, keep behavior equivalent to legacy null entry
  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ./nixos.nix;
    };
    nix-darwin = {
      home = null;
      system = null;
    };
  };
}
