{ definition, ... }:
{ ... }: {
  virtualisation.docker = {
    enable = true;
    storageDriver = definition.settings.storageDriver or "btrfs";
  };
}
