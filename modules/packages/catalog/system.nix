# System-scope package metadata registry.
#
# This registry is derived only from package definitions in
# modules/package-definitions.
let
  taxonomy = import ../taxonomy.nix;
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

in systemDefinitionMetadata
