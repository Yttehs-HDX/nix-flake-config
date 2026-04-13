{ lib, input }:
let
  # Load package definitions
  packageDefinitions = import ../../../../package-definitions { inherit lib; };

  # Build registry directly from package definitions.
  definitionRegistry = builtins.mapAttrs (id: def:
    let backendPath = def.backends.home-manager.home or null;
    in if backendPath == null then null else import backendPath)
    packageDefinitions;

  resolve = packageId: definition:
    if builtins.hasAttr packageId definitionRegistry then
      if definitionRegistry.${packageId} == null then
        ({ ... }: { })
      else
        definitionRegistry.${packageId} { inherit input definition; }
    else
      throw
      "Unsupported Home Manager package `${packageId}` on `${input.relationId}`.";
in map (packageId: resolve packageId input.packages.home.${packageId})
(lib.sort lib.lessThan (builtins.attrNames input.packages.home))
