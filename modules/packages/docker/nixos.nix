{ input, definition, ... }:
{ ... }: {
  virtualisation.docker = {
    enable = true;
    storageDriver = definition.settings.storageDriver or "btrfs";
  };

  users.users.${input.identity.name}.extraGroups = [ "docker" ];
}
