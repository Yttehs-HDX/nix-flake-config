{ lib, input }:
let
  registry = {
    docker = import ./docker.nix;
    hello = import ./hello.nix;
    networking = import ./networking.nix;
    wireshark = import ./wireshark.nix;
  };

  resolve = packageId: definition:
    if builtins.hasAttr packageId registry then
      registry.${packageId} { inherit input definition; }
    else
      throw
      "Unsupported nix-darwin package `${packageId}` on host `${input.hostId}`.";
in map (packageId: resolve packageId input.packages.system.${packageId})
(lib.sort lib.lessThan (builtins.attrNames input.packages.system))
