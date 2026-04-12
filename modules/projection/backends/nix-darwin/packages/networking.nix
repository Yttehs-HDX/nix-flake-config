{ input, ... }:
{ lib, ... }: {
  networking = {
    hostName = lib.mkDefault input.hostId;
    localHostName = lib.mkDefault input.hostId;
    computerName = lib.mkDefault input.hostId;
  };
}
