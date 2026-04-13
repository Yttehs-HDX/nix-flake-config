{ ... }:
{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.asusctl ];

  services.asusd = {
    enable = true;
    enableUserService = true;
  };
}
