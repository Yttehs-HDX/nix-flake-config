{ input }:
{ lib, pkgs, ... }:
let
  homePackages = input.packages.home or { };
  hasPackage = packageId: builtins.hasAttr packageId homePackages;
  hasWaylandSession = hasPackage "hyprland" || hasPackage "niri";
  hasHyprlandSession = hasPackage "hyprland";
  hasNiriSession = hasPackage "niri";
  lockCommand = if hasPackage "swaylock-effects" then
    "swaylock-themed"
  else
    "${lib.getExe pkgs.swaylock} -fF";
in lib.mkMerge [
  (lib.mkIf (hasWaylandSession && hasPackage "cliphist") {
    services.cliphist = {
      enable = true;
      allowImages = false;
    };
  })

  (lib.mkIf (hasWaylandSession && hasPackage "hyprpolkitagent") {
    services.hyprpolkitagent.enable = true;
  })

  (lib.mkIf (hasWaylandSession && hasPackage "swww") {
    services.swww.enable = true;
  })

  (lib.mkIf (hasHyprlandSession && hasPackage "hypridle") {
    services.hypridle = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = lockCommand;
        };
        listener = [
          {
            timeout = 300;
            on-timeout = lockCommand;
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  })

  (lib.mkIf (hasNiriSession && hasPackage "swayidle") {
    services.swayidle = {
      enable = true;
      events = [{
        event = "before-sleep";
        command = lockCommand;
      }];
      timeouts = [
        {
          timeout = 300;
          command = lockCommand;
        }
        {
          timeout = 600;
          command = "niri msg action power-off-monitors";
        }
      ];
    };
  })
]
