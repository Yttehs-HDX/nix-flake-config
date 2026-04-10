{ input }:
{ lib, ... }:
let
  description = if input.current.user.meta.displayName != null then
    input.current.user.meta.displayName
  else
    input.userId;
in {
  users.knownUsers = [ input.identity.name ];

  users.users.${input.identity.name} = {
    name = input.identity.name;
    createHome = true;
    description = description;
    home = input.identity.homeDirectory;
  } // lib.optionalAttrs (input.identity.uid != null) {
    uid = input.identity.uid;
  };
}
