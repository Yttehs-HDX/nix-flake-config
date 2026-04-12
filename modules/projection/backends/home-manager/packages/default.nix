{ lib, input }:
let
  # Load package definitions
  packageDefinitions = import ../../../../package-definitions { inherit lib; };

  # Build registry from definitions + legacy entries
  # Definitions take precedence over legacy hardcoded imports
  definitionRegistry = builtins.mapAttrs (id: def:
    let backendPath = def.backends.home-manager.home or null;
    in if backendPath == null then null else import backendPath)
    packageDefinitions;

  # Fully migrated in Phase 1: keep an explicit empty legacy set for clarity.
  legacyRegistry = { };

  # Merge definitions (preferred) with legacy entries (fallback)
  registry = legacyRegistry // definitionRegistry;

  resolve = packageId: definition:
    if builtins.hasAttr packageId registry then
      if registry.${packageId} == null then
        ({ ... }: { })
      else
        registry.${packageId} { inherit input definition; }
    else
      throw
      "Unsupported Home Manager package `${packageId}` on `${input.relationId}`.";
in map (packageId: resolve packageId input.packages.home.${packageId})
(lib.sort lib.lessThan (builtins.attrNames input.packages.home))
