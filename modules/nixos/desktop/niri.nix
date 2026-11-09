{ pkgs, ... }:

{
  imports = [
    ./common/audio.nix
    ./common/bluetooth.nix
    ./common/blueman.nix
    ./common/portal.nix
    ./common/sushi.nix
    ./common/udisks2.nix
    ./common/polkit.nix
    ./common/dbus.nix
    ./sddm.nix
    ../theme/catppuccin-mocha
  ];

  programs.niri.enable = true;

  services.dbus.packages = [ pkgs.swayosd ];
  systemd.packages = [ pkgs.swayosd ];
  systemd.services.swayosd-libinput-backend.wantedBy = [ "graphical.target" ];

  security.pam.services = {
    niri = { };
    swaylock = { };
  };
}
