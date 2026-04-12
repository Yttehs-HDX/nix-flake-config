{ input, ... }:
{ ... }: {
  networking = {
    hostName = input.hostId;
    extraHosts = ''
      127.0.0.1 localhost
      ::1 localhost
      127.0.0.1 ${input.hostId}.local
    '';
    networkmanager.enable = true;
  };
}
