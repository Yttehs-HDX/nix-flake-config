{ lib, input }:
let
  # Load package definitions
  packageDefinitions = import ../../../../package-definitions { inherit lib; };

  # Build registry directly from package definitions.
  definitionRegistry = builtins.mapAttrs (id: def:
    let backendPath = def.backends.nixos.system or null;
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
      "Unsupported NixOS package `${packageId}` on host `${input.hostId}`.";
in map (packageId: resolve packageId input.packages.system.${packageId})
(lib.sort lib.lessThan (builtins.attrNames input.packages.system))
