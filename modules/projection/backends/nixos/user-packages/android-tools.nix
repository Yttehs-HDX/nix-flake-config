{ input }:
{ ... }: {
  programs.adb.enable = true;
  users.users.${input.identity.name}.extraGroups = [ "adbusers" ];
}
