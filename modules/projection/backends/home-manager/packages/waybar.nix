{ input, definition, ... }:
{ lib, pkgs, ... }:
let
  firstNonNull = values:
    let filtered = builtins.filter (value: value != null) values;
    in if filtered == [ ] then null else builtins.head filtered;
  desktopTheme =
    if input.theme != null then input.theme.desktop or null else null;
  waybarTheme = if desktopTheme != null then
    desktopTheme.consumers.waybar or null
  else
    null;
  fontFamily = firstNonNull [
    (definition.settings.fontFamily or null)
    (if waybarTheme != null then waybarTheme.font.family or null else null)
    "DejaVu Sans"
  ];
  playerTitleCmd = "playerctl metadata --format='{{ title }}' --follow";
  playPauseCmd = "playerctl play-pause";
  toggleMuteCmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
  toggleNotificationCmd = "swaync-client -t";
  menuCmd = definition.settings.menuCommand or "hexecute";
in {
  home.packages = [ pkgs.playerctl ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.main = {
      layer = "top";
      position = "top";
      mode = "dock";
      height = 32;
      exclusive = true;
      passthrough = false;
      gtk-layer-shell = true;
      ipc = true;
      fixed-center = true;
      margin-top = 5;
      margin-left = 5;
      margin-right = 5;
      margin-bottom = 0;

      modules-left = [ "group/hyprland" "group/misc" ];
      modules-center = [ ];
      modules-right = [ "group/monitor" "group/connection" "group/menu" ];

      "group/hyprland" = {
        orientation = "horizontal";
        modules = [ "hyprland/workspaces" "hyprland/window" ];
      };

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        active-only = false;
        format = "{icon}";
        format-icons = {
          "1" = "壱";
          "2" = "弐";
          "3" = "参";
          "4" = "肆";
          "5" = "伍";
          "6" = "陸";
          "7" = "漆";
          "8" = "捌";
          "9" = "玖";
          "10" = "拾";
        };
        on-click = "activate";
        persistent-workspaces = { "*" = [ 1 2 3 4 5 6 ]; };
      };

      "hyprland/window" = {
        format = "{class}";
        icon = true;
        icon-size = 15;
      };

      "group/misc" = {
        orientation = "horizontal";
        modules = [ "clock" "custom/lyric" ];
      };

      clock = {
        format = "󰥔  {:%H:%M}";
        format-alt = "󰃭  {:%Y-%m-%d %A}";
        locale = "C";
        tooltip-format = ''
          <big>{:%Y %B}</big>
          <tt><small><span font='JetbrainsMono Nerd Font'>{calendar}</span></small></tt>'';
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          weeks-pos = "right";
          format = lib.optionalAttrs (waybarTheme != null) {
            months =
              "<span color='${waybarTheme.calendar.months}'><b>{}</b></span>";
            days =
              "<span color='${waybarTheme.calendar.days}'><b>{}</b></span>";
            weeks =
              "<span color='${waybarTheme.calendar.weeks}'><b>W{}</b></span>";
            weekdays =
              "<span color='${waybarTheme.calendar.weekdays}'><b>{}</b></span>";
            today =
              "<span color='${waybarTheme.calendar.today}'><b><u>{}</u></b></span>";
          };
        };
        actions.on-click-right = "mode";
        interval = 1;
        timezone = definition.settings.timezone or "Asia/Taipei";
      };

      "custom/lyric" = {
        exec = playerTitleCmd;
        format = "󰎆  {}";
        tooltip-format = "Play/Pause";
        on-click = playPauseCmd;
        escape = true;
        return-type = "text";
        max-length = definition.settings.playerTitleMaxLength or 25;
      };

      "group/monitor" = {
        orientation = "horizontal";
        modules = [ "cpu" "memory" "backlight" "pulseaudio" ];
      };

      cpu = {
        interval = 10;
        format = "  {usage}";
      };

      memory = {
        interval = 30;
        format = "  {percentage}";
        max-length = 10;
      };

      backlight = {
        format = "{icon} {percent}";
        format-icons = [ " " " " " " " " " " " " " " " " " " ];
      };

      pulseaudio = {
        format = "{icon} {volume}";
        format-bluetooth = "  {volume}";
        format-muted = " ";
        format-icons.default = [ "" " " " " ];
        on-click = toggleMuteCmd;
      };

      "group/connection" = {
        orientation = "horizontal";
        modules = [ "network" "bluetooth" ];
      };

      network = {
        interface = definition.settings.networkInterface or "wlo1";
        format = "{icon}";
        format-icons = {
          wifi = [ "󰤯 " "󰤟 " "󰤢 " "󰤥 " "󰤨 " ];
          ethernet = [ "󰈀 " ];
          disconnected = [ "󰤭 " ];
        };
        tooltip-format-wifi = "{essid} ({signalStrength}%)";
        tooltip-format-ethernet = "{ifname}";
        tooltip-format-disconnected = "Disconnected";
      };

      bluetooth = {
        format = "";
        format-disabled = "󰂲";
        format-connected = "󰂱";
        tooltip-format = "{controller_alias}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-off = "Off";
        tooltip-format-disabled = "Off";
        tooltip-format-enumerate-connected =
          "{device_alias}	{device_battery_percentage}%";
      };

      "group/menu" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 300;
          transition-left-to-right = false;
        };
        modules = [ "battery" "tray" "custom/menu" ];
      };

      tray = {
        icon-size = 15;
        spacing = 10;
      };

      battery = {
        interval = 60;
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon}  {capacity}";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁾" "󰁿" "󰂀" "󰂁" "󰂁" "󰂂" "󰁹" ];
        on-click = toggleNotificationCmd;
      };

      "custom/menu" = {
        format = " ";
        tooltip-format = "Launcher";
        on-click = menuCmd;
      };
    };
  } // lib.optionalAttrs (waybarTheme != null) {
    style = ''
      @define-color rosewater ${waybarTheme.colors.rosewater};
      @define-color flamingo ${waybarTheme.colors.flamingo};
      @define-color pink ${waybarTheme.colors.pink};
      @define-color mauve ${waybarTheme.colors.mauve};
      @define-color red ${waybarTheme.colors.red};
      @define-color maroon ${waybarTheme.colors.maroon};
      @define-color peach ${waybarTheme.colors.peach};
      @define-color yellow ${waybarTheme.colors.yellow};
      @define-color green ${waybarTheme.colors.green};
      @define-color teal ${waybarTheme.colors.teal};
      @define-color sky ${waybarTheme.colors.sky};
      @define-color sapphire ${waybarTheme.colors.sapphire};
      @define-color blue ${waybarTheme.colors.blue};
      @define-color lavender ${waybarTheme.colors.lavender};
      @define-color accent ${waybarTheme.colors.accent};
      @define-color text ${waybarTheme.colors.text};
      @define-color subtext1 ${waybarTheme.colors.subtext1};
      @define-color subtext0 ${waybarTheme.colors.subtext0};
      @define-color overlay2 ${waybarTheme.colors.overlay2};
      @define-color overlay1 ${waybarTheme.colors.overlay1};
      @define-color overlay0 ${waybarTheme.colors.overlay0};
      @define-color surface2 ${waybarTheme.colors.surface2};
      @define-color surface1 ${waybarTheme.colors.surface1};
      @define-color surface0 ${waybarTheme.colors.surface0};
      @define-color surface0-alpha ${waybarTheme.colors.surface0Alpha};
      @define-color base-alpha ${waybarTheme.colors.baseAlpha};
      @define-color border-alpha ${waybarTheme.colors.borderAlpha};
      @define-color base ${waybarTheme.colors.base};
      @define-color mantle ${waybarTheme.colors.mantle};
      @define-color crust ${waybarTheme.colors.crust};

      * {
        font-family: ${fontFamily}, "Noto Sans CJK JP", "Noto Sans CJK TC", "Noto Sans CJK SC";
        font-size: ${toString (waybarTheme.font.size or 17)}px;
        min-height: 0;
      }

      #waybar {
        background: transparent;
        color: @text;
      }

      #hyprland,
      #misc,
      #monitor,
      #connection,
      #menu {
        border: 2px solid;
        border-color: @lavender;
        border-radius: 1rem;
        background-color: @surface0-alpha;
        padding: 0.5rem 0.7rem;
        margin: 0rem;
      }

      #hyprland {
        border-color: @sky;
        padding: 0.5rem 0rem 0.5rem 0.5rem;
      }

      #workspaces,
      #window {
        padding: 0rem 0rem;
      }

      #workspaces button {
        background: @surface1;
        color: @lavender;
        border-radius: 1rem;
        padding: 0rem 0.3rem;
        margin: 0rem 0.3rem;
      }

      #workspaces button.active,
      #workspaces button:hover {
        background: @sky;
        color: @surface1;
      }

      #window {
        margin: 0rem 0.4rem 0rem 0.1rem;
      }

      #misc {
        border-color: @blue;
      }

      #clock,
      #custom-lyric {
        margin: 0rem 0rem 0rem 0.7rem;
      }

      #clock {
        color: @blue;
        margin: 0rem;
      }

      #custom-lyric {
        color: @text;
      }

      #monitor,
      #connection {
        padding: 0.5rem 0.7rem;
        margin: 0rem 0.3rem 0rem 0rem;
      }

      #monitor {
        border-color: @yellow;
      }

      #cpu,
      #memory,
      #backlight,
      #pulseaudio {
        margin: 0rem 0.7rem 0rem 0rem;
      }

      #cpu {
        color: @peach;
      }

      #memory {
        color: @teal;
      }

      #backlight {
        color: @yellow;
      }

      #pulseaudio {
        color: @maroon;
        margin: 0rem;
      }

      #connection {
        border-color: @lavender;
      }

      #network,
      #bluetooth {
        margin: 0rem 0.7rem 0rem 0rem;
      }

      #network {
        color: @lavender;
      }

      #bluetooth {
        margin: 0rem;
        color: @mauve;
      }

      #menu {
        border-color: @green;
      }
    '';
  };
}
