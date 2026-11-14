{
  imports = [
    ./common/audio.nix
    ./common/bluetooth.nix
    ./common/portal.nix
    ./common/udisks2.nix
    ./common/polkit.nix
    ./common/dbus.nix
    ./dux-files.nix
    ./dux-greeter.nix
  ];

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  services.accounts-daemon.enable = true;

  security.pam.services = {
    niri = { };
    dankshell = { };
  };
}
