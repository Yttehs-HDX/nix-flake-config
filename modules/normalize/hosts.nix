{ lib, profile }:
let normalizeSoftware = import ./software.nix { inherit lib; };
in lib.mapAttrs (hostId: host:
  host // {
    inherit hostId;
    software = normalizeSoftware.host host;
  }) profile.hosts
