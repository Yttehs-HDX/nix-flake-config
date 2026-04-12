{ lib, input }:
let
  # Load package definitions
  packageDefinitions = import ../../../../package-definitions { inherit lib; };

  # Build registry from definitions + legacy entries
  # Definitions take precedence over legacy hardcoded imports
  definitionRegistry = builtins.mapAttrs (id: def:
    let backendPath = def.backends.nix-darwin.system or null;
    in if backendPath == null then null else import backendPath)
    packageDefinitions;

  # Legacy inline entries (to be migrated to package definitions)
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
      "Unsupported nix-darwin package `${packageId}` on host `${input.hostId}`.";
in map (packageId: resolve packageId input.packages.system.${packageId})
(lib.sort lib.lessThan (builtins.attrNames input.packages.system))
