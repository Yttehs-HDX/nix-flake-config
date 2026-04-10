{ lib, ... }:
let schema = import ../../schema/default.nix { inherit lib; };
in {
  options.profile.relations = lib.mkOption {
    type = lib.types.attrsOf schema.relationType;
    default = { };
    description = "Relation source declarations.";
  };
}
