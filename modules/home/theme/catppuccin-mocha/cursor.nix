{ pkgs, ... }:

{
  home.pointerCursor = {
    name = "catppuccin-mocha-lavender-cursors";
    package = pkgs.catppuccin-cursors.mochaLavender;
    size = 24;
  };
}
