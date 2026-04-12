# Home-scope package metadata registry.
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
    crossPlatformUserPackage linuxDesktopUser linuxDesktopHost darwinHintManual;
  inherit (taxonomy) targets missingStrategies owners;

  # Load package definitions
  lib = builtins; # Minimal lib for filtering
  packageDefinitions = import ../../package-definitions { inherit lib; };

  # Extract metadata from definitions for home-scope packages
  # Filter to only packages that have home targets in their allowedTargets
  homeDefinitionMetadata = builtins.mapAttrs (id: def: def.metadata)
    (builtins.listToAttrs (builtins.filter (item: item != null) (map (id:
      let
        def = packageDefinitions.${id};
        hasHomeTarget = builtins.any (target:
          target == taxonomy.targets.nixosHome || target
          == taxonomy.targets.darwinHome || target
          == taxonomy.targets.standaloneHomeManagerHome)
          def.metadata.allowedTargets;
      in if hasHomeTarget then {
        name = id;
        value = def;
      } else
        null) (builtins.attrNames packageDefinitions))));

  # Fully migrated in Phase 1: keep an explicit empty legacy set for clarity.
  legacyEntries = { };
  # Merge definitions (preferred) with legacy entries (fallback)
  # Definitions override legacy entries for the same package ID
in legacyEntries // homeDefinitionMetadata
