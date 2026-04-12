# System-scope package metadata registry.
#
# This registry now merges two sources:
# 1. Package definitions from modules/package-definitions (preferred)
# 2. Legacy inline entries (to be migrated)
#
# Packages with definitions take precedence. Legacy entries remain for
# packages not yet migrated to the definition system.
let
  presets = import ../presets.nix;
  taxonomy = import ../taxonomy.nix;
  inherit (presets)
    linuxSystemHost crossPlatformSystemHost linuxDesktopSystemHost;
  inherit (taxonomy) targets;

  # Load package definitions
  lib = builtins; # Minimal lib for filtering
  packageDefinitions = import ../../package-definitions { inherit lib; };

  # Extract metadata from definitions for system-scope packages
  # Filter to only packages that have system targets in their allowedTargets
  systemDefinitionMetadata = builtins.mapAttrs (id: def: def.metadata)
    (builtins.listToAttrs (builtins.filter (item: item != null) (map (id:
      let
        def = packageDefinitions.${id};
        hasSystemTarget = builtins.any (target:
          target == taxonomy.targets.nixosSystem || target
          == taxonomy.targets.darwinSystem) def.metadata.allowedTargets;
      in if hasSystemTarget then {
        name = id;
        value = def;
      } else
        null) (builtins.attrNames packageDefinitions))));

  # Fully migrated in Phase 1 for system scope: keep explicit empty legacy set.
  legacyEntries = { };
  # Merge definitions (preferred) with legacy entries (fallback)
  # Definitions override legacy entries for the same package ID
in legacyEntries // systemDefinitionMetadata
