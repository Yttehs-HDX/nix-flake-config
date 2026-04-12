{ lib, profile }:
let normalizePackages = import ./packages.nix { inherit lib; };
in lib.mapAttrs (hostId: host:
  host // {
    inherit hostId;
    packages = normalizePackages.host host;
  }) profile.hosts
