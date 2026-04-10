{ lib, normalized, validation }:
let instances = import ./instances.nix { inherit lib normalized; };
in builtins.deepSeq validation instances
