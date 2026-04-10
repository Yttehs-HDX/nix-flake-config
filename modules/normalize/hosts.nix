{ lib, profile }:
lib.mapAttrs (hostId: host: host // { inherit hostId; }) profile.hosts
