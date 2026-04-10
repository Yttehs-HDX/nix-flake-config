{ lib, input }:
let
  registry = { hello = import ./hello.nix; };

  resolve = packageId: definition:
    if builtins.hasAttr packageId registry then
      registry.${packageId} { inherit input definition; }
    else
      throw
      "Unsupported nix-darwin package `${packageId}` on host `${input.hostId}`.";
in map (packageId: resolve packageId input.packages.system.${packageId})
(lib.sort lib.lessThan (builtins.attrNames input.packages.system))
