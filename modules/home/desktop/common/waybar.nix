{ lib, pkgs, ... }:

let
  idleInhibitorService = "waybar-idle-inhibitor.service";
  idleInhibitor = pkgs.writeShellApplication {
    name = "waybar-idle-inhibitor";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      case "''${1:-status}" in
        toggle)
          if systemctl --user is-active --quiet ${idleInhibitorService}; then
            systemctl --user stop ${idleInhibitorService}
          else
            systemctl --user start ${idleInhibitorService}
          fi
          ;;
        status)
          if systemctl --user is-active --quiet ${idleInhibitorService}; then
            printf '%s\n' '{"text":" ","tooltip":"Keep awake","class":"activated"}'
          else
            printf '%s\n' '{"text":"󰤄","tooltip":"Allow idle","class":"deactivated"}'
          fi
          ;;
        *)
          printf 'usage: waybar-idle-inhibitor {status|toggle}\n' >&2
          exit 2
          ;;
      esac
    '';
  };
in
{
  systemd.user.services.waybar-idle-inhibitor = {
    Unit = {
      Description = "Waybar idle inhibitor";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service.ExecStart = ''
      ${pkgs.systemd}/bin/systemd-inhibit \
        --what=idle \
        --who=Waybar \
        --why="Waybar caffeine mode" \
        --mode=block \
        ${pkgs.coreutils}/bin/sleep infinity
    '';
  };

  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings.main =
      let
        niriWindows = pkgs.buildGoModule {
          pname = "waybar-niri-windows";
          version = "2.3.1";
          src = pkgs.fetchFromGitHub {
            owner = "calico32";
            repo = "waybar-niri-windows";
            rev = "17828f901b56250e88acb421054b87ef311d8f3a";
            hash = "sha256-bnPxKRugnIGj/Od8R+6PAl0MRhhl361H9rYydCWQ/yw=";
          };
          vendorHash = "sha256-jK87vZYfUe8znk65SmJ1mN8qP5K3dtt950hKGWTYXs4=";
          nativeBuildInputs = [ pkgs.pkg-config ];
          buildInputs = [ pkgs.gtk3 ];
          buildPhase = "make waybar-niri-windows.so";
          checkPhase = "go test ./jsonc ./niri";
          installPhase = ''install -Dm644 waybar-niri-windows.so "$out/lib/waybar-niri-windows.so"'';
        };
      in
      {
        layer = "top";
        position = "top";
        mode = "dock";
        height = 38;
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        ipc = true;
        fixed-center = true;
        margin-top = 1;
        margin-left = 1;
        margin-right = 1;
        margin-bottom = 0;

        modules-left = [
          "group/niri"
          "cava"
        ];
        modules-center = [ "group/misc" ];
        modules-right = [
          "group/monitor"
          "group/connection"
          "group/quick"
          "group/power"
        ];

        "group/niri" = {
          orientation = "horizontal";
          modules = [
            "niri/workspaces"
            "cffi/niri-windows"
            "niri/window"
          ];
        };

        "niri/workspaces" = {
          disable-click = false;
          all-outputs = false;
          current-only = false;
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
        };

        "cffi/niri-windows" = {
          module_path = "${niriWindows}/lib/waybar-niri-windows.so";
          options = {
            on-tile-middle-click = "";
            icon-minimum-size = 14;
            rules = [
              {
                app-id = "(?i)^kitty$";
                class = "terminal";
                icon = "";
              }
              {
                app-id = "(?i)^google-chrome$";
                class = "browser";
                icon = "";
              }
              {
                app-id = "(?i)^code$";
                class = "editor";
                icon = "󰨞";
              }
              {
                app-id = "(?i)^discord$";
                class = "discord";
                icon = "󰙯";
              }
              {
                app-id = "(?i)^qq$";
                class = "qq";
                icon = "";
              }
              {
                app-id = "(?i)^wechat$";
                class = "wechat";
                icon = "";
              }
              {
                app-id = "(?i)^vlc$";
                class = "vlc";
                icon = "󰕼";
              }
              {
                app-id = "(?i)^(org[.]kde[.])?krita$";
                class = "krita";
                icon = "";
              }
              {
                app-id = "(?i)^mpv$";
                class = "mpv";
                icon = "";
              }
              {
                app-id = "(?i)^jetbrains-studio$";
                class = "android-studio";
                icon = "";
              }
              {
                app-id = "(?i)^(md[.]obsidian[.])?obsidian$";
                class = "obsidian";
                icon = "";
              }
              {
                class = "default";
                icon = "󰞅";
              }
            ];
          };
        };

        "niri/window" = {
          format = "{app_id}";
          max-length = 18;
          icon = true;
          icon-size = 15;
          separate-outputs = true;
        };

        cava = {
          hide_on_silence = true;
          framerate = 60;
          bars = 8;
          format-icons = [
            "▁"
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
          input_delay = 1;
          sleep_timer = 5;
          bar_delimiter = 0;
          on-click = "playerctl play-pause";
        };

        "group/misc" = {
          orientation = "horizontal";
          modules = [
            "clock"
            "custom/lyric"
          ];
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
            format = {
              months = "<span color='#f5e0dc'><b>{}</b></span>";
              days = "<span color='#f5c2e7'><b>{}</b></span>";
              weeks = "<span color='#94e2d5'><b>W{}</b></span>";
              weekdays = "<span color='#f9e2af'><b>{}</b></span>";
              today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
            };
          };
          actions.on-click-right = "mode";
          interval = 1;
          timezone = "Asia/Taipei";
        };

        "custom/lyric" = {
          exec = "playerctl metadata --format='{{ title }}' --follow";
          format = "󰎆  {}";
          tooltip-format = "Play/Pause";
          on-click = "playerctl play-pause";
          escape = true;
          return-type = "text";
          max-length = 25;
        };

        "group/monitor" = {
          orientation = "horizontal";
          modules = [
            "cpu"
            "memory"
            "backlight"
            "pulseaudio"
          ];
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
          format-icons = [
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
          ];
        };

        pulseaudio = {
          format = "{icon} {volume}";
          format-bluetooth = "  {volume}";
          format-muted = " ";
          format-icons.default = [
            ""
            " "
            " "
          ];
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };

        "group/connection" = {
          orientation = "horizontal";
          modules = [
            "network"
            "bluetooth"
          ];
        };

        network = {
          interface = "wlo1";
          format = "{icon}";
          format-icons = {
            wifi = [
              "󰤯 "
              "󰤟 "
              "󰤢 "
              "󰤥 "
              "󰤨 "
            ];
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
          tooltip-format-enumerate-connected = "{device_alias}	{device_battery_percentage}%";
        };

        "group/quick" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 300;
            transition-left-to-right = false;
          };
          modules = [
            "custom/hexecute"
            "tray"
          ];
        };

        tray = {
          icon-size = 15;
          spacing = 6;
        };

        "group/power" = {
          orientation = "inherit";
          modules = [
            "custom/idle-inhibitor"
            "battery"
          ];
        };

        "custom/idle-inhibitor" = {
          exec = "${idleInhibitor}/bin/waybar-idle-inhibitor status";
          on-click = "${idleInhibitor}/bin/waybar-idle-inhibitor toggle";
          return-type = "json";
          interval = 1;
        };

        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          on-click = "swaync-client -t";
        };

        "custom/hexecute" = {
          format = " ";
          tooltip-format = "魔法使い";
          on-click = "hexecute";
        };
      };
  };
}
