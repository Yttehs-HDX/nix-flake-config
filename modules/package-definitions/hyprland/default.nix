# Hyprland package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "hyprland";

  # Metadata - Linux desktop user package
  metadata = presets.linuxDesktopUser "desktop-session";

  # Backend implementation references
  backends = {
    home-manager = {
      home = ./home.nix;
      system = null;
    };
    nixos = {
      home = ./home.nix;
      system = null; # Could add system-level hyprland setup here
    };
    nix-darwin = {
      home = null; # Not supported on Darwin
      system = null;
    };
  };
}
