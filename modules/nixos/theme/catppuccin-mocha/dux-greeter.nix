{ pkgs, ... }:

{
  systemd.services.greetd.environment = {
    XCURSOR_THEME = "catppuccin-mocha-lavender-cursors";
    XCURSOR_SIZE = "24";
    XCURSOR_PATH = "${pkgs.catppuccin-cursors.mochaLavender}/share/icons";
  };
}
