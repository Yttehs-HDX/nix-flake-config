{ input }:
{ ... }: {
  users.users.${input.identity.name}.extraGroups = [ "uucp" "dialout" ];
}
