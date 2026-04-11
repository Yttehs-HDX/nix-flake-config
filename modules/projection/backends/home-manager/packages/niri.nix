{ ... }:
{ lib, ... }: {
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = lib.mkForce "niri";
    XDG_SESSION_DESKTOP = lib.mkForce "niri";
    XDG_SESSION_TYPE = lib.mkForce "wayland";
    GDK_BACKEND = lib.mkForce "wayland,x11,*";
    GDK_SCALE = lib.mkForce 1;
    GDK_DPI_SCALE = lib.mkForce 1;
    NIXOS_OZONE_WL = lib.mkForce 1;
    ELECTRON_OZONE_PLATFORM_HINT = lib.mkForce "auto";
    MOZ_ENABLE_WAYLAND = lib.mkForce 1;
    OZONE_PLATFORM = lib.mkForce "wayland";
    EGL_PLATFORM = lib.mkForce "wayland";
    CLUTTER_BACKEND = lib.mkForce "wayland";
    SDL_VIDEODRIVER = lib.mkForce "wayland";
    QT_QPA_PLATFORM = lib.mkForce "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = lib.mkForce 1;
    QT_AUTO_SCREEN_SCALE_FACTOR = lib.mkForce 1;
  };

  xdg.configFile."niri/input.kdl".text = ''
    input {
        keyboard {
            numlock
        }

        touchpad {
            tap
            natural-scroll
        }
    }
  '';

  xdg.configFile."niri/layout.kdl".text = ''
    layout {
        gaps 6
        center-focused-column "on-overflow"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width {
            proportion 0.5
        }

        focus-ring {
            off
        }

        border {
            width 2
            active-gradient from="#ca9ee6" to="#f2d5cf" angle=45 relative-to="workspace-view"
            inactive-gradient from="#b4befecc" to="#6c7086cc" angle=45 relative-to="workspace-view"
            urgent-color "#f38ba8"
        }
    }
  '';

  xdg.configFile."niri/bindings.kdl".text = ''
    binds {
        Mod+Q repeat=false { spawn "kitty"; }
        Mod+R repeat=false { spawn-sh "rofi -show drun"; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C repeat=false { close-window; }
        Mod+V { toggle-window-floating; }
        Mod+Tab repeat=false { toggle-overview; }

        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up    { focus-window-up; }
        Mod+Down  { focus-window-down; }

        XF86AudioNext allow-when-locked=true { spawn "playerctl" "next"; }
        XF86AudioPause allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioPrev allow-when-locked=true { spawn "playerctl" "previous"; }
    }
  '';

  xdg.configFile."niri/window-rules.kdl".text = ''
    window-rule {
        match app-id=r#"^[Rr]ofi$"#
        open-floating true
    }

    window-rule {
        match app-id=r#"^swappy$"#
        open-floating true
    }
  '';

  xdg.configFile."niri/config.kdl".text = ''
    include "input.kdl"
    include "layout.kdl"
    include "bindings.kdl"
    include "window-rules.kdl"

    prefer-no-csd

    overview {
        zoom 0.25
        backdrop-color "#1e1e2e"

        workspace-shadow {
            off
        }
    }
  '';
}
