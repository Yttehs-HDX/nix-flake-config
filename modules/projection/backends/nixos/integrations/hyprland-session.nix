{ input }:
{ ... }: {
  programs.hyprland = {
    enable = true;
    withUWSM = input.packages.home.hyprland.settings.withUWSM or false;
    xwayland.enable =
      input.packages.home.hyprland.settings.xwaylandEnable or true;
  };
}
