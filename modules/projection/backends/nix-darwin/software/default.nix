{ lib, input }:
let
  registry = { hello = import ./hello.nix; };

  resolve = softwareId: definition:
    if builtins.hasAttr softwareId registry then
      registry.${softwareId} { inherit input definition; }
    else
      throw
      "Unsupported nix-darwin software `${softwareId}` on host `${input.hostId}`.";
in map (softwareId: resolve softwareId input.software.system.${softwareId})
(lib.sort lib.lessThan (builtins.attrNames input.software.system))
