{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.catppuccin-cursors.mochaLavender ];

  environment.sessionVariables = {
    XCURSOR_THEME = "catppuccin-mocha-lavender-cursors";
    XCURSOR_SIZE = "24";
  };
}
