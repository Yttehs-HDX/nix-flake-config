{ lib, input }:
let
  registry = {
    docker = import ./docker.nix;
    hello = import ./hello.nix;
    nix-ld = import ./nix-ld.nix;
    wireshark = import ./wireshark.nix;
  };

  resolve = softwareId: definition:
    if builtins.hasAttr softwareId registry then
      registry.${softwareId} { inherit input definition; }
    else
      throw
      "Unsupported NixOS software `${softwareId}` on host `${input.hostId}`.";
in map (softwareId: resolve softwareId input.software.system.${softwareId})
(lib.sort lib.lessThan (builtins.attrNames input.software.system))
