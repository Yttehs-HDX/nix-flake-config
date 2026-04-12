# Hyprland package definition
{ lib }:
let
  presets = import ../../packages/presets.nix;
in
{
  packageId = "hyprland";

  # Metadata - Linux desktop user package
  metadata = presets.linuxDesktopUser "desktop-session";

  # Default settings
  defaultSettings = {
    xwaylandEnable = true;
    launcherCommand = "rofi -show drun";
  };

  # Backend implementation references
  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/hyprland.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/hyprland.nix;
      system = null;  # Could add system-level hyprland setup here
    };
    nix-darwin = {
      home = null;  # Not supported on Darwin
      system = null;
    };
  };
}
