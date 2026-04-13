{ input, definition, ... }:
{ lib, pkgs, ... }:
let
  desktopTheme =
    if input.theme != null then input.theme.desktop or null else null;
  hyprlandTheme = if desktopTheme != null then
    desktopTheme.consumers.hyprland or null
  else
    null;
  activeBorderColors = if hyprlandTheme != null then
    hyprlandTheme.activeBorder or [ "#cba6f7" "#f5e0dc" ]
  else [
    "#cba6f7"
    "#f5e0dc"
  ];
  inactiveBorderColors = if hyprlandTheme != null then
    hyprlandTheme.inactiveBorder or [ "#b4befe" "#6c7086" ]
  else [
    "#b4befe"
    "#6c7086"
  ];
  expoBackground = if hyprlandTheme != null then
    hyprlandTheme.background or "#1e1e2e"
  else
    "#1e1e2e";
  sessionCommands = import
    ../../projection/backends/home-manager/integrations/session-commands.nix {
      inherit input;
    };
  stripHash = color: lib.removePrefix "#" color;
  rgba = color: alpha: "rgba(${stripHash color}${alpha})";
  preferredTerminal = input.current.user.preferences.terminal;
  terminalCmd =
    if preferredTerminal != null then preferredTerminal else "kitty";
  launcherCmd = definition.settings.launcherCommand or "rofi -show drun";
  ocrCmd = if input.packages.home ? ocr then "ocr" else null;
  emojiCmd = if input.packages.home ? rofimoji then
    "rofimoji --action copy --prompt '󰞅  emoji' --use-icons"
  else
    null;
  execOnce = lib.optionals (input.packages.home ? fcitx5) [ "fcitx5 -d" ];
  workspaceBindings = builtins.concatLists ((builtins.genList (i:
    let
      key = i + 1;
      workspace = toString key;
    in [
      "$mod, ${toString key}, workspace, ${workspace}"
      "$mod SHIFT, ${toString key}, movetoworkspace, ${workspace}"
    ]) 9)
    ++ [[ "$mod, 0, workspace, 10" "$mod SHIFT, 0, movetoworkspace, 10" ]]);
in {
  home.packages = [ pkgs.playerctl ];

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11,*";
    GDK_SCALE = 1;
    GDK_DPI_SCALE = 1;
    NIXOS_OZONE_WL = 1;
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    MOZ_ENABLE_WAYLAND = 1;
    OZONE_PLATFORM = "wayland";
    EGL_PLATFORM = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = definition.settings.xwaylandEnable or true;
    settings = {
      "$mod" = "SUPER";
      exec-once = execOnce;

      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];
      bind = [
        "$mod, Q, exec, ${terminalCmd}"
        "$mod, R, exec, ${launcherCmd}"
        "$mod, F, fullscreen"
        "$mod, C, killactive"
        "$mod, V, exec, hyprctl dispatch togglefloating"
        "$mod, TAB, hyprexpo:expo, toggle"
        "$mod, escape, exec, hexecute"
        "$mod, M, exec, hyprctl dispatch exit"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        "$mod, mouse_down, workspace, e-1"
        "$mod, mouse_up, workspace, e+1"
      ] ++ lib.optionals (sessionCommands.clipboard != null)
        [ "$mod, W, exec, ${sessionCommands.clipboard}" ]
        ++ lib.optionals (emojiCmd != null) [ "$mod, E, exec, ${emojiCmd}" ]
        ++ lib.optionals (sessionCommands.screenshot != null) [
          ", Print, exec, ${sessionCommands.screenshot}"
          "$mod SHIFT, S, exec, ${sessionCommands.screenshot}"
        ] ++ lib.optionals (ocrCmd != null) [ "$mod SHIFT, T, exec, ${ocrCmd}" ]
        ++ lib.optionals (sessionCommands.lock != null)
        [ "$mod ALT, L, exec, ${sessionCommands.lock}" ]
        ++ lib.optionals (sessionCommands.colorPicker != null)
        [ "$mod ALT, DELETE, exec, ${sessionCommands.colorPicker}" ] ++ [
          ", xf86KbdBrightnessUp, exec, brightnessctl -d *::kbd_backlight set 33%+"
          ", xf86KbdBrightnessDown, exec, brightnessctl -d *::kbd_backlight set 33%-"
        ] ++ workspaceBindings;

      general = {
        gaps_in = 2;
        gaps_out = 4.5;
        border_size = 2;
        "col.active_border" = rgba (builtins.elemAt activeBorderColors 0) "ff"
          + " " + rgba (builtins.elemAt activeBorderColors 1) "ff" + " 45deg";
        "col.inactive_border" =
          rgba (builtins.elemAt inactiveBorderColors 0) "cc" + " "
          + rgba (builtins.elemAt inactiveBorderColors 1) "cc" + " 45deg";
        resize_on_border = true;
        layout = "dwindle";
      };

      decoration = {
        shadow.enabled = false;
        rounding = 10;
        dim_special = 0.3;
        blur = {
          enabled = true;
          special = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
          ignore_opacity = true;
          xray = false;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "fluent_decel, 0.1, 1, 0, 1"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
        ];
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 2.5, md3_decel"
          "workspaces, 1, 3.5, easeOutExpo, slide"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };

      layerrule =
        [ "blur,rofi" "ignorezero,rofi" "blur,waybar" "ignorezero,waybar" ];

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 4;
          bg_col = rgba expoBackground "cc";
          workspace_method = "center current";
          gesture_distance = 300;
        };

        dynamic-cursors = {
          enabled = true;
          mode = "tilt";
        };
      };

      xwayland.force_zero_scaling = true;
    };
    plugins = [
      pkgs.hyprlandPlugins.hyprexpo
      pkgs.hyprlandPlugins."hypr-dynamic-cursors"
    ];
  } // lib.optionalAttrs (input.backend.type == "nixos") {
    package = null;
    portalPackage = null;
  };
}
