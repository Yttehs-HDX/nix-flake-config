{ lib, ... }:
let
  schema = import ../../schema/default.nix { inherit lib; };
in {
  options.profile.hosts = lib.mkOption {
    type = lib.types.attrsOf schema.hostType;
    default = { };
    description = "Host source declarations.";
  };
}
