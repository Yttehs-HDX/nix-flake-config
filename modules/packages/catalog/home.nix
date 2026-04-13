# Home-scope package metadata registry.
#
# This registry is derived only from package definitions in
# modules/package-definitions.
let
  taxonomy = import ../taxonomy.nix;
  inherit (taxonomy) targets;

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

in homeDefinitionMetadata
