{ input }:
{ lib, ... }:
let
  description = if input.current.user.meta.displayName != null then
    input.current.user.meta.displayName
  else
    input.userId;
in {
  users.users.${input.identity.name} = {
    isNormalUser = true;
    inherit description;
    home = input.identity.homeDirectory;
    extraGroups = input.membership.extraGroups;
  } // lib.optionalAttrs (input.membership.primaryGroup != null) {
    group = input.membership.primaryGroup;
  } // lib.optionalAttrs (input.identity.uid != null) {
    uid = input.identity.uid;
  } // lib.optionalAttrs (input.account.initialHashedPassword != null) {
    initialHashedPassword = input.account.initialHashedPassword;
  };
}
