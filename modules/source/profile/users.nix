{ lib, ... }:
let
  schema = import ../../schema/default.nix { inherit lib; };
in {
  options.profile.users = lib.mkOption {
    type = lib.types.attrsOf schema.userType;
    default = { };
    description = "User source declarations.";
  };
}
